/decl/species/monkey
	name = SPECIES_MONKEY
	name_plural = "Monkeys"
	description = "Ook."
	codex_description = "Monkeys and other similar creatures tend to be found on science stations and vessels as \
	cheap and disposable test subjects. This, naturally, infuriates animal rights groups."
	hidden_from_codex = FALSE

	available_bodytypes = list(/decl/bodytype/monkey)
	holder_icon = 'icons/mob/human_races/species/monkey/holder.dmi'

	show_ssd = null

	gibbed_anim = "gibbed-m"
	dusted_anim = "dust-m"
	death_message = "lets out a faint chimper as it collapses and stops moving..."

	unarmed_attacks = list(/decl/natural_attack/bite, /decl/natural_attack/claws, /decl/natural_attack/punch)
	inherent_verbs = list(/mob/living/proc/ventcrawl)
	species_hud = /datum/hud_data/monkey
	meat_type = /obj/item/chems/food/meat/monkey

	rarity_value = 0.1
	total_health = 150

	spawn_flags = SPECIES_IS_RESTRICTED

	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	pass_flags = PASS_FLAG_TABLE
	holder_type = /obj/item/holder

	appearance_descriptors = list(
		/datum/appearance_descriptor/height = 0.6,
		/datum/appearance_descriptor/build =  0.6
	)

	force_cultural_info = list(
		TAG_CULTURE =   /decl/cultural_info/culture/hidden/monkey,
		TAG_HOMEWORLD = /decl/cultural_info/location/stateless,
		TAG_FACTION =   /decl/cultural_info/faction/other
	)

	ai = /datum/ai/monkey
