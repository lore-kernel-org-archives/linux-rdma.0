From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH mlx5-next 1/7] net/mlx5: Update mlx5_ifc with DEVX UCTX
 capabilities bits
Date: Mon, 03 Dec 2018 13:32:45 -0500
Message-ID: <92d7a16f7c83b870d7c905d9199b28edd5aedbdc.camel@redhat.com>
References: <20181126062838.5907-1-leon@kernel.org>
         <20181126062838.5907-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-qdr0IpDP8SN/pp6xV3K5"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126062838.5907-2-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-qdr0IpDP8SN/pp6xV3K5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-11-26 at 08:28 +0200, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> Expose device capabilities for DEVX user context, it includes which caps
> the device is supported and a matching bit to set as part of user
> context creation.
>=20
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

This looks fine to me.  Is it in mlx5-next yet?

> ---
>  include/linux/mlx5/mlx5_ifc.h | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.=
h
> index 6f64e814cc10..ece1b606c909 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -883,6 +883,10 @@ enum {
>  	MLX5_CAP_UMR_FENCE_NONE		=3D 0x2,
>  };
> =20
> +enum {
> +	MLX5_UCTX_CAP_RAW_TX =3D 1UL << 0,
> +};
> +
>  struct mlx5_ifc_cmd_hca_cap_bits {
>  	u8         reserved_at_0[0x30];
>  	u8         vhca_id[0x10];
> @@ -1193,7 +1197,13 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>  	u8	   num_vhca_ports[0x8];
>  	u8	   reserved_at_618[0x6];
>  	u8	   sw_owner_id[0x1];
> -	u8	   reserved_at_61f[0x1e1];
> +	u8         reserved_at_61f[0x1];
> +
> +	u8         reserved_at_620[0x80];
> +
> +	u8         uctx_cap[0x20];
> +
> +	u8	   reserved_at_6c0[0x140];
>  };
> =20
>  enum mlx5_flow_destination_type {
> @@ -9276,7 +9286,9 @@ struct mlx5_ifc_umem_bits {
>  struct mlx5_ifc_uctx_bits {
>  	u8         modify_field_select[0x40];
> =20
> -	u8         reserved_at_40[0x1c0];
> +	u8         cap[0x20];
> +
> +	u8         reserved_at_60[0x1a0];
>  };
> =20
>  struct mlx5_ifc_create_umem_in_bits {

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-qdr0IpDP8SN/pp6xV3K5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlwFds0ACgkQuCajMw5X
L91JZQ/+I3gBT5neimKVomiYqcBR7D07fV4pqrWAgKhQoml47ZrcEdJEj/eIlySb
CjpRXhVVzCJGcp/xUoUhBJZDo2nu0uH2uSQlGWbHSuw3ad8awQsAK70zADFZV+jE
YkTuxSV1NxmZ37ZsE9pynF7MFL5pM8A9xa55dh/ZvciKB4Mdx57Lv3PMOGyI7K/8
wDMzc4+rcf014ejctsGA92Wg5g4W+evUDDI1Fu4cZ81HhApzVGbys3GY7HwNkho0
M7vuhT+j10aEcNuRkrg4XefNdOxy8G7wmSw4AKjzaRrx1EMYhlD0WnUdwYTU44ON
HMQWxw3YpEz7IDjTxpth25pvU+WxUeHwWN3cfeBYLMYEB6D7FjHmWA/5dgDjOWGU
U9jzXMCFQyGdggJ+lq2qctQLFlK0rw2SUaAyvwSZaRluYqhcaR0t0+AbzJaVp57L
35+qhC2OMNEs61mghOkdnx4sKsQHN5NpPxiYg/aCR+nHGJYO3iuiGWCuw1PhrAqb
u63RGJRSidOjyzarnJC8N0jMdIvCkgjuZAGGDKHpidXQMRJetA7hjbfkEKRz/MoD
Hdgf586crXVgnmUjQeM7un4W3ogygsWrjtvbhmhvnRA0ilNApYWrGC42aiYk1p+8
aWchacpwplTtJ1n+mtOqN6UuC5uskRQwd+/bmWzS9iw/5Ggk+us=
=9YOe
-----END PGP SIGNATURE-----

--=-qdr0IpDP8SN/pp6xV3K5--
