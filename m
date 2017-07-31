From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-rc 01/14] RDMA/(core,ulp): Convert register/unregister
 event handler to be void
Date: Mon, 31 Jul 2017 18:50:13 +0300
Message-ID: <20170731155013.GY13672@mtr-leonro.local>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-2-leon@kernel.org>
 <1501514653.3009.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sL7C0a98p/u5aVah"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501514653.3009.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--sL7C0a98p/u5aVah
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 11:24:13AM -0400, Doug Ledford wrote:
> On Mon, 2017-07-31 at 10:09 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The functions ib_register_event_handler() and
> > ib_register_event_handler() always returned success and they can't
> > fail.
> >
> > Let's convert those functions to be void and remove redundant checks.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/cache.c                 | 23 ++++++++-------
> > --------
> >  drivers/infiniband/core/device.c                |  8 ++------
> >  drivers/infiniband/core/sa_query.c              |  3 +--
> >  drivers/infiniband/core/uverbs_main.c           | 13 +------------
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c       | 10 +---------
> >  drivers/infiniband/ulp/iser/iser_verbs.c        |  6 ++----
> >  drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |  7 +------
> >  drivers/infiniband/ulp/srpt/ib_srpt.c           |  5 ++---
> >  include/rdma/ib_verbs.h                         |  4 ++--
> >  9 files changed, 20 insertions(+), 59 deletions(-)
>
> Unless this fixes a build warning or an actual bug, this is not -rc
> material.  You are putting a lot of stuff in -rc pull requests because
> "they are simple one line changes" or "it's a cleanup".  That's not
> what -rc is for.  It's for fixes, be they build fixes or run time
> fixes.  Please split your pull requests appropriately and resubmit.

It is not cleanup, but my attempt to run smatch/sparse tools cleanly on
drivers/infiniband.

I'll resubmit.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--sL7C0a98p/u5aVah
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/UbUACgkQ5GN7iDZy
WKeeNQ//dTspbCStjWKRI6h4CV38BB0W+V7p/EK469mtphTigZdO8sbcUzettT4G
fsT1pvodDNMJ8J7NuiHiU9oFFHFlqFXM5H5ZU79lVzphj5iAZTuPDA/Iy+ceCNik
/gBs1hVeHEw98Fi448coaAPR925Um2uQxr4NJazyrQ4u6LqzRVUQ/tsynRnDHqCC
aYw/RvoWUlFOZHwgOOGSAU6u5AhED9KcWI6HHg5w1+B7ah5yhiy7IpgJQE/O/QkW
6jUN7SOK8o3bLiTUIqj4nM3Z1l+YOZKFCQ2TLBPcUddSVkizKLgb4u2IbVX1v0wA
2WxO74fmmgNkuytaJ0mtkzea5LHnT0eYaEItoEsmm1yi71w8rc61KPqLnLQDzfAo
PpLKnnhyYQwcg88s8TAmN8y3eLXYXXfjTE+zfh1v9gJ2V1vFEwbhdkWq8WJp2y4q
NKzV26iU/cqaSndxFfAT7GRXRbVyi7L7ipJALaBCR4xjGpZZ91/0nBnCVGgb3Pa6
DLTtVU+aQXy7jAcQ0/nJFkllAmSwrsl/Sy5fG/VOu9GBxmnXfjmaHDn9jKgX1ZVb
PkaYHrifJTfETmli6nPcVWm2sPPtBXy5B1ysJ3dIkaRfv+yvw/WX3egIK0RnDD7E
fUSzAJRQQnd1/SzTI+eBiaL7rgCqdS2hi2VxJVSRShL6QDTDaJ0=
=SOuq
-----END PGP SIGNATURE-----

--sL7C0a98p/u5aVah--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
