From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Concall with Doug
Date: Mon, 25 Sep 2017 21:29:41 -0600
Message-ID: <20170926032941.GB7599@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, skc-YOWKrPYUwWM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Everyone,

As a follow up to LPC we are going to have a public con call with Doug, with
the following agenda:

- Doug: Explain new process used in 4.14, feed back?
- Leon: Explain how Mellanox is handling net-next coordination and
   timing of net tree acceptance vs rdma tree acceptance
- Jason/All: QA coordination and ensuring QA cycles are well spent,
   eg 'what to test'
- Distributing patch acceptance, covering PTO periods, etc.
- Open mic period

This will probably make the most sense in the context of the LPC
discussions, but of course everyone is welcome to listen in and
participate.

I would like to get to all topics so I will MC the call to keep things
moving.

The time is 10 am PDT, Thursday Sep 28. Leon was first to donate a
bridge, attached is an ISC file with all the information.

Regards,
Jason

--HlL+5n6rz5pIUxbD
Content-Type: text/calendar; charset=us-ascii
Content-Disposition: attachment; filename="linux.ics"

BEGIN:VCALENDAR
METHOD:REQUEST
PRODID:Microsoft Exchange Server 2010
VERSION:2.0
BEGIN:VTIMEZONE
TZID:Israel Standard Time
BEGIN:STANDARD
DTSTART:16010101T020000
TZOFFSETFROM:+0300
TZOFFSETTO:+0200
RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=-1SU;BYMONTH=10
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:16010101T020000
TZOFFSETFROM:+0200
TZOFFSETTO:+0300
RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=4FR;BYMONTH=3
END:DAYLIGHT
END:VTIMEZONE
BEGIN:VEVENT
ORGANIZER;CN=Leon Romanovsky:MAILTO:leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=Jason Gunt
 horpe:MAILTO:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
DESCRIPTION;LANGUAGE=en-US:When: Thursday\, September 28\, 2017 20:00-21:00
  (UTC+02:00) Jerusalem.\nWhere: Skype Meeting\n\nNote: The GMT offset abov
 e does not reflect daylight saving time adjustments.\n\n*~*~*~*~*~*~*~*~*~
 *\n\nHi Jason\,\n\nThis is the bridge for the coming community call.\nPlea
 se let me know if Lync is ok or should I open Webex instead?\n\nThanks\n..
 ..........................................................................
 .............................................................\n--> Join Sk
 ype Meeting<https://mtrmeet.mellanox.com/leonro/M7892MJ7>\n  Trouble Joini
 ng? Try Skype Web App<https://mtrmeet.mellanox.com/leonro/M7892MJ7?sl=1>\n
 Join by phone\n+972 (74) 7237000 (Israel)<tel:+972%20(74)%207237000%20(Isr
 ael)>                        English (United States)\n+33 (805) 100672 (Fr
 ance Toll Free)<tel:+33%20(805)%20100672%20(France%20Toll%20Free)>        
   English (United States)\n+49 (800) 5892698 (Germany Toll Free)<tel:+49%2
 0(800)%205892698%20(Germany%20Toll%20Free)>              English (United S
 tates)\n8 800 1006947 (Russia Toll Free)<tel:8%20800%201006947%20(Russia%2
 0Toll%20Free)>                        English (United States)\n+44 (800) 1
 700936 (UK Toll Free)<tel:+44%20(800)%201700936%20(UK%20Toll%20Free)>     
                    English (United States)\n+1 (888) 3314421 (US Toll Free
 )<tel:+1%20(888)%203314421%20(US%20Toll%20Free)>                  English 
 (United States)\n+972 (1809) 494180 (IL Toll Free)<tel:+972%20(1809)%20494
 180%20(IL%20Toll%20Free)>                      English (United States)\n+4
 0 (800) 895907 (Romania Toll Free)<tel:+40%20(800)%20895907%20(Romania%20T
 oll%20Free)>                English (United States)\n+61 (1800) 459683 (Au
 stralia Toll Free)<tel:+61%20(1800)%20459683%20(Australia%20Toll%20Free)> 
          English (United States)\n+81 (800) 1700770 (Japan Toll Free)<tel:
 +81%20(800)%201700770%20(Japan%20Toll%20Free)>          English (United St
 ates)\n+82 (007) 9885214386 (South Korea Toll Free)<tel:+82%20(007)%209885
 214386%20(South%20Korea%20Toll%20Free)>      English (United States)\n+4 5
 80 880 552 (Denmark Toll free)<tel:+4%20580%20880%20552%20(Denmark%20Toll%
 20free)>          English (United States)\n+44 (203) 1500253 (UK)<tel:+44%
 20(203)%201500253%20(UK)>                                English (United S
 tates)\n+1 (408) 9160061 (US West)<tel:+1%20(408)%209160061%20(US%20West)>
                       English (United States)\n+1 (978) 4395425 (US East)<
 tel:+1%20(978)%204395425%20(US%20East)>                      English (Unit
 ed States)\n+91 000 (800) 0401963 (India Toll Free)<tel:+91%20000%20(800)%
 200401963%20(India%20Toll%20Free)>                English (United States)\
 n+55 (800) 8923204 (Brazil Toll Free)<tel:+55%20(800)%208923204%20(Brazil%
 20Toll%20Free)>                Portuguese (Brazil)\n+52 (1800) 7334070 (Me
 xico Toll Free)<tel:+52%20(1800)%207334070%20(Mexico%20Toll%20Free)>      
         English (United States)\n+27 (800) 988088 (South Africa Toll Free)
 <tel:+27%20(800)%20988088%20(South%20Africa%20Toll%20Free)>            Eng
 lish (United States)\n0018009720127 (Thailand Toll Free)<tel:0018009720127
 %20(Thailand%20Toll%20Free)>                English (United States)\n+41 (
 800) 321019 (Switzerland Toll Free)<tel:+41%20(800)%20321019%20(Switzerlan
 d%20Toll%20Free)>                English (United States)\n+86-1057892250 C
 hina<tel:+86-1057892250%20China>                                English (U
 nited States)\n+86 (400) 6713580 China Toll-Free<tel:+86%20(400)%206713580
 %20China%20Toll-Free>                        English (United States)\n+886
 -281786069 Taiwan<tel:+886-281786069%20Taiwan>                            
   English (United States)\n+886 00801979798 (Taiwan Toll Free)<tel:+886%20
 00801979798%20(Taiwan%20Toll%20Free)>            English (United States)\n
 +65-63504799 Singapore<tel:+65-63504799%20Singapore>                      
       English (United States)\n+65 (800) 9721125 (Singapore Toll Free)<tel
 :+65%20(800)%209721125%20(Singapore%20Toll%20Free)>          English (Unit
 ed States)\n+64 (800) 451030 (New Zealand Toll Free)<tel:+64%20(800)%20451
 030%20(New%20Zealand%20Toll%20Free)>              English (United States)\
 n+39 (800) 098375 (Italy Toll Free)<tel:+39%20(800)%20098375%20(Italy%20To
 ll%20Free)>                    English (United States)\n+31 0800 0200698 (
 Netherlands Toll Free)<tel:+31%200800%200200698%20(Netherlands%20Toll%20Fr
 ee)>                English (United States)\nFind a local number<https://m
 trdialin.mellanox.com>\n\nConference ID: 6852361\n Forgot your dial-in PIN
 ?<https://mtrdialin.mellanox.com> |Help<https://o15.officeredir.microsoft.
 com/r/rlidLync15?clid=1033&p1=5&p2=2009>\n\n[!OC([1033])!]\n..............
 ..........................................................................
 .................................................\n\n\n
