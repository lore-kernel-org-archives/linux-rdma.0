From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] IB/cma: Fix setting default RoCE GID type
Date: Fri, 8 Sep 2017 04:35:27 +0000
Message-ID: <HE1PR0502MB3004000B36E33ECFD12741CFD1950@HE1PR0502MB3004.eurprd05.prod.outlook.com>
References: <1504842194-63298-1-git-send-email-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504842194-63298-1-git-send-email-parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please drop this patch.
This fix is already merged. I referred to wrong tree.
Sorry.

Parav

> -----Original Message-----
> From: Parav Pandit [mailto:parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Thursday, September 07, 2017 10:43 PM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Matan Barak
> <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Parav Pandit
> <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: [PATCH] IB/cma: Fix setting default RoCE GID type
>=20
> GID table entry attribute stores gid entry type in absolute value (not bi=
t mask).
> HCA driver provides type of supported GID entries as bit mask.
> cma code with recent change compares cma's preferred bit mask and sets
> default GID type as bit mask. Setting bit mask is incorrect because it se=
ts default
> GID type as 2 (1 << 1).
> Currently valid GID types are 0 and 1.
> Due to this default GID entry is set incorrectly to 2. configfs also show=
s incorrect
> GID entry type.
>=20
> This patch fixes it by compares GID type bit mask and sets default GID ty=
pe as
> absolute value.
>=20
> In follow up email [1] Leon mentioned correction in definition but it is =
actually in
> comparision as done in the patch now.
>=20
> [1]
> https://emea01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.=
s
> pinics.net%2Flists%2Flinux-
> rdma%2Fmsg50619.html&data=3D02%7C01%7Cparav%40mellanox.com%7Cad596
> 1e2cef847dd9b5c08d4f66bc86a%7Ca652971c7d2e4d9ba6a4d149256f461b%7C
> 0%7C0%7C636404390169778399&sdata=3Dxl%2F%2FH7Cu1vUYW9yILyA90XerTjL
> WzC2mVbWMspLzfYs%3D&reserved=3D0
>=20
> Fixes: a5288b27b731 (IB/cma: Fix default RoCE type setting)
> Fixes: 63a5f483af0e (IB/cma: Set default gid type to RoCEv2)
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c index
> f13f016..8444546 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -72,7 +72,8 @@
>  #define CMA_MAX_CM_RETRIES 15
>  #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)  #define
> CMA_IBOE_PACKET_LIFETIME 18 -#define CMA_PREFERRED_ROCE_GID_TYPE
> (1 << IB_GID_TYPE_ROCE_UDP_ENCAP)
> +#define CMA_PREFERRED_ROCE_GID_TYPE IB_GID_TYPE_ROCE_UDP_ENCAP
> #define
> +CMA_PREFERRED_ROCE_GID_TYPE_MASK
> BIT(CMA_PREFERRED_ROCE_GID_TYPE)
>=20
>  static const char * const cma_events[] =3D {
>  	[RDMA_CM_EVENT_ADDR_RESOLVED]	 =3D "address resolved",
> @@ -4307,7 +4308,7 @@ static void cma_add_one(struct ib_device *device)
>  	for (i =3D rdma_start_port(device); i <=3D rdma_end_port(device); i++) =
{
>  		supported_gids =3D roce_gid_type_mask_support(device, i);
>  		WARN_ON(!supported_gids);
> -		if (supported_gids & CMA_PREFERRED_ROCE_GID_TYPE)
> +		if (supported_gids & CMA_PREFERRED_ROCE_GID_TYPE_MASK)
>  			cma_dev->default_gid_type[i -
> rdma_start_port(device)] =3D
>  				CMA_PREFERRED_ROCE_GID_TYPE;
>  		else
> --
> 1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
