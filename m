From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Tue, 21 Jan 2014 23:27:38 -0800
Message-ID: <1390375658.5567.917.camel@haakon3.risingtidesystems.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
	 <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
	 <52CD1C68.4050406@mellanox.com>
	 <1389645171.5567.459.camel@haakon3.risingtidesystems.com>
	 <1389820541.5567.543.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
	 <1389906852.5567.668.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>
	 <1390102949.5567.749.camel@haakon3.risingtidesystems.com>
	 <52DBB4F1.4020400@mellanox.com>
	 <CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>
	 <CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>
	 <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland & Co,

On Tue, 2014-01-21 at 16:43 -0800, Roland Dreier wrote:
> On Tue, Jan 21, 2014 at 2:00 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> > Roland, ping! the signature patches were posted > three months ago.=
 We
> > deserve a response from the maintainer that goes beyond "I need to
> > think on that".
> >
> > Responsiveness was stated by Linus to be the #1 requirement from
> > kernel maintainers.
>=20
> Or, I'm not sure what response you're after from me.  Linus has also
> said that maintainers should say "no" a lot more
> (http://lwn.net/Articles/571995/) so maybe you want me to say, "No, I
> won't merge this patch set, since it adds a bunch of complexity to
> support a feature no one really cares about."  Is that it?=20

The patch set proposed by Sagi + Or is modest in terms of LOC to core I=
B
code, and includes mostly mlx5 specific driver changes that enables HW
offloads.

> (And yes I
> am skeptical about this stuff =E2=80=94 I work at an enterprise stora=
ge
> company and even here it's hard to find anyone who cares about
> DIF/DIX, especially offload features that stop it from being
> end-to-end)
>=20

My understanding is most HBAs capable of T10 PI offload in DIX PASS +
VERIFY mode are already implementing DIX INSERT + STRIP modes in variou=
s
capacities to support legacy environments.

Beyond the DIX INSERT + STRIP case for enterprise storage, the amount o=
f
=46C + SAS HBAs that already support T10 PI metadata is substantial.

> I'm sure you're not expecting me to say, "Sure, I'll merge it without
> understanding the problem it's solving or how it's doing that,"
> especially given the your recent history of pushing me to merge stuff
> like the IP-RoCE patches back when they broke the userspace ABI.

With the merge window now upon us, there is a understandable reluctance
to merge new features.  Given the amount of time the series has spent o=
n
the list, it is however a good candidate to consider for an exception.

Short of that, are you planning to accept the series for the next round
once the current merge window closes..?

We'd really like to start enabling fabrics with these types of offloads
for v3.15.=20

> I'd really rather spend my time on something actually useful like
> cleaning up softroce.
>=20

+1 for softroce + T10 PI support!

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
