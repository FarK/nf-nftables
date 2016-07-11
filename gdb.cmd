# for internal use
define offsetof
	set $rc = (char*)&((struct $arg0 *)0)->$arg1 - (char*)0
end

define list_entry
	offsetof $arg1 $arg2
	set $rc = ((struct $arg1 *) ((uint8_t *) ($arg0) - $rc))
end

# dump a Pintos list
define dumplist
	set $e = $arg0.next
	set $i = 0
	while $e != &$arg0
		list_entry $e $arg1 $arg2
		set $l = $rc
		printf "pintos-debug: dumplist #%d: %p ", $i++, $l
		output *$l
		set $e = $e.next
		printf "\n"
	end
end

document dumplist
	Dump list content invoke as dumplist name_of_list name_of_struct
	name_of_elem_in_list_struct
end

file nft

set print pretty on

run flush ruleset
run add table t
run add chain t c { type filter hook output priority 0\; }

# break evaluate.c : 947
# break evaluate.c : 986
break evaluate.c : 1015
# break evaluate.c : expr_evaluate

run add rule t c ip daddr . meta cpu {8.8.8.8 . 1} counter
