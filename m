From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: IPoIB GRO
Date: Sun, 3 Nov 2013 10:58:23 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-158363d1-7b8c-4bca-8d11-472c34bb8a4d"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-158363d1-7b8c-4bca-8d11-472c34bb8a4d
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,=0A=
=0A=
I have a little update to the unlucky GRO IPoIB behaviour I observed =0A=
in the last weeks in datagram mode on our ConnectX cards. In the=0A=
GRO receive path the kernel steps into the inet_gro_receive() function=0A=
of net/ipv4/af_inet.c. If I read the code right it compares two=0A=
IP packets and decides if they come from the same "flow". =0A=
Further checks are included in some subroutines that narrow=0A=
down the comparison to IPv4 and so on.=0A=
=0A=
I put a debugging message into the following comparison that=0A=
seems to be the culprit of it all. =0A=
=0A=
inet_gro_receive()=0A=
  ...=0A=
  /* All fields must match except length and checksum. */=0A=
  NAPI_GRO_CB(p)->flush |=3D=0A=
    (iph->ttl ^ iph2->ttl) |=0A=
    (iph->tos ^ iph2->tos) |=0A=
    (__force int)((iph->frag_off ^ iph2->frag_off) & htons(IP_DF)) |=0A=
    ((u16)(ntohs(iph2->id) + NAPI_GRO_CB(p)->count) ^ id);=0A=
  /* Do some debug */=0A=
  printk("%i %i %i\n",ntohs(iph2->id),NAPI_GRO_CB(p)->count,id);=0A=
  ...=0A=
=0A=
On a normal GBit Intel card the kernel output reads:=0A=
=0A=
32933 12 32945 =0A=
32933 13 32946=0A=
32946 1 32947=0A=
32946 2 32948=0A=
...=0A=
32946 15 32961=0A=
32964 3 32967=0A=
32964 4 32968=0A=
...=0A=
=0A=
The interpretation of it all should be that packet ids must match =0A=
the sum of the initial packet id plus its count field. Then=0A=
we have a GRO candidate.=0A=
=0A=
On our ib0 interface the count field of a received packet seems=0A=
to be 1 most of the time and the packet id always matches the=0A=
initial packet id:=0A=
=0A=
35754 1 35754=0A=
35754 1 35754=0A=
35754 1 35754=0A=
...=0A=
35754 1 35786=0A=
35786 1 35786=0A=
35786 1 35786=0A=
...=0A=
=0A=
Thats why the flush flag is always set and the GRO stack does=0A=
not work at all. I'm willing to dig deeper into this but I'm unsure =0A=
if those fields are filled on sender or receiver side and especially =0A=
where in the IPoIB stack. Maybe someone can point me into the=0A=
right direction so that I can dig deeper and provide some more =0A=
information.=0A=
=0A=
Bet regards.=0A=
=0A=
Markus=0A=
=0A=
------=_NextPartTM-000-158363d1-7b8c-4bca-8d11-472c34bb8a4d
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

------=_NextPartTM-000-158363d1-7b8c-4bca-8d11-472c34bb8a4d--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
