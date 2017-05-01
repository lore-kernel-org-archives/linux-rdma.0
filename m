From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ocrdma: fix out of bounds access to local buffer
Date: Mon, 1 May 2017 11:57:36 +0300
Message-ID: <20170501085736.GW14088@mtr-leonro.local>
References: <20170501064116.3900-1-dev@michaelmera.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g7y1ijQH9DuGXLTD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170501064116.3900-1-dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--g7y1ijQH9DuGXLTD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 01, 2017 at 03:41:16PM +0900, Michael Mera wrote:
> In write to debugfs file 'resource_stats' the local buffer 'tmp_str' is
> written at index 'count-1' where 'count' is the size of the write, so
> potentially 0.
>
> This patch filters odd values for the write size/position to avoid this
> type of problem.
>
> Signed-off-by: Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--g7y1ijQH9DuGXLTD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkG+IAACgkQ5GN7iDZy
WKdH8g/+JvhQwymVaCc9SATEWPDnX/UGB1hZjhCRekMCx8FmHqiePsyvbOVedcFP
LVwfArkstinJskho0PCYBXRLRsYiipKYlWVY6atyQ+EduwYEpE32L1oZQFfrzfeA
FH7EZ3EWO4S/L3A87FhgqiiHY3KkMxT9c3ISq7GgPYHN73Of/ZGm6jP+wG5CYss4
GwR9O70I9O3RS2cTO9b1J4HO6zHyyz41eL7bc7ghoP94+vdmTcCcZndjNwEtOdvf
Eya/ho92ju4BFfraXbZBS2hWz6ExDNIk+FVJcP/GOCdLN3U/dNFNi3G2L1dEzCQn
Qb+M24PFg8lyaIlHiufJdOyTyEeMMO7nHlRK8LXjprrrX2gsd2veZCDQ/RRPZM1S
cSDI9iAZo/xaVZkdIQQqdOvH8uDwNIlsT3ZQPjuu/jJ9cTs78ca/j2p1IzZR615n
0i7q/A/kMiEbPPuM1kz3KpLE+qjQxOQbHYHmaJ+XrP3v8Y6+wvMx8+nCHAcmhVdy
/B3iWE34cR54lzcSizN6ecNTRsue+oKc7RU0rP2pkxTHJQYOL7AeX0c02NT/owjj
X2RYLfckPK+tRGlBT0d78GOnjSBw//7fJ5a9RkWiggqYTanNoxs02Qu59r+zcT8y
K6k2RD3DvVmJJ5zpAs9qJnOxHKjYipfxO7LONAoLCObcnJmYq9c=
=mayg
-----END PGP SIGNATURE-----

--g7y1ijQH9DuGXLTD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
