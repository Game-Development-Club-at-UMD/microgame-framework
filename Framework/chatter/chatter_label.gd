class_name ChatterLabel extends RichTextLabel

var is_talking : bool = false

const TEXT_SPEED : float = 0.04
const PUNCTUATION_PAUSE_AMOUNT : float = 0.2

const PAUSE_PUNCTUATION: Array[String] = [
	",",
	",",
	".",
	";",
	":",
	"!",
	"?",
	"(",
	")",
	"-",
]

signal started_talking
signal ended_talking

@export_file("*.txt") var file
@export var timer : Timer
@export var play_once : bool = false

var dialogue_lines : Array[String]

var temp_lines : Array[String]



func _ready() -> void:
	if file == null:
		printerr("%s: file is null, cannot read lines from null text file!" % self)
	dialogue_lines = MENU_STRINGS
	reset_temp_lines()
	if !play_once:
		_on_timer_timeout()


#func load_from_file() -> void:
	#dialogue_lines = ChatterParser.read_lines(file)
	#reset_temp_lines()


func char_causes_sentence_pause(character : String) -> bool:
	if PAUSE_PUNCTUATION.has(character):
		return true
	return false


func slowly_appear_line() -> void:
	var target_text : String = get_next_line()
	var curr_text : String = ""
	while target_text.length() > 0:
		curr_text += target_text.left(1)
		target_text = target_text.erase(0, 1)
		self.text = curr_text
		if char_causes_sentence_pause(curr_text.right(1)):
			await get_tree().create_timer(PUNCTUATION_PAUSE_AMOUNT).timeout
		await get_tree().create_timer(TEXT_SPEED).timeout


func reset_temp_lines() -> void:
	temp_lines = dialogue_lines.duplicate()
	temp_lines.shuffle()


func format_text(string : String) -> String:
	return "[shake]" + string


func get_next_line() -> String:
	if temp_lines.size() == 0:
		reset_temp_lines()
	var next_line : String = temp_lines.pop_front()
	if next_line == null:
		printerr("%s: dialogue_lines is likely empty! Check the contents of %s" % [self, file])
		return ""
	return next_line


func _on_timer_timeout() -> void:
	started_talking.emit()
	is_talking = true
	await slowly_appear_line()
	text = format_text(text)
	is_talking = false
	ended_talking.emit()
	if !play_once:
		timer.start()


const MENU_STRINGS : Array[String] = [
	"I used to be a gamer like you. Then I took a shot of self esteem. ",
	"Do you think it's comfortable in the Tamagotchi thing? It's not. All those jagged pixels poking me, and no room to move! ",
	"Doesn't matter how long you delay, you're gonna start the game and immediately get thrashed. It's okay.",
	"Wait, you'we actuawwy weading this? Waow!!! You'we so witerate! Now, for the love of Christ, hit play.",
	"My mother was right. The gaming business has ripped me open and turned me inside out... mostly proverbially.",
	"Can we get a move on? I'm sick of standing here, I want to watch you **** up a minigame already.",
	"Far overrrrr... the sweatyyy gamer palms... a keyboard/mouse... or controllerrrrr....",
	"I play Asmoranomardicadaistinoculdacar, play with my worm a lil bit, and pass the turn.",
	"Ayyy, I'm gamin' heea!... Man, I thought that would kill. Tough crowd.",
	"For moral and legal reasons, I cannot advise you to TERRORIZE THE FEDERAL GOVERNMENT. Don't do it!",
	"You know hiding in this menu doesn't increase your score, right? Unless there's a metagame at play here...",
	"Don't play this game at 3 AM! I'll crawl out of the screen, raid your pantry, and kick your ***!",
	"I'm here to play games and eat Fancy Feast- and I'm all out of Fancy Feast. Please, god, feed me.",
	"Man, these developers did a *really* good job hiding the Bitcoin mining!... Did I say that out loud?",
	"Don't look me up online. Not because you'll find anything weird, it's just that 'Guy' isn't very specific.",
	"Is it even the fourth wall if I'm in a two-dimensional environment?",
	"For my next trick, I'll pretend to be invested in your continued success! Play the game already, man.",
	"I don't actually have fur, this is a mold that's covered my body and invaded my mind. It smells rancid.",
	"Shouldn't you be reading a book or doing homework or something?... Who am I kidding, keep playing!",
	"Heartbreaking: Economic Strife Pushes Potential-Filled Youth to Play Games Instead of Getting a 401K",
	"Maybe you should spend less time reading this and more time playing the game. Unless... you like me?! EW!",
	"An idle mind is the devil's playground, so please, keep pausing so I can play.",
	"You know, I have a Master's in Business Dev, and here I am narrating this nonsensical ********. God.",
	"When you turn the game off, everything goes dark... is that sleep, death, or something worse?",
	"Mehmehmehmehmeh, mehmehmeh. Mehmehmehmehmeh mehmeh!... Did I make you think you'd gone illiterate? No? Dang.",
	"Could you ask the devs to add a philly cheesesteak feature? I have other suggestions as well.",
	"Don't confuse me for that other white-furred cat guy, he gets up to some weird **** on twitter.",
	"Please take a moment to consider the life choices that lead you here. Take your time.",
	"Aren't I zany and quirky and kooky and crazy and nasty and freaky and... uhh... what was I saying?",
	"I've hijacked this machine's camera, but I got blinded by your bald spot. What, you haven't noticed it?",
	"Fun fact- if you scream obscenities into the microphone, the game doesn't change in any way whatsoever.",
	"We had a bathing minigame at one point, but the sheer cleanliness terrified playtesters.",
	"They cut my social link and romance route from the final build. Can you believe that ****?",
	"Just when I thought I was out... they code me back in!",
	"I did some poking around in your file directory. I won't tell anyone, but I WILL judge you.",
	"Four high scores and seven games ago, our devs brought forth on this framework, a new game, conceived in Godot...",
	"Do you leave the pause menu often? What am I saying, of course you don't.",
]


