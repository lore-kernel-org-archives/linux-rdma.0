From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Take source mac from AH instead from the port
Date: Tue, 19 Jan 2016 15:58:02 -0500
Message-ID: <569EA35A.3010605@redhat.com>
References: <1452786458-30341-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CuEINEoFSeRafXu2xF0NkWiBu4XfA59kr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452786458-30341-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CuEINEoFSeRafXu2xF0NkWiBu4XfA59kr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/14/2016 10:47 AM, Moni Shoua wrote:
> In commit dbf727de7440 ("IB/core: Use GID table in AH creation and dmac=

> resolution") we copy source mac to mlx4_ah from the attributes of
> gid at ib_ah_attr.grh.sgid_index. Now we can use it.
>=20
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/qp.c | 24 ++----------------------
>  1 file changed, 2 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
> index 24ed03c..bb30a0f 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -32,6 +32,7 @@
>   */
> =20
>  #include <linux/log2.h>
> +#include <linux/etherdevice.h>
>  #include <linux/slab.h>
>  #include <linux/netdevice.h>
>  #include <linux/vmalloc.h>
> @@ -2256,16 +2257,6 @@ static int build_sriov_qp0_header(struct mlx4_ib=
_sqp *sqp,
>  	return 0;
>  }
> =20
> -static void mlx4_u64_to_smac(u8 *dst_mac, u64 src_mac)
> -{
> -	int i;
> -
> -	for (i =3D ETH_ALEN; i; i--) {
> -		dst_mac[i - 1] =3D src_mac & 0xff;
> -		src_mac >>=3D 8;
> -	}
> -}
> -
>  static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *=
wr,
>  			    void *wqe, unsigned *mlx_seg_len)
>  {
> @@ -2387,27 +2378,16 @@ static int build_mlx_header(struct mlx4_ib_sqp =
*sqp, struct ib_ud_wr *wr,
> =20
>  	if (is_eth) {
>  		struct in6_addr in6;
> -
>  		u16 pcp =3D (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13=
;
> =20
>  		mlx->sched_prio =3D cpu_to_be16(pcp);
> =20
> +		ether_addr_copy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac);
>  		memcpy(sqp->ud_header.eth.dmac_h, ah->av.eth.mac, 6);
> -		/* FIXME: cache smac value? */
>  		memcpy(&ctrl->srcrb_flags16[0], ah->av.eth.mac, 2);
>  		memcpy(&ctrl->imm, ah->av.eth.mac + 2, 4);
>  		memcpy(&in6, sgid.raw, sizeof(in6));
> =20
> -		if (!mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
> -			u64 mac =3D atomic64_read(&to_mdev(ib_dev)->iboe.mac[sqp->qp.port -=
 1]);
> -			u8 smac[ETH_ALEN];
> -
> -			mlx4_u64_to_smac(smac, mac);
> -			memcpy(sqp->ud_header.eth.smac_h, smac, ETH_ALEN);
> -		} else {
> -			/* use the src mac of the tunnel */
> -			memcpy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac, ETH_ALEN);
> -		}
> =20
>  		if (!memcmp(sqp->ud_header.eth.smac_h, sqp->ud_header.eth.dmac_h, 6)=
)
>  			mlx->flags |=3D cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--CuEINEoFSeRafXu2xF0NkWiBu4XfA59kr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqNaAAoJELgmozMOVy/d0ycQAJCicrhsQMVyc6swoKuV9kFY
/O8wXtipq8ZzLCWVR78cay75ZwyMSttjEqjUeAqG/mIFAnuxuq5iJoCrZaIatRDw
+Fy7pg499NFcBNnjj+GeRRpZ4icksugsMmLCsmU3t9+7F4B8LY59oYN6NXP4EF8A
7Zs0S6/u3lb0a4Z5XcQV5grF/SgDbzsASm35z1tmvbG1qWOCEPFB9ptsqLs6ED7f
Jzqo7AsVjELhUzjDhkVSy+eQaImCkodtiZRwIgTFe3DT6OiwZLpZ/jMN4gxaFztA
7/jx51JG96/GumcDcpBHOynFOF11cCiDDEAdeKmoKvfjsuaJsuVaDTUNzq7jRP+j
tXQRtMKDc2gCpy5SiHEGVmPH69blHEdoZPb+YlD0tBLwaNoeYkTSG9uxpdXxI2gs
Wlk/9bFCHo1gGlAfEClhyB93xcL881QlO8IQS0P3S6XPgIg9Pp4zVWDE8ex90768
pxAf0WUMQAJ+jzs5chhKh3hBgNEHjl+4IfiPqbFL02QIbZli3IvvpCE4Gn9ZlmBI
w1k/9w0JFfp4yIDdRDsqN5DNCdevtFiWWUd9AnONv3poq8OkQ3Pct/3gDhnVv1d4
TE9WMlqgAnk380wduOPtsemj38v80True9AH3A4yjsp3QUyUZt3gwytSROyGLoc4
8gU2WbT87Scc5D9NrYlP
=a2y3
-----END PGP SIGNATURE-----

--CuEINEoFSeRafXu2xF0NkWiBu4XfA59kr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
