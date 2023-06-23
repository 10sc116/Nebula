var/global/list/stored_shock_by_ref = list()

/mob/living/proc/apply_stored_shock_to(var/mob/living/target)
	if(stored_shock_by_ref["\ref[src]"])
		target.electrocute_act(stored_shock_by_ref["\ref[src]"]*0.9, src)
		stored_shock_by_ref["\ref[src]"] = 0

/decl/species/proc/toggle_stance(var/mob/living/carbon/human/H)
	if(!H.incapacitated())
		H.pulling_punches = !H.pulling_punches
		to_chat(H, "<span class='notice'>You are now [H.pulling_punches ? "pulling your punches" : "not pulling your punches"].</span>")

/decl/species/proc/fluid_act(var/mob/living/carbon/human/H, var/datum/reagents/fluids)
	var/water = REAGENT_VOLUME(fluids, /decl/material/liquid/water)
	if(water >= 40 && H.getHalLoss())
		H.adjustHalLoss(-(water_soothe_amount))
		if(prob(5))
			to_chat(H, SPAN_NOTICE("The water ripples gently over your skin in a soothing balm."))

/decl/species/proc/is_available_for_join()
	if(!(spawn_flags & SPECIES_CAN_JOIN))
		return FALSE
	else if(!isnull(max_players))
		var/player_count = 0
		for(var/mob/living/carbon/human/H in global.living_mob_list_)
			if(H.client && H.key && H.species == src)
				player_count++
				if(player_count >= max_players)
					return FALSE
	return TRUE

/decl/species/proc/check_background(var/datum/job/job, var/datum/preferences/prefs)
	. = TRUE

/decl/species/proc/get_digestion_product()
	return /decl/material/liquid/nutriment

/decl/species/proc/handle_post_species_pref_set(var/datum/preferences/pref)
	if(!pref)
		return
	if(length(base_markings))
		for(var/mark_type in base_markings)
			if(!LAZYACCESS(pref.body_markings, mark_type))
				LAZYSET(pref.body_markings, mark_type, base_markings[mark_type])

/decl/species/proc/customize_preview_mannequin(var/mob/living/carbon/human/dummy/mannequin/mannequin)

	if(length(base_markings))
		for(var/mark_type in base_markings)
			var/decl/sprite_accessory/marking/mark_decl = GET_DECL(mark_type)
			for(var/bodypart in mark_decl.body_parts)
				var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(mannequin, bodypart)
				if(O && !LAZYACCESS(O.markings, mark_type))
					LAZYSET(O.markings, mark_type, base_markings[mark_type])

	for(var/obj/item/organ/external/E in mannequin.get_external_organs())
		E.skin_colour = default_bodytype.base_color

	mannequin.eye_colour = default_bodytype.base_eye_color
	mannequin.hair_colour = default_bodytype.base_hair_color
	mannequin.facial_hair_colour = default_bodytype.base_hair_color
	default_bodytype.set_default_hair(mannequin)

	if(preview_outfit)
		var/decl/hierarchy/outfit/outfit = outfit_by_type(preview_outfit)
		outfit.equip(mannequin, equip_adjustments = (OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR|OUTFIT_ADJUSTMENT_SKIP_BACKPACK))

	mannequin.force_update_limbs()
	mannequin.update_mutations(0)
	mannequin.update_body(0)
	mannequin.update_underwear(0)
	mannequin.update_hair(0)
	mannequin.update_icon()
	mannequin.update_transform()

/decl/species/proc/equip_default_fallback_uniform(var/mob/living/carbon/human/H)
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/harness, slot_w_uniform_str)

/decl/species/proc/is_blood_incompatible(var/my_blood_type, var/their_blood_type)
	var/decl/blood_type/my_blood = get_blood_type_by_name(my_blood_type)
	if(!istype(my_blood))
		return FALSE
	return !my_blood.can_take_donation_from(get_blood_type_by_name(their_blood_type))
