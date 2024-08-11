extends Control

signal textbox_closed

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0
var is_defending = false
var is_dodging = false

func _ready():
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$Textbox.hide()
	$ActionsPanel.hide()
	
	display_text("%s stands before you." % enemy.name)
	await self.textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]

func _input(_event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.text = text

func enemy_turn():
	
	var dragon_action =  randi_range(1, 3)
	
	match dragon_action:
		1:
			display_text("%s launches his claws at you." % enemy.name)
			pass
		2:
			display_text("%s starts breathing scorching fire." % enemy.name)
			pass
		3:
			display_text("%s swings his mighty tail." % enemy.name)
			pass
			
	await self.textbox_closed
	
	if is_defending:
		is_defending = false
		
		if dragon_action == 2:
			$AnimationPlayer.play("mini_shake")
			await $AnimationPlayer.animation_finished
			display_text("You blocked the fire with your shield.")
		else:
			current_player_health = max(0, current_player_health - enemy.damageFire)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			$AnimationPlayer.play("shake")
			await $AnimationPlayer.animation_finished
			if dragon_action == 1:
				display_text("Spear-like claws penetrate your flesh.")
			if dragon_action == 3:
				display_text("The tail strikes your weak body.")
		
		await self.textbox_closed
	elif is_dodging:
		is_dodging = false
		
		if dragon_action == 3:
			$AnimationPlayer.play("mini_shake")
			await $AnimationPlayer.animation_finished
			display_text("You jumped over %s's tail." % enemy.name)
		else:
			current_player_health = max(0, current_player_health - enemy.damageTail)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			$AnimationPlayer.play("shake")
			await $AnimationPlayer.animation_finished
			if dragon_action == 1:
				display_text("Spear-like claws penetrate your flesh.")
			if dragon_action == 2:
				display_text("The fire scorches you iron clothes.")
		
		await self.textbox_closed
	else:
		current_player_health = max(0, current_player_health - enemy.damageClaw)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
		if dragon_action == 1:
			display_text("Spear-like claws penetrate your flesh.")
		if dragon_action == 2:
			display_text("The fire scorches you iron clothes.")
		if dragon_action == 3:
			display_text("The tail strikes your weak body.")
		await self.textbox_closed
		
	if current_player_health <= 0:
		display_text("You are dead!")
		await self.textbox_closed
		await get_tree().create_timer(0.25).timeout
		get_tree().quit()
			
	$ActionsPanel.show()

func _on_Run_pressed():
	is_dodging = true
	
	display_text("You prepare to dodge.")
	await self.textbox_closed
	
	await get_tree().create_timer(0.25).timeout
	
	enemy_turn()

func _on_Attack_pressed():
	display_text("You swing your sword.")
	await self.textbox_closed

	match Globals.game_mode:
		Globals.GameMode.CLASSIC:
			attack_classic()
			pass
		Globals.GameMode.ROGUE:
			attack_rogue()
			pass
		Globals.GameMode.ADVANCED:
			attack_advanced()
			pass

	enemy_turn()

func _on_Defend_pressed():
	is_defending = true
	
	display_text("You prepare yout shield.")
	await self.textbox_closed
	
	await get_tree().create_timer(0.25).timeout
	
	enemy_turn()
	
func attack_classic():
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)

	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You managed to strike the beast.")
	await self.textbox_closed
	
	if current_enemy_health == 0:
		display_text("%s was defeated." % enemy.name)
		await self.textbox_closed
		
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		
		await get_tree().create_timer(0.25).timeout
		get_tree().quit()

func attack_rogue():
	pass

func attack_advanced():
	pass
	
func enemy_classic():
	pass

func enemy_rogue():
	pass

func enemy_advanced():
	pass
