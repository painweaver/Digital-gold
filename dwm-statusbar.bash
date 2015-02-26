#!/bin/bash
#
# ~/bin/dwm-statusbar
#
# Status bar for dwm. Expanded from:
# https://bitbucket.org/jasonwryan/eeepc/src/73dadb289dead8ef17ef29a9315ba8f1706927cb/Scripts/dwm-status

glyph_msc="\uE003"
glyph_cpu="\uE00E"
glyph_mem="\uE021"
glyph_dl="\uE005"
glyph_ul="\uE004"
glyph_com="\uE006"
glyph_eml="\uE070"
glyph_vol="\uE051"
glyph_tim="\uE015"
glyph_tor="\uE010"
sep_solid="\uE001"
sep_line="\uE001"
sep_bar="\uE001"

print_song_info() {
  song_info="$(mpc current -f '[[[[%artist% \uE0B1 ]%title%]]|[%file%]]' | head -c 75)"
  if [[ ! $song_info ]]; then
    song_info="Off"
  fi
  echo -ne "${sep_solid} ${glyph_msc} ${song_info} "
}

print_mem_used() {
  mem_used="$(free -m | awk 'NR==3 {print $3}')"
  echo -ne "${sep_line} ${glyph_mem} ${mem_used}M "
}

print_volume() {
  volume="$(amixer get PCM | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
  echo -ne "${sep_solid} ${glyph_vol} ${volume}% "
}

print_datetime() {
  datetime="$(date "+%a %d %b ${sep_line} ${glyph_tim} %H:%M")"
  echo -ne "${sep_solid} ${datetime} "
}

# network (from: http://dzen.geekmode.org/dwiki/doku.php?id=dzen:network-meter)
# cpu (from: https://bbs.archlinux.org/viewtopic.php?pid=661641#p661641)
rx_old=$(cat /sys/class/net/enp5s0/statistics/rx_bytes)
tx_old=$(cat /sys/class/net/enp5s0/statistics/tx_bytes)

while true; do
  # get new cpu idle and total usage
  eval $(awk '/^cpu /{print "cpu_idle_now=" $5 "; cpu_total_now=" $2+$3+$4+$5 }' /proc/stat)
  cpu_interval=$((cpu_total_now-${cpu_total_old:-0}))
  # calculate cpu usage (%)
  let cpu_used="100 * ($cpu_interval - ($cpu_idle_now-${cpu_idle_old:-0})) / $cpu_interval"

  # get new rx/tx counts
  rx_now=$(cat /sys/class/net/enp5s0/statistics/rx_bytes)
  tx_now=$(cat /sys/class/net/enp5s0/statistics/tx_bytes)
  # calculate the rate (K) and total (M)
  let rx_rate=($rx_now-$rx_old)/1024
  let tx_rate=($tx_now-$tx_old)/1024
  #  let rx_total=$rx_now/1048576
  #  let tx_total=$tx_now/1048576

  # output vars
  print_cpu_used() {
    printf "%-14b" "${sep_solid} ${glyph_cpu} ${cpu_used}%"
  }
  print_rx_rate() {
    printf "%-15b" "${sep_solid} ${glyph_dl} ${rx_rate}K"
  }
  print_tx_rate() {
    printf "%-14b" "${sep_line} ${glyph_ul} ${tx_rate}K"
  }

  # Pipe to status bar, not indented due to printing extra spaces/tabs
  xsetroot -name "$(print_song_info)\
$(print_cpu_used)$(print_mem_used)\
$(print_rx_rate)$(print_tx_rate)\
$(print_volume)\
$(print_datetime)"

  # reset old rates
  rx_old=$rx_now
  tx_old=$tx_now
  cpu_idle_old=$cpu_idle_now
  cpu_total_old=$cpu_total_now
  # loop stats every 1 second
  sleep 1
done