UID:040000008200E00074C5B7101A82E00800000000E00B76EEDB35D301000000000000000
 010000000B14CA7D61B1CAC439DBA3350CAAFDEF1
SUMMARY;LANGUAGE=en-US:Community Call
DTSTART;TZID=Israel Standard Time:20170928T200000
DTEND;TZID=Israel Standard Time:20170928T210000
CLASS:PUBLIC
PRIORITY:5
DTSTAMP:20170925T055617Z
TRANSP:OPAQUE
STATUS:CONFIRMED
SEQUENCE:0
LOCATION;LANGUAGE=en-US:Skype Meeting
X-MICROSOFT-CDO-APPT-SEQUENCE:0
X-MICROSOFT-CDO-OWNERAPPTID:-2095474719
X-MICROSOFT-CDO-BUSYSTATUS:TENTATIVE
X-MICROSOFT-CDO-INTENDEDSTATUS:BUSY
X-MICROSOFT-CDO-ALLDAYEVENT:FALSE
X-MICROSOFT-CDO-IMPORTANCE:1
X-MICROSOFT-CDO-INSTTYPE:0
X-MICROSOFT-ONLINEMEETINGEXTERNALLINK:https://mtrmeet.mellanox.com/leonro/M
 7892MJ7
X-MICROSOFT-ONLINEMEETINGCONFLINK:conf:sip:leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org\;gruu\;opaqu
 e=app:conf:focus:id:M7892MJ7?conversation-id=295c5xAYM
X-MICROSOFT-CONFERENCETELURI:tel:+972747237000\,\,6852361
X-MICROSOFT-DISALLOW-COUNTER:FALSE
BEGIN:VALARM
DESCRIPTION:REMINDER
TRIGGER;RELATED=START:-PT15M
ACTION:DISPLAY
END:VALARM
END:VEVENT
END:VCALENDAR

--HlL+5n6rz5pIUxbD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