const WIN_STRINGS : Array[String] = [
	"Wait, you won? ****, I owe Dino twelve grand!",
	"Take my advice: Quit while you're ahead.",
	"Quasimodo predicted this victory.",
	"You did it! Surely, women will like you now!",
	"Keep up the mediocre work, chump!",
	"Man, you're a beast! Morbidly, a beast!",
	"I didn't know you could crank 90's in this game...",
	"I'd do WAY better than that if I had thumbs.",
	"They'll sing songs of this victory. Boring songs.",
	"You ARE the danger. You are the one that CLICKS.",
	"Whaddya want, a trophy? Some Reddit karma?",
	"It only gets tougher from here, dingus.",
	"Great, woohoo, you clicked a ball or something.",
	"Dude, no, it's golf rules! Stop getting points!",
	"Clean up on aisle my pants! Wait, I have none...",
	"Only gets harder from here... that's what he said!",
	"You're cheating, aren't you? Judge! Judge!!!",
	"Hey man, a D+ is a passing grade. Chill.",
	"Holy ****, you pressed the right button!",
	"A high score won't bring your wife back.",
	"Only 185 points away from a free t-shirt!*",
	"The next game is my favorite. Allegedly.",
	"You won just so I'd praise you, didn't you?",
	"Only 5038 points away from a commemorative mug!*",
	"Thanks, but your princess is in another minigame.",
	"Ah, the diogenic approach... genius...",
	"Superficial victories are great... for you...",
	"You're almost at the end! Trust me :)",
	"Don't get cocky yet! Dicky is on the table tho.",
]


const LOSE_STRINGS : Array[String] = [
	"Cope! Mald! Seethe! Et cetera!",
	"The catnip just hit, I can't ******* aim!",
	"Your win streak... whateva happened there?",
	"You never had the makings of a varsity gamer.",
	"There goes your esports career, genius.",
	"Do I smell the litterbox or your gameplay?",
	"Is it a 'coup de grace' if you already sucked?",
	"Try pressing buttons next time.",
	"Mom said it's my turn with the controller!",
	"Good lord, that was just... sad...",
	"That high score's not happenin', champ.",
	"Great, now you can go outside! Seriously, go outside.",
	"...but that backflip, tho!",
	"My dead granny could play better. Scary ghost granny.",
	"It's time to t-t-t, t-t-touch grass!",
	"Your fly's down AND you lost? Tragic.",
	"PWNED... what do you mean, nobody says that anymore?",
	"You can try again, but you'll never get your pride back.",
	"Failure is the business of losers. Loser!",
	"You're supposed to *follow* the instructions.",
	"38 dead, 172 wounded, zero games won.",
	"Every time you lose, they take one of my teeth...",
	"LOCK IN ALREADY, IT'S A SIMPLE GAME!",
	"It wasn't lag, it wasn't the mouse, it was YOU.",
	"You're supposed to go next when you lose, not cry.",
	"That's it, I'm voting for whoever you don't like now.",
	"Perseverance is good, but winning is *actually* good.",
	"My disappointment is immeasurable, and my day is ruined.",
	"Are you even trying? No? Oh, that makes sense then.",
	"You suck. Plain and simple!"
]
