/obj/item/chems/food/slice/bread/attackby(obj/item/W, mob/user)

	if(istype(W,/obj/item/shard) || istype(W,/obj/item/chems/food))
		var/obj/item/chems/food/csandwich/S = new()
		S.dropInto(loc)
		S.attackby(W,user)
		qdel(src)
	..()

/obj/item/chems/food/csandwich
	name = "sandwich"
	desc = "The best thing since sliced bread."
	icon_state = "breadslice"
	plate = /obj/item/plate
	bitesize = 2

	var/list/ingredients = list()

/obj/item/chems/food/csandwich/attackby(obj/item/W, mob/user)

	var/sandwich_limit = 4
	for(var/obj/item/O in ingredients)
		if(istype(O,/obj/item/chems/food/slice/bread))
			sandwich_limit += 4

	if(src.contents.len > sandwich_limit)
		to_chat(user, "<span class='wwarning'>If you put anything else on \the [src] it's going to collapse.</span>")
		return
	else if(istype(W,/obj/item/shard))
		if(!user.try_unequip(W, src))
			return
		to_chat(user, "<span class='warning'>You hide [W] in \the [src].</span>")
		update()
		return
	else if(istype(W,/obj/item/chems/food))
		if(!user.try_unequip(W, src))
			return
		to_chat(user, "<span class='warning'>You layer [W] over \the [src].</span>")
		var/obj/item/chems/F = W
		F.reagents.trans_to_obj(src, F.reagents.total_volume)
		ingredients += W
		update()
		return
	..()

/obj/item/chems/food/csandwich/proc/update()
	var/fullname = "" //We need to build this from the contents of the var.
	var/i = 0

	overlays.Cut()

	for(var/obj/item/chems/food/O in ingredients)

		i++
		if(i == 1)
			fullname += "[O.name]"
		else if(i == ingredients.len)
			fullname += " and [O.name]"
		else
			fullname += ", [O.name]"

		var/image/I = new(src.icon, "sandwich_filling")
		I.color = O.filling_color
		I.pixel_x = pick(list(-1,0,1))
		I.pixel_y = (i*2)+1
		overlays += I

	var/image/T = new(src.icon, "sandwich_top")
	T.pixel_x = pick(list(-1,0,1))
	T.pixel_y = (ingredients.len * 2)+1
	overlays += T

	SetName(lowertext("[fullname] sandwich"))
	if(length(name) > 80) SetName("[pick(list("absurd","colossal","enormous","ridiculous"))] sandwich")
	w_class = CEILING(clamp((ingredients.len/2),2,4))

/obj/item/chems/food/csandwich/Destroy()
	for(var/obj/item/O in ingredients)
		qdel(O)
	return ..()

/obj/item/chems/food/csandwich/examine(mob/user)
	. = ..(user)
	var/obj/item/O = pick(contents)
	to_chat(user, "<span class='warning'>You think you can see [O.name] in there.</span>")

/obj/item/chems/food/csandwich/attack(mob/M, mob/user, def_zone)

	var/obj/item/shard
	for(var/obj/item/O in contents)
		if(istype(O,/obj/item/shard))
			shard = O
			break

	var/mob/living/H
	if(isliving(M))
		H = M

	if(H && shard && M == user) //This needs a check for feeding the food to other people, but that could be abusable.
		to_chat(H, "<span class='warning'>You lacerate your mouth on a [shard.name] in the sandwich!</span>")
		H.take_damage(BRUTE, 5) //TODO: Target head if human.
	..()
