/*
Holds the proc for backstabbing.

usage:

/obj/item/attack(mob/living/target, mob/user, var/target_zone)
	backstab(target, user, 60, BRUTE, DAM_SHARP, target_zone)
	..()
May also be used as:

/obj/item/attack(mob/living/target, mob/user, var/target_zone)
	..()
	if(backstab(target, user, 60, BRUTE, DAM_SHARP, target_zone))
		[insert code here]
---------------
The proc itself:

backstab(mob/living/target, mob/user, damage, damage_type, damage_flags, target_zone, location_check )

Expected inputs per arg:
target: Mob
user: mob/user
damage: Num. Defaults to 30 if not set. Can be zero, if you just want the backstab check itself. This is the flat damage done to SIMPLE MOBS. Humans recieve organ damage instead.
damtype: Expects a damage type macro. Can accept the damage strings, but it is recommended you use the macro instead.
target_zone: target zone intent.
location_check: bool. allows facestabs if set to false, skipping the check for both mob's locations. Automatically set to false if the target is lying down -AND- lying face down.
---------------
Proc returns a boolean if successful.
*/

/obj/item/proc/backstab(var/mob/living/target, mob/user, var/damage = 30, var/damage_type = BRUTE, var/damage_flags, var/target_zone = BP_CHEST, var/location_check = TRUE)

	//Runtime prevention.
	if( !( damage_type in list( BRUTE, BURN, TOX, OXY, CLONE, PAIN ) ) ) //End the proc with a false return if we're not doing a valid damage type.
		return FALSE

	if(!ishuman(target)) //No. You cannot backstab the borg.
		return FALSE

	if(damage < 0) //No negative values allowed.
		return FALSE

	if( target.lying && ( target.dir in list(NORTH, EAST) ) )
		location_check = FALSE //Skip the check for locations if the enemy is floored. His back is waiting for you, seductively. It's ready to take your knife.

	//B-stabs can only occur on a mob from behind, in cases where they are both facing the same direction. More notably, a mob lying face-up cannot be backstabbed.
	if(location_check)

		if(!( sharp ))
			var/decl/pronouns/G = target.get_pronouns()
			user.visible_message(
				SPAN_DANGER("\The [user] tries to stab deep into \the [target]'s back, but it dinks off, scraping [G.him] instead!"), \
				SPAN_WARNING("\The [src] is too dull for a proper backstab!"), \
				SPAN_WARNING("You hear a soft dinking noise."))
			return FALSE

		if(!( get_turf(user) == get_step(target, turn( target.dir, 180)) ) ) //You aren't behind them.
			return FALSE

		if( user.dir != target.dir )
			return FALSE

		if( get_turf(user) == get_turf(target) ) //To prevent people from stabbing people from Neckgrab. Still possible when they're lying face down, but you're fucked anyways.
			to_chat(user, SPAN_WARNING("You are too close to [target] to stab them properly!"))
			return FALSE

		if( target.lying && ( target.dir in list(WEST, SOUTH) ) ) //Failed the above lying check. His back isn't exposed.
			to_chat(user, SPAN_WARNING("You can't reach \the [target]'s back, flip them over!"))
			return FALSE

		if(target_zone in list(BP_L_FOOT, BP_R_FOOT) ) //No feetstabs.
			to_chat(user, SPAN_WARNING("How do you expect to get a meaningful backstab on that floppy thing?"))
			return FALSE

	if(damage >= 1) //Let's not do a damage check if it doesn't actually do damage.

		//Let's actually do the backstab.
		var/mob/living/carbon/human/H

		if(ishuman(target))

			H = target
			var/obj/item/organ/external/stabbed_part = GET_EXTERNAL_ORGAN(H, target_zone)
			if( !prob(H.get_blocked_ratio(target_zone, BRUTE, damage_flags, 0, damage) * 100) && !isnull(stabbed_part) && LAZYLEN(stabbed_part.internal_organs) )
				var/obj/item/organ/internal/damaged_organ = pick(stabbed_part.internal_organs) //This could be improved by checking the size of an internal organ.
				var/organ_damage = damage * 0.20
				damaged_organ.take_internal_damage(organ_damage)
				var/decl/pronouns/G = target.get_pronouns()
				to_chat(user, SPAN_DANGER("You stab [target] in the back of [G.his] [stabbed_part.name]!"))
				H.custom_pain(SPAN_DANGER("<font size='10'>You feel a stabbing pain in the back of your [stabbed_part.name]!</font>")) //Only the stabber and stabbed should know how bad this is.
		else
			target.apply_damage(damage, damage_type, target_zone, DAM_SHARP, src) //Backstabbing. Does extra damage to simple mobs only.
			to_chat(user, SPAN_DANGER("You stab [target] in the back!"))

	return TRUE //Returns a value in case you want to layer additional behavior on this.
