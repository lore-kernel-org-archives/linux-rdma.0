From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: AW: AW: ACK behaviour difference LRO/GRO
Date: Tue, 29 Oct 2013 15:54:17 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A1FCB@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F@EXCHANGE.collogia.de>,<526F725A.1040009@mellanox.com>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A0CFD@EXCHANGE.collogia.de>
 <526F9F5A.7010903@mellanox.com>
 <526FB051.5020709@dev.mellanox.co.il>,<526FBEF7.2030807@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-5e8d1331-45e3-4abf-bba1-c9fa49113e34"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526FBEF7.2030807-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-5e8d1331-45e3-4abf-bba1-c9fa49113e34
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: Or Gerlitz [ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]=0A=
> Gesendet: Dienstag, 29. Oktober 2013 14:58=0A=
> An: Erez Shitrit=0A=
> Cc: Markus Stockhausen; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Yishai Hadas; s.wendy=
.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Erez Shitrit; Saeed Mahameed=0A=
> Betreff: Re: AW: ACK behaviour difference LRO/GRO=0A=
> =0A=
> On 29/10/2013 14:55, Erez Shitrit wrote:=0A=
> > In addition to what Or just wrote,=0A=
> > GRO currently doesn't work on ipoib interfaces, that according to bad=
=0A=
> > handling mac address that are not 6 bytes (we have plans to fix that=0A=
> > in the near future), that is the reason you don't see 64k packets on=0A=
> > tcpdump (like you see in LRO).=0A=
> =0A=
> I just checked with net-next which is 3.12-rc6+ and there IS=0A=
> aggregationfor datagram mode=0A=
> =0A=
> > 15:56:40.983883 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags=0A=
> > [.], seq 1801688305:1801692289, ack 1, win 220, options [nop,nop,TS=0A=
> > val 44014459 ecr 305403520], length 3984=0A=
> > 15:56:40.983942 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags=0A=
> > [.], seq 1801692289:1801756033, ack 1, win 220, options [nop,nop,TS=0A=
> > val 44014459 ecr 305403520], length 63744=0A=
> > 15:56:40.984027 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags=0A=
> > [.], seq 1801756033:1801819777, ack 1, win 220, options [nop,nop,TS=0A=
> > val 44014459 ecr 305403520], length 63744=0A=
> > 15:56:40.984079 IP 192.168.20.17.40861 > 192.168.20.18.55714: Flags=0A=
> > [.], ack 1801688305, win 1544, options [nop,nop,TS val 305403520 ecr=0A=
> > 44014459], length 0=0A=
> > 15:56:40.984104 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags=0A=
> > [.], seq 1801819777:1801823649, ack 1, win 220, options [nop,nop,TS=0A=
> > val 44014459 ecr 305403520], length 3872=0A=
> > 15:56:40.984159 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags=0A=
> > [.], seq 1801823649:1801883521, ack 1, win 220, options [nop,nop,TS=0A=
> > val 44014459 ecr 305403520], length 59872=0A=
> > 15:56:40.984214 IP 192.168.20.17.40861 > 192.168.20.18.55714: Flags=0A=
> > [.], ack 1801819777, win 1009, options [nop,nop,TS val 305403520 ecr=0A=
> > 44014459], length 0=0A=
> > 15:56:40.984241 IP 192.168.20.18.55714 > 192.168.20.17.40861: Flags=0A=
> > [.], seq 1801883521:1801887393, ack 1, win 220, options [nop,nop,TS=0A=
> > val 44014459 ecr 305403520], length 3872=0A=
> =0A=
=0A=
Thanks to both of you for that clarification. Nevertheless this=0A=
info seems a little contradictionary. Should I exepect GRO to=0A=
work on Mellanox IB cards with Linux 3.12 in general? Or is =0A=
this only an effect because you have test cards with "good=0A=
mac addresses"?=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-5e8d1331-45e3-4abf-bba1-c9fa49113e34
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-5e8d1331-45e3-4abf-bba1-c9fa49113e34--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
