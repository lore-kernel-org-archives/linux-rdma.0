From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 for-next] RDMA: Fix return value check for
 ib_get_eth_speed()
Date: Thu, 17 Aug 2017 18:23:36 +0300
Message-ID: <20170817152336.GI23648@mtr-leonro.local>
References: <1502981887-31953-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pE2VAHO2njSJCslu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502981887-31953-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--pE2VAHO2njSJCslu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 17, 2017 at 07:58:07AM -0700, Selvin Xavier wrote:
> ib_get_eth_speed() return 0 on success. Fixing the condition checking
> and prevent reporting failure for query_port verb.
>
> Fixes: d41861942fc5 ("Add generic function to extract IB speed from netdev")
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
> v1 -> v2:
> 	Fixing the commit log. Also, fixes the same issue in usnic driver also
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c     | 4 ++--
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--pE2VAHO2njSJCslu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmVtPcACgkQ5GN7iDZy
WKfVCg/+PmCJRuvv/2oal9dTRTD+vG1AYQ4NmPTwO5HFi2U+vLjEdrMmcsuSR3/y
J5CtW6OogdaEOGwX3eRX/cl16YHKdrggGxAAN6oKtO8mm1J8nwTNVG0X9CyAqK6Y
qjvvUDwb0HHK36H6DuAOyQLKxkFA0wq21SE90sLmbO+72Drsnyunl3Qp5RPqlEIK
ji82RaG8dWw8ma8h++3a2Mi0rWkSHFBKJEW1ZEgXwGIMg6xjuIvl3l4qAt1Wp9Yu
Qj5B/+T0rUkv3D/7NZkNgfgEsb5GuAJeOd8ari7swtBZczrOVw1SU/kICgyGdDx8
rVr89PaNwN4Pv5eT+T5HxpZ+7tg5kfbRbnopDHuc3k5IvGz4gTRLfneq66GpNC7P
xioWOHEsqmcuy2CrduZrWambu5qKPwSFGaUhJ5vbeHpIZAB+JIQPI6KHcoiyzCAa
4sCSPJdQ/QJqrgWGm17JPl1mARmp9YnlwopFkME4knCw3HfiGe/uAHNZ+124pfAU
6wI9crOi9nGBbhPYeUg2T5U1MyURhHblx4yPf1/8AQGzBePxVY52cGBV9wbYLyCy
AxaL1OHeujVqFj6i8Yc7M6KDrr60pwAAQK08OyR0vOEywFgazY4ZOuJ4hexg8/SD
piuxwkB2KXXiJp2eK/a6Sh3rnT04rj+wyDRRj6lvSkfgGPsvrwQ=
=nm+a
-----END PGP SIGNATURE-----

--pE2VAHO2njSJCslu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
