From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 6/7] IB/mlx5: Enable MAD_IFC commands for IB
 ports only
Date: Tue, 13 Sep 2016 08:43:09 +0300
Message-ID: <20160913054309.GL8812@leon.nu>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
 <1473696984-6161-7-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UK1lfQXsnwKrySH9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473696984-6161-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UK1lfQXsnwKrySH9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 12, 2016 at 07:16:23PM +0300, Leon Romanovsky wrote:
> From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> MAD_IFC command is supported only for physical functions (PF)
> and when physical port is IB. The proposed fix enforces it.
>
> Fixes: d603c809ef91 ("IB/mlx5: Fix decision on using MAD_IFC")
> Reported-by: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Let's see if patchworks handles tags with name/email different from
FROM field of email sender.

Reported-and-tested-by: Sujith Pandel <sujith_pandel-8PEkshWhKlo@public.gmane.org>

http://marc.info/?l=linux-rdma&m=147373086900629&w=2

> ---
>  drivers/infiniband/hw/mlx5/main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 8150ea3..0480b64 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -288,7 +288,9 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
>
>  static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
>  {
> -	return !MLX5_CAP_GEN(dev->mdev, ib_virt);
> +	if (MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_IB)
> +		return !MLX5_CAP_GEN(dev->mdev, ib_virt);
> +	return 0;
>  }
>
>  enum {
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--UK1lfQXsnwKrySH9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX15HtAAoJEORje4g2clinxiEP+wSOPPTuVBuUDbu1kl/C8AEs
Cvy1C0iFaqFANZlVPMjexEb1rYLg7uP1aoozOSjFK+LqtSsMNNXvdzu0hIUtj25M
k71sbbkWFQvPPTPkjO1NM1r0DH+xjqNTFz1+3s63P4D8WNkX/ogsHNuXYi62ha6o
mNYT2oNbnsV2Re36s/Op7tdDpEGpl2eY9VEVjcpJuOzt8bFcmU8c3wMgtGDrzq9G
6Equ++zYyMOrrZ1RFTmjAdo26PmoIzmvLE90uJJ1CHrTi6v9tnAKRo2H4mR0Jgk+
EwjvnzQ6zDiKiQTAcpjr7hksvL23xRYFmbu7LFv2ap9IPhC6qB04O0ugLE8n5mbY
iBiHxOfnQEUFmj9O+BVhLrtqBvvzYNR8meEiLe8zGuehAo+8OsE9KvuM+6hK1KYM
bQz/50S49hJBrU4yi/4NojluVY8GrPup69kSS8DB2B2/ypfX//BiVkplpgVPLVnc
dQWVnBfWfZJCDDqLPHqufGpMwUWaFUA2CDVfbWHvg9Go8xRCfxRxwwdxvHM2hl5b
fL9MjbBOdoKyUklul7TcndmqQM3ow3LPULnSBeUG/ouN2U3ILmICb5ULHhRMChLZ
H+pVpOj0aX9bpxqyCk0GiXUDwitSL8t08EOJE8dQm69yz2kDGfT2cNL1hsRejcTE
r95x55qgDEjTgrtZh+wb
=SB7D
-----END PGP SIGNATURE-----

--UK1lfQXsnwKrySH9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
