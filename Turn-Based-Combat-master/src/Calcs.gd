extends Node

func _ready():
	simulate_battle()
	pass
	
func simulate_battle():
	var hero_victories : float = 0
	var dragon_victories : float = 0
	
	var hero_dmg : int = 10
	var hero_hp : int = 15
	var dragon_hp : int = 150
	
	var end : bool = false
	
	var winningSeeds : Array = []
		
	var hero_actions : Array[int] = []
	var dragon_actions : Array[int] = []
	
	var ciclos : int = 10000000
	for i in ciclos:
		seed(randi())
		
		end = false
		hero_hp = 15
		dragon_hp = 150
		
		hero_actions.clear()
		dragon_actions.clear()
		
		while not end:
	
			var hero_action = randi_range(1, 3)
			var dragon_action = randi_range(1, 3)
			
			hero_actions.push_back(hero_action)
			dragon_actions.push_back(dragon_action)
			
			match hero_action:
				1:
					dragon_hp -= hero_dmg
					if dragon_action != 1:
						hero_hp -= 2
					pass
				2:
					if dragon_action == 1:
						hero_hp -= 2
					if dragon_action == 3:
						hero_hp -= 3
					pass
				3:
					if dragon_action != 3:
						hero_hp -= 3
					pass
			
			if hero_hp <= 0:
				dragon_victories += 1
				end = true
				
			if dragon_hp <= 0:
				if winningSeeds.find(i) == -1:
					winningSeeds.push_back(i)
					hero_victories += 1
				end = true
	
	print(str(hero_victories))
	print(str(dragon_victories))
	print(str((hero_victories/dragon_victories)*100.0)+"%")
