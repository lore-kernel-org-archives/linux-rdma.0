From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: AW:  IPoIB GRO
Date: Wed, 6 Nov 2013 07:58:46 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A52D8@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>
 <527759C6.3070009@dev.mellanox.co.il>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>
 <52779612.9020103@dev.mellanox.co.il>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A45CF@EXCHANGE.collogia.de>
 <5278A757.2070406@mellanox.com>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A4B3D@EXCHANGE.collogia.de>
 <5278B0CA.9080305@dev.mellanox.co.il>,<20131105172431.GA14706@obsidianresearch.com>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A508B@EXCHANGE.collogia.de>,<5279F4DB.8040202@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-479d7217-a071-45cc-aab2-ddd07d5caeb5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5279F4DB.8040202-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-479d7217-a071-45cc-aab2-ddd07d5caeb5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: Or Gerlitz [ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]=0A=
> Gesendet: Mittwoch, 6. November 2013 08:50=0A=
> An: Markus Stockhausen; Jason Gunthorpe; Erez Shitrit=0A=
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Wendy Cheng=0A=
> Betreff: Re:  IPoIB GRO=0A=
> =0A=
> On 05/11/2013 20:08, Markus Stockhausen wrote:=0A=
> > Incredible how a card that does not support TSO can bring big packets=
=0A=
> > on the wire that somehow get reassembled on the client side=0A=
>not sure to follow, you have shown they are **not**  reassembled, correct?=
=0A=
=0A=
Sorry for being not correct. I meant that activating TSO=0A=
on that particular card seems to be nothing more than =0A=
creating fragments. They are reassembled but not in the=0A=
GRO path. From my stupid point of view that could have =0A=
resulted in much more problems than GRO not working =0A=
correctly. =0A=
=0A=
Markus=0A=
=0A=
------=_NextPartTM-000-479d7217-a071-45cc-aab2-ddd07d5caeb5
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

------=_NextPartTM-000-479d7217-a071-45cc-aab2-ddd07d5caeb5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
