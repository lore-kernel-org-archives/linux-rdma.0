From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 1/2] mlx4: Expose correct max_sge_rd limit
Date: Tue, 8 Dec 2015 12:56:50 -0500
Message-ID: <566719E2.7040403@redhat.com>
References: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
 <1446031696-19022-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8k69edejB9pFaRoghcx2DuIh4vIiditJP"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1446031696-19022-2-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: Steve Wise <swise@opengridcomputing.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8k69edejB9pFaRoghcx2DuIh4vIiditJP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/28/2015 07:28 AM, Sagi Grimberg wrote:
> mlx4 devices (ConnectX-2, ConnectX-3) has a limitation
> where rdma read work queue entries cannot exceed 512 bytes.
> A rdma_read wqe needs to fit in 512 bytes:
> - wqe control segment (16 bytes)
> - rdma segment (16 bytes)
> - scatter elements (16 bytes each)
>=20
> So max_sge_rd should be: (512 - 16 - 16) / 16 =3D 30.
>=20
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c |    2 +-
>  include/linux/mlx4/device.h       |   11 +++++++++++
>  2 files changed, 12 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/=
mlx4/main.c
> index 7026580..e0232a2 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -499,7 +499,7 @@ static int mlx4_ib_init_device_flags(struct ib_devi=
ce *ibdev)
>  	ibdev->max_qp_wr	   =3D dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPAR=
E;
>  	ibdev->max_sge		   =3D min(dev->dev->caps.max_sq_sg,
>  					 dev->dev->caps.max_rq_sg);
> -	ibdev->max_sge_rd	   =3D ibdev->max_sge;
> +	ibdev->max_sge_rd	   =3D MLX4_MAX_SGE_RD;
>  	ibdev->max_cq		   =3D dev->dev->quotas.cq;
>  	ibdev->max_cqe		   =3D dev->dev->caps.max_cqes;
>  	ibdev->max_mr		   =3D dev->dev->quotas.mpt;

What code tree did you make this patch from?  Because in an upstream 4.4
kernel, there is no function mlx4_ib_init_device_flags(), but there is
mlx4_ib_query_device() that does much the same thing.  But in there,
there is no ibdev->max_sge_rd, there is props->max_sge_rd.  It's like
this came from an entirely different source base somewhere.

> diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
> index dac6872..3dcae41 100644
> --- a/include/linux/mlx4/device.h
> +++ b/include/linux/mlx4/device.h
> @@ -427,6 +427,17 @@ enum {
>  };
> =20
>  enum {
> +	/*
> +	 * Max wqe size for rdma read is 512 bytes, so this
> +	 * limits our max_sge_rd as the wqe needs to fit:
> +	 * - ctrl segment (16 bytes)
> +	 * - rdma segment (16 bytes)
> +	 * - scatter elements (16 bytes each)
> +	 */
> +	MLX4_MAX_SGE_RD	=3D (512 - 16 - 16) / 16
> +};
> +
> +enum {
>  	MLX4_DEV_PMC_SUBTYPE_GUID_INFO	 =3D 0x14,
>  	MLX4_DEV_PMC_SUBTYPE_PORT_INFO	 =3D 0x15,
>  	MLX4_DEV_PMC_SUBTYPE_PKEY_TABLE	 =3D 0x16,
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--8k69edejB9pFaRoghcx2DuIh4vIiditJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWZxnjAAoJELgmozMOVy/dz4QP/jkB9qPbto3OUmqnooUcJe/n
VckcnWUZCC8fd4pTcVgD1BbMYSVO1RyElysWU4e4edAXkOFJ7R72D/f+SpQQSVPl
Hb//X6KpDkhSLxBAhmJhyrlTP1O+99mVuWQwBc6BvvGKuqGFCZwjvaF+2E902jTx
ZDkWba8Nt1LX7QuulBSYC/CzFvIoVBgcGlGF1l9SBf+SyTRS8RLXw+jaJUGJUfEl
pKtoQMtfjBL1YeIiNHwlYfjH39B5coVVCKgNQkLXei3UpgaZgYUQwU/Tudp+yx2R
A4bH5JBDoolxy5zZrYa88QBITmpoX6aP63nuKSnhRIVePsZarVhJ0c0cCdMxuDlO
QwXPPyrfe3NvmK1RWN4zH+sz+2gMEINIw6gy6vxnn4uO9aRwPbUqgD3FBw6y9LbA
KnYjvtcWPApvNqLlDhRfWQu5mvMnMpwLZKZrDJpb92mo21Cw02O5R4dxFRcpOjW3
NuONDG8ZWuqdRryIHBjmDk1dGwBI4yfPRmjUq1RQHfIrSHEjD234T4yfpMotdE+s
ijGKAiVZHRBT6NnZd6QaKhOUiAh2Uct3B1hfEEEkEPc8lBaCkCJtkzc+GAquxdxb
2B1emrosuyiMkfHQpNAu8zfFJIAwsvVa1Fh6RrCXN03ImODRi73/9AMromzEE/Kp
hYIKc65JWGWBuVh27T3E
=TSGO
-----END PGP SIGNATURE-----

--8k69edejB9pFaRoghcx2DuIh4vIiditJP--
