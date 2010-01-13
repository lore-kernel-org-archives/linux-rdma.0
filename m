From: Bryan Green <bryan.d.green-NSQ8wuThN14@public.gmane.org>
Subject: Re: Documentation for libiverbs?
Date: Wed, 13 Jan 2010 10:09:15 -0800
Message-ID: <20100113180915.685262448E@vis06.nas.nasa.gov>
References: <S1752421Ab0AMJqp/20100113094645Z+1609@vger.kernel.org> <4B4D9B1E.1020604@eso.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4B4D9B1E.1020604-hv++7WL8WN4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Werther Pirani <wpirani-hv++7WL8WN4@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Werther Pirani writes:
>     Hello,
> 
> I've been redirected to this list from OpenFabrics' web site, so let me apo=
> logise=20
> right away if this is not the right place for this question.
> 
> We are writing an application that requires high throughput and low latency=
> . More=20
> specifically, we need to take advantage of features like RDMA, possibly thr=
> ough=20
> the ibv_ API in libiverbs, but the documentation available is really too sk=
> etchy=20
> to be of any help (and even the OpenFabrics' web site isn't of any use in t=
> his=20
> respect).
> 
> At the moment all I have to go by is the RDMA_RC_example in the "RDMA Ware =
> Network=20
> Programming User's Manual" from Mellanox, but it's really not quite enough.=
>  Since=20
> even searching the web isn't turning out any documentation, I was wondering=
>  if=20
> anyone here has any to share.

You should read Chapters 10 (Software Transport Interface) and 11 (Software
Transport Verbs) of the Infiniband Architecture Specification, Volume 1.

Then, besides the example code such as ib_write_bw and ib_rdma_bw, there are the man pages for libibverbs
and librdmacm.

-Bryan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
