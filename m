From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: Re: AW: AW: ACK behaviour difference LRO/GRO
Date: Tue, 29 Oct 2013 21:17:32 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A214B@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F@EXCHANGE.collogia.de>,<526F725A.1040009@mellanox.com>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A0CFD@EXCHANGE.collogia.de>
 <526F9F5A.7010903@mellanox.com>
 <526FB051.5020709@dev.mellanox.co.il>,<526FBEF7.2030807@mellanox.com>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A1FCB@EXCHANGE.collogia.de>,<526FDA6E.3030708@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-28988efd-d523-4821-9fbe-326d016e0807"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526FDA6E.3030708-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-28988efd-d523-4821-9fbe-326d016e0807
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: Or Gerlitz [ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]=0A=
> Gesendet: Dienstag, 29. Oktober 2013 16:55=0A=
> An: Markus Stockhausen; Erez Shitrit=0A=
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Yishai Hadas; s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Sa=
eed Mahameed=0A=
> Betreff: Re: AW: AW: ACK behaviour difference LRO/GRO=0A=
> =0A=
> On 29/10/2013 17:54, Markus Stockhausen wrote:=0A=
> > Should I exepect GRO to work on Mellanox IB cards with Linux 3.12 in ge=
neral?=0A=
> =0A=
> YES=0A=
=0A=
I'm so sorry to tell you that a jump on the 3.12 rc6 bandwagon did not=0A=
gave a better picture. To sum up the most recent situation: =0A=
=0A=
- NFS server based on a 3.5 kernel =0A=
- Server has an "older" Xeon L5420=0A=
- NFS client based on a 3.12 rc6 kernel - NFS version 3/4 does not matter =
=0A=
- Client has a newer Core i7=0A=
- Both ends use datagram mode with 2K MTU =0A=
- Client reads data from NFS (RAM) with dd into null device=0A=
- tcpdump is running on the server side.=0A=
=0A=
>From the dump I can see most of the time about 20 incoming ack =0A=
packets for one sent out data packet of size 64k. Statistics from =0A=
/proc/interrupts on the server side give a result that fits the picture. =
=0A=
~870000 interrupts for 4GB transferred data. That is round about one =0A=
interrupt per 4,5K. Not very scientific but at least an idea of what is =0A=
going on.=0A=
=0A=
With the mac address explanation of Erez in mind I would confirm that=0A=
there is still room to improve GRO even in newest kernels.=0A=
=0A=
Markus =0A=
=0A=
=0A=
------=_NextPartTM-000-28988efd-d523-4821-9fbe-326d016e0807
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

------=_NextPartTM-000-28988efd-d523-4821-9fbe-326d016e0807--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
