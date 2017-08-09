From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [v2 01/12] IB/ocrdma: Use kcalloc() in
 ocrdma_mbx_alloc_pd_range()
Date: Wed, 9 Aug 2017 09:43:01 +0300
Message-ID: <20170809064301.GA1423@mtr-leonro.local>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
 <21442d70-e77b-8338-30f7-9c41d048a665@users.sourceforge.net>
 <CANjDDBgOa=8d5747AdTAZdwueGYrZNVZBe6zSPKOC1qzyDiheg@mail.gmail.com>
 <1493139733.3041.75.camel@redhat.com>
 <9cdbdfa6-7118-c830-7587-aa27929f7028@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9cdbdfa6-7118-c830-7587-aa27929f7028-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 08, 2017 at 07:26:45PM +0200, SF Markus Elfring wrote:
> Hello,
>
> How will the clarification be continued for the shown change possibilities?

Every sub-maintainer will decide on his own what and how to proceed with
these patches.

Thanks

>
> Regards,
> Markus

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmKrvUACgkQ5GN7iDZy
WKdGkg/+MsSEUcC6qL709mHiyBYXDZ3cCLVvWnRkVHeGbP25eUebS29aH2x1b+/L
O/r2KHhGd4kceiyY1MXNiRjD2LzGCJZ+FPHUr52eku6adcAP9g0vt8y/ug8S723a
fYX2/TEAbhQSo6x7GWfweKF9GPYyNC5a0AwfY6NkBrPZ2MjgaVaDW9z8MjemHxMD
kgOYJUlmZ5U8qNhDTjHzL0LC4NsLiz+9QSgE5Ap3SQ5Byb3PLjceTsu27jruKILs
3lrjNkEruQxKorKogJwglE/OkrbmCWbbBnYoUpAvwpreeLSgF3Aehrmjgh3rqIzz
Vm5unRY/yBIuqPrL5y1Qyk2869BbydY9y1eH0mck4CDVLgmYy3eZ4XO7tIeGGHqB
dwwaZtJKcnA2cKYlfKACGXHBIwtxOQNaIgdsBCzYWvFzSyj3LfSRJmrzJTiuUaop
M8iyaIi77okArIcpiOrEHFGCVSR0Y/iMVOtG1378MV0CUwxtgfZ1hcpWCPOqiIng
10ps4T7x0iQJglV9L5np4tFlrSmxSTmEMIiQ/GXIlf4z5l+hQEcplPT+u5WXSJpD
0kzMtrY5Vz069pseuOeXSs82GR5T+ek7Vx4Hvv03oC6aJdxCcXuO1hFbDLvyaTnU
VtLRiMYsSkXbqhqNQyzUM3h+7FllFESC38AM4PBjXILq5tKqaNc=
=4guo
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
