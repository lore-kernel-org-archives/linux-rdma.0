From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/rxe: check for allocation failure on elem
Date: Tue, 12 Sep 2017 17:48:29 +0300
Message-ID: <20170912144829.GR3405@mtr-leonro.local>
References: <20170908143745.2445-1-colin.king@canonical.com>
 <20170909125607.GA22465@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WkfBGePaEyrk4zXB"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170909125607.GA22465@mtr-leonro.local>
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--WkfBGePaEyrk4zXB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 09, 2017 at 03:56:07PM +0300, Leon Romanovsky wrote:
> On Fri, Sep 08, 2017 at 03:37:45PM +0100, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > The allocation for elem may fail (especially because we're using
> > GFP_ATOMIC) so best to check for a null return.  This fixes a potential
> > null pointer dereference when assigning elem->pool.
> >
> > Detected by CoverityScan CID#1357507 ("Dereference null return value")
> >
> > Fixes: 8700e3e7c485 ("Soft RoCE driver")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/infiniband/sw/rxe/rxe_pool.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
> > index c1b5f38f31a5..3b4916680018 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_pool.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_pool.c
> > @@ -404,6 +404,8 @@ void *rxe_alloc(struct rxe_pool *pool)
> >  	elem = kmem_cache_zalloc(pool_cache(pool),
> >  				 (pool->flags & RXE_POOL_ATOMIC) ?
> >  				 GFP_ATOMIC : GFP_KERNEL);
> > +	if (!elem)
> > +		return NULL;
> >
>
> It is not enough to simply return NULL, you also should release "pool" too.

Colin,
do you plan to fix the comment and resend it?

Thanks

>
> Thanks
>
> >  	elem->pool = pool;
> >  	kref_init(&elem->ref_cnt);
> > --
> > 2.14.1
> >



--WkfBGePaEyrk4zXB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm3870ACgkQ5GN7iDZy
WKfM5xAAx0CRcc2Y/b9bwaResORHrLlJh5zLi589gbJ2NiVaJQaWF9vQKrvVnBNJ
QWjrUf9LjSMuwB/ybShex12P5jDHdmJNOsHxHMVawuNj8O4n76/alFgAPZMPX1V6
4nQCZzwjBafVAxC8jOG/YO1nSfUp3NUyR7CK5im8fMI6LFBcrsQ6OgKIUcvO6ri7
qMQla2o2eHzk1oFpwjhu9kBGXQmoPP4JfLLDpECQapGnW8dCq8SdpQhOsHdhMlDf
V+fVqkiEo35n3NzlHtB9xUGgQTFxNvT/YQ9bLP2pmRI8JPUSPVy8E0/nyyCDhnMf
P4bM4gqMroT8pLGbImr2my0QRFDytDaapbgaIu3O0mwYEZwoDmel1l6RCZCOinx8
AufC3gPk7rdbfUviEP2mMcA8RTT4Rozdyu2zUkVNDh9W9kQ0iiB8FxfTb74gRFwx
3X3GX+sAag4MtXIwPpLIthAxMP03HeBps6Ycnf8XDU2Y8v070bLgDIESXYCF7PnF
oLl0OuqWAm2s77W5Tk0CXYy7QtrwdcR2l7by7lJ/VUlt1LBBo3MbndX2qtgf3Qv+
CB7QMCrtUmOObUNWdRVTShCV/psLkHA+UAffX3UNfCKEkjCenJgxOHTmRczWNQh0
dHarjWakqegngL0RlrvRohQVNc8brOCIBI5WSEk7BtSgNZsOUZ0=
=NSDU
-----END PGP SIGNATURE-----

--WkfBGePaEyrk4zXB--
