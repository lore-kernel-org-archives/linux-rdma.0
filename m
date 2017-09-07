From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core RESEND] libqedr: Add iWARP support for
 user-space lib
Date: Thu, 7 Sep 2017 06:45:31 +0000
Message-ID: <BN3PR07MB25783CFAAAA5DE95D0E10058F8940@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1504622214-9730-1-git-send-email-Ram.Amrani@cavium.com>
 <20170905151412.GA18205@obsidianresearch.com>
 <BN3PR07MB2578B8F3480B5218A06F2167F8970@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170906151944.GA6262@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170906151944.GA6262-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks.

> On Wed, Sep 06, 2017 at 09:18:58AM +0000, Amrani, Ram wrote:
> > > On Tue, Sep 05, 2017 at 05:36:54PM +0300, Ram Amrani wrote:
> > > > +		if (iwarp) {
> > > > +			writel(qp->rq.iwarp_db2_data.raw, qp->rq.iwarp_db2);
> > > > +			mmio_flush_writes();
> > > > +		}
> > >
> > > Can you update this driver to use the macros in util/mmio.h and
> > > discard this writel thing?
> >
> > Sure. I can write a dedicated patch to convert all of the locations at =
once.
> >
> > A couple of questions -
> >
> > I see that for 16, as an example, there are three functions:
> > 1) mmio_write16_le()
> > 2) mmio_write16_be()
> > 3) mmio_write16()
> > Per my understanding the first two do not manipulate the data and are o=
nly intended to
> > allow sparse to pass (and protect us).
>=20
> Yes..
>=20
> > However the 3rd performs htole. Is this correct?
>=20
> Yes, if necessary it performs the swap to create the defined TLP on
> any arches that require it.
>=20
> It is basically equivalent to the kernel's writel_relaxed
>=20
> > #define MAKE_WRITE(_NAME_, _SZ_)                                       =
        \
> >         static inline void _NAME_##_be(void *addr, __be##_SZ_ value)   =
        \
> >         {                                                              =
        \
> >                 atomic_store_explicit((_Atomic(uint##_SZ_##_t) *)addr, =
        \
> >                                       (__force uint##_SZ_##_t)value,   =
        \
> >                                       memory_order_relaxed);           =
        \
> >         }                                                              =
        \
> > What is the effect of the "relaxed ordering" if we use a non-WC BUS?
>=20
> memory_order_relaxed tells the compiler to WRITE_ONCE but otherwise
> not concern it self with ordering of stores.
>=20
> eg
>=20
>  *foo =3D 1
>   mmio_write16(bar, 12);
>=20
> Can be freely re-ordered during compilation and during execution.
>=20
> Code needs to insert a util/barrier.h if it requires ordering.
>=20
> But qedr is using WC right?

Yes.
Sometimes, however, I disable WC for various checks.

>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
