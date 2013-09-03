From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: Strange NFS client ACK behaviour
Date: Tue, 3 Sep 2013 18:28:04 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585722AA@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-b5792a2c-d331-4d39-83e9-5b6ca3903a77"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-b5792a2c-d331-4d39-83e9-5b6ca3903a77
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,=0A=
=0A=
we observed a performance drop in our IPoIB NFS backup=0A=
infrastructure since we switched to machines with newer =0A=
kernels. As I do not know where to start I hope someone =0A=
on this list can give me hint where to dig for more details.=0A=
=0A=
To make a long story short. We use ConnectX cards with the =0A=
standard kernel drivers on version 2.6.32 (Ubuntu 10.04), 3.5 =0A=
(Ubuntu 12.04) and 3.10 (Fedora 19). The very simple and not =0A=
scientific test consists of mounting a NFS share using IPoIB UD =0A=
network interfaces at MTU of 2044. Afterwards read a large file =0A=
on the client side with dd if=3Dfile of=3D/dev/null bs=3D256K. =0A=
During the transfer we run a tcpdump on the ibX interface on =0A=
the NFS server side. No special settings for kernel parameters =0A=
until now.=0A=
=0A=
When doing the test with a 2.6.32 kernel based client we see the=0A=
following packet sequence. More or less a lot of transferd blocks=0A=
from the NFS server to the client with sometimes an ACK package=0A=
from the client to the server:=0A=
=0A=
16:16:45.050930 IP server.nfs > cli_2_6_32.896: =0A=
  Flags [.], seq 8909853:8913837, ack 1154149, =0A=
  win 604, options [nop,nop,TS val 1640401415 =0A=
  ecr 3881919089], length 3984=0A=
16:16:45.050936 IP server.nfs > cli_2_6_32.896: =0A=
  Flags [.], seq 8913837:8917821, ack 1154149, =0A=
  win 604, options [nop,nop,TS val 1640401415  =0A=
  ecr 3881919089], length 3984=0A=
=0A=
... 8 more ...=0A=
=0A=
16:16:45.050976 IP cli_2_6_32.896 > server.nfs: =0A=
  Flags [.], ack 8909853, win 24574, options =0A=
  [nop,nop,TS val 3881919089 ecr 1640401415], =0A=
  length 0=0A=
...=0A=
=0A=
After switchng to a client with a newer kernel (3.5 or 3.10) the=0A=
sequence all of a sudden gives just the opposite behaviour.=0A=
One should note that this is the same server as in the test=0A=
above. The server sends bigger packets (I guess TSO is doing=0A=
the rest of the work). After each packet the client sends =0A=
several ACK packages back.=0A=
=0A=
16:15:21.038782 IP server.nfs > cli_3_5_0.928: =0A=
  Flags [.], seq 9612429:9652269, ack 372776, =0A=
  win 5815, options [nop,nop,TS val 1640380412 =0A=
  ecr 560111379], length 39840=0A=
16:15:21.038806 IP cli_3_5_0.928 > server.nfs: =0A=
  Flags [.], ack 9542205, win 16384, options =0A=
  [nop,nop,TS val 560111379 ecr 1640380412], =0A=
  length 0=0A=
16:15:21.038812 IP cli_3_5_0.928 > server.nfs: =0A=
  Flags [.], ack 9546077, win 16384, options =0A=
  [nop,nop,TS val 560111379 ecr 1640380412], =0A=
length 0=0A=
=0A=
... 6-8 more ...=0A=
=0A=
The visible side effects of this changed processing include:=0A=
- NIC interrupts on the NFS servers raise by a factor of 8. =0A=
- Transfer speed lowers by 50% (400->200 MB/sec)=0A=
=0A=
Best regards.=0A=
=0A=
Markus=
------=_NextPartTM-000-b5792a2c-d331-4d39-83e9-5b6ca3903a77
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

------=_NextPartTM-000-b5792a2c-d331-4d39-83e9-5b6ca3903a77--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
