From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Have cbuild map the git alternates
Date: Mon, 25 Dec 2017 12:32:01 +0200
Message-ID: <20171225103201.GF2942@mtr-leonro.local>
References: <20171214224106.31017-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sW3EvpYZ43JhLhGX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171214224106.31017-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--sW3EvpYZ43JhLhGX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2017 at 03:41:06PM -0700, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> When running commands in the travis configuration it needs access to
> the git history to run checkpatch, but if the local repo is using
> alternates that fails.
>
> The simple solution is to just map the alternate directories into the
> container as well.
>
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  buildlib/cbuild | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>

Thanks, applied

--sW3EvpYZ43JhLhGX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpA06EACgkQ5GN7iDZy
WKc2wBAAvoCL+dbWNZyWF7QKoPvAcFUKdj6BKD4f3QwWW67jy565b1x2R7t0xNM7
9SIhF7+/Kgn22OLbrlLaSsGVbzOYTBHGcrWyWg8UgFkxCnhIF7pYPM/RvAzVqEXS
PHq5t740xmjievJ8x7ydjkyUqDXdmZZIKSDLn0rkZG2Mf95jPEv2r9/x69VmuTJc
b32eH1BpHqBWo9wkpE3nfaxumLvTl6XLvEP9XwuW/LRPSJyPaCPwfZr/oga4Xw2i
d20eRV2XoEA1EgH0yDNVmoIwCcptac5JQvjr+S7vacKTFMmYpzsORuI70cLAEa10
LCX1VDYlW3VWyrZlc2t3bM4qhdq0lwDlgClDSLwJFWVvhCT8fPeHQtmm787pN+yB
bLCD6QXco1KuA5fugo2RzPy98XXT5qqr6ymAAIrHSDIwdgOLoZocoI5hUM6gLKy6
iFTeN6kLamxnbDFBt2hglGn1JyEvS0AYnvf7XwaArJ/4Ir7rIqvzTtLcb0FkRG2l
jZ0PARVY84TnhIekz0VrdrhmHP833sFB6cnoUrEWF7LJgzGMmOuMTUgkiHuAqLcy
lA1BSiooE4mxwFV3wD1VyDZoN+QOi/ztjOaEI9PrDyvblPrLfDGFx7qXnyaz8XVT
tRCN6B3RhuY2dSJVs2F2tA8slf5kMH7TU0xIiPERWApp74yVZdc=
=cRbd
-----END PGP SIGNATURE-----

--sW3EvpYZ43JhLhGX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
