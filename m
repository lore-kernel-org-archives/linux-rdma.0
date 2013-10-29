From: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Subject: AW: ACK behaviour difference LRO/GRO
Date: Tue, 29 Oct 2013 11:10:49 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173585A0CFD@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F@EXCHANGE.collogia.de>,<526F725A.1040009@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-e351d192-381d-4286-b08a-5eb8440f9e58"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526F725A.1040009-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: de-DE
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-e351d192-381d-4286-b08a-5eb8440f9e58
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> ________________________________________=0A=
> Von: Or Gerlitz [ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]=0A=
> Gesendet: Dienstag, 29. Oktober 2013 09:31=0A=
> An: Markus Stockhausen; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Yishai Hadas=0A=
> Cc: s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Erez Shitrit; Saeed Mahameed=0A=
> Betreff: Re: ACK behaviour difference LRO/GRO=0A=
> =0A=
> On 28/10/2013 21:34, Markus Stockhausen wrote:=0A=
> > After some quite hard test iterations the problem seems to come from th=
e=0A=
> > IPoIB switch from LRO to GRO between kernels 2.6.37 and 2.6.38.=0A=
> >=0A=
> > I built a test setup with a 2.6.38 kernel and additionaly compiled a 2.=
6.37=0A=
> > ib_ipoib module against it. This way I can run a direct comparison=0A=
> > between the old and new module. The major difference between the=0A=
> > two version is inside the ipoib_ib_handle_rx_wc() function:=0A=
> >=0A=
> > 2.6.37: lro_receive_skb(&priv->lro.lro_mgr, skb, NULL);=0A=
> > 2.6.38: napi_gro_receive(&priv->napi, skb);=0A=
> =0A=
> These two commits that went in 3.3=0A=
> =0A=
> 936d7de IPoIB: Stop lying about hard_header_len and use skb->cb to stash=
=0A=
> LL addresses=0A=
> a0417fa net: Make qdisc_skb_cb upper size bound explicit=0A=
> =0A=
> were supposed to make IPoIB/GRO to work properly, specifically with=0A=
> them, you should see aggregation coming into play=0A=
> =0A=
> I think Yishai Hadas from Mellanox was looking on that too, do we have=0A=
> any insights on the matter?=0A=
> =0A=
> Or.=0A=
=0A=
At least for the 2.6.38 that sounds clear. My initial post was about=0A=
3.5. and 3.10 test kernels that showed the missing aggregation. So=0A=
I'm still a bit away from a solution. I will try to get the test machine=0A=
back to 3.10/3.11 to validate it once again. =0A=
=0A=
Just to be on the right way: What are the basics to get GRO working =0A=
with a ConnectX (not 2 or 3) card in 2044 MTU datagram mode? =0A=
=0A=
- enable GRO with ethtool.=0A=
- Activate Coalescing with ethtool? If yes how?=0A=
=0A=
Thanks for the help.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-e351d192-381d-4286-b08a-5eb8440f9e58
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

------=_NextPartTM-000-e351d192-381d-4286-b08a-5eb8440f9e58--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
