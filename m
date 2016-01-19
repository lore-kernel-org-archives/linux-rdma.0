From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix passing casted pointer in
 mlx5_query_port_roce
Date: Tue, 19 Jan 2016 16:01:48 -0500
Message-ID: <569EA43C.6050005@redhat.com>
References: <1452337279-13593-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dVBGI4feAor20Gxt4osLVeJgJBsRHArn6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452337279-13593-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dVBGI4feAor20Gxt4osLVeJgJBsRHArn6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/09/2016 06:01 AM, Leon Romanovsky wrote:
> Fix static checker warning:
>         drivers/infiniband/hw/mlx5/main.c:149 mlx5_query_port_roce()
>         warn: passing casted pointer '&props->qkey_viol_cntr' to
> 	'mlx5_query_nic_vport_qkey_viol_cntr()' 32 vs 16.
>=20
> Fixes: 3f89a643eb29 ("IB/mlx5: Extend query_device/port to support RoCE=
")
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/=
mlx5/main.c
> index 5e3d3ae..890cf20 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -132,6 +132,7 @@ static int mlx5_query_port_roce(struct ib_device *d=
evice, u8 port_num,
>  	struct mlx5_ib_dev *dev =3D to_mdev(device);
>  	struct net_device *ndev;
>  	enum ib_mtu ndev_ib_mtu;
> +	u16 qkey_viol_cntr;
> =20
>  	memset(props, 0, sizeof(*props));
> =20
> @@ -146,8 +147,8 @@ static int mlx5_query_port_roce(struct ib_device *d=
evice, u8 port_num,
>  	props->state            =3D IB_PORT_DOWN;
>  	props->phys_state       =3D 3;
> =20
> -	mlx5_query_nic_vport_qkey_viol_cntr(dev->mdev,
> -					    (u16 *)&props->qkey_viol_cntr);
> +	mlx5_query_nic_vport_qkey_viol_cntr(dev->mdev, &qkey_viol_cntr);
> +	props->qkey_viol_cntr =3D qkey_viol_cntr;
> =20
>  	ndev =3D mlx5_ib_get_netdev(device, port_num);
>  	if (!ndev)
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--dVBGI4feAor20Gxt4osLVeJgJBsRHArn6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqQ8AAoJELgmozMOVy/dVroP/jERnr838NixM4msdETrYZnB
ibrJbV+sNlWhdIkTsIu6LBCVwbFPemgWnz7THiQhw6399YXbZzJ90S1QXI/0SS5h
atdRWV3+IMj0FBIWe4rGInCNwFkD/jr/bX3pfVv+pS+mpjmCgZbn/ATUFHgnQuaO
ziZS0GKP1QpdAAEoWCeaU5wac/NFw2H5uz57o9952HbrsSjToCJX6ukrW0wD8Sqo
MvlOmKhl1lTgxiQMB5qElialfwizFCWtzW6lUmpwd6lXyB2dKDzln0fkROeLNb0O
dPy5q8fbUKYLG7T8WXnvYes1Xl7GmMgnLDq7QmQB8hR0J9iwEYpCkB2eifvP2xXO
5NF2sWIQWfj5o6Y26GhCu4JF0meiPeYJzuXadm3B+d+GpHcLiUClOpPRmf0Nk68N
/kbvwBtQyrP4bGybbjuT7135MdlnAL4/Gc2h3sIBHeUbcppptXW3Rcu0k0t/XZvp
3dhHTz3hMr/LDWWZr2AJOsIxDCeIF1SVpFwoVO9HOG8k4Eb2k6zbfP0q2xLYhX+2
i+fizR7kx4tk3B4k3Wwiz6SxRNvOTnhvkhSwCsH8dec2c+kuGCaM3oWhif54JWzT
MqEEeUZAjuQbtGZsbG7T+7uUmqHimwh/9coqyujtZr7ieLuUbP6yMycPwsSLiEn2
gMmLCa5XqLk2/N3pIuPF
=btsx
-----END PGP SIGNATURE-----

--dVBGI4feAor20Gxt4osLVeJgJBsRHArn6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
