From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-rc 01/14] RDMA/(core,ulp): Convert register/unregister
 event handler to be void
Date: Mon, 31 Jul 2017 16:07:47 +0300
Message-ID: <20170731130747.GX13672@mtr-leonro.local>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-2-leon@kernel.org>
 <67e53715-1346-c969-b59a-ca4494d3b7c4@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="buDNgeHiu+HCsDEc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <67e53715-1346-c969-b59a-ca4494d3b7c4-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--buDNgeHiu+HCsDEc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 09:03:12AM -0400, Dennis Dalessandro wrote:
> On 7/31/2017 3:09 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The functions ib_register_event_handler() and
> > ib_register_event_handler() always returned success and they can't fail.
> >
> > Let's convert those functions to be void and remove redundant checks.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >   drivers/infiniband/core/cache.c                 | 23 ++++++++---------------
> >   drivers/infiniband/core/device.c                |  8 ++------
> >   drivers/infiniband/core/sa_query.c              |  3 +--
> >   drivers/infiniband/core/uverbs_main.c           | 13 +------------
> >   drivers/infiniband/ulp/ipoib/ipoib_main.c       | 10 +---------
> >   drivers/infiniband/ulp/iser/iser_verbs.c        |  6 ++----
> >   drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |  7 +------
> >   drivers/infiniband/ulp/srpt/ib_srpt.c           |  5 ++---
> >   include/rdma/ib_verbs.h                         |  4 ++--
> >   9 files changed, 20 insertions(+), 59 deletions(-)
>
> I think you mean "... and ib_unregister_event_handler()". Also maybe mention
> a couple words about this lets us clean up some of the goto stuff.

Right, I'll respin.

>
> Otherwise:
>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks

--buDNgeHiu+HCsDEc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/K6MACgkQ5GN7iDZy
WKc/rRAAqpZ7Mu0bJwOzaKSZhz3iyoRkS3w4kDnUfpQiGIs0+lg2JKarmp4xqkaR
CNoOmaxs1oqdifhKW88nKkwRzbuuexsuROB7wDI8XPrdXHTP85P9pFjpPQ6IhAQn
PAk/Y1vWzy4kXEDh2siUYGZXlpF1rw04zMocofDx+GssUbxcmWSuYaFLsBq1SfiO
Yy37OiqfuIOOhqvIEKPwAUtLlb2jEh6xmfR+lEzl0ihFoM0NKkX94j5IgICnCZ3W
VzJpJxGhRVq74uQL8D0myOHdNkhSA0BquixB520yAyksEC0nw1Npnfv8oEFMrlBW
bTcInEtfhbMPDjfTwXMm7CcSJVKATGSYAVfnOnmHdFU8EF29u42UHMxqSPNHGNDw
LmxyD9Qmg7nw2wxsF9FtbxzZlykTdKXeoVk/eo9cXGTBaOUcUVUkLXBNgCcnyY8C
rP7wuij9x8SX7wSFe4vqU+O9qet3xA2TJDTZ9quubPwJCdSJN83Fpm7kw9uq/2BL
YfHcdysMofxpbdDBnMfVvD7vRchdbwt6dKsZSTyCuixWw+9xzhT/3QVxj/NjQFiB
fW+K8/B8Nr6FIOi+IgOLsK5RVcEBfYuJKDW0cHeWGCZngJVUov9pqBZ5YrzYdsIL
xhQZ4C3SoVNKyKzpIjHv576zIN+oT+zAXdglWHC6VD9phWFFEoU=
=+kkx
-----END PGP SIGNATURE-----

--buDNgeHiu+HCsDEc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
