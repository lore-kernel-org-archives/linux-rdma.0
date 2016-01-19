From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Delete locally redefined variable
Date: Tue, 19 Jan 2016 15:43:54 -0500
Message-ID: <569EA00A.10107@redhat.com>
References: <1453194684-1549-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ORw6hwnins57daANtwEr8oGRx9VTim5s7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453194684-1549-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ORw6hwnins57daANtwEr8oGRx9VTim5s7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/19/2016 04:11 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Fix the following sparse warning:
> drivers/infiniband/hw/mlx5/main.c:1061:29: warning: symbol 'pfn' shadow=
s
> an earlier one
> drivers/infiniband/hw/mlx5/main.c:1030:21: originally declared here
>=20
> Fixes: d69e3bcf7976 ('IB/mlx5: Mmap the HCA's core clock register to us=
er-space')
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/=
mlx5/main.c
> index 5e3d3aea35bc..5e997c0793d1 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1057,9 +1057,6 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcon=
text, struct vm_area_struct *vm
>  		return -ENOSYS;
> =20
>  	case MLX5_IB_MMAP_CORE_CLOCK:
> -	{
> -		phys_addr_t pfn;
> -
>  		if (vma->vm_end - vma->vm_start !=3D PAGE_SIZE)
>  			return -EINVAL;
> =20
> @@ -1082,7 +1079,6 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcon=
text, struct vm_area_struct *vm
>  			    vma->vm_start,
>  			    (unsigned long long)pfn << PAGE_SHIFT);
>  		break;
> -	}
> =20
>  	default:
>  		return -EINVAL;
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ORw6hwnins57daANtwEr8oGRx9VTim5s7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqAKAAoJELgmozMOVy/drigQAJfOflKVyvgokQ3keAlx6pkj
qx2y5hIufB5EMLChGAo2nVKxjNp3oC19bsyUayz7M+FNzD2RV+wsat2Yypc2PzcS
LSNUEI9Jmf7L8CTmLOwoUHsxwA/Kr1rqyHWjNlLYzZzM8mIZelhU2f5ztHK42SQQ
m3q/pD75GYeqASGeqWuBQ6DuPTm2PFPWBTxJMMBBn+0UNY2fe4OvuvT5Anj5JcZq
MDvGUt0AuWJSLl71Q24r8hidtKRbC0HhJGIJpJrJogQ5Js9IjxeV7izr7a9SqtHT
EhIPLJBTzKkd45mHdo0uTwGMvOpGTGc10wp3ksFaJHtU6qgS76ATwHG26QjwrZva
6OAFi9cbVsHrVkT4tSJTMHwuupTQCjOTFldfIq5rXui+EpSaGP985T2tYIdXXq9G
hkt+nGd4P+YpD55RxSsSV/qb9vtL6e054mvrfPxzGHt7QfNKkDv/KAb04cBLYY+V
+FX6imrFdYRh3zAyuvFaTsdpu3GCqq/d/wARSsCuXPSPIpz0tPSHHUPiJiv/iS5L
QHUuW97mXfPHkbGQRRUZwgdvhfkY8eGJA8sFlZQoH2EhXEDwyubWNiMMEwD07enc
yu20uOLhg5/35rM4OztR1asbGS5ek7SaftVn7i8iiWIR8Sh6ItEYTgvmQ8qNLSDp
n6FvH1wYwpHxJmQuZAR4
=cvIj
-----END PGP SIGNATURE-----

--ORw6hwnins57daANtwEr8oGRx9VTim5s7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
