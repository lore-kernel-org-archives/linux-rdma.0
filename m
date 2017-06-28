From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma v1 1/1] IB/core: Fix input len in multiple user verbs
Date: Wed, 28 Jun 2017 13:11:24 +0300
Message-ID: <20170628101124.GD1248@mtr-leonro.local>
References: <1498572282-22370-1-git-send-email-Ram.Amrani@cavium.com>
 <1498572282-22370-2-git-send-email-Ram.Amrani@cavium.com>
 <20170628095422.GA1248@mtr-leonro.local>
 <BN3PR07MB25788193EFA21CEB5C430201F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9/uPS4O9TzVxv0qR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB25788193EFA21CEB5C430201F8DD0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9/uPS4O9TzVxv0qR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 28, 2017 at 10:02:45AM +0000, Amrani, Ram wrote:
> > > Most user verbs pass user data to the kernel with the inclusion of the
> > > ib_uverbs_cmd_hdr structure. This is problematic because the vendor has
> > > no ideas if the verb was called by a legacy verb or an extended verb.
> >
> > Why vendor should know about it? It has midlayer (ib/core) between him
> > and user to handle it.
> >
>
> Knowing the inlen can be used to determine if the library is newer than
> the kernel and what features it supports or not.

It is not interesting case, because we are not breaking UAPI, only
extending. It ensures that kernel will fill as much as possible and will
always have success in it. After that it is library responsibility to
understand if everything was filled.

Thanks

>
> Ram
>
>

--9/uPS4O9TzVxv0qR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllTgMwACgkQ5GN7iDZy
WKf8iBAAyraC/3rhyi+5kjR7GtjS72CXwk4p0j8YKBDXjaBIRQzeVRVQlSz22tS2
1LUI9QhAwnpYoGXyLi8DJplzh76pMxzQ27ZBZwJM4reud93nKq15i8bHXvD15Vyv
jYZgtkV/U/ZLpWhlaESNeTySYcp1YuTo337CXQpZUoqQTrBVVfyVln1c7ItAcI/B
YiaK0wGjinFh3JmkHXvIDIhy/VflDe9pfd7WXIifPQ1waJk0Yb6M9yFymxK9AEq4
dPsjP7E6/MRh6L9OnamSpITwLGVf5oIImVRxXdlZpJ7FTkjj9OcnGnaB1uCk/a27
B16q/kfbk/5xc7cHynEdRmX7PL0U+XtyHQubKT+K7tM7UdMENnhY4ixyYm7ivi/4
cMekyZOXYmSYM+Z/43SMqHhmUkRM/wSt2AX9fAVgfcjOtYBHsqZyDJiYrMH38g4K
JGXOMZP7Pd4/kpDVYCJvGYs6cSL/JfofSEonVMM97IAyRR7dwDKBlkEo6QSMkoQV
t5Xf5QQMtK2jo/lkpNGlfDlauUuBbM0rKwpb+vHUYw7b5jrbMRUQNBha+Wp8HhNV
zrbcC1gy8WH82KSt31SyXHdZnXIgPsUalRknwf+K6NMxBcGEU7euNn6ZNKJMQPUv
BqMk6poiGY2DfSFMfYzaCiHkEc1REZuWRCSzhagcWTeX93xzCzY=
=aecA
-----END PGP SIGNATURE-----

--9/uPS4O9TzVxv0qR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
