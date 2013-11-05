From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: AW: AW: AW: IPoIB GRO
Date: Tue, 5 Nov 2013 08:25:25 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A4B3D@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>,<527759C6.3070009@dev.mellanox.co.il>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>,<52779612.9020103@dev.mellanox.co.il>
 <12EF8D94C6F8734FB2FF37B9FBEDD173585A45CF@EXCHANGE.collogia.de>,<5278A757.2070406@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-f445c686-70f8-4e8f-ae0a-aa2465f8880a"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5278A757.2070406-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-f445c686-70f8-4e8f-ae0a-aa2465f8880a
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> I see. This didn't happen on our setups here since we tests with =0A=
> newer cards (ConnectX2/3/3-pro).=0A=
> For ConnectX1 (A0) and this firmware that you are using smells =0A=
> like something goes wrong. If possible, I would change to newish =0A=
> card.=0A=
=0A=
No problem with that. My journey up to here was hard but very =0A=
interesting. Especially when you expect everything in the system=0A=
to be consistent and new speedups with every new kernel or=0A=
driver version. Encountering a throughput drop of nearly 50% =0A=
with the upgrade of our NFS servers I was challenged.=0A=
=0A=
With TSO disabled on our old cards I'm back to LRO speeds and =0A=
I'm more than happy with that. =0A=
=0A=
Just a final clarification for the interested reader: Are the TCP Ids =0A=
in an TSO setup generated through firmware or in the software =0A=
stack? And if in firmware: How does the card know how to =0A=
increase them? I would expect that it only works with IB packets=0A=
and does not know of the IP encapsulation.=0A=
=0A=
Best regards.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-f445c686-70f8-4e8f-ae0a-aa2465f8880a
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

------=_NextPartTM-000-f445c686-70f8-4e8f-ae0a-aa2465f8880a--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
