###########################################
# Battery plugin for oh-my-zsh            #
# Original Author: Peter hoeg (peterhoeg) #
# Email: peter@speartail.com              #
###########################################
# Author: Sean Jones (neuralsandwich)     #
# Email: neuralsandwich@gmail.com         #
# Modified to add support for Apple Mac   #
###########################################

if [[ $(uname) == "Darwin" ]] ; then

  function battery_pct() {
<<<<<<< HEAD
    local smart_battery_status="$(ioreg -rc "AppleSmartBattery")"
    typeset -F maxcapacity=$(echo $smart_battery_status | grep '^.*"MaxCapacity"\ =\ ' | sed -e 's/^.*"MaxCapacity"\ =\ //')
    typeset -F currentcapacity=$(echo $smart_battery_status | grep '^.*"CurrentCapacity"\ =\ ' | sed -e 's/^.*CurrentCapacity"\ =\ //')
=======
    typeset -F maxcapacity=$(ioreg -rc "AppleSmartBattery"| grep '^.*"MaxCapacity"\ =\ ' | sed -e 's/^.*"MaxCapacity"\ =\ //')
    typeset -F currentcapacity=$(ioreg -rc "AppleSmartBattery"| grep '^.*"CurrentCapacity"\ =\ ' | sed -e 's/^.*CurrentCapacity"\ =\ //')
>>>>>>> 488e6f1aa030b4b5c62a6fb96d6e59f17b751ff0
    integer i=$(((currentcapacity/maxcapacity) * 100))
    echo $i
  }
  
  function battery_pct_remaining() {
    if [[ $(ioreg -rc AppleSmartBattery | grep -c '^.*"ExternalConnected"\ =\ No') -eq 1 ]] ; then
      battery_pct
    else
      echo "External Power"
    fi
  }

  function battery_time_remaining() {
<<<<<<< HEAD
  	local smart_battery_status="$(ioreg -rc "AppleSmartBattery")"
    if [[ $(echo $smart_battery_status | grep -c '^.*"ExternalConnected"\ =\ No') -eq 1 ]] ; then
      timeremaining=$(echo $smart_battery_status | grep '^.*"AvgTimeToEmpty"\ =\ ' | sed -e 's/^.*"AvgTimeToEmpty"\ =\ //')
=======
    if [[ $(ioreg -rc AppleSmartBattery | grep -c '^.*"ExternalConnected"\ =\ No') -eq 1 ]] ; then
      timeremaining=$(ioreg -rc "AppleSmartBattery"| grep '^.*"AvgTimeToEmpty"\ =\ ' | sed -e 's/^.*"AvgTimeToEmpty"\ =\ //')
>>>>>>> 488e6f1aa030b4b5c62a6fb96d6e59f17b751ff0
      echo "~$((timeremaining / 60)):$((timeremaining % 60))"
    else
      echo "∞"
    fi
  }

  function battery_pct_prompt () {
    if [[ $(ioreg -rc AppleSmartBattery | grep -c '^.*"ExternalConnected"\ =\ No') -eq 1 ]] ; then
      b=$(battery_pct_remaining)
      if [ $b -gt 50 ] ; then
        color='green'
      elif [ $b -gt 20 ] ; then
        color='yellow'
      else
        color='red'
      fi
      echo "%{$fg[$color]%}[$(battery_pct_remaining)%%]%{$reset_color%}"
    else
      echo "∞"
    fi
  }
<<<<<<< HEAD
  
  function battery_is_charging() {
	  [[ $(ioreg -rc "AppleSmartBattery"| grep '^.*"IsCharging"\ =\ ' | sed -e 's/^.*"IsCharging"\ =\ //') == "Yes" ]]
  }
=======
>>>>>>> 488e6f1aa030b4b5c62a6fb96d6e59f17b751ff0

