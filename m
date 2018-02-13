From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH RESEND v1 rdma-next 2/6] RDMA/nldev: provide detailed
 CM_ID information
Date: Tue, 13 Feb 2018 20:43:57 +0000
Message-ID: <VI1PR0502MB300833C7A62DB411AB8E7982D1F60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <cover.1518552800.git.swise@opengridcomputing.com>
 <1510713d3e0f14b101bea7dc9e02084e46e580ec.1518552800.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510713d3e0f14b101bea7dc9e02084e46e580ec.1518552800.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Tuesday, January 30, 2018 10:59 AM
> To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Subject: [PATCH RESEND v1 rdma-next 2/6] RDMA/nldev: provide detailed
> CM_ID information
>=20
> Implement RDMA nldev netlink interface to get detailed CM_ID information.
>=20
> Because cm_id's are attached to rdma devices in various work queue contex=
ts,
> the pid and task information at device-attach time is sometimes not usefu=
l.  For
> example, an nvme/f host connection cm_id ends up being bound to a device =
in a
> work queue context and the resulting pid at attach time no longer exists =
after
> connection setup.  So instead we mark all cm_id's created via the rdma_uc=
m as
> "user", and all others as "kernel".
> This required tweaking the restrack code a little.  It also required wrap=
ping some
> rdma_cm functions to allow passing the module name string.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c      |  55 ++++++---
>  drivers/infiniband/core/nldev.c    | 246
> +++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/restrack.c |  15 ++-
>  drivers/infiniband/core/ucma.c     |   8 +-
>  include/rdma/rdma_cm.h             |  24 +++-
>  include/rdma/restrack.h            |   4 +
>  include/uapi/rdma/rdma_netlink.h   |  30 +++++
>  7 files changed, 352 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c index
> 203519e..61ea800 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -466,6 +466,9 @@ static void _cma_attach_to_dev(struct rdma_id_private
> *id_priv,
>  	id_priv->id.route.addr.dev_addr.transport =3D
>  		rdma_node_get_transport(cma_dev->device->node_type);
>  	list_add_tail(&id_priv->list, &cma_dev->id_list);
> +	id_priv->id.res.type =3D RDMA_RESTRACK_CM_ID;
> +	id_priv->id.res.kern_name =3D id_priv->id.caller;
> +	rdma_restrack_add(&id_priv->id.res);
>  }
>=20
>  static void cma_attach_to_dev(struct rdma_id_private *id_priv, @@ -738,1=
0
> +741,10 @@ static void cma_deref_id(struct rdma_id_private *id_priv)
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
> @@ -749,7 +752,10 @@ struct rdma_cm_id *rdma_create_id(struct net *net,
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
>  	id_priv->id.event_handler =3D event_handler; @@ -769,7 +775,7 @@
> struct rdma_cm_id *rdma_create_id(struct net *net,
>=20
>  	return &id_priv->id;
>  }
> -EXPORT_SYMBOL(rdma_create_id);
> +EXPORT_SYMBOL(__rdma_create_id);
>=20
>  static int cma_init_ud_qp(struct rdma_id_private *id_priv, struct ib_qp =
*qp)  {
> @@ -1629,6 +1635,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
>  	mutex_unlock(&id_priv->handler_mutex);
>=20
>  	if (id_priv->cma_dev) {
> +		rdma_restrack_del(&id_priv->id.res);
>  		if (rdma_cap_ib_cm(id_priv->id.device, 1)) {
>  			if (id_priv->cm_id.ib)
>  				ib_destroy_cm_id(id_priv->cm_id.ib);
> @@ -1787,9 +1794,10 @@ static struct rdma_id_private
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
> @@ -1844,8 +1852,8 @@ static struct rdma_id_private
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
> @@ -2111,10 +2119,11 @@ static int iw_conn_req_handler(struct iw_cm_id
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
> @@ -2239,8 +2248,8 @@ static void cma_listen_on_dev(struct rdma_id_privat=
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
> @@ -3348,8 +3357,10 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct
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
> @@ -3732,14 +3743,18 @@ static int cma_send_sidr_rep(struct
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
> @@ -3779,7 +3794,7 @@ int rdma_accept(struct rdma_cm_id *id, struct
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
> fa8655e..13f5c46 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -34,9 +34,11 @@
>  #include <linux/pid.h>
>  #include <linux/pid_namespace.h>
>  #include <net/netlink.h>
> +#include <rdma/rdma_cm.h>
>  #include <rdma/rdma_netlink.h>
>=20
>  #include "core_priv.h"
> +#include "cma_priv.h"
>=20
>  static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] =3D {
>  	[RDMA_NLDEV_ATTR_DEV_INDEX]     =3D { .type =3D NLA_U32 },
> @@ -71,6 +73,22 @@
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
> 182,6 +200,7 @@ static int fill_res_info(struct sk_buff *msg, struct ib_d=
evice
> *device)
>  		[RDMA_RESTRACK_PD] =3D "pd",
>  		[RDMA_RESTRACK_CQ] =3D "cq",
>  		[RDMA_RESTRACK_QP] =3D "qp",
> +		[RDMA_RESTRACK_CM_ID] =3D "cm_id",
>  	};
>=20
>  	struct rdma_restrack_root *res =3D &device->res; @@ -284,6 +303,99
> @@ static int fill_res_qp_entry(struct sk_buff *msg,
>  	return -EMSGSIZE;
>  }
>=20
> +static int fill_res_cm_id_entry(struct sk_buff *msg,
> +				struct rdma_cm_id *cm_id, uint32_t port) {
> +	struct rdma_id_private *id_priv;
> +	struct nlattr *entry_attr;
> +
> +	if (port && port !=3D cm_id->port_num)
> +		return 0;
> +
> +	id_priv =3D container_of(cm_id, struct rdma_id_private, id);
> +	entry_attr =3D nla_nest_start(msg,
> RDMA_NLDEV_ATTR_RES_CM_ID_ENTRY);
> +	if (!entry_attr)
> +		goto out;
> +
> +	if (cm_id->port_num &&
> +	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, cm_id-
> >port_num))
> +		goto err;
> +
> +	if (id_priv->qp_num &&
> +	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, id_priv-
> >qp_num))
> +		goto err;
> +
> +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PS, cm_id->ps))
> +		goto err;
> +
> +	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_TYPE, cm_id->qp_type))
> +		goto err;
> +	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_STATE, id_priv->state))
> +		goto err;
> +	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_DEV_TYPE,
> +		       id_priv->id.route.addr.dev_addr.dev_type))
> +		goto err;
> +	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_TRANSPORT_TYPE,
> +		       id_priv->id.route.addr.dev_addr.transport))
> +		goto err;
> +
> +	if (cm_id->route.addr.src_addr.ss_family =3D=3D AF_INET) {
> +		struct sockaddr_in *sin;
> +
> +		sin =3D (struct sockaddr_in *)&cm_id->route.addr.src_addr;
> +		if (nla_put_in_addr(msg,
> RDMA_NLDEV_ATTR_RES_IPV4_SADDR,
> +				    sin->sin_addr.s_addr))
> +			goto err;
> +		if (nla_put_net16(msg, RDMA_NLDEV_ATTR_RES_IP_SPORT,
> +				  be16_to_cpu(sin->sin_port)))
> +			goto err;
> +
> +		sin =3D (struct sockaddr_in *)&cm_id->route.addr.dst_addr;
> +		if (nla_put_in_addr(msg,
> RDMA_NLDEV_ATTR_RES_IPV4_DADDR,
> +				    sin->sin_addr.s_addr))
> +			goto err;
> +		if (nla_put_net16(msg, RDMA_NLDEV_ATTR_RES_IP_DPORT,
> +				  be16_to_cpu(sin->sin_port)))
> +			goto err;
> +	} else {
> +		struct sockaddr_in6 *sin6;
> +
> +		sin6 =3D (struct sockaddr_in6 *)&cm_id->route.addr.src_addr;
> +		if (nla_put_in6_addr(msg,
> RDMA_NLDEV_ATTR_RES_IPV6_SADDR,
> +				     &sin6->sin6_addr))
> +			goto err;
> +		if (nla_put_net16(msg, RDMA_NLDEV_ATTR_RES_IP_SPORT,
> +				  sin6->sin6_port))
> +			goto err;
> +
> +		sin6 =3D (struct sockaddr_in6 *)&cm_id->route.addr.dst_addr;
> +		if (nla_put_in6_addr(msg,
> RDMA_NLDEV_ATTR_RES_IPV6_DADDR,
> +				     &sin6->sin6_addr))
> +			goto err;
> +		if (nla_put_net16(msg, RDMA_NLDEV_ATTR_RES_IP_DPORT,
> +				  sin6->sin6_port))
> +			goto err;
> +	}
> +
> +	if (id_priv->id.caller) {
> +		if (nla_put_string(msg, RDMA_NLDEV_ATTR_RES_KERN_NAME,
> +				   id_priv->id.caller))
> +			goto err;
> +	} else {
> +		/* CMA keeps the owning pid. */
> +		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PID, id_priv-
> >owner))
> +			goto err;
> +	}
> +
> +	nla_nest_end(msg, entry_attr);
> +	return 0;
> +
> +err:
> +	nla_nest_cancel(msg, entry_attr);
> +out:
> +	return -EMSGSIZE;
> +}
> +
>  static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			  struct netlink_ext_ack *extack)
>  {
> @@ -686,6 +798,137 @@ static int nldev_res_get_qp_dumpit(struct sk_buff
> *skb,
>  	return ret;
>  }
>=20
> +static int nldev_res_get_cm_id_dumpit(struct sk_buff *skb,
> +				      struct netlink_callback *cb)
> +{
> +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
> +	struct rdma_restrack_entry *res;
> +	int err, ret =3D 0, idx =3D 0;
> +	struct nlattr *table_attr;
> +	struct ib_device *device;
> +	int start =3D cb->args[0];
> +	struct rdma_cm_id *cm_id =3D NULL;
> +	struct nlmsghdr *nlh;
> +	u32 index, port =3D 0;
> +
> +	err =3D nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> +			  nldev_policy, NULL);
> +	/*
> +	 * Right now, we are expecting the device index to get QP information,
> +	 * but it is possible to extend this code to return all devices in
> +	 * one shot by checking the existence of
> RDMA_NLDEV_ATTR_DEV_INDEX.
> +	 * if it doesn't exist, we will iterate over all devices.
> +	 *
> +	 * But it is not needed for now.
> +	 */
> +	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
> +		return -EINVAL;
> +
> +	index =3D nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> +	device =3D ib_device_get_by_index(index);
> +	if (!device)
> +		return -EINVAL;
> +
> +	/*
> +	 * If no PORT_INDEX is supplied, return all CM_IDs from that device
> +	 */
> +	if (tb[RDMA_NLDEV_ATTR_PORT_INDEX]) {
> +		port =3D nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> +		if (!rdma_is_port_valid(device, port)) {
> +			ret =3D -EINVAL;
> +			goto err_index;
> +		}
> +	}
> +
> +	nlh =3D nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
> +		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
> RDMA_NLDEV_CMD_RES_CM_ID_GET),
> +		0, NLM_F_MULTI);
> +
> +	if (fill_nldev_handle(skb, device)) {
> +		ret =3D -EMSGSIZE;
> +		goto err;
> +	}
> +
> +	table_attr =3D nla_nest_start(skb, RDMA_NLDEV_ATTR_RES_CM_ID);
> +	if (!table_attr) {
> +		ret =3D -EMSGSIZE;
> +		goto err;
> +	}
> +
> +	down_read(&device->res.rwsem);
> +	hash_for_each_possible(device->res.hash, res, node,
> +			       RDMA_RESTRACK_CM_ID) {
> +		if (idx < start)
> +			goto next;
> +
> +		if ((rdma_is_kernel_res(res) &&
> +		     task_active_pid_ns(current) !=3D &init_pid_ns) ||
> +		    (!rdma_is_kernel_res(res) &&
> +		     task_active_pid_ns(current) !=3D
> +		     task_active_pid_ns(res->task)))
> +			/*
> +			 * 1. Kernel QPs should be visible in init namsapce only
> +			 * 2. Preent only QPs visible in the current namespace
Present only
> +			 */
> +			goto next;
> +
> +		if (!rdma_restrack_get(res))
> +			/*
> +			 * Resource is under release now, but we are not
> +			 * relesing lock now, so it will be released in
> +			 * our next pass, once we will get ->next pointer.
> +			 */
> +			goto next;
> +
> +		cm_id =3D container_of(res, struct rdma_cm_id, res);
> +
> +		up_read(&device->res.rwsem);
> +		ret =3D fill_res_cm_id_entry(skb, cm_id, port);
> +		down_read(&device->res.rwsem);
> +		/*
> +		 * Return resource back, but it won't be released till
> +		 * the &device->res.rwsem will be released for write.
> +		 */
> +		rdma_restrack_put(res);
> +
> +		if (ret =3D=3D -EMSGSIZE)
> +			/*
> +			 * There is a chance to optimize here.
> +			 * It can be done by using list_prepare_entry
> +			 * and list_for_each_entry_continue afterwards.
> +			 */
> +			break;
> +		if (ret)
> +			goto res_err;
> +next:		idx++;
> +	}
> +	up_read(&device->res.rwsem);
> +
> +	nla_nest_end(skb, table_attr);
> +	nlmsg_end(skb, nlh);
> +	cb->args[0] =3D idx;
> +
> +	/*
> +	 * No more CM_IDs to fill, cancel the message and
> +	 * return 0 to mark end of dumpit.
> +	 */
> +	if (!cm_id)
> +		goto err;
> +
> +	put_device(&device->dev);
> +	return skb->len;
> +
> +res_err:
> +	nla_nest_cancel(skb, table_attr);
> +	up_read(&device->res.rwsem);
> +
> +err:
> +	nlmsg_cancel(skb, nlh);
> +
> +err_index:
> +	put_device(&device->dev);
> +	return ret;
> +}
>  static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] =3D {
>  	[RDMA_NLDEV_CMD_GET] =3D {
>  		.doit =3D nldev_get_doit,
> @@ -712,6 +955,9 @@ static int nldev_res_get_qp_dumpit(struct sk_buff *sk=
b,
>  		 * too.
>  		 */
>  	},
> +	[RDMA_NLDEV_CMD_RES_CM_ID_GET] =3D {
> +		.dump =3D nldev_res_get_cm_id_dumpit,
> +	},
>  };
>=20
>  void __init nldev_init(void)
> diff --git a/drivers/infiniband/core/restrack.c
> b/drivers/infiniband/core/restrack.c
> index 83bce7e..6385914 100644
> --- a/drivers/infiniband/core/restrack.c
> +++ b/drivers/infiniband/core/restrack.c
> @@ -3,12 +3,15 @@
>   * Copyright (c) 2017-2018 Mellanox Technologies. All rights reserved.
>   */
>=20
> +#include <rdma/rdma_cm.h>
>  #include <rdma/ib_verbs.h>
>  #include <rdma/restrack.h>
>  #include <linux/mutex.h>
>  #include <linux/sched/task.h>
>  #include <linux/pid_namespace.h>
>=20
> +#include "cma_priv.h"
> +
>  void rdma_restrack_init(struct rdma_restrack_root *res)  {
>  	init_rwsem(&res->rwsem);
> @@ -44,7 +47,7 @@ static void set_kern_name(struct rdma_restrack_entry
> *res)
>  	struct ib_qp *qp;
>=20
>  	if (type !=3D RDMA_RESTRACK_QP)
> -		/* PD and CQ types already have this name embedded in */
> +		/* Other types already have this name embedded in */
>  		return;
>=20
>  	qp =3D container_of(res, struct ib_qp, res); @@ -61,6 +64,7 @@ static
> void set_kern_name(struct rdma_restrack_entry *res)  static struct ib_dev=
ice
> *res_to_dev(struct rdma_restrack_entry *res)  {
>  	enum rdma_restrack_type type =3D res->type;
> +	struct rdma_cm_id *cm_id;
>  	struct ib_device *dev;
>  	struct ib_xrcd *xrcd;
>  	struct ib_pd *pd;
> @@ -84,6 +88,10 @@ static struct ib_device *res_to_dev(struct
> rdma_restrack_entry *res)
>  		xrcd =3D container_of(res, struct ib_xrcd, res);
>  		dev =3D xrcd->device;
>  		break;
> +	case RDMA_RESTRACK_CM_ID:
> +		cm_id =3D container_of(res, struct rdma_cm_id, res);
> +		dev =3D cm_id->device;
> +		break;
>  	default:
>  		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
>  		return NULL;
> @@ -95,6 +103,7 @@ static struct ib_device *res_to_dev(struct
> rdma_restrack_entry *res)  static bool res_is_user(struct rdma_restrack_e=
ntry
> *res)  {
>  	enum rdma_restrack_type type =3D res->type;
> +	struct rdma_cm_id *cm_id;
>  	struct ib_xrcd *xrcd;
>  	struct ib_pd *pd;
>  	struct ib_cq *cq;
> @@ -119,6 +128,10 @@ static bool res_is_user(struct rdma_restrack_entry
> *res)
>  		xrcd =3D container_of(res, struct ib_xrcd, res);
>  		is_user =3D xrcd->inode;
>  		break;
> +	case RDMA_RESTRACK_CM_ID:
> +		cm_id =3D container_of(res, struct rdma_cm_id, res);
> +		is_user =3D !cm_id->caller;
> +		break;
>  	default:
>  		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
>  	}
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucm=
a.c
> index d67219d..f7f0282 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -476,8 +476,8 @@ static ssize_t ucma_create_id(struct ucma_file *file,
> const char __user *inbuf,
>  		return -ENOMEM;
>=20
>  	ctx->uid =3D cmd.uid;
> -	ctx->cm_id =3D rdma_create_id(current->nsproxy->net_ns,
> -				    ucma_event_handler, ctx, cmd.ps, qp_type);
> +	ctx->cm_id =3D __rdma_create_id(current->nsproxy->net_ns,
> +			      ucma_event_handler, ctx, cmd.ps, qp_type, NULL);
>  	if (IS_ERR(ctx->cm_id)) {
>  		ret =3D PTR_ERR(ctx->cm_id);
>  		goto err1;
> @@ -1084,12 +1084,12 @@ static ssize_t ucma_accept(struct ucma_file *file=
,
> const char __user *inbuf,
>  	if (cmd.conn_param.valid) {
>  		ucma_copy_conn_param(ctx->cm_id, &conn_param,
> &cmd.conn_param);
>  		mutex_lock(&file->mut);
> -		ret =3D rdma_accept(ctx->cm_id, &conn_param);
> +		ret =3D __rdma_accept(ctx->cm_id, &conn_param, NULL);
>  		if (!ret)
>  			ctx->uid =3D cmd.uid;
>  		mutex_unlock(&file->mut);
>  	} else
> -		ret =3D rdma_accept(ctx->cm_id, NULL);
> +		ret =3D __rdma_accept(ctx->cm_id, NULL, NULL);
>=20
>  	ucma_put_ctx(ctx);
>  	return ret;
> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h index
> 6538a5c..3e90501 100644
> --- a/include/rdma/rdma_cm.h
> +++ b/include/rdma/rdma_cm.h
> @@ -155,8 +155,19 @@ struct rdma_cm_id {
>  	enum rdma_port_space	 ps;
>  	enum ib_qp_type		 qp_type;
>  	u8			 port_num;
> +	const char *caller;
> +
> +	/*
> +	 * Internal to RDMA/core, don't use in the drivers
> +	 */
> +	struct rdma_restrack_entry     res;
I didn't review the whole code; can this be kept in rdma_cm_priv_id instead=
?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
