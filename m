From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Wed, 31 Jan 2018 20:47:23 +0000
Message-ID: <VI1PR0502MB3008805F1A6056F50A12DEDBD1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <cover.1517418595.git.swise@opengridcomputing.com>
 <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Tuesday, January 30, 2018 10:59 AM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Subject: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
>=20
> Implement RDMA nldev netlink interface to get detailed CM_ID information.
>=20
> Because cm_id's are attached to rdma devices in various work queue contex=
ts,
> the pid and task information at device-attach time is sometimes not usefu=
l.
> For example, an nvme/f host connection ends up being bound to a device in=
 a
> work queue context and the resulting pid at attach time no longer exists =
after
> connection setup.  So instead we mark all cm_id's created via the rdma_uc=
m as
> "user", and all others as "kernel".  This required tweaking the restrack =
code a
> little.  It also required wrapping some rdma_cm functions to allow passin=
g the
> module name string.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c      |  55 ++++++---
>  drivers/infiniband/core/nldev.c    | 245
> +++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/restrack.c |  29 ++++-
>  drivers/infiniband/core/ucma.c     |   8 +-
>  include/rdma/rdma_cm.h             |  24 +++-
>  include/rdma/restrack.h            |   4 +
>  include/uapi/rdma/rdma_netlink.h   |  30 +++++
>  7 files changed, 365 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c index
> 72ad52b..51fbfa1 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -465,6 +465,9 @@ static void _cma_attach_to_dev(struct rdma_id_private
> *id_priv,
>  	id_priv->id.route.addr.dev_addr.transport =3D
>  		rdma_node_get_transport(cma_dev->device->node_type);
>  	list_add_tail(&id_priv->list, &cma_dev->id_list);
> +	id_priv->id.res.type =3D RDMA_RESTRACK_CM_ID;
> +	id_priv->id.res.kern_name =3D id_priv->id.caller;
> +	rdma_restrack_add(&id_priv->id.res);
>  }
>=20
>  static void cma_attach_to_dev(struct rdma_id_private *id_priv, @@ -737,1=
0
> +740,10 @@ static void cma_deref_id(struct rdma_id_private *id_priv)
>  		complete(&id_priv->comp);
>  }
>=20
> -struct rdma_cm_id *rdma_create_id(struct net *net,
> -				  rdma_cm_event_handler event_handler,
> -				  void *context, enum rdma_port_space ps,
> -				  enum ib_qp_type qp_type)
> +struct rdma_cm_id *__rdma_create_id(struct net *net,
> +				    rdma_cm_event_handler event_handler,
> +				    void *context, enum rdma_port_space ps,
> +				    enum ib_qp_type qp_type, const char *caller)
>  {
>  	struct rdma_id_private *id_priv;
>=20
> @@ -748,7 +751,10 @@ struct rdma_cm_id *rdma_create_id(struct net *net,
>  	if (!id_priv)
>  		return ERR_PTR(-ENOMEM);
>=20
> -	id_priv->owner =3D task_pid_nr(current);
> +	if (caller)
> +		id_priv->id.caller =3D caller;
> +	else
> +		id_priv->owner =3D task_pid_nr(current);
>  	id_priv->state =3D RDMA_CM_IDLE;
>  	id_priv->id.context =3D context;
>  	id_priv->id.event_handler =3D event_handler; @@ -768,7 +774,7 @@
> struct rdma_cm_id *rdma_create_id(struct net *net,
>=20
>  	return &id_priv->id;
>  }
> -EXPORT_SYMBOL(rdma_create_id);
> +EXPORT_SYMBOL(__rdma_create_id);
>=20
>  static int cma_init_ud_qp(struct rdma_id_private *id_priv, struct ib_qp =
*qp)  {
> @@ -1628,6 +1634,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
>  	mutex_unlock(&id_priv->handler_mutex);
>=20
>  	if (id_priv->cma_dev) {
> +		rdma_restrack_del(&id_priv->id.res);
>  		if (rdma_cap_ib_cm(id_priv->id.device, 1)) {
>  			if (id_priv->cm_id.ib)
>  				ib_destroy_cm_id(id_priv->cm_id.ib);
> @@ -1786,9 +1793,10 @@ static struct rdma_id_private
> *cma_new_conn_id(struct rdma_cm_id *listen_id,
>  		ib_event->param.req_rcvd.primary_path->service_id;
>  	int ret;
>=20
> -	id =3D rdma_create_id(listen_id->route.addr.dev_addr.net,
> +	id =3D __rdma_create_id(listen_id->route.addr.dev_addr.net,
>  			    listen_id->event_handler, listen_id->context,
> -			    listen_id->ps, ib_event->param.req_rcvd.qp_type);
> +			    listen_id->ps, ib_event->param.req_rcvd.qp_type,
> +			    listen_id->caller);
>  	if (IS_ERR(id))
>  		return NULL;
>=20
> @@ -1843,8 +1851,8 @@ static struct rdma_id_private
> *cma_new_udp_id(struct rdma_cm_id *listen_id,
>  	struct net *net =3D listen_id->route.addr.dev_addr.net;
>  	int ret;
>=20
> -	id =3D rdma_create_id(net, listen_id->event_handler, listen_id->context=
,
> -			    listen_id->ps, IB_QPT_UD);
> +	id =3D __rdma_create_id(net, listen_id->event_handler, listen_id-
> >context,
> +			      listen_id->ps, IB_QPT_UD, listen_id->caller);
>  	if (IS_ERR(id))
>  		return NULL;
>=20
> @@ -2110,10 +2118,11 @@ static int iw_conn_req_handler(struct iw_cm_id
> *cm_id,
>  		goto out;
>=20
>  	/* Create a new RDMA id for the new IW CM ID */
> -	new_cm_id =3D rdma_create_id(listen_id->id.route.addr.dev_addr.net,
> -				   listen_id->id.event_handler,
> -				   listen_id->id.context,
> -				   RDMA_PS_TCP, IB_QPT_RC);
> +	new_cm_id =3D __rdma_create_id(listen_id->id.route.addr.dev_addr.net,
> +				     listen_id->id.event_handler,
> +				     listen_id->id.context,
> +				     RDMA_PS_TCP, IB_QPT_RC,
> +				     listen_id->id.caller);
>  	if (IS_ERR(new_cm_id)) {
>  		ret =3D -ENOMEM;
>  		goto out;
> @@ -2238,8 +2247,8 @@ static void cma_listen_on_dev(struct rdma_id_privat=
e
> *id_priv,
>  	if (cma_family(id_priv) =3D=3D AF_IB && !rdma_cap_ib_cm(cma_dev-
> >device, 1))
>  		return;
>=20
> -	id =3D rdma_create_id(net, cma_listen_handler, id_priv, id_priv->id.ps,
> -			    id_priv->id.qp_type);
> +	id =3D __rdma_create_id(net, cma_listen_handler, id_priv, id_priv->id.p=
s,
> +			      id_priv->id.qp_type, id_priv->id.caller);
>  	if (IS_ERR(id))
>  		return;
>=20
> @@ -3347,8 +3356,10 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct
> sockaddr *addr)
>=20
>  	return 0;
>  err2:
> -	if (id_priv->cma_dev)
> +	if (id_priv->cma_dev) {
> +		rdma_restrack_del(&id_priv->id.res);
>  		cma_release_dev(id_priv);
> +	}
>  err1:
>  	cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_IDLE);
>  	return ret;
> @@ -3731,14 +3742,18 @@ static int cma_send_sidr_rep(struct
> rdma_id_private *id_priv,
>  	return ib_send_cm_sidr_rep(id_priv->cm_id.ib, &rep);  }
>=20
> -int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param
> *conn_param)
> +int __rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param
> *conn_param,
> +		  const char *caller)
>  {
>  	struct rdma_id_private *id_priv;
>  	int ret;
>=20
>  	id_priv =3D container_of(id, struct rdma_id_private, id);
>=20
> -	id_priv->owner =3D task_pid_nr(current);
> +	if (caller)
> +		id_priv->id.caller =3D caller;
> +	else
> +		id_priv->owner =3D task_pid_nr(current);
>=20
>  	if (!cma_comp(id_priv, RDMA_CM_CONNECT))
>  		return -EINVAL;
> @@ -3778,7 +3793,7 @@ int rdma_accept(struct rdma_cm_id *id, struct
> rdma_conn_param *conn_param)
>  	rdma_reject(id, NULL, 0);
>  	return ret;
>  }
> -EXPORT_SYMBOL(rdma_accept);
> +EXPORT_SYMBOL(__rdma_accept);
>=20
>  int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event)  { diff=
 --git
> a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c index
> fa8655e..a4091b5 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -34,6 +34,7 @@
>  #include <linux/pid.h>
>  #include <linux/pid_namespace.h>
>  #include <net/netlink.h>
> +#include <rdma/rdma_cm.h>
>  #include <rdma/rdma_netlink.h>
>=20
>  #include "core_priv.h"
> @@ -71,6 +72,22 @@
>  	[RDMA_NLDEV_ATTR_RES_PID]		=3D { .type =3D NLA_U32 },
>  	[RDMA_NLDEV_ATTR_RES_KERN_NAME]		=3D { .type =3D
> NLA_NUL_STRING,
>  						    .len =3D TASK_COMM_LEN },
> +	[RDMA_NLDEV_ATTR_RES_CM_ID]		=3D { .type =3D
> NLA_NESTED },
> +	[RDMA_NLDEV_ATTR_RES_CM_ID_ENTRY]	=3D { .type =3D
> NLA_NESTED },
> +	[RDMA_NLDEV_ATTR_RES_PS]		=3D { .type =3D NLA_U32 },
> +	[RDMA_NLDEV_ATTR_RES_IPV4_SADDR]	=3D {
> +				.len =3D FIELD_SIZEOF(struct iphdr, saddr) },
> +	[RDMA_NLDEV_ATTR_RES_IPV4_DADDR]	=3D {
> +				.len =3D FIELD_SIZEOF(struct iphdr, saddr) },
> +	[RDMA_NLDEV_ATTR_RES_IPV6_SADDR]	=3D {
> +				.len =3D FIELD_SIZEOF(struct ipv6hdr, saddr) },
> +	[RDMA_NLDEV_ATTR_RES_IPV6_DADDR]	=3D {
> +				.len =3D FIELD_SIZEOF(struct ipv6hdr, saddr) },
> +	[RDMA_NLDEV_ATTR_RES_IP_SPORT]		=3D { .type =3D NLA_U16 },
> +	[RDMA_NLDEV_ATTR_RES_IP_DPORT]		=3D { .type =3D NLA_U16 },
> +	[RDMA_NLDEV_ATTR_RES_DEV_TYPE]		=3D { .type =3D NLA_U8 },
> +	[RDMA_NLDEV_ATTR_RES_TRANSPORT_TYPE]	=3D { .type =3D NLA_U8 },
> +	[RDMA_NLDEV_ATTR_RES_NETWORK_TYPE]	=3D { .type =3D NLA_U8 },
>  };
>=20
>  static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *devi=
ce) @@ -
> 182,6 +199,7 @@ static int fill_res_info(struct sk_buff *msg, struct ib_d=
evice
> *device)
>  		[RDMA_RESTRACK_PD] =3D "pd",
>  		[RDMA_RESTRACK_CQ] =3D "cq",
>  		[RDMA_RESTRACK_QP] =3D "qp",
> +		[RDMA_RESTRACK_CM_ID] =3D "cm_id",

May be rdmacm_id a better name to avoid confusion with ib_cm/iw_cm ids?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
