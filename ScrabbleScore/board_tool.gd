@tool
extends EditorScript

# Run with File > Run in the script editor. Writes board_data.gd, which the
# microgame preloads. Nothing here ships with the game.

const GRID = 15
const WORDS_PATH = "res://ScrabbleScore/Data/dictionary.txt"
const OUT_PATH = "res://ScrabbleScore/Data/board_data.gd"

const BOARD_COUNT = 8
const TARGET_TILES = 60
const MAX_GROW_WORD = 7
const PLAYS_PER_SIZE = 8
const CANDIDATES_PER_SEGMENT = 60

var word_set = {}
var by_anchor = {}
var by_length = {}


func _run():
	if not load_words():
		return

	var boards = []
	for i in range(BOARD_COUNT):
		var grid = grow_board()
		var plays = find_plays(grid)
		if plays.size() < 4:
			print("board %d only found %d plays, discarded" % [i, plays.size()])
			continue
		boards.append({"rows": grid_to_rows(grid), "plays": plays})
		print("board %d kept: %d tiles, %d plays" % [i, count_tiles(grid), plays.size()])

	if boards.size() == 0:
		push_error("no boards survived, check the word list")
		return

	write_output(boards)


#region word list
func load_words():
	var f = FileAccess.open(WORDS_PATH, FileAccess.READ)
	if f == null:
		push_error("no word list at " + WORDS_PATH)
		return false

	while not f.eof_reached():
		var raw = f.get_line().strip_edges()
		if raw.length() < 2 or raw.length() > GRID:
			continue
		if not is_plain_alpha(raw):
			continue

		var w = raw.to_upper()
		word_set[w] = true

		if not by_length.has(w.length()):
			by_length[w.length()] = []
		by_length[w.length()].append(w)

		# Index by (length, position, letter) so hooked words can be found fast.
		for i in range(w.length()):
			var key = "%d_%d_%s" % [w.length(), i, w[i]]
			if not by_anchor.has(key):
				by_anchor[key] = []
			by_anchor[key].append(w)

	print("loaded %d words" % word_set.size())
	return word_set.size() > 1000


func is_plain_alpha(s):
	for c in s:
		var code = c.to_upper().unicode_at(0)
		if code < 65 or code > 90:
			return false
	return true
#endregion


#region grid helpers
# orient 0 reads a row (line is y, index is x). orient 1 reads a column.
func cell(g, orient, line, index):
	if orient == 0:
		return g[line][index]
	return g[index][line]


func to_cell(orient, line, index):
	if orient == 0:
		return Vector2i(index, line)
	return Vector2i(line, index)


func new_grid():
	var g = []
	for y in range(GRID):
		var row = []
		for x in range(GRID):
			row.append("")
		g.append(row)
	return g


func count_tiles(g):
	var n = 0
	for y in range(GRID):
		for x in range(GRID):
			if g[y][x] != "":
				n += 1
	return n


func grid_to_rows(g):
	var rows = []
	for y in range(GRID):
		var s = ""
		for x in range(GRID):
			s += "." if g[y][x] == "" else g[y][x]
		rows.append(s)
	return rows
#endregion


#region generation
func grow_board():
	var g = new_grid()

	# Seed with a word through the centre square.
	var seed_len = 5 + randi() % 3
	var pool = by_length.get(seed_len, [])
	if pool.is_empty():
		pool = by_length[by_length.keys()[0]]
	var word = pool[randi() % pool.size()]
	var start = 7 - randi() % word.length()
	start = clamp(start, 0, GRID - word.length())
	for i in range(word.length()):
		g[7][start + i] = word[i]

	var guard = 0
	while count_tiles(g) < TARGET_TILES and guard < 4000:
		guard += 1
		var play = find_one_play(g, 1, MAX_GROW_WORD, 120)
		if play.is_empty():
			continue
		for i in range(play["cells"].size()):
			var c = play["cells"][i]
			g[c.y][c.x] = play["letters"][i]

	return g


func find_plays(g):
	var buckets = {1: [], 2: [], 3: [], 4: []}
	var seen = {}
	var guard = 0

	while guard < 30000:
		guard += 1
		var p = find_one_play(g, 1, 4, 1)
		if p.is_empty():
			continue

		var size = p["cells"].size()
		if buckets[size].size() >= PLAYS_PER_SIZE:
			continue

		var key = "%s|%s" % [str(p["cells"]), p["letters"]]
		if seen.has(key):
			continue
		seen[key] = true
		buckets[size].append(p)

		if buckets[1].size() >= PLAYS_PER_SIZE \
			and buckets[2].size() >= PLAYS_PER_SIZE \
			and buckets[3].size() >= PLAYS_PER_SIZE \
			and buckets[4].size() >= PLAYS_PER_SIZE:
			break

	var all = []
	for size in [1, 2, 3, 4]:
		all.append_array(buckets[size])
	return all


