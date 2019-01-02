From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH -next] IB/qib: Add missing err handle for
 qib_user_sdma_rb_insert
Date: Wed, 2 Jan 2019 20:40:50 +0200
Message-ID: <20190102184050.GI5424@mtr-leonro.mtl.com>
References: <20181221021938.13784-1-yuehaibing@huawei.com>
 <20190102171224.GA26765@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rMWmSaSbD7nr+du9"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190102171224.GA26765@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: YueHaibing <yuehaibing@huawei.com>, dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--rMWmSaSbD7nr+du9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 02, 2019 at 10:12:24AM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 21, 2018 at 10:19:38AM +0800, YueHaibing wrote:
> > It should goto err handle if qib_user_sdma_rb_insert fails,
> > other than success return.
> >
> > Fixes: 67810e8c3c01 ("RDMA/qib: Remove all occurrences of BUG_ON()")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  drivers/infiniband/hw/qib/qib_user_sdma.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
> > index 31c523b..e87c0a7 100644
> > --- a/drivers/infiniband/hw/qib/qib_user_sdma.c
> > +++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
> > @@ -237,6 +237,8 @@ qib_user_sdma_queue_create(struct device *dev, int unit, int ctxt, int sctxt)
> >
> >  		ret = qib_user_sdma_rb_insert(&qib_user_sdma_rb_root,
> >  					sdma_rb_node);
> > +		if (ret == 0)
> > +			goto err_rb;
> >  	}
>
> This doesn't look right, what about undoing the kmalloc directly
> above?

Back then, I came to conclusion that qib_user_sdma_rb_insert() never
returns 0. Otherwise, Dennis would see that BUG_ON() for a long time
ago.

Thanks

>
> Jason

--rMWmSaSbD7nr+du9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcLQWyAAoJEORje4g2clinTXQP/3g26wJfvgrpjNoC1NKzLBli
H99XIUi7CD2/1moHI+f/oinbOiVPPAK7oOZPcQ0RZ4V0R8iTC8+1gcskxdvU9ypc
08CD5mxuzPOfjg8G5/PVmKMx26cPgswxgFc1BbSfuC8LPFa7xqn/DrwXJMEs8CO5
YJG8ClyaRdED1oEkyh8tpDCiiwRDuzSGzyaF4V9OGzy2h122RTliubmxeT9RkZYt
GKH1V2cJuxaCd3bnNUFAFMGOXv+DxRBWROBz7y+ECw2TTn23yKojL0bW2nIIZRFM
IX13iW0+ehUGwAzhzBjOZ3ILw2DfTig36vax1bixYnXmS2sh58CTxrDiZdD/XLee
GDbLjH4G1lHutpi2qf8T6e4l4s9AuLKaQ2pnKNpR3JEq5GN9plLl3sZX0hrmd8UW
LgNBu6/iy8F/bDi8YlVqmsjzYpsgA5aPZzxcT0z7JJTjXpu9+A90jBQ9oKkvZRYT
ZbcqtS1SRS2p+A5N3KocaueLiMyySs5anb5yxKfuycoOjjtlQVpCxUheLlOKJqR8
XkQD+YBsNQSEF3qpj6Ym4wKWDe+mUFcDllgQD/ExfAYedheY1DU2uvWQC0bdAhdj
pJ5FMMPGtO5F6wC5bs3NDqcWMYdqq+B/d/boXgMVJ1SDiCBBxqshhYZimvhluvmo
LQb9xXP4IFBHneNkHtJQ
=3aEi
-----END PGP SIGNATURE-----

--rMWmSaSbD7nr+du9--
