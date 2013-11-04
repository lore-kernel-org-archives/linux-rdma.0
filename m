From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: AW: IPoIB GRO
Date: Mon, 4 Nov 2013 08:12:48 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A42C7@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-a6be6c64-bb3b-4a4d-918d-3eeb001038d8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-a6be6c64-bb3b-4a4d-918d-3eeb001038d8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Thats why the flush flag is always set and the GRO stack does=0A=
> not work at all. I'm willing to dig deeper into this but I'm unsure=0A=
> if those fields are filled on sender or receiver side and especially=0A=
> where in the IPoIB stack. =0A=
=0A=
Maybe I got the reason for that strange ack behaviour during=0A=
large NFS over IPoIB reads and hopefully someone can confirm this=0A=
=0A=
If I turn on TSO for an IPoIB datagram interface on the sender side =0A=
GRO on the receiver side is totally broken. This due to the fact that =0A=
TSO "generates" large 60k packets that are offloaded into =0A=
fragments. Each of these fragments has the same ID in the packet =0A=
header. GRO expects IDs to be in incremental order and issues a =0A=
flush after each package. Each flush results in an ACK packet back =0A=
to the server.=0A=
=0A=
With TSO disabled GRO can kick in. Packets are build with =0A=
sequential IDs. GRO only acknowledges every few packets.=0A=
=0A=
For a fully cached file read of 6GB the numbers read:=0A=
=0A=
TSO on: ~220MByte/s - 1,522,679 MLX4 Interrupts on server=0A=
TSO off: ~550MByte/s - 318,322 MLX4 Interrupts on server=0A=
=0A=
Is there any chance IPoIB TSO handling can be optimized?=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-a6be6c64-bb3b-4a4d-918d-3eeb001038d8
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

------=_NextPartTM-000-a6be6c64-bb3b-4a4d-918d-3eeb001038d8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
