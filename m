From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: AW: Strange NFS client ACK behaviour
Date: Tue, 10 Sep 2013 06:51:58 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735857537F@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585722AA@EXCHANGE.collogia.de>
	<CABgxfbF6iWsDei3De0ePsrVnA-a3vYuUbD07Bog6m1Mquy6Ecw@mail.gmail.com>
	<12EF8D94C6F8734FB2FF37B9FBEDD17358574B51@EXCHANGE.collogia.de>,<CABgxfbHYMi6z-7OHgfQnMNrihHPcqcipCnXZ65q5yXDJzK7rrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-f44df226-f931-441b-8355-9b10abed19f8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbHYMi6z-7OHgfQnMNrihHPcqcipCnXZ65q5yXDJzK7rrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-f44df226-f931-441b-8355-9b10abed19f8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: Wendy Cheng [s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]=0A=
> Gesendet: Montag, 9. September 2013 22:03=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org=0A=
> Betreff: Re: Strange NFS client ACK behaviour=0A=
> =0A=
> On Sun, Sep 8, 2013 at 11:24 AM, Markus Stockhausen=0A=
> <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org> wrote:=0A=
> =0A=
> >> > we observed a performance drop in our IPoIB NFS backup=0A=
> >> > infrastructure since we switched to machines with newer=0A=
> >> > kernels.=0A=
> >=0A=
> =0A=
> Not sure how your backup infrastructure works but the symptoms seem to=0A=
> match with this discussion:=0A=
> http://www.spinics.net/lists/linux-nfs/msg38980.html=0A=
> =0A=
> If you know how to recompile nfs kmod, Trond's patch does worth a try.=0A=
> Or open an Ubuntu support ticket, let them build you a test kmod.=0A=
> =0A=
> -- Wendy=0A=
=0A=
Thanks for pointing into that direction. From my understanding this=0A=
patch goes into the NFS client side. I built a patched module for my=0A=
Fedora 19 client (3.10 kernel). Nevertheless the behaviour ist still=0A=
the same.  If I get the patch right it is about forked childs that=0A=
access a page of a mmapped file round robin and the kernel issues =0A=
tons of write requests to the file.=0A=
=0A=
My case is only about ACK transmissions for a single writer.=0A=
=0A=
Markus=0A=
 =
------=_NextPartTM-000-f44df226-f931-441b-8355-9b10abed19f8
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

------=_NextPartTM-000-f44df226-f931-441b-8355-9b10abed19f8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
