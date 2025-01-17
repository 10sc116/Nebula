/turf/floor/natural/path/basalt
	name = "basalt path"
	color = COLOR_DARK_GRAY
	base_color = COLOR_DARK_GRAY

/turf/floor/natural/path/herringbone/basalt
	name = "basalt path"
	color = COLOR_DARK_GRAY
	base_color = COLOR_DARK_GRAY

/turf/floor/natural/path/running_bond/basalt
	name = "basalt path"
	color = COLOR_DARK_GRAY
	base_color = COLOR_DARK_GRAY

/turf/wall/brick/basalt
	material = /decl/material/solid/stone/basalt
	color = COLOR_DARK_GRAY

/turf/wall/natural/basalt
	material = /decl/material/solid/stone/basalt
	color = COLOR_DARK_GRAY

/turf/wall/natural/basalt/shaded_hills
	strata_override = /decl/strata/shaded_hills

/turf/wall/natural/random/basalt
	material = /decl/material/solid/stone/basalt
	color = COLOR_DARK_GRAY

/turf/wall/natural/random/high_chance/basalt
	material = /decl/material/solid/stone/basalt
	color = COLOR_DARK_GRAY

/turf/wall/natural/random/basalt/shaded_hills
	strata_override = /decl/strata/shaded_hills

/turf/wall/natural/random/high_chance/basalt/shaded_hills
	strata_override = /decl/strata/shaded_hills

/turf/floor/natural/rock/basalt
	material = /decl/material/solid/stone/basalt
	color = COLOR_DARK_GRAY

/turf/wall/log/ebony
	icon_state = "wood"
	material = /decl/material/solid/organic/wood/ebony
	color = WOOD_COLOR_BLACK

/obj/structure/door/wood/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = WOOD_COLOR_BLACK

/obj/abstract/landmark/roofed
	name = "roofed turf"

/obj/abstract/landmark/roofed/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/abstract/landmark/roofed/LateInitialize()
	var/turf/T = loc
	if(istype(T))
		T.set_outside(OUTSIDE_NO)
	qdel(src)
