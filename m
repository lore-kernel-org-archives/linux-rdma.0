From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: add a simple SRQ pool per PD
Date: Sat, 18 Nov 2017 09:36:56 +0200
Message-ID: <20171118073656.GS18825@mtr-leonro.local>
References: <1510852885-25519-1-git-send-email-maxg@mellanox.com>
 <1510852885-25519-2-git-send-email-maxg@mellanox.com>
 <20171116181049.GO18825@mtr-leonro.local>
 <c94d2e03-dd32-ff0a-789f-aae4d65f3955@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m35yhtyYP/lVCYkX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c94d2e03-dd32-ff0a-789f-aae4d65f3955-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--m35yhtyYP/lVCYkX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 17, 2017 at 09:12:46PM +0200, Max Gurtovoy wrote:
> > > +#ifndef _RDMA_SRQ_POOL_H
> > > +#define _RDMA_SRQ_POOL_H 1
> > > +
> > > +#include <rdma/ib_verbs.h>
> > > +
> > > +struct ib_srq *ib_srq_pool_get(struct ib_pd *pd);
> > > +void ib_srq_pool_put(struct ib_pd *pd, struct ib_srq *srq);
> > > +
> > > +int ib_srq_pool_init(struct ib_pd *pd, int nr,
> > > +		struct ib_srq_init_attr *srq_attr);
> > > +void ib_srq_pool_destroy(struct ib_pd *pd);
> >
> > Can you please use rdma_ prefix instead of ib_ prefix?
> >
> > Thanks
> >
>
> Do you mean rdma_srq_pool_get instead of ib_srq_pool_get ? is this new
> convetion ? this is a pool that contain ib_srq objects and not rdma_srq
> objects..

I want to follow similar pattern as was chosen for various popular pools
implementation, like dma_pool_, mempool e.t.c

IMHO rdma_srqpool_* looks cleaner than it is now.

Thanks

>
> I can do it if needed.

>
> > > +
> > > +#endif /* _RDMA_SRQ_POOL_H */
> > > --
> > > 1.8.3.1
> > >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--m35yhtyYP/lVCYkX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloP4xgACgkQ5GN7iDZy
WKfNVA//csFnNIPapNb4SBZ5lfnuAPfcuTI8rgWTfJftS7YpPfx0oIQGv/c5nuUI
afSNaieVjCLHPTo7u75zhMnLxW3MNb9X0Z00VT8xewkaURW+q1dWxOdOAr1QpU8f
ZAT+35yhjKS112d6Kr2MgXsVbUhKJWhUw+l+nrTB7wA2Hb9EMfL0fPTkxmzPKYI6
oJvxFJXDYAOZIpejPmvf5TY4JLvCc6eA6cpjmykuN9II/uFD2eq1PDwBah+RtNEx
7hwRRUjG20URI9Zr+pnvV65EK4rN/4NMGefeAXWqQlUDaX1QCzLGfRaVZnscXlJl
Gs+Se9rd9ZAvJvkCBd2WaixekxMFFTXF5Ug6HQHWr8pKODBj9nC/z+jmIGSeR0KC
WCQjol3cOTbDEzES3yfgTweelKFgefSpRLY87D6I4YWg3usezV630RsU3SurZ3vj
BTooraNIJFTFC0ICdaQlvChci4dtk0xZY9gckSyk+HPe57DiDVTFCmxBHae3hcsV
XPHzz12f7a+NMoEEIdTV7ttq5SCYCFWP2W+IIrPUSvhuhFkbNfhYPeyXYfkMy5zX
y09NucpUGGh17U4EskzNYjM0pTANwGNeYYAlpqzLy3iGnRtxNjZ915WrhoM3kP8F
3ixeMcWTL7F0uj6a7RH37puT8Ll96S5mZvMVFwnqRd4P818nNgg=
=Mk5p
-----END PGP SIGNATURE-----

--m35yhtyYP/lVCYkX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