elif [[ $(uname) == "Linux"  ]] ; then

  function battery_pct_remaining() {
    if [[ $(acpi 2&>/dev/null | grep -c '^Battery.*Discharging') -gt 0 ]] ; then
      echo "$(acpi | cut -f2 -d ',' | tr -cd '[:digit:]')" 
    fi
  }

  function battery_time_remaining() {
    if [[ $(acpi 2&>/dev/null | grep -c '^Battery.*Discharging') -gt 0 ]] ; then
      echo $(acpi | cut -f3 -d ',')
    fi
  }

  function battery_pct_prompt() {
    b=$(battery_pct_remaining) 
    if [[ $(acpi 2&>/dev/null | grep -c '^Battery.*Discharging') -gt 0 ]] ; then
      if [ $b -gt 50 ] ; then
        color='green'
      elif [ $b -gt 20 ] ; then
        color='yellow'
      else
        color='red'
      fi
      echo "%{$fg[$color]%}[$(battery_pct_remaining)%%]%{$reset_color%}"
    else
      echo "∞"
    fi
  }
<<<<<<< HEAD
  
  function battery_pct() {
    # todo for on linux
  }
  
  function battery_is_charging() {
    # todo on linux
	false
  }

else
  # Empty functions so we don't cause errors in prompts
  function battery_pct_remaining() {
  }

  function battery_time_remaining() {
  }

  function battery_pct_prompt() {
  }
fi

function battery_level_gauge() {
  local gauge_slots=${BATTERY_GAUGE_SLOTS:-10};
  local green_threshold=${BATTERY_GREEN_THRESHOLD:-6};
  local yellow_threshold=${BATTERY_YELLOW_THRESHOLD:-4};
  local color_green=${BATTERY_COLOR_GREEN:-%F{green}};
  local color_yellow=${BATTERY_COLOR_YELLOW:-%F{yellow}};
  local color_red=${BATTERY_COLOR_RED:-%F{red}};
  local color_reset=${BATTERY_COLOR_RESET:-%{%f%k%b%}};
  local battery_prefix=${BATTERY_GAUGE_PREFIX:-'['};
  local battery_suffix=${BATTERY_GAUGE_SUFFIX:-']'};
  local filled_symbol=${BATTERY_GAUGE_FILLED_SYMBOL:-'▶'};
  local empty_symbol=${BATTERY_GAUGE_EMPTY_SYMBOL:-'▷'};
  local charging_color=${BATTERY_CHARGING_COLOR:-$color_yellow};
  local charging_symbol=${BATTERY_CHARGING_SYMBOL:-'⚡'};

  local battery_remaining_percentage=$(battery_pct);

  if [[ $battery_remaining_percentage =~ [0-9]+ ]]; then
    local filled=$(((( $battery_remaining_percentage + $gauge_slots - 1) / $gauge_slots)));
    local empty=$(($gauge_slots - $filled));
	
    if [[ $filled -gt $green_threshold ]]; then local gauge_color=$color_green;
    elif [[ $filled -gt $yellow_threshold ]]; then local gauge_color=$color_yellow;
    else local gauge_color=$color_red;
    fi
  else
    local filled=$gauge_slots;
    local empty=0;
  	filled_symbol=${BATTERY_UNKNOWN_SYMBOL:-'.'};
  fi

  
  local charging=' ' && battery_is_charging && charging=$charging_symbol;

  printf ${charging_color//\%/\%\%}$charging${color_reset//\%/\%\%}${battery_prefix//\%/\%\%}${gauge_color//\%/\%\%}
  printf ${filled_symbol//\%/\%\%}'%.0s' {1..$filled}
  [[ $filled -lt $gauge_slots ]] && printf ${empty_symbol//\%/\%\%}'%.0s' {1..$empty}
  printf ${color_reset//\%/\%\%}${battery_suffix//\%/\%\%}${color_reset//\%/\%\%}
}


=======
else
	# Empty functions so we don't cause errors in prompts
	function battery_pct_remaining() {
	}

	function battery_time_remaining() {
	}

	function battery_pct_prompt() {
	}
fi
>>>>>>> 488e6f1aa030b4b5c62a6fb96d6e59f17b751ff0
