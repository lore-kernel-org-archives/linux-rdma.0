From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 10/11] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Fri, 29 May 2015 12:41:24 -0400
Message-ID: <1432917684.114391.98.camel@redhat.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
	 <1432220202-9834-11-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-fXk2idP+bNCHKyPxSqmn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432220202-9834-11-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-fXk2idP+bNCHKyPxSqmn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 17:56 +0300, Or Gerlitz wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> mlx4 needs to report the number of supported timestamp
> bits (mask) and the hca_core_clock frequency.
>=20
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/main.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index ef211c8..a5a90c4 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -233,6 +233,8 @@ static int mlx4_ib_query_device(struct ib_device *ibd=
ev,
>  	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
>  					   props->max_mcast_grp;
>  	props->max_map_per_fmr =3D dev->dev->caps.max_fmr_maps;
> +	props->hca_core_clock =3D dev->dev->caps.hca_core_clock;
> +	props->timestamp_mask =3D 0xFFFFFFFFFFFFULL;
> =20
>  out:
>  	kfree(in_mad);

Or, please squash 8, 9, and 10 to a single patch.  They all are "add
support for timestamping to mlx4" but without squashing them together,
the support they add is broken/partial.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-fXk2idP+bNCHKyPxSqmn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVaJa0AAoJELgmozMOVy/dYAMP/3/8OGuD7lTkKoWA54yRwNaW
P04fOxyNqZL6Ml1KU4iYcUvdpJrGcGNiT5gRdd3ZvSdmteecrI6pONNvSjC80aFK
jLbqU8LI+rXpSHz9oBfH11tyMmyUsS0M9ByKtGI4viaHzRMfP0tvToV/alAKkUXC
uth5a3ZtNz9rvi3wwH0NBcd01R96n3TiwWMTo+eKS9POrH9iOj7Fq4JvFZNBrMcV
qgfL2Imir4k09U29yIvwni8C7zv7pRsvvalaTvTy0zBKPWL1LRxYz/zuo+/ezC2n
GWYhbNZpjfwQ10AjXQu6wbo3yqLqMMdaoAHvpTB5hGCjwYZGKQS62Vf44Z8TOKt5
uNUeBFLv97ksGTblZOmL7KcFSMnfhxoz3qByNituRppeTU4FeLQTDR1OdPw3uCWW
UQ0tnvwoIuUA0jV1e7Pnpkn0r2gwbw5KSX+wC4Qlm7esSXw+0uicpoIphxEVySXu
b7TklLT82f9gVB5P/gWd3AWQ+wfWHDl3h7HfGpomBDkw8pGohNfANlV4TefSihJ3
m4OJYkK7ufccavt5hPVrdA7bawHM9yt09GYa7YBi8yjQSPIufisXbxTuEaW3azWa
IKKjG8ngGFcIe0JhcmDbruuXn2HHanPwaMHKN8Eg6wGZV3x6jSRqJj8Jt/ctDidO
WqUcITX9By956zyj+7n1
=pwZh
-----END PGP SIGNATURE-----

--=-fXk2idP+bNCHKyPxSqmn--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
