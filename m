From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Remove dead code from alloc_cached_mr()
Date: Tue, 28 Jul 2015 10:47:52 -0400
Message-ID: <55B79618.10402@redhat.com>
References: <1438033403-13129-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="W8cPanpvAbASr0rgDJ4Rrla0wD5DoEsW1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438033403-13129-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W8cPanpvAbASr0rgDJ4Rrla0wD5DoEsW1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/27/2015 05:43 PM, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>=20
> The only place that assigns mr inside the loop already does a break.
> So "if (mr)" will never be true here since the function initializes mr
> to NULL at the top.  We can just drop the extra if and break here.
>=20
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/ml=
x5/mr.c
> index bc9a0de897cb..10d2b213a4d8 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -441,9 +441,6 @@ static struct mlx5_ib_mr *alloc_cached_mr(struct ml=
x5_ib_dev *dev, int order)
>  		spin_unlock_irq(&ent->lock);
> =20
>  		queue_work(cache->wq, &ent->work);
> -
> -		if (mr)
> -			break;
>  	}
> =20
>  	if (!mr)
>=20

Thanks Roland.  Picking this up for 4.3 today.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--W8cPanpvAbASr0rgDJ4Rrla0wD5DoEsW1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVt5YYAAoJELgmozMOVy/dSJAQALs4N1xa4G7GMyvAEU0dpWs2
UVjAj/4UVBiqbkSynKRbIzrWDNDZ6yd0LCEb7E7H1XCVLYHT4uNPMjGzZH3bIRrx
GBA9wTYMyYGhWVULf77bYYkVHFH43KvPvU998LDX44QjKVoO5V35oS/qQ9NR2Tdu
YzfJ1VhoF5nlQxreuBvuPl0C+szQkKLaV0HaRme1Fl1iHco9P5CjAXncuIJ3gmol
AU70DqgPv6+YZrqRfI/OlBDqPzhGIPPknhLL9SQVMhySfsT1Joq0moZ38SZz2eV6
HnhPJFTehEDziafPeoCOVz+B04kzt8XTkHkE2swDNybq4ysnoIw6LxmC/42aFOMJ
pCTe5effIxlrrEi5c4hOsvyvyDkPxaE8WoO1PSzVyJB/vmC/0duvnFayNJwm23cS
07HiPTb9eZXPUj3sDBq7yawMip1EzfFLNYj/Xz447EiN9GSjadgNr0Aek+FQVHkn
JGxtjqB7vKZg1jxUX47L+qqnmdhJ1d2UI5leKzxsgJcEkmV5cW5AHyIKfGOESzIi
aF8QsY8nIJpFUQg6ZBRtR849gCbeuBDRq3lK0m8ESNcWMsSKaGxWK7cUDrG4WQTC
G5GeW4fhoL+c8GZqxOJUe3dhbo0KbcyqRNffPh/UpuKHMspD6nTDIVS05YVGd/HC
xZj2+OH/ODKi5apTPsRD
=fkX5
-----END PGP SIGNATURE-----

--W8cPanpvAbASr0rgDJ4Rrla0wD5DoEsW1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
