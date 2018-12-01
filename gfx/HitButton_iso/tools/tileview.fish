# for i in (  begin
#                 image gfx/HitButton_iso/16x20/HitButton_iso-(gettilebyid mon_zombie | pp_tile).png; and eval echo (cat data/json/monsters.json | jq '.[] | select (.id == "mon_zombie") | {id, name, description}' | jq .name) | tr [:lower:] [:upper:] | gsed -r s/"(.)"/"\1 "/g; and echo; and eval echo (cat data/json/monsters.json | jq '.[] | select (.id == "mon_zombie") | {id, name, description}' | jq .description); and echo
#             end )
#      echo $i
# end

function showtile
    for i in $argv
        image gfx/HitButton_iso/16x20/HitButton_iso-(gettilebyid $i | pp_tile).png
        echo fg: (gettilebyid $i | pp_tile)
        image gfx/HitButton_iso/16x20/HitButton_iso-(gettilebyid $i | tile_bg).png
        echo bg: (gettilebyid $i | tile_bg)
        and eval echo (cat data/json/monsters.json | jq '.[] | select (.id == "'$i'") | {id, name, description}' | jq .name) | tr [:lower:] [:upper:] | gsed -r s/"(.)"/"\1 "/g
        and echo
        and eval echo (cat data/json/monsters.json | jq '.[] | select (.id == "'$i'") | {id, name, description}' | jq .description)
        and echo
    end
end

function showtileslike
    for i in $argv
        set tiles_like_list (gettilebyidlike $i) # full list, e.g. id: [this, notthis, andnotthids]
        set tiles_like_ids (eval echo (echo $tiles_like_list | tile_id) | tr ' ' \n | sort | uniq | grep $i)
        # set tiles_like_fgs (gettile $tiles_like_ids)
        for tile_id in $tiles_like_ids
            image gfx/HitButton_iso/16x20/HitButton_iso-(gettilebyid $tile_id | tile_fg).png
            and eval echo (cat data/json/monsters.json data/json/monsters/*.json | jq '.[] | select (.id == "'$tile_id'") | {id, name, description}' | jq .name) | tr [:lower:] [:upper:] | gsed -r s/"(.)"/"\1 "/g
            and echo $tile_id
            and gettilebyid $tile_id | tile_fg
            and echo
            and eval echo (cat data/json/monsters.json data/json/monsters/*.json | jq '.[] | select (.id == "'$tile_id'") | {id, name, description}' | jq .description)
            and echo
        end
    end
end


function showtileslike_inner
    # echo $argv
    for tile_id in $argv
        # gettilebyid $tile_id
        # gettilebyid $tile_id | tile_fg
        # gettilebyid $tile_id | tile_fg | wc -c
        if true # test -n "(gettilebyid $tile_id | tile_fg)"
            echo image gfx/HitButton_iso/16x20/HitButton_iso-(gettilebyid $tile_id | tile_fg; gettilebyid $tile_id | tile_bg).png
        else
            echo "no image found for $tile_id"
        end
        image gfx/HitButton_iso/16x20/HitButton_iso-(gettilebyid $tile_id | tile_fg; gettilebyid $tile_id | tile_bg).png
        and eval echo (cat (find data/json -iname \*.json) | jq '.[] | select (.id == "'$tile_id'") | {id, name, description}' 2>/dev/null | jq .name) | tr [:lower:] [:upper:] | gsed -r s/"(.)"/"\1 "/g
        and echo id: $tile_id
        and echo fg: (gettilebyid $tile_id | tile_fg)
        and echo bg: (gettilebyid $tile_id | tile_bg)
        and echo
        and echo DESCRIPTION
        and cat (find data/json -iname \*.json) | jq '.[] | select (.id == "'$tile_id'") | {id, name, description}' 2>/dev/null | jq .description 2>/dev/null
        echo \n——————————————
        # and echo
    end # | base64
end

function showtileslike_parallel
    for i in $argv
        set tiles_like_list (gettilebyidlike $i) # full list, e.g. id: [this, notthis, andnotthids]
        set tiles_like_ids (eval echo (echo $tiles_like_list | tile_id) | tr ' ' \n | sort | uniq | grep $i)
        # set tiles_like_fgs (gettile $tiles_like_ids)
        echo $tiles_like_ids | tr ' ' \n | parallel -j12 fish -c showtileslike_inner\\ \{\} # \ \| base64
#         echo $tiles_like_ids | tr ' ' \n | xargs -I qqq -P12 fish -c showtileslike_inner\ qqq
    end
end


# function showtileslike
#     for i in $argv
#         set tiles_like_list (gettilebyidlike $i) # full list, e.g. id: [this, notthis, andnotthids]
#         set tiles_like_ids (eval echo (echo $tiles_like_list | tile_id) | tr ' ' \n | sort | uniq | grep $i)
#         set tiles_like_fgs (echo $tiles_like_list | tile_fg | sort | uniq)
#         for tile_id in $tiles_like_ids
#             image gfx/HitButton_iso/16x20/HitButton_iso-(gettilebyid $tile_id | tile_fg).png
#             and eval echo (cat data/json/monsters.json data/json/monsters/*.json | jq '.[] | select (.id == "'$tile_id'") | {id, name, description}' | jq .name) | tr [:lower:] [:upper:] | gsed -r s/"(.)"/"\1 "/g
#             and echo $tile_id
#             and gettilebyid $tile_id | tile_fg
#             and echo
#             and eval echo (cat data/json/monsters.json data/json/monsters/*.json | jq '.[] | select (.id == "'$tile_id'") | {id, name, description}' | jq .description)
#             and echo
#         end
#     end
# end



# and eval echo (cat data/json/monsters.json | jq '.[] | select (.id | contains("'$i'")) | {id, name, description}' | jq .name) | tr [:lower:] [:upper:] | gsed -r s/"(.)"/"\1 "/g
# and echo
# and eval echo (cat data/json/monsters.json | jq '.[] | select (.id | contains("'$i'")) | {id, name, description}' | jq .description)
# and echo

