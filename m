From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] IB/rxe: Remove unneeded check
Date: Sun, 23 Jul 2017 16:07:11 +0300
Message-ID: <20170723130711.GH3259@mtr-leonro.local>
References: <20170721192050.3724-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KC+fneiph5CALyUl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170721192050.3724-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--KC+fneiph5CALyUl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 21, 2017 at 10:20:50PM +0300, Yuval Shaia wrote:
> Port validation is performed in ib_core, no need to duplicate it here.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* Restore one line that was removed by mistake
> ---
>  drivers/infiniband/sw/rxe/rxe_av.c | 5 -----
>  1 file changed, 5 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--KC+fneiph5CALyUl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll0n34ACgkQ5GN7iDZy
WKf8zhAAwMKlz8PXvGzaxW08FO2XyFkW38UzbtZwjBM/z0F5Ji5tsvWu+xS8Gk0e
AJK6jyFckyaQQjDhRM7y+jUW9hy917M4TDbrJluaNiT1fAWDhoYrKqSd/LetSdf+
wA/inRSyj1gpZQfPOMNfbePIxzPQAsomz7SYbN4VhIKmrH9jsdD3FeVaccr8CdAc
wtN88B/solin0i1eXrkdurPxd7tp7x/GJJiNx4MVRHNLrHZuc06sSdVK1CBlAUqP
TzadchdWrW2eKuxWYbYfDrNLZYPMIx5I34qiIgydWm6NMN5sP/OiZ/4+gIqr7OJV
0IkDnSdtCYZ7R493GY62pOaFy+gRDunQ410AR3vPvp3GIbYepaQUUbuj1eWidzHb
sWthItMyEdQ18lNCU1SL2GlSPcUkwGVoaT8M2G8/f5faIvtlUkRtv8TL4YEoLrOQ
0LXXQ79L74gs0xeOvCNShPQ7wpeaYhSxdEgln6+JpNIorphVgAOa92bjD2g4sZWk
Wu1XVr/i9Ipq337McLwpValp4qsP50A8i9XM5Jv9iEvy955UHHGUGmz3YsxniTaA
KYq1O0DahHvuOiwQYvG0gyM9l9Nj4K0UO+l9E5wjaHNGIRXfCO9bZoa2PRzJQBrZ
QNrpOJL21y5cZBTKGH7dtY0VVOU7ng5NAg1Lkbf4xW7FWGHogg4=
=GSR2
-----END PGP SIGNATURE-----

--KC+fneiph5CALyUl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
