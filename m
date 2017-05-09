From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/netlink: Remove export of
 ibnl_chk_listeners function
Date: Tue, 9 May 2017 09:06:27 +0300
Message-ID: <20170509060627.GE10073@mtr-leonro.local>
References: <20170508121343.3213-1-leon@kernel.org>
 <20170509053922.GA2117@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170509053922.GA2117@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 09, 2017 at 08:39:23AM +0300, Yuval Shaia wrote:
> On Mon, May 08, 2017 at 03:13:43PM +0300, Leon Romanovsky wrote:
> > The ibnl_chk_listeners() function is called in the code
> > located at the same module, hence no need to be exported.
>
> Do you think it's declaration should move from include/rdma/ to local
> header file also?

You are right, I'll move it together with ibnl_init(), ibnl_cleanup()
functions and will send v1 shortly.

Thanks

>
> >
> > Remove EXPORT_SYMBOL from it.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/netlink.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> > index 10469b0088b5..ebd16885cfce 100644
> > --- a/drivers/infiniband/core/netlink.c
> > +++ b/drivers/infiniband/core/netlink.c
> > @@ -55,7 +55,6 @@ int ibnl_chk_listeners(unsigned int group)
> >  		return -1;
> >  	return 0;
> >  }
> > -EXPORT_SYMBOL(ibnl_chk_listeners);
> >
> >  int ibnl_add_client(int index, int nops,
> >  		    const struct ibnl_client_cbs cb_table[])
> > --
> > 2.12.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkRXGMACgkQ5GN7iDZy
WKdblBAAuijP80g0JQEjj8FjOMWPI/kX3R18DKV05bgUZ7oQf+2BwEdjaPwFpWCx
5O7cV3IZbcFtUMfsOy3CyZ5gbI9vIB1tuP3dH03rRt8R1UW/hJJ5odKTc4+7GmrU
H54CNQ5zvoMgOwXfIlEpZ+UlSYiyJ1JcuMC3JbNLllr/lI3u87+5ShIMlSdd02AN
rYHppRJetmzUxMR3/cXeCNQGCn5gaY7MS7dOLqp3dongyqleV/5xJRmuSlQFZtf6
CboJXbTMsmqM/6Fxs3jxLDEHyL3OtoqYMrOEktieLixetgyDbTpxh6YfQ/dimQnR
MCammJ+ou1zWOD4FPjLE0ycwcdxZHFssddoyF7G4iFXotUbIxG6o6IBYkDIgZW9/
ahYyZB4AkKyVDqMEa4sliLExiFm8668URIk1uU9xQONsRgpAeqKEXHgNlByEhFFI
ijNuHUNdDkgGN2Q4rIwadbF+fAL5UkQ6tp4JdwJO/K5LeyHNrKJISk0zrf3Ysmbi
V6RFoQsoi+tPsSHa2PG5w+D2/J5T7zHXejcHbVTlKrG+CT96el1vfgpCvs4sa/4Z
pz5u8h6HtW18Dl6ggWSJ93E1+DHlyMlH2+HryhCfeBtXAku2vgQpcMcz/TsD8WPQ
L9/4R4lSKVbkhtkye6DZoPBSl/Dc84nf+qbwPAiyXt0zlq7a4RQ=
=ElYW
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
