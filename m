From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Expose correct max_fast_reg_page_list_len
Date: Thu, 3 Mar 2016 11:27:38 -0500
Message-ID: <56D865FA.7060208@redhat.com>
References: <1457005071-4900-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JEPEGU1NkiSEsJUQRe4aF0ptovQwhWtUN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457005071-4900-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JEPEGU1NkiSEsJUQRe4aF0ptovQwhWtUN
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/03/2016 06:37 AM, Sagi Grimberg wrote:
> While documentation indicates that the number of translation
> entries per memory key is unlimited, in practice, we can
> only fit a finite amount of translation entries in a single
> registration wqe (which is log_max_klm_list_size).
>=20
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/=
mlx5/main.c
> index 90c5e24..136ed67 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -536,7 +536,8 @@ static int mlx5_ib_query_device(struct ib_device *i=
bdev,
>  	props->local_ca_ack_delay  =3D MLX5_CAP_GEN(mdev, local_ca_ack_delay)=
;
>  	props->max_res_rd_atom	   =3D props->max_qp_rd_atom * props->max_qp;
>  	props->max_srq_sge	   =3D max_rq_sg - 1;
> -	props->max_fast_reg_page_list_len =3D (unsigned int)-1;
> +	props->max_fast_reg_page_list_len =3D
> +		1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size);
>  	get_atomic_caps(dev, props);
>  	props->masked_atomic_cap   =3D IB_ATOMIC_NONE;
>  	props->max_mcast_grp	   =3D 1 << MLX5_CAP_GEN(mdev, log_max_mcg);
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--JEPEGU1NkiSEsJUQRe4aF0ptovQwhWtUN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2GX7AAoJELgmozMOVy/dxHkP/Rtgue/2rlm6MXtFjRL+n4Rm
x8MaN1rzbBd+FD9jM2wWQiglqSzKkwHLhAR+XL+ns6KS2/yC1y+dC0vR0A/KQAse
E+60oPcnNNUH7FBZTBezK+ch9SEjZ2krLbx3QUtvBcXVmqE2Vhk89zTIpfQF9Ytx
WYj8+QeioycIfmLyO6qd9SWmAg/CSNDx05SNx+AwhTPNBAZISPeFGGxgz34aTl7n
KO1FEYQcnCz9nH+OcPypVDBb7xGMds03hV0nqpqUK97abN9VZrXhkcJlLsI7mu2t
q22k0Fp/NW4iXmaDUqldChNEOBhmIPU0NI7R0xb9DoMIzsxKEFbACc+xpvi4FNDc
OZFAMkjzzflYfG+mFuthqx4FSZiSuynj6C04TCvlRXDUql77cqX4WNnZ57TrmZd2
sS1yd8rCdcMMCdpitonr62HKUJxczmlQCeehOLfFWv/MiLRh508vZSimv4uZlVDx
2B2/ME2S8PWb5enUJUc2KcnHdlvK+KHNTc/F370q/tBh5aBy9lZyx1VqE5V8kLk5
+23Uap/4Z4Rv8iMOFo2R6oK/W993wxmZrTIXyVm+VEcAh2mbZlsUCpVMVAKvS75a
ghaJ7Pxs4zuBtO0GurRX/X01/ji1gJMskJz+LGOOJ1L7bkirG55fvsitYsfX/cpi
C35YIxUwag72LDGV1xVc
=SJgY
-----END PGP SIGNATURE-----

--JEPEGU1NkiSEsJUQRe4aF0ptovQwhWtUN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
