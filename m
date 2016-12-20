From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE size
Date: Tue, 20 Dec 2016 15:42:03 +0200
Message-ID: <20161220134203.GW1074@mtr-leonro.local>
References: <20161219203227.86392-1-henry.orosco@intel.com>
 <20161220112417.GV1074@mtr-leonro.local>
 <748B799B6A00724488C603FD7E5E7EB94CBAEEA0@FMSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VIFPKPeEU/ajvd6j"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <748B799B6A00724488C603FD7E5E7EB94CBAEEA0-XfjTATA9Em864kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Orosco, Henry" <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VIFPKPeEU/ajvd6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 20, 2016 at 12:44:04PM +0000, Tung, Chien Tin wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> > Sent: Tuesday, December 20, 2016 5:24 AM
> > To: Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-
> > rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Tung, Chien Tin <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE size
> >
> > > diff --git a/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > b/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > index 12acd68..57d3f1d 100644
> > > --- a/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > +++ b/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > > @@ -39,8 +39,8 @@
> > >
> > >  #include <linux/types.h>
> > >
> > > -#define I40IW_ABI_USERSPACE_VER 4
> > > -#define I40IW_ABI_KERNEL_VER    4
> > > +#define I40IW_ABI_VER 5
> > > +
> >
> > Why did you remove defines and move to use constants "4" and "5" instead?
> [Chien Tin Tung] This is the ABI version change, did you read the commit message?  Two defines were not necessary.
>

Thank you Chian Tin Tung for your informative answer and yes, I read commit message.

If you think that these defines are not needed, so can you please remove
the code which uses hardcoded "case 4" and "case 5"?

Or maybe they still needed and should be renamed?

Thanks

--VIFPKPeEU/ajvd6j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhZNSsACgkQ5GN7iDZy
WKeKAQ//dJIrEsUp74kyupRvKkWfzmbfqG0JxiMi8TzGEZ4OgJunZ7hxHE5M1EhM
WU4Q1/fptMetEd9hdTvXW/DwWqdm/c8ji0gWVVgfXI3ubHXBdGEEtRj75OTyk9Gv
mcsHGR265itq6gCLSAi6LFrbWmQ0f0HJ4YiHoGdtJIj++GBxcUcZUHQV4cB+l5AT
C6iSz07+q2PNIajM2qccR57u++jhZn/avtz0FP0Zvvws9snPyRAQag7viqE78kmR
nU8AzqPEx+HJ5mVEtF59u2URX1eCGgtvuNV3S/EqII+v7VrA17SceWl6UBcKgyBV
g3cepr1w6fBWjz/d9tkq9/UwKFtOz+rGgLn6H27UdvGhE+IIM1JF4npqirGkk5XY
M8p9fZDAnj/e8HeIl110pixVuUvp1XshFVfQRxD28MDCEeDHAIRkf917B8S0CAyC
HuhDgDmJZjE8M4M5kZ2PaNm9J7fZHGzWXu3jZIXXF/nn6iTsNT7nq8i8afyV6WFi
KfB8J1ygw+QnXEPLDTyNxlUqLVOfvZbWwEoU4k4tPSlRprN8N1TC23DBUBoqWGE1
XuOSfuuWQFTKugjmZJYehhRs5cBR0h1KqJYJ8yCQ0AH32C+mVXDpTM5WEWv5uwdJ
t0shfyhzGlCfXplxaBYPZCPoMuv1/2LFednIhk3PyhGxq6nXCqs=
=3FlV
-----END PGP SIGNATURE-----

--VIFPKPeEU/ajvd6j--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
