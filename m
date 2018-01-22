From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 1/6] RDMA/cma: Check existence of netdevice
 during port validation
Date: Mon, 22 Jan 2018 20:39:19 +0000
Message-ID: <VI1PR0502MB30080B452158077BBA9C9EE4D1EC0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180109135859.7676-1-leon@kernel.org>
 <20180109135859.7676-2-leon@kernel.org> <20180122184807.GN14358@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122184807.GN14358-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe
> Sent: Monday, January 22, 2018 12:48 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; RDMA mailing list <linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Mark Bloch
> <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 1/6] RDMA/cma: Check existence of netdevice
> during port validation
>=20
> On Tue, Jan 09, 2018 at 03:58:54PM +0200, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > If valid netdevice is not found for RoCE, GID table should not be
> > searched with NULL netdevice.
> >
> > Fixes: abae1b71dd37 ("IB/cma: cma_validate_port should verify the port
> > and netdevice")
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > drivers/infiniband/core/cma.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/cma.c
> > b/drivers/infiniband/core/cma.c index 169d3a3bbf71..683428cffd54
> > 100644
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -624,11 +624,13 @@ static inline int cma_validate_port(struct ib_dev=
ice
> *device, u8 port,
> >  	if ((dev_type !=3D ARPHRD_INFINIBAND) && rdma_protocol_ib(device,
> port))
> >  		return ret;
> >
> > -	if (dev_type =3D=3D ARPHRD_ETHER && rdma_protocol_roce(device, port))
> > +	if (dev_type =3D=3D ARPHRD_ETHER && rdma_protocol_roce(device, port))=
 {
> >  		ndev =3D dev_get_by_index(&init_net, bound_if_index);
>=20
> Why are we using indexes as a long term handle to netdevs? Is there some
> reason for this you know of?
I am not sure why index was used instead of netdev pointer in beginning.
I do prefer pointer. Sometime back I tried to look at this code but dropped=
 the idea due to convoluted code of rdma_translate_ip() and rdma_copy_addr(=
).

>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
