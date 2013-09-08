From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: AW: Strange NFS client ACK behaviour
Date: Sun, 8 Sep 2013 18:24:57 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD17358574B51@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585722AA@EXCHANGE.collogia.de>,<CABgxfbF6iWsDei3De0ePsrVnA-a3vYuUbD07Bog6m1Mquy6Ecw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-e86bdd11-a4ba-41d4-91fb-684e77f84452"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbF6iWsDei3De0ePsrVnA-a3vYuUbD07Bog6m1Mquy6Ecw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-e86bdd11-a4ba-41d4-91fb-684e77f84452
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: Wendy Cheng [s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]=0A=
> Gesendet: Donnerstag, 5. September 2013 18:42=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org=0A=
> Betreff: Re: Strange NFS client ACK behaviour=0A=
> =0A=
> CC linux-nfs .. maybe this is obvious to someone there ... Two=0A=
> comments inlined below.=0A=
> =0A=
> On Tue, Sep 3, 2013 at 11:28 AM, Markus Stockhausen=0A=
> <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org> wrote:=0A=
> > Hello,=0A=
> >=0A=
> > we observed a performance drop in our IPoIB NFS backup=0A=
> > infrastructure since we switched to machines with newer=0A=
> > kernels. As I do not know where to start I hope someone=0A=
> > on this list can give me hint where to dig for more details.=0A=
> =0A=
> In case of no other reply, I would start w/ a socket program (or a=0A=
> network performance measuring tool) on the interface that does similar=0A=
> logic as "dd" you described below; that is, send a 256K message in a=0A=
> fixed number of loops (so total transfer size somewhere close to your=0A=
> file size) between client and server, followed by comparing the=0A=
> interrupt counters (cat /proc/interrtups) on both kernels. If the=0A=
> interrupt count differs as you described, the problem is most likely=0A=
> with the IB driver, not NFS layer.=0A=
> =0A=
> >=0A=
> > To make a long story short. We use ConnectX cards with the=0A=
> > standard kernel drivers on version 2.6.32 (Ubuntu 10.04), 3.5=0A=
> > (Ubuntu 12.04) and 3.10 (Fedora 19). The very simple and not=0A=
> > scientific test consists of mounting a NFS share using IPoIB UD=0A=
> > network interfaces at MTU of 2044. Afterwards read a large file=0A=
> > on the client side with dd if=3Dfile of=3D/dev/null bs=3D256K.=0A=
> > During the transfer we run a tcpdump on the ibX interface on=0A=
> > the NFS server side. No special settings for kernel parameters=0A=
> > until now.=0A=
> =0A=
> I don't know much about ConnectX. Not sure what "IPoIB UD" means ?=0A=
> "Datagram vs. CM" or "TCP vs. UDP" ?=0A=
> =0A=
=0A=
Hello,=0A=
=0A=
thanks for stopping by. I followed your advise and compared the=0A=
behaviour to a tcpdump of a netserver/netperf session. That reads=0A=
more normal:=0A=
=0A=
20:06:50.397472 IP server.43845 > client.58489: seq ... length 63744=0A=
20:06:50.397531 IP client.58489 > server.43845: ack ... length 0=0A=
20:06:50.397567 IP server.43845 > client.58489: seq ... length 63744=0A=
20:06:50.397595 IP server.43845 > client.58489: seq ... length 63744=0A=
20:06:50.397622 IP server.43845 > client.58489: seq ... length 63744=0A=
20:06:50.397632 IP client.58489 > server.43845: ack ... length 0=0A=
20:06:50.397667 IP server.43845 > client.58489: seq ... length 63744=0A=
20:06:50.397715 IP client.58489 > server.43845: ack ... length 0=0A=
20:06:50.397723 IP client.58489 > server.43845: ack ... length 0=0A=
=0A=
It is not really comparable as we se transfers to several ports=0A=
but at least a much better ratio between send and ack packets.=0A=
Seems like further digging in NFS behaviour is required. But=0A=
that may be another story.=0A=
=0A=
Markus=0A=
=0A=
=0A=
------=_NextPartTM-000-e86bdd11-a4ba-41d4-91fb-684e77f84452
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

------=_NextPartTM-000-e86bdd11-a4ba-41d4-91fb-684e77f84452--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
