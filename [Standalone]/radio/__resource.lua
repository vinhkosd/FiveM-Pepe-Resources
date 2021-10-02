resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- Example custom radios
supersede_radio "RADIO_01_CLASS_ROCK" { url = "http://playerservices.streamtheworld.com/api/livestream-redirect/TLPSTR02.mp3 ", volume = 0.3, name = "[538 Top 40]"}
supersede_radio "RADIO_02_POP" { url = "http://playerservices.streamtheworld.com/api/livestream-redirect/RADIO538.mp3 ", volume = 0.3, name = "[Radio 538]"}
supersede_radio "RADIO_03_HIPHOP_NEW" { url = "http://icecast.omroep.nl/funx-hiphop-bb-mp3", volume = 0.3, name = "[FunX Hiphop]" }
supersede_radio "RADIO_04_PUNK" { url = "https://stream.100p.nl/web02_mp3", volume = 0.3, name = "[100% NL]"}
supersede_radio "RADIO_05_TALK_01" { url = "http://playerservices.streamtheworld.com/api/livestream-redirect/TLPSTR01.mp3", volume = 0.3, name = "[Radio 538 Dance Department]" }
supersede_radio "RADIO_06_COUNTRY" { url = "https://stream.100p.nl/web01_mp3", volume = 0.3, name = "[100% NL Feest]"}
supersede_radio "RADIO_07_DANCE_01" { url = "http://icecast-qmusicnl-cdp.triple-it.nl/Qmusic_nl_fouteuur_96.mp3", volume = 0.3, name = "[Q-Music Het Foute Uur]" }
supersede_radio "RADIO_08_MEXICAN" { url = "http://streaming.slam.nl/web11_mp3", volume = 0.3, name = "[Slam! FM Hardstyle]"}
supersede_radio "RADIO_09_HIPHOP_OLD" { url = "http://stream.radiocorp.nl/web10_mp3", volume = 0.3, name = "[Slam! Non-Stop]" }
supersede_radio "RADIO_11_TALK_02" { url = "http://playerservices.streamtheworld.com/api/livestream-redirect/TLPSTR16.mp3 ", volume = 0.3, name = "[538 Party]" }
supersede_radio "RADIO_12_REGGAE" { url = "	https://stream.slam.nl/web13_mp3 ", volume = 0.3, name = "[Slam! Mixmarathon]"}
supersede_radio "RADIO_13_JAZZ" { url = "http://icecast-qmusic.cdp.triple-it.nl/Qmusic_nl_live_96.mp3", volume = 0.3, name = "[Q-Music]" }
supersede_radio "RADIO_14_DANCE_02" { url = "http://icecast.omroep.nl/funx-bb-mp3", volume = 0.3, name = "[FunX]"}
supersede_radio "RADIO_15_MOTOWN" { url = "http://icecast.omroep.nl/funx-slowjamz-bb-mp3", volume = 0.3, name = "[FunX Slow Jamz]" }
supersede_radio "RADIO_16_SILVERLAKE" { url = "http://playerservices.streamtheworld.com/api/livestream-redirect/TLPSTR09.mp3 ", volume = 0.3, name = "[538 Non-Stop]" }
supersede_radio "RADIO_17_FUNK" { url = "http://icecast-qmusicnl-cdp.triple-it.nl/Qmusic_nl_nonstop_96.mp3", volume = 0.3, name = "[Q-Music Non-Stop]"}
supersede_radio "RADIO_18_90S_ROCK" { url = "https://stream.slam.nl/slam_mp3", volume = 0.3, name = "[Slam! Live]" }
supersede_radio "RADIO_19_USER" { url = "http://icecast.omroep.nl/funx-dance-bb-mp3", volume = 0.3, name = "[FunX Dance]"}
supersede_radio "RADIO_20_THELAB" { url = "http://playerservices.streamtheworld.com/api/livestream-redirect/TLPSTR11.mp3", volume = 0.3, name = "[538 Hitzone]"}
supersede_radio "RADIO_21_DLC_XM17" { url = "http://streams.olympia-radio.nl/olympia", volume = 0.3, name = "[Olympia Radio]"}
supersede_radio "RADIO_22_DLC_BATTLE_MIX1_RADIO" { url = "http://icecast.omroep.nl/funx-reggae-bb-mp3", volume = 0.3, name = "[FunX Reggae]"}

files {
	"index.html"
}

ui_page "index.html"

client_scripts {
	"data.js",
	"client.js"
}
