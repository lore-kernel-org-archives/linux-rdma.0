From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Check return value from get_settings
Date: Sun, 4 Jun 2017 20:26:30 +0300
Message-ID: <20170604172630.GF6868@mtr-leonro.local>
References: <20170604170619.3697-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dzs2zDY0zgkG72+7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170604170619.3697-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Dzs2zDY0zgkG72+7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 04, 2017 at 08:06:19PM +0300, Yuval Shaia wrote:
> The functions get_link_ksettings and get_settings might return bad
> status indicating a failure to retrieve interface atttibutes.
> Check return value to cover this case.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--Dzs2zDY0zgkG72+7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk0QsYACgkQ5GN7iDZy
WKccABAArpyCsSdwlZEKYB3fFTJ50ORiyiyWJtZfGdYsAj+ku/i0jee2Vwym3bze
RvbLfCHigxmPO1R3mm7lmmhlqsmkHYx1s1+8MfC9jwsa6DGdWIicmjF4n9LNkxql
32Zf7dzMvuTCDAUJ6O4dYqt/dNZ1q4iC8tt+0rV7quwZS7EZ6RwaVifko0gu6QLw
8xr2rezqQZpXRMOZGSf+3SoFZwrMg1gprU6OcFSB0Ssnt3/2x5oaqMzw3FD2nxMq
TnBzccqVYJtjZqDqpsHQf6D2C5B5EQ83zR6bpRtm3Gtqqg2hHwkBY82qKAaigi2y
yFsp4YByz3f5hmkPsm1+279kFpXwOX0WrsovUZbzHsgHQWE5KTzxHPK1Anwz9OJO
dJLfCftG4BMu82t/AvuFYwK5WTjdHqM2IHqyemDcewoZ5KurM4ttme0ngK3peMyz
ZYdbd8H03Bh2C42TvesPx5Gqn07mqprLWNy7iU6SmlPYVrTTfKaGgun35yWsF/kC
KlHGfR5hCNrhLdz5VEEGHTyc6Zu1JqzhW6qtkoStKCdYCgn8M+Q7RGXZvqOTXylZ
+kL9XkCiEwca72Ta5iKn66ULAbZZ7dKxtyanH8Vdi9rmA7rvq2cVNq+t8lv18SOn
fZaeexhS9NnPiT5o7yxB00lkwk2uLyhwGgUMkO4E2S6qqZUf/lM=
=gDru
-----END PGP SIGNATURE-----

--Dzs2zDY0zgkG72+7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
