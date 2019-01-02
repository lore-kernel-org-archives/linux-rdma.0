From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH -next] IB/qib: Add missing err handle for
 qib_user_sdma_rb_insert
Date: Wed, 2 Jan 2019 21:22:11 +0200
Message-ID: <20190102192211.GJ5424@mtr-leonro.mtl.com>
References: <20181221021938.13784-1-yuehaibing@huawei.com>
 <20190102171224.GA26765@ziepe.ca>
 <20190102184050.GI5424@mtr-leonro.mtl.com>
 <20190102190740.GH26211@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rV8arf8D5Dod9UkK"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190102190740.GH26211@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: YueHaibing <yuehaibing@huawei.com>, dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--rV8arf8D5Dod9UkK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 02, 2019 at 12:07:40PM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 02, 2019 at 08:40:50PM +0200, Leon Romanovsky wrote:
> > On Wed, Jan 02, 2019 at 10:12:24AM -0700, Jason Gunthorpe wrote:
> > > On Fri, Dec 21, 2018 at 10:19:38AM +0800, YueHaibing wrote:
> > > > It should goto err handle if qib_user_sdma_rb_insert fails,
> > > > other than success return.
> > > >
> > > > Fixes: 67810e8c3c01 ("RDMA/qib: Remove all occurrences of BUG_ON()")
> > > > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > > >  drivers/infiniband/hw/qib/qib_user_sdma.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
> > > > index 31c523b..e87c0a7 100644
> > > > +++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
> > > > @@ -237,6 +237,8 @@ qib_user_sdma_queue_create(struct device *dev, int unit, int ctxt, int sctxt)
> > > >
> > > >  		ret = qib_user_sdma_rb_insert(&qib_user_sdma_rb_root,
> > > >  					sdma_rb_node);
> > > > +		if (ret == 0)
> > > > +			goto err_rb;
> > > >  	}
> > >
> > > This doesn't look right, what about undoing the kmalloc directly
> > > above?
> >
> > Back then, I came to conclusion that qib_user_sdma_rb_insert() never
> > returns 0. Otherwise, Dennis would see that BUG_ON() for a long time
> > ago.
>
> It fails if the index is in the RB tree, which would indicate a
> programming bug.

I tried to say that this programming bug doesn't exist in the reality.

>
> The way to replace the BUG_ON is something like:
>
> if (WARN_ON(ret == 0)) {
>     kfree()
>     goto err_rb;
> }
>
> Jason

--rV8arf8D5Dod9UkK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcLQ9jAAoJEORje4g2clin/0EP/jyOpkvSoAVDoLD6Ct3VP6P0
bpSqwOhuu+qFj6bBY/hzpyhJ6Xth9oxz76ZoQyKqvbSzevUDtLR7XKD73ztFj3BJ
G4dNhMS+Zm5ctOcJCag3DA17QZ5ljPtiEwrHRtU8fnzCQXmnyc3GT+oCMSumQnUI
zmR+4A4h+Vi6DMG+WJYviLeMPF5X3K8nHICjZYeDRx1iARuhlSYTlBv5vrGplVaW
NkSmXjYP9DqngwA37PrAmsMoDtnIpAOBleZU/FA4NAx8GQHGLjPXT/zo6rJhYCVu
n+29JAM2ATpnAbUWLdxYtdg3Wpyg+3/5AkT7ewe/G1kq/Hx1UVZEMiYIVUMPD1AW
34PNJ1PwI6jL6c5ARWIKAM5mP9FP6VgMIJ2fUtIfWxed7n7F2pQDhessiT7XjOPx
QzZ2W5t/mkaB+A79ik6NBem5Y83Tj6ewBNpyY09vq3gusPWF8u1o1paZN6SW2wqC
+JNib70qwYPUU4RF5rWXdN+0tGU3qZLKxl83IWq++L+puD8/KwmhLzyuoAVVyIOW
cOz5bsfm2bqy/aAEXC19LJTpBBh73c3KMXjoCjihdI7m7arT31Z3hfIL098G5yb0
I+kix85NrviX1rhUKjKsq9CVTQg4a7ZJxhLVwyzbReewWzG5F5PXplsN5YtmvK4V
EZalHE25GOeccbvHw5Mv
=zx/n
-----END PGP SIGNATURE-----

--rV8arf8D5Dod9UkK--
