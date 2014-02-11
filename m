From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/3] Add ibv_port_cap_flags
Date: Tue, 11 Feb 2014 14:53:29 +0100
Message-ID: <1392126809.11170.32.camel@localhost.localdomain>
References: <1392121864-9672-1-git-send-email-ogerlitz@mellanox.com>
	 <1392121864-9672-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392121864-9672-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le mardi 11 f=C3=A9vrier 2014 =C3=A0 14:31 +0200, Or Gerlitz a =C3=A9cr=
it :
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Add an enum that describes ibv_port_cap_flags that complies
> with the respective kernel enum and modify the existing
> field in struct ibv_port_attr to be of that type.
>=20

The last part is no more true.

> This value could be fetched when using ibv_query_port.
>=20
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/infiniband/verbs.h |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index 5064636..a79a1de 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -186,6 +186,28 @@ enum {
>  	IBV_LINK_LAYER_ETHERNET,
>  };
> =20
> +enum ibv_port_cap_flags {
> +	IBV_PORT_SM				=3D 1 <<  1,
> +	IBV_PORT_NOTICE_SUP			=3D 1 <<  2,
> +	IBV_PORT_TRAP_SUP			=3D 1 <<  3,
> +	IBV_PORT_OPT_IPD_SUP			=3D 1 <<  4,
> +	IBV_PORT_AUTO_MIGR_SUP			=3D 1 <<  5,
> +	IBV_PORT_SL_MAP_SUP			=3D 1 <<  6,
> +	IBV_PORT_MKEY_NVRAM			=3D 1 <<  7,
> +	IBV_PORT_PKEY_NVRAM			=3D 1 <<  8,
> +	IBV_PORT_LED_INFO_SUP			=3D 1 <<  9,
> +	IBV_PORT_SYS_IMAGE_GUID_SUP		=3D 1 << 11,
> +	IBV_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	=3D 1 << 12,
> +	IBV_PORT_EXTENDED_SPEEDS_SUP		=3D 1 << 14,
> +	IBV_PORT_CM_SUP				=3D 1 << 16,
> +	IBV_PORT_SNMP_TUNNEL_SUP		=3D 1 << 17,
> +	IBV_PORT_REINIT_SUP			=3D 1 << 18,
> +	IBV_PORT_DEVICE_MGMT_SUP		=3D 1 << 19,
> +	IBV_PORT_VENDOR_CLASS			=3D 1 << 24,
> +	IBV_PORT_CLIENT_REG_SUP			=3D 1 << 25,
> +	IBV_PORT_IP_BASED_GIDS			=3D 1 << 26,
> +};
> +
>  struct ibv_port_attr {
>  	enum ibv_port_state	state;
>  	enum ibv_mtu		max_mtu;

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
