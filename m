From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 2/5] i40iw: Do not generate CQE for RTR on QP flush
Date: Wed, 4 Oct 2017 20:31:12 +0300
Message-ID: <20171004173112.GI25829@mtr-leonro.local>
References: <20171003161150.16172-1-shiraz.saleem@intel.com>
 <20171003161150.16172-3-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="16qp2B0xu0fRvRD7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171003161150.16172-3-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--16qp2B0xu0fRvRD7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 03, 2017 at 11:11:47AM -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> If RTR WQE is posted and QP is flushed, a CQE is
> incorrectly generated for the RTR WQE. Add code
> to look for the RTR and not generate a CQE when
> QP is flushed.
>
> Fixes: 280cfc4b74e6 ("i40iw: user kernel shared files")
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_uk.c   | 13 +++++++++++++
>  drivers/infiniband/hw/i40iw/i40iw_user.h |  1 +
>  2 files changed, 14 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--16qp2B0xu0fRvRD7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnVGuAACgkQ5GN7iDZy
WKcY5RAAybV7asQ6RAe6BQM09yyC2pa9jQf9K7OsBAa/kcxUMq2ilA+w8kHqFPtx
SbupdrI/v2kUrRMTOAbtHmvajhoyuj8EKb1lswWmv4bV8hUq64UgFOCvBlcErmpV
jKRRajIjGj4ibl2XxbJLxd+Ov1ygf2xrI3FzUUofJKEef/9c7FCefp1FI1ZqYaLI
/6WSv/J4OGwnCEGhLSnUY0Z86XHlMYCNnDDliQEBWVwYPETZIDayO7z0MMzFidnS
sgVgNRYfuGJ3Am5h3bLNlJ7AcULE715cPtDc3zgstviym/TcYFbrt0PqYJqRmClQ
2CgMNe1vC6Pf5T9kpmHz/eif3hxInBSscLM1qPtfI3NJDjyGY8IqpCqSMPhueJm8
ZrgvnXG12OJyE1q5SXBiHwArhqJ/UAf1Nidcl8U5hin0kvI/uB/jO8Ja0GWsOXf8
BG75JA7IiywKid+wWa9cFDeMl3efgbj12MWgtDHNZnVYBwpgU/+hMWW7y+hMpNTN
VbyG939pqGvf6umhCKlOVHMxJ2w/KRs190HDqpqejpBkQ0hGiKgGt35H1onUwGUH
iefJ2zXR96B7YzU3gckyBRQ0wbNK4C/0HtwNSa1h/13Oo/M6b1SuAc9W65HIWbt2
RL/DevSG4ooz7VIxz25qGlxXZHW56f7sqdBUKVpTYz8wCaLgOdc=
=Pdq3
-----END PGP SIGNATURE-----

--16qp2B0xu0fRvRD7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
