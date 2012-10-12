From: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>
Subject: Re: (R)DMA in userspace
Date: Fri, 12 Oct 2012 11:12:43 +0200
Message-ID: <1350033163.2291.22.camel@test.quest-ce.net>
References: <OF84B00CFA.7F1CDA02-ONC1257A94.00545627-C1257A94.0055881A@ch.ibm.com>
	 <CAL1RGDUOMz7Qf8bX7hZpJgARGepLQRwY25f6Q1utYBZ0taMs9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUOMz7Qf8bX7hZpJgARGepLQRwY25f6Q1utYBZ0taMs9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 11 octobre 2012 =C3=A0 13:44 -0700, Roland Dreier a =C3=A9crit=
 :
> On Thu, Oct 11, 2012 at 8:34 AM, Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBihhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >
> > During memory memory registration, userspace buffers also go throug=
h same
> > API calls (dma_map_sg_attrs(...)).
> > What I am confused about why no such synchronization primitives are
> > required in userspace before accessing
> > an RDMA data buffer just after when an incoming write/recv (DMA on =
it) is
> > finished? Who guarantees data
> > freshness?
>=20
> No one has really ever tried to deal with the issue of userspace RDMA=
 on
> a cache-incoherent architecture.  Basically if you try the current st=
ack, the
> in-kernel users (IPoIB etc) should be OK but libibverbs etc. will be =
completely
> broken.
>=20

With the current ARMv7 Cortex-A9 / Cortex-A15 MPCore and the upcoming
ARM 64 bits architecture eg ARMv8 aka Aarch64, one might want in the
near future use RDMA (InfiniBand/RoCE) with them to create highly
parallel system with low-power consumption.=20

But this question and some reading about ARM memory management makes me
feel pretty unsure of the ability to use RDMA (InfiniBand) on ARM.

In this article: "ARM, DMA, and memory management"
http://lwn.net/Articles/440221/"=20
it is said that a memory page must not be mapped multiple time with
different caching attributes.

This article take the point of Linaro's developers who want to upload
texture to the GPU without holding them in caches. This behavior might
also be applicable to RDMA as well: writing to a memory zone to be
either local IBV_WR_SEND, local IBV_WR_RDMA_WRITE or remote
IBV_WR_RDMA_READ, there's probably no need to keep it in cache.

You could also read this other article "CMA [contiguous memory
allocator] and ARM" http://lwn.net/Articles/450286/
and "ARM's multiply-mapped memory mess" http://lwn.net/Articles/409689/

After reading this, and not being an ARM expert, I'm asking myself abou=
t
a possible RDMA (InfiniBand) support on ARM.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
