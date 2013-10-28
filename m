From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: ACK behaviour difference LRO/GRO
Date: Mon, 28 Oct 2013 19:34:45 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-d22594c1-bff9-43e8-b64e-854a615bb6a0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-d22594c1-bff9-43e8-b64e-854a615bb6a0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,=0A=
=0A=
about two month we had some problems with IPoIB transfer speeds . =0A=
See more http://marc.info/?l=3Dlinux-rdma&m=3D137823326109158&w=3D2=0A=
After some quite hard test iterations the problem seems to come from the =
=0A=
IPoIB switch from LRO to GRO between kernels 2.6.37 and 2.6.38. =0A=
=0A=
I built a test setup with a 2.6.38 kernel and additionaly compiled a 2.6.37=
=0A=
ib_ipoib module against it. This way I can run a direct comparison=0A=
between the old and new module. The major difference between the =0A=
two version is inside the ipoib_ib_handle_rx_wc() function:=0A=
=0A=
2.6.37: lro_receive_skb(&priv->lro.lro_mgr, skb, NULL);=0A=
2.6.38: napi_gro_receive(&priv->napi, skb);=0A=
=0A=
As in the last post we use ConnectX cards in datagram mode with a=0A=
2044 MTU.  We read a file sequentially from a NFS server into /dev/null. =
=0A=
We just want to get the wire speed neglecting hard drives. The =0A=
hardware is slightly newer so we get different transfer speeds but =0A=
the overall effect should be evident. The server uses a 3.5 kernel and =0A=
is not changed during the tests.=0A=
=0A=
With 2.6.37 IPoIB module on the client side and LRO enabled the =0A=
speed is 950 MByte/sec. On the NFS server side a tcpdump trace =0A=
reads like:=0A=
=0A=
19:51:51.432630 IP 10.10.30.251.nfs > 10.10.30.1.781: =0A=
  Flags [P.], seq 1008434065:1008497161, ack 617432, =0A=
  win 688, options [nop,nop,TS val 133047292 ecr 429568], =0A=
  length 63096=0A=
19:51:51.432672 IP 10.10.30.1.781 > 10.10.30.251.nfs: =0A=
  Flags [.], ack 1008241041, win 24576, options =0A=
  [nop,nop,TS val 429568 ecr 133047292], length 0=0A=
19:51:51.432677 IP 10.10.30.251.nfs > 10.10.30.1.781: =0A=
  Flags [.], seq 1008497161:1008560905, ack 617432, =0A=
  win 688, options [nop,nop,TS val 133047292 ecr 429568], =0A=
  length 63744=0A=
19:51:51.432725 IP 10.10.30.1.781 > 10.10.30.251.nfs: =0A=
  Flags [.], ack 1008304585, win 24576, options =0A=
  [nop,nop,TS val 429568 ecr 133047292], length 0=0A=
19:51:51.432729 IP 10.10.30.251.nfs > 10.10.30.1.781: =0A=
  Flags [.], seq 1008560905:1008624649, ack 617432, =0A=
  win 688, options [nop,nop,TS val 133047292 ecr 429568], =0A=
length 63744=0A=
=0A=
With some slight differences here and there the client sends only=0A=
1 ack for about 60k of transferred data. With 2.6.38 module and=0A=
onwards (GRO enabled) the speed drops down to 380 MByte/sec =0A=
and a different transfer pattern.=0A=
=0A=
19:58:14.631430 IP 10.10.30.251.nfs > 10.10.30.1.ircs: =0A=
  Flags [.], seq 722492293:722502253, ack 442312, win 537, =0A=
  options [nop,nop,TS val 133143092 ecr 467889], length 9960=0A=
19:58:14.631460 IP 10.10.30.1.ircs > 10.10.30.251.nfs: =0A=
  Flags [.], ack 722478181, win 24562, options =0A=
  [nop,nop,TS val 467889 ecr 133143092], length 0=0A=
19:58:14.631485 IP 10.10.30.1.ircs > 10.10.30.251.nfs: =0A=
  Flags [.], ack 722478181, win 24562, options =0A=
  [nop,nop,TS val 467889 ecr 133143092,nop,nop,sack 1 =0A=
  {722480117:722482333}], length 0=0A=
19:58:14.631510 IP 10.10.30.1.ircs > 10.10.30.251.nfs: =0A=
  Flags [.], ack 722488197, win 24562, options [nop,nop,TS =0A=
  val 467889 ecr 133143092], length 0=0A=
19:58:14.631534 IP 10.10.30.1.ircs > 10.10.30.251.nfs: =0A=
  Flags [.], ack 722494229, win 24562, options =0A=
  [nop,nop,TS val 467889 ecr 133143092], length 0=0A=
=0A=
It seems as if the NFS client acknowledges every 2K packet=0A=
separately. I thought that it may come from missing =0A=
coalescing parameters and tried a  "ethtool -C ib0 rx-usecs 5"=0A=
on both machines but without success.=0A=
=0A=
I'm quite lost now maybe someone can give a tip if I'm =0A=
missing something.=0A=
=0A=
Best regards.=0A=
=0A=
Markus=
------=_NextPartTM-000-d22594c1-bff9-43e8-b64e-854a615bb6a0
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

------=_NextPartTM-000-d22594c1-bff9-43e8-b64e-854a615bb6a0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
