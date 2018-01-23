From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH iproute2-next v2 00/10] RDMA resource tracking
Date: Tue, 23 Jan 2018 20:47:30 +0200
Message-ID: <20180123184730.GX1393@mtr-leonro.local>
References: <20180117100232.3155-1-leon@kernel.org>
 <f0ac1406-6ef4-cdcb-5a81-82c52e9d450d@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/Rh48Y0bnrojh5Wm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0ac1406-6ef4-cdcb-5a81-82c52e9d450d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/Rh48Y0bnrojh5Wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 23, 2018 at 11:33:55AM -0700, David Ahern wrote:
> On 1/17/18 3:02 AM, Leon Romanovsky wrote:
> >
> > David, Stephen,
> >
> > The kernel code is not accepted yet, but the interface and functionality
> > of iproute2 stable enough and ready for review.
> >
> > iproute2 part:
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/iproute2.git/log/?h=topic/resource-tracking-3
> >
> > kernel part:
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=rn/restrack-v5
>
> BTW, I just remembered rdma tool is using libmnl and it has the same
> problem devlink had -- old commands may not work as expected on newer
> kernels as more RDMA_NLDEV_ATTR_ are added.
>
> Specifically, this check in rd_attr_cb:
> 	if (mnl_attr_type_valid(attr, RDMA_NLDEV_ATTR_MAX) < 0)
> 		return MNL_CB_ERROR;

Thanks, I'll take a look on the devlink implementation.

--/Rh48Y0bnrojh5Wm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpng0IACgkQ5GN7iDZy
WKe1IQ//a+Mdp5HO8xNDxCGxlnSRjr6QWvn61BXIAPr8Caf5RjbnfDa/Gk4yvHKx
z83pGrpMGP0awUqB8RAa9KfgkfkIzzu6gLeJk5gD2JNA0rQnS3hpuYNvpsJuuxLM
EvEXuPuR2cl+SMgQVZP+2KBqd1Nm4BFA1n1DCeavl7b7cIKg9zypwkr8VqHZUsJm
QnlB91B/Hs2OHQXz63h5jIkKzjMXpDL4apFwRMxQ0BtcJ8GuWskZ69VgKFO4rBv/
i+zSsgb8/44s5br3+CE7H0K1K+5BhNo9x/ZXSUpLM1FKhIonh3SgufY3uVjIL4TY
6NdW0S3dKR1CPoXPJ6ASa0gK/MH+hj9IB26DWj2WFXdfWuuEr/TK9NLslI7P3TSF
fUROCfIjv/xqCLnvwcT2T0SZTZlYbPG8R0OdlnaJTZJ0W1e4UP5UqzTz+CfkF+Ao
m4F7uqbdAen946zdOkYagwAqcUnW/IDDPj4VUiOXnBa38Q/H0h5CATWs3pt67lRT
Q+f2YQObjsk3B+12z1oTV+V0WFQekFeen+cy/qctQUoSaOTW6JzJQ8Yk1pPNjI6z
y7qfI6TDMUnOWCaFg80TPJgLj+kOIoGEJ18rowgVwq4hym1dMLRECbjXxPEnEX8s
yyaqiZYZmkv/qRvZt9tvf0C9jnFShPVtG99XneDpjaierjv2oBs=
=tS4P
-----END PGP SIGNATURE-----

--/Rh48Y0bnrojh5Wm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
