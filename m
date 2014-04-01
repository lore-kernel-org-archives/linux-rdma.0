From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Wed, 2 Apr 2014 00:31:51 +0300
Message-ID: <CAJZOPZLydM-My4imixChjJ6Sc3hsBbB6GXiiyi-C=rZ4FzGs7A@mail.gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 22, 2014 at 3:43 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
[...]
> I'd really rather spend my time on something actually useful like cleaning up softroce.

Hi Roland,

Were you referring to the code that was posted here few years ago, or
you're working on something new? two comments

1. make sure it uses IP based GIDs...

2. I think we don't want to have a 3rd SW implementation in the kernel
of IB transport, (1=ipath, 2=qib) right? so the relevant
qib code could/should be refactored  into a module which implements
the IB transport.

thoughts?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
