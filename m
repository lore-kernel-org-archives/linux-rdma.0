From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-cm] IB/core: Fix memory corruption in
 ib_cache_gid_set_default_gid
Date: Thu, 15 Oct 2015 12:27:40 -0400
Message-ID: <561FD3FC.10705@redhat.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iLdKetRLTHcPcu2R9LLEpASj318sD3xee"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444910463-5688-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iLdKetRLTHcPcu2R9LLEpASj318sD3xee
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/15/2015 08:01 AM, Matan Barak wrote:
> From: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> When ib_cache_gid_set_default_gid is called from several threads,
> updating the table could make find_gid fail, therefore a negative
> index will be retruned and an invalid table entry will be used.
> Locking find_gid as well fixes this problem.
>=20
> Fixes: 03db3a2d81e6 ('IB/core: Add RoCE GID table management')
> Signed-off-by: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>=20
> Hi Doug,
>=20
> This patch fixes a bug in RoCE GID table implementation. When several
> instances executes ib_cache_gid_set_default_gid, we could try to update=

> the same default GID (at the same index) simultaneously.
> Therefore, find_gid will fail finding this default GID and we'll hit th=
e
> WARN_ON condition.
>=20
> We hit this bug while testing this code under pressure of doing ifup/if=
down.
>=20
> Thanks,
> Matan

Safe enough, applied for rc.

>=20
>  drivers/infiniband/core/cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/=
cache.c
> index 8f66c67..87471ef 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -508,12 +508,12 @@ void ib_cache_gid_set_default_gid(struct ib_devic=
e *ib_dev, u8 port,
>  	memset(&gid_attr, 0, sizeof(gid_attr));
>  	gid_attr.ndev =3D ndev;
> =20
> +	mutex_lock(&table->lock);
>  	ix =3D find_gid(table, NULL, NULL, true, GID_ATTR_FIND_MASK_DEFAULT);=

> =20
>  	/* Coudn't find default GID location */
>  	WARN_ON(ix < 0);
> =20
> -	mutex_lock(&table->lock);
>  	if (!__ib_cache_gid_get(ib_dev, port, ix,
>  				&current_gid, &current_gid_attr) &&
>  	    mode =3D=3D IB_CACHE_GID_DEFAULT_MODE_SET &&
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--iLdKetRLTHcPcu2R9LLEpASj318sD3xee
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWH9P8AAoJELgmozMOVy/dmWUP/37Di8VFGQTmSgLLZU3LSLhX
U+u7NUVIRhP0yE0HYaMx+BDYRYB7JPgX4S8Aqt1YPwQWoCFT+EZ4IoQOHQ0CcPrZ
tDLoKlPImKx6d46kfzr0Bp1/tK29OMm80rg9Fpq8SZZbmb1eDp5aeEy76PI4Ugrj
YoyW95DU8ALBldKiOH6ZFvxvvCQP0C8NYBWD+q2FXN+2QDZk90Pas4t3bP1mIFoI
N8VzpMF0vVBL1iVBqPXjYBCzXRrjSa3z8xbR44mYIrPBbh6/Sy3Jiriv/5FZtISG
fvzyUQiH6ejFJ3r43Z1fPFFQnm19A0h858wi+ee9BdhYVB0fA9T4u18jL2P2dHKG
RD8LCaBRY+F4Fc+Cs5PSIsrx+rkOkkLRAPBkRGwT1/InvB9E02aNNnpf6vsvPwwX
vwnI5DAqreMu2sXERLxnEKd/8aGhwQbM0MsjT6CaUUUqFwyq7qI3C+w5YeY1C9xY
6zXoHikgzvjEbsX5aPh6bCyrraqt2mk8TeCatc6QfaVbqgq8fXzk6N828wepD2FL
stNTlu34Jl4fjRxYxjTdYlTZnxx9SPvdlLX+6BQQDylENsqVfUrdF7Id0eGsnhBf
38ERJTbAv6aUK0JDIUQS6qWWEqpXSEFXZhJm0j1ImHrD63AqUDqO4m+UaGuYk/Kt
lPCmqkc2vD4UKO52I8V/
=9yqM
-----END PGP SIGNATURE-----

--iLdKetRLTHcPcu2R9LLEpASj318sD3xee--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
