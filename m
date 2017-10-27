From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] IB/mlx5: give back valid speed/width even without plugged
 in SFP module
Date: Fri, 27 Oct 2017 18:32:57 +0000
Message-ID: <VI1PR0502MB3008AE9EEBF086840CC06077D15A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20171027123011.10454-1-tbogendoerfer@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171027123011.10454-1-tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Thomas Bogendoerfer
> Sent: Friday, October 27, 2017 7:30 AM
> To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon Romanovsky
> <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] IB/mlx5: give back valid speed/width even without plugge=
d in
> SFP module
>=20
> If there is no SFP module plugged into a port of mlx5 cards 'cat
> /sys/class/infniband/mlx5_X/ports/1/rate' returns Invalid argument.
> This causes tools like 'ibstat' to malfunction. This change adjusts mlx5 =
to all
> other RoCE/iWarp drivers, which always return valid speed/width.
>=20
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c
> b/drivers/infiniband/hw/mlx5/main.c
> index 260f8be1d0ed..4388618e3434 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -246,7 +246,10 @@ static int translate_eth_proto_oper(u32
> eth_proto_oper, u8 *active_speed,
>  		*active_speed =3D IB_SPEED_EDR;
>  		break;
>  	default:
> -		return -EINVAL;
> +		/* Unknown */
> +		*active_width =3D IB_WIDTH_1X;
> +		*active_speed =3D IB_SPEED_SDR;
> +		break;
>  	}
>=20
>  	return 0;
> --
> 2.12.3

Similar issue was reported by Ghazale in offline email and she also provide=
d similar patch.
I added her in this mail thread.
Please add below reported-by tag if you find it appropriate.
Reported-by: Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks for the short term fix.
However I believe that ibstat tool should be enhanced to report unknown por=
t speed instead of expecting drivers to supply some random number like this=
.
Similar tools such as ethtool does report unknown port speed as unknown lik=
e below output which doesn't have SFP.

ethtool ens2f0
        <....>
        Speed: Unknown!
        Duplex: Unknown! (255)
        <....>
        Link detected: no
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
