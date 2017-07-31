From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-rc 13/14] RDMA/mthca: Make explicit conversion to 64bit
 value
Date: Mon, 31 Jul 2017 19:16:36 +0300
Message-ID: <20170731161636.GA13672@mtr-leonro.local>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-14-leon@kernel.org>
 <1501514243.2466.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yhqQ34TVR4fE8mPU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501514243.2466.5.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--yhqQ34TVR4fE8mPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 03:17:24PM +0000, Bart Van Assche wrote:
> On Mon, 2017-07-31 at 10:09 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The "lg" variable is declared as int so in all places where
> > this variable is used as a shift operand, the output will be
> > int too.
> >
> > This produces the following smatch warning:
> > drivers/infiniband/hw/mthca/mthca_cmd.c:701 mthca_map_cmd() warn:
> > 	should '1 << lg' be a 64 bit type?
> >
> > Simple declaration of "1" to be "1ULL" will fix the issue.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mthca/mthca_cmd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
> > index 9d83a53c0c67..1052c35f2e75 100644
> > --- a/drivers/infiniband/hw/mthca/mthca_cmd.c
> > +++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
> > @@ -698,7 +698,7 @@ static int mthca_map_cmd(struct mthca_dev *dev, u16 op, struct mthca_icm *icm,
> >  		for (i = 0; i < mthca_icm_size(&iter) >> lg; ++i) {
> >  			if (virt != -1) {
> >  				pages[nent * 2] = cpu_to_be64(virt);
> > -				virt += 1 << lg;
> > +				virt += 1ULL << lg;
> >  			}
> >
> >  			pages[nent * 2 + 1] =
>
> Hello Leon,
>
> Is my analysis correct that lg can be equal to or larger than 32? If so,
> isn't this patch a bug fix that needs a "Fixes:" tag?

This is the fix to commit introduced in pre-git era and I don't have
adequate Fixes tag. The fact that no one complained about the problem
suggests to me that no one is really important to have it in stable trees.

Tariq and me did the analysis for the same code issue with mlx4 (he is
planning to forward the fix to Dave) and our conclusion that it is not
bug.

The reason to it in line 689:drivers/infiniband/hw/mthca/mthca_cmd.c
 689                 lg = ffs(mthca_icm_addr(&iter) | mthca_icm_size(&iter)) - 1;

The "lg" for sure will be less than 31, because ffs returns values from 0 to 31 and minus 1.
The situation that ffs will return 0 is unlikely to happen.

Thanks

>
> Thanks,
>
> Bart.

--yhqQ34TVR4fE8mPU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/V+QACgkQ5GN7iDZy
WKdt4A//SKm18zpP7xsN+qQG8BXmHS3Ju2sFo4OChp0TU50sd7KgQ7w5cL/zV75v
N2vv4n15SfsVP/Ot8VLMkJ+GqXLbKkohkZE0IZE+UICQ5ysmpC7hSYdp1Ed+4b0b
+v//wlmPOT0X/5t8u+0s8n9KGRJoFXuVUoJDe1qI9c/AL/4c5JNnki92KSnoNot1
sz/Mk5TyAjhcZfKHV5UqwmwjRxLE/Opf7xovpK8xDyW0f8HofsB1QZObvWetnZ4A
0YHgq5kWmw+reBg1GPso9jAW0kTJ3KXK2UTztWEI3l1ZHGp4xLgLRoiJGVKfYNII
8dDk8it/phG33XEeXz3cKZLE7tNseqEZvVq0ehT1uBhjJ0rY3iiGY2ZqLxiKw3FX
x0umXiofluuGn7wUL1fw41SM196AOqHgRwZaLrAPyYC3dddDRB3OFndV4mNqGIqV
cDusxF4Phe7FXLMTCHqe8VPMkl59PouHjr3UMygCY0y2LtvUxpFqOOi3DENos+5O
ayHdMrQv+pQ3VdC1jeInN6w5/HU8aswbk2dJec6Aih9N8fiIBejj2M7W/h0z+RD+
Tef6+eitvup0nwF261G++sQIj5/pkZ+ZrZvEbd5OnwnJAOq6hI9osClN+cyhrKId
h1K/Ry41RcBkPbIxJjnPkYUTdcSphH1BLU0q5ejg96+jCG4VaCo=
=AXiJ
-----END PGP SIGNATURE-----

--yhqQ34TVR4fE8mPU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
