From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-rc 08/14] RDMA/mlx4: Avoid potential derefence warning
Date: Tue, 1 Aug 2017 10:20:41 +0300
Message-ID: <20170801072041.GJ13672@mtr-leonro.local>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-9-leon@kernel.org>
 <20170731162133.GB13672@mtr-leonro.local>
 <20170731190208.evfjlejsp6xce3m2@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9gXqgVhKaPB5h51M"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731190208.evfjlejsp6xce3m2@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9gXqgVhKaPB5h51M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 10:02:08PM +0300, Dan Carpenter wrote:
> On Mon, Jul 31, 2017 at 07:21:33PM +0300, Leon Romanovsky wrote:
> > On Mon, Jul 31, 2017 at 10:09:18AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > The smatch complains about possible dereference, it is unclear from
> > > source how it can occur, since in case of failure to find/allocate
> > > group, the acquire_group() will return error.
> > >
> > > Avoid the following error, by changing IS_ERR() to be IS_ERR_OR_NULL().
> > >
> > > drivers/infiniband/hw/mlx4/mcg.c:964 mlx4_ib_mcg_multiplex_handler() error:
> > > 	potential null dereference 'group'.  (acquire_group returns null)
> > >
> > > Fixes: b9c5d6a64358 ("IB/mlx4: Add multicast group (MCG) paravirtualization for SR-IOV")
> > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/mlx4/mcg.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> >
> > Hi Dan,
> >
> > Bart [1] and me both believe that smatch tool is incorrectly reported error.
> > Do you think that the tool should be fixed?
> >
>
> Yeah.  There are two functions called acquire_group() and one returns
> NULL and one returns error pointers.  It's getting them mixed up.
> It's simple enough to silence the warning.  I'll push that tomorrow.
>
> I normally run with the cross function database so I don't see this
> warning on my builds.  The cross function DB doesn't get confused when
> there are two functions with the same name.

Thanks

>
> regards,
> dan carpenter

--9gXqgVhKaPB5h51M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmAK8kACgkQ5GN7iDZy
WKdgLw/8Dc/SiLGDCk3/MamWDa0j0HJBvo5J8WXimKUgCw0GzkbTuMDtni+kSTrC
dp5+bu8KvA1vLXqyeUIKLAOk4WcbYgaGFswV2vzN2mqXdmJYB/kPl73y5X0CRjNE
h22t+b6cmxTE7GZm6U4mpt9mPKr2CTSA337DyNxYOaQWVm+Di+vgw33uYEZUKoTL
75HG7nMD6AXfuic7WKRBDdfaWdKbmkTVEjcrfn+GY/yPllLE4ROuoL8bayHoQraz
RBZDP/I/JRW3khjY7McSwKec8lDZdVowXpbDtTmeCp/84C7VeGoFauAYowkP5lrV
i4GQzajYMv5h4rNLOe9RNXY52upnUKSUJJggvqr7oZaM+o/pie9uC4dHfrhvPUqB
u0e30FXnJXGlvtDJXVSxMDqhBV9vaCwOipVKeXshrJRjyJkWXs8boSWgQBc1GVLY
KwYpOMm7j4n2mXIcXQ+r81LW4hkbhiB3EHe/v25F02ciktJlx48wLy8/RxprzxeC
vta7ouq8gdpV3w6GIqb4TgzPbCvJS0kNDZkUPdqOZArK8kWNL4BWtu4rRhdeHGr+
ZKVqir944WIgekceOMuTJ601eE8ryUtNWvkr4L7pvBJes57a45r7gu/eDfyh3QT7
MCU5Oo1Rc0RNnDN5NwJvFHEDCYVFyhaG5wMhdhEUxCEPaMlNLLI=
=dekY
-----END PGP SIGNATURE-----

--9gXqgVhKaPB5h51M--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
