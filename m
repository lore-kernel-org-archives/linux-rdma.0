From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: AW: AW: IPoIB GRO
Date: Mon, 4 Nov 2013 13:21:28 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A45CF@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>,<527759C6.3070009@dev.mellanox.co.il>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>,<52779612.9020103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-21646519-1695-4244-ab48-595fad918771"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52779612.9020103-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-21646519-1695-4244-ab48-595fad918771
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Hi Markus,=0A=
> =0A=
> Can you please tell me what is the FW version you have on your ConnectX=
=0A=
> cards?=0A=
=0A=
of course. the server has:=0A=
=0A=
root@client:~# ibstat=0A=
CA 'mlx4_0'=0A=
        CA type: MT26418=0A=
        Number of ports: 1=0A=
        Firmware version: 2.9.1000=0A=
        Hardware version: a0=0A=
        Node GUID: 0x0002c903000ec11a=0A=
        System image GUID: 0x0002c903000ec11d=0A=
        Port 1:=0A=
                State: Active=0A=
                Physical state: LinkUp=0A=
                Rate: 20=0A=
                Base lid: 4=0A=
                LMC: 0=0A=
                SM lid: 2=0A=
                Capability mask: 0x02510868=0A=
                Port GUID: 0x0002c903000ec11b=0A=
=0A=
The  client has an older 2.7.x firmware. Mostly because of=0A=
the X58 chipset incompatibility with newer firmwares. Your=0A=
question suggests that this behaviour may be related to the =0A=
older firmware. So I changed the client side test to another =0A=
host with newer firmware. Nevertheless the TSO problem =0A=
occurs there too.=0A=
=0A=
root@client:~# ibstat=0A=
CA 'mlx4_0'=0A=
        CA type: MT25418=0A=
        Number of ports: 2=0A=
        Firmware version: 2.9.1000=0A=
        Hardware version: a0=0A=
        Node GUID: 0x001e0bffff4cf9c4=0A=
        System image GUID: 0x001e0bffff4cf9c7=0A=
        Port 1:=0A=
                State: Active=0A=
                Physical state: LinkUp=0A=
                Rate: 20=0A=
                Base lid: 14=0A=
                LMC: 0=0A=
                SM lid: 2=0A=
                Capability mask: 0x02510868=0A=
                Port GUID: 0x001e0bffff4cf9c5=0A=
        Port 2:=0A=
                State: Down=0A=
                Physical state: Polling=0A=
                Rate: 10=0A=
                Base lid: 0=0A=
                LMC: 0=0A=
                SM lid: 0=0A=
                Capability mask: 0x02510868=0A=
                Port GUID: 0x001e0bffff4cf9c6=0A=
=0A=
Best regards & thanks in advance.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-21646519-1695-4244-ab48-595fad918771
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

------=_NextPartTM-000-21646519-1695-4244-ab48-595fad918771--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
