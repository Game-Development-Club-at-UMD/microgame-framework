class_name ScoreRules
extends RefCounted

# Pure scoring logic. No nodes, no animation. Produces an ordered plan that the
# display walks through one step at a time.

const GRID = 15

const POINTS = {
	"A": 1, "B": 3, "C": 3, "D": 2, "E": 1, "F": 4, "G": 2, "H": 4, "I": 1,
	"J": 8, "K": 5, "L": 1, "M": 3, "N": 1, "O": 1, "P": 3, "Q": 10, "R": 1,
	"S": 1, "T": 1, "U": 1, "V": 4, "W": 4, "X": 8, "Y": 4, "Z": 10,
}

# . plain   d double letter   t triple letter   D double word   T triple word
const PREMIUM = [
	"T......T......T",
	".D.d..t.t..d.D.",
	"..D..d...d..D..",
	".d.D.......D.d.",
	"....D..d..D....",
	"..d..t...t..d..",
	".t....d.d....t.",
	"T...d..D..d...T",
	".t....d.d....t.",
	"..d..t...t..d..",
	"....D..d..D....",
	".d.D.......D.d.",
	"..D..d...d..D..",
	".D.d..t.t..d.D.",
	"T......T......T",
]


# rows: the board BEFORE this round, as 15 strings.
# placed: Array of {"cell": Vector2i, "letter": String}.
#
# Returns an Array of word entries, primary word first:
#   {
#     "word": "CATS",
#     "cells": [Vector2i, ...],
#     "steps": [{"cell","letter","base","letter_mult","value","running","code"}],
#     "word_mults": [{"cell","mult","code"}],
#     "subtotal": int,      # after letter multipliers, before word multipliers
#     "total": int,
#     "new_count": int,
#   }
static func build_plan(rows, placed):
	var grid = []
	for y in range(GRID):
		var row = []
		for x in range(GRID):
			row.append(rows[y][x])
		grid.append(row)

	var new_cells = {}
	for p in placed:
		var c = p["cell"]
		grid[c.y][c.x] = p["letter"]
		new_cells[c] = true

	# Collect every word of two or more letters that contains a new tile.
	# Keyed on orientation plus first cell so a word is never counted twice.
	var found = {}
	for p in placed:
		var c = p["cell"]
		for orient in [0, 1]:
			var cells = run_through(grid, c, orient)
			if cells.size() < 2:
				continue
			found["%d_%d_%d" % [orient, cells[0].x, cells[0].y]] = cells

	var entries = []
	for key in found:
		entries.append(score_word(grid, found[key], new_cells))

	# Primary word first: most new tiles, then longest, then alphabetical.
	entries.sort_custom(func(a, b):
		if a["new_count"] != b["new_count"]:
			return a["new_count"] > b["new_count"]
		if a["cells"].size() != b["cells"].size():
			return a["cells"].size() > b["cells"].size()
		return a["word"] < b["word"]
	)
	return entries


static func run_through(grid, cell, orient):
	var cells = []
	if orient == 0:
		var a = cell.x
		while a > 0 and grid[cell.y][a - 1] != ".":
			a -= 1
		var b = cell.x
		while b < GRID - 1 and grid[cell.y][b + 1] != ".":
			b += 1
		for i in range(a, b + 1):
			cells.append(Vector2i(i, cell.y))
	else:
		var a = cell.y
		while a > 0 and grid[a - 1][cell.x] != ".":
			a -= 1
		var b = cell.y
		while b < GRID - 1 and grid[b + 1][cell.x] != ".":
			b += 1
		for i in range(a, b + 1):
			cells.append(Vector2i(cell.x, i))
	return cells


static func score_word(grid, cells, new_cells):
	var word = ""
	var steps = []
	var word_mults = []
	var running = 0
	var new_count = 0

	for c in cells:
		var letter = grid[c.y][c.x]
		word += letter
		var base = int(POINTS.get(letter, 0))
		var letter_mult = 1

		# Premium squares only count on the turn the tile is laid.
		var code = "."
		if new_cells.has(c):
			new_count += 1
			code = PREMIUM[c.y][c.x]
			if code == "d":
				letter_mult = 2
			elif code == "t":
				letter_mult = 3
			elif code == "D":
				word_mults.append({"cell": c, "mult": 2, "code": code})
			elif code == "T":
				word_mults.append({"cell": c, "mult": 3, "code": code})

		var value = base * letter_mult
		running += value
		steps.append({
			"cell": c,
			"letter": letter,
			"base": base,
			"letter_mult": letter_mult,
			"value": value,
			"running": running,
			"code": code,
		})

	var total = running
	for m in word_mults:
		total *= m["mult"]

	return {
		"word": word,
		"cells": cells,
		"steps": steps,
		"word_mults": word_mults,
		"subtotal": running,
		"total": total,
		"new_count": new_count,
	}


static func plan_total(plan):
	var n = 0
	for entry in plan:
		n += entry["total"]
	return n