func find_one_play(g, min_new, max_new, tries):
	for attempt in range(tries):
		var orient = randi() % 2
		var line = randi() % GRID
		var options = windows(g, orient, line, min_new, max_new)
		if options.is_empty():
			continue
		options.shuffle()
		var limit = min(options.size(), 12)
		for n in range(limit):
			var w = options[n]
			var play = try_window(g, orient, line, w["ws"], w["we"], w["fixed"], w["empties"])
			if not play.is_empty():
				return play
	return {}


# Every bounded word extent in this line needing between min_new and max_new
# new tiles. A word cannot contain a gap, so all empty cells inside get filled.
# This is what allows a play to straddle an existing letter.
func windows(g, orient, line, min_new, max_new):
	var out = []
	for ws in range(GRID):
		if ws > 0 and cell(g, orient, line, ws - 1) != "":
			continue
		for we in range(ws + 1, GRID):
			if we < GRID - 1 and cell(g, orient, line, we + 1) != "":
				continue

			var fixed = {}
			var empties = []
			for i in range(ws, we + 1):
				var c = cell(g, orient, line, i)
				if c == "":
					empties.append(i)
				else:
					fixed[i - ws] = c

			if fixed.is_empty() or empties.is_empty():
				continue
			if empties.size() < min_new or empties.size() > max_new:
				continue

			out.append({"ws": ws, "we": we, "fixed": fixed, "empties": empties})
	return out


func try_window(g, orient, line, ws, we, fixed, empties):
	var length = we - ws + 1
	var candidates = candidate_words(length, fixed)
	if candidates.is_empty():
		return {}
	candidates.shuffle()

	var limit = min(candidates.size(), CANDIDATES_PER_SEGMENT)
	for n in range(limit):
		var word = candidates[n]
		var cells = []
		var letters = ""
		var ok = true

		for index in empties:
			var letter = word[index - ws]
			if not cross_word_ok(g, orient, line, index, letter):
				ok = false
				break
			cells.append(to_cell(orient, line, index))
			letters += letter

		if ok:
			return {"cells": cells, "letters": letters}

	return {}


func candidate_words(length, fixed):
	# Start from the rarest anchor, then filter down.
	var best = []
	var first = true
	for pos in fixed:
		var key = "%d_%d_%s" % [length, pos, fixed[pos]]
		var list = by_anchor.get(key, [])
		if list.is_empty():
			return []
		if first or list.size() < best.size():
			best = list
			first = false

	var result = []
	for word in best:
		var ok = true
		for pos in fixed:
			if word[pos] != fixed[pos]:
				ok = false
				break
		if ok:
			result.append(word)
	return result


# Checks the word formed perpendicular to the play through one new cell.
func cross_word_ok(g, orient, line, index, letter):
	var other = 1 - orient

	var a = line
	while a > 0 and cell(g, other, index, a - 1) != "":
		a -= 1
	var b = line
	while b < GRID - 1 and cell(g, other, index, b + 1) != "":
		b += 1

	if a == b:
		return true

	var word = ""
	for i in range(a, b + 1):
		if i == line:
			word += letter
		else:
			word += cell(g, other, index, i)
	return word_set.has(word)
#endregion


func write_output(boards):
	var out = "# Generated by board_tool.gd. Do not edit by hand.\n\n"
	out += "const BOARDS = [\n"

	for b in boards:
		out += "\t{\n\t\t\"rows\": [\n"
		for row in b["rows"]:
			out += "\t\t\t\"%s\",\n" % row
		out += "\t\t],\n\t\t\"plays\": [\n"
		for p in b["plays"]:
			var parts = []
			for c in p["cells"]:
				parts.append("Vector2i(%d, %d)" % [c.x, c.y])
			out += "\t\t\t{\"letters\": \"%s\", \"cells\": [%s]},\n" % [p["letters"], ", ".join(parts)]
		out += "\t\t],\n\t},\n"

	out += "]\n"

	var f = FileAccess.open(OUT_PATH, FileAccess.WRITE)
	if f == null:
		push_error("could not write " + OUT_PATH)
		return
	f.store_string(out)
	print("wrote ", OUT_PATH)
