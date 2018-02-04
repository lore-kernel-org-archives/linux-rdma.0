From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Sun, 4 Feb 2018 17:05:53 +0200
Message-ID: <20180204150553.GH27780@mtr-leonro.local>
References: <cover.1517418595.git.swise@opengridcomputing.com>
 <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com>
 <20180201084944.GH2055@mtr-leonro.local>
 <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 01, 2018 at 10:07:20AM -0600, Steve Wise wrote:
>
> >
> > On Tue, Jan 30, 2018 at 08:59:11AM -0800, Steve Wise wrote:
> > > Implement RDMA nldev netlink interface to get detailed CM_ID
> information.
> > >
> > > Because cm_id's are attached to rdma devices in various work queue
> contexts,
> > > the pid and task information at device-attach time is sometimes not
> useful.
> > > For example, an nvme/f host connection ends up being bound to a device
> > > in a work queue context and the resulting pid at attach time no longer
> exists
> > > after connection setup.  So instead we mark all cm_id's created via the
> > > rdma_ucm as "user", and all others as "kernel".  This required tweaking
> > > the restrack code a little.  It also required wrapping some rdma_cm
> > > functions to allow passing the module name string.
> > >
> > > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/cma.c      |  55 ++++++---
> > >  drivers/infiniband/core/nldev.c    | 245
> > +++++++++++++++++++++++++++++++++++++
> > >  drivers/infiniband/core/restrack.c |  29 ++++-
> > >  drivers/infiniband/core/ucma.c     |   8 +-
> > >  include/rdma/rdma_cm.h             |  24 +++-
> > >  include/rdma/restrack.h            |   4 +
> > >  include/uapi/rdma/rdma_netlink.h   |  30 +++++
> > >  7 files changed, 365 insertions(+), 30 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/core/cma.c
> b/drivers/infiniband/core/cma.c
> > > index 72ad52b..51fbfa1 100644
> > > --- a/drivers/infiniband/core/cma.c
> > > +++ b/drivers/infiniband/core/cma.c
> > > @@ -465,6 +465,9 @@ static void _cma_attach_to_dev(struct
> > rdma_id_private *id_priv,
> > >  	id_priv->id.route.addr.dev_addr.transport =
> > >  		rdma_node_get_transport(cma_dev->device->node_type);
> > >  	list_add_tail(&id_priv->list, &cma_dev->id_list);
> > > +	id_priv->id.res.type = RDMA_RESTRACK_CM_ID;
> > > +	id_priv->id.res.kern_name = id_priv->id.caller;
> >
> > Steve, I don't like it, I worked hard to hide it from the users of
> restrack,
> > and don't see reason why the same trick as with ib_create_cq/ib_create_pd
> > won't
> > work here.
>
> I am doing the same trick, no?  rdma_create_id() is a static inline that
> passes KBUILD_MODNAME.  The issue is that at the time the rdma_cm_id is
> created, it is not associated with any ib_device.  That only happens at
> cma_attach time.  So how can the resource be added if there is no device?
>

So maybe, we don't need to add resource to the DB at rdma_create_id
stage and do it in cma_attach only, and in that stage you will update
the kern_name with KBUILD_MODNAME.

> >
> > > +	rdma_restrack_add(&id_priv->id.res);
> > >  }
> > >
> > >  static void cma_attach_to_dev(struct rdma_id_private *id_priv,
> > > @@ -737,10 +740,10 @@ static void cma_deref_id(struct rdma_id_private
> > *id_priv)
> > >  		complete(&id_priv->comp);
> > >  }
> > >
> > > -struct rdma_cm_id *rdma_create_id(struct net *net,
> > > -				  rdma_cm_event_handler event_handler,
> > > -				  void *context, enum rdma_port_space ps,
> > > -				  enum ib_qp_type qp_type)
> > > +struct rdma_cm_id *__rdma_create_id(struct net *net,
> > > +				    rdma_cm_event_handler event_handler,
> > > +				    void *context, enum rdma_port_space ps,
> > > +				    enum ib_qp_type qp_type, const char
> *caller)
> > >  {
> > >  	struct rdma_id_private *id_priv;
> > >
> > > @@ -748,7 +751,10 @@ struct rdma_cm_id *rdma_create_id(struct net *net,
> > >  	if (!id_priv)
> > >  		return ERR_PTR(-ENOMEM);
> > >
> > > -	id_priv->owner = task_pid_nr(current);
> > > +	if (caller)
> > > +		id_priv->id.caller = caller;
> > > +	else
> > > +		id_priv->owner = task_pid_nr(current);
> >
> > See the comment above
>
> There is no ib_device at this point, so caller (and owner) must be saved
> until the cm_id is bound to a device (or possibly devices for listening
> ids).

Why do we need previous owner? Can it be that rdma_create_id was
performed by one process and cma_attach by another?

>
> >
> > >  	id_priv->state = RDMA_CM_IDLE;
> > >  	id_priv->id.context = context;
> > >  	id_priv->id.event_handler = event_handler;
> >
> > Not saying that we need to do it now, but it is important to write, most
> > probably we can drop certain initialization from rdma_create_id() adn
> > reuse rdma_restrack_put/_get.
> >
>
> I don't understand this comment.  Can you please elaborate?

Most probably, we will be able to drop id_priv->qp_mutex in the future,
but let's not discuss it now, it is not related to this series.

>
> > > @@ -768,7 +774,7 @@ struct rdma_cm_id *rdma_create_id(struct net *net,
> > >
> > >  	return &id_priv->id;
> > >  }
> > > -EXPORT_SYMBOL(rdma_create_id);
> > > +EXPORT_SYMBOL(__rdma_create_id);
> > >
> > >  static int cma_init_ud_qp(struct rdma_id_private *id_priv, struct ib_qp
> *qp)
> > >  {
> > > @@ -1628,6 +1634,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
> > >  	mutex_unlock(&id_priv->handler_mutex);
> > >
> > >  	if (id_priv->cma_dev) {
> > > +		rdma_restrack_del(&id_priv->id.res);
> >
> > You should count all created cm_ids and not only binded.
>
> No ib_device if they aren't bound.
>
> >
> > >  		if (rdma_cap_ib_cm(id_priv->id.device, 1)) {
> > >  			if (id_priv->cm_id.ib)
> > >  				ib_destroy_cm_id(id_priv->cm_id.ib);
> > > @@ -1786,9 +1793,10 @@ static struct rdma_id_private
> > *cma_new_conn_id(struct rdma_cm_id *listen_id,
> > >  		ib_event->param.req_rcvd.primary_path->service_id;
> > >  	int ret;
> > >
> > > -	id = rdma_create_id(listen_id->route.addr.dev_addr.net,
> > > +	id = __rdma_create_id(listen_id->route.addr.dev_addr.net,
> > >  			    listen_id->event_handler, listen_id->context,
> > > -			    listen_id->ps,
> ib_event->param.req_rcvd.qp_type);
> > > +			    listen_id->ps, ib_event->param.req_rcvd.qp_type,
> > > +			    listen_id->caller);
> >
> > I think the cleanest way will be to create some struct and pass pointer to
> it so
> > you can unfold all relevant data inside of __rdma_create_id().
> >
>
> Why is that cleaner?  Marshall up the data into a struct, pass a ptr,
> unmarshall it all...

I counted 6 arguments, and for me, it smells like something wrong.

>
>
> > >  	if (IS_ERR(id))
> > >  		return NULL;
> > >
> > > @@ -1843,8 +1851,8 @@ static struct rdma_id_private
> > *cma_new_udp_id(struct rdma_cm_id *listen_id,
> > >  	struct net *net = listen_id->route.addr.dev_addr.net;
> > >  	int ret;
> > >
> > > -	id = rdma_create_id(net, listen_id->event_handler,
> listen_id->context,
> > > -			    listen_id->ps, IB_QPT_UD);
> > > +	id = __rdma_create_id(net, listen_id->event_handler, listen_id-
> > >context,
> > > +			      listen_id->ps, IB_QPT_UD, listen_id->caller);
> > >  	if (IS_ERR(id))
> > >  		return NULL;
> > >
> > > @@ -2110,10 +2118,11 @@ static int iw_conn_req_handler(struct iw_cm_id
> > *cm_id,
> > >  		goto out;
> > >
> > >  	/* Create a new RDMA id for the new IW CM ID */
> > > -	new_cm_id = rdma_create_id(listen_id->id.route.addr.dev_addr.net,
> > > -				   listen_id->id.event_handler,
> > > -				   listen_id->id.context,
> > > -				   RDMA_PS_TCP, IB_QPT_RC);
> > > +	new_cm_id = __rdma_create_id(listen_id->id.route.addr.dev_addr.net,
> > > +				     listen_id->id.event_handler,
> > > +				     listen_id->id.context,
> > > +				     RDMA_PS_TCP, IB_QPT_RC,
> > > +				     listen_id->id.caller);
> > >  	if (IS_ERR(new_cm_id)) {
> > >  		ret = -ENOMEM;
> > >  		goto out;
> > > @@ -2238,8 +2247,8 @@ static void cma_listen_on_dev(struct
> > rdma_id_private *id_priv,
> > >  	if (cma_family(id_priv) == AF_IB && !rdma_cap_ib_cm(cma_dev-
> > >device, 1))
> > >  		return;
> > >
> > > -	id = rdma_create_id(net, cma_listen_handler, id_priv,
> id_priv->id.ps,
> > > -			    id_priv->id.qp_type);
> > > +	id = __rdma_create_id(net, cma_listen_handler, id_priv,
> id_priv->id.ps,
> > > +			      id_priv->id.qp_type, id_priv->id.caller);
> > >  	if (IS_ERR(id))
> > >  		return;
> > >
> > > @@ -3347,8 +3356,10 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct
> > sockaddr *addr)
> > >
> > >  	return 0;
> > >  err2:
> > > -	if (id_priv->cma_dev)
> > > +	if (id_priv->cma_dev) {
> > > +		rdma_restrack_del(&id_priv->id.res);
> > >  		cma_release_dev(id_priv);
> > > +	}
> > >  err1:
> > >  	cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_IDLE);
> > >  	return ret;
> > > @@ -3731,14 +3742,18 @@ static int cma_send_sidr_rep(struct
> > rdma_id_private *id_priv,
> > >  	return ib_send_cm_sidr_rep(id_priv->cm_id.ib, &rep);
> > >  }
> > >
> > > -int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param
> > *conn_param)
> > > +int __rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param
> > *conn_param,
> > > +		  const char *caller)
> > >  {
> > >  	struct rdma_id_private *id_priv;
> > >  	int ret;
> > >
> > >  	id_priv = container_of(id, struct rdma_id_private, id);
> > >
> > > -	id_priv->owner = task_pid_nr(current);
> > > +	if (caller)
> > > +		id_priv->id.caller = caller;
> > > +	else
> > > +		id_priv->owner = task_pid_nr(current);
> > >
> > >  	if (!cma_comp(id_priv, RDMA_CM_CONNECT))
> > >  		return -EINVAL;
> > > @@ -3778,7 +3793,7 @@ int rdma_accept(struct rdma_cm_id *id, struct
> > rdma_conn_param *conn_param)
> > >  	rdma_reject(id, NULL, 0);
> > >  	return ret;
> > >  }
> > > -EXPORT_SYMBOL(rdma_accept);
> > > +EXPORT_SYMBOL(__rdma_accept);
> > >
> > >  int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event)
> > >  {
> > > diff --git a/drivers/infiniband/core/nldev.c
> b/drivers/infiniband/core/nldev.c
> > > index fa8655e..a4091b5 100644
> > > --- a/drivers/infiniband/core/nldev.c
> > > +++ b/drivers/infiniband/core/nldev.c
> > > @@ -34,6 +34,7 @@
> > >  #include <linux/pid.h>
> > >  #include <linux/pid_namespace.h>
> > >  #include <net/netlink.h>
> > > +#include <rdma/rdma_cm.h>
> > >  #include <rdma/rdma_netlink.h>
> > >
> > >  #include "core_priv.h"
> > > @@ -71,6 +72,22 @@
> > >  	[RDMA_NLDEV_ATTR_RES_PID]		= { .type = NLA_U32 },
> > >  	[RDMA_NLDEV_ATTR_RES_KERN_NAME]		= { .type =
> > NLA_NUL_STRING,
> > >  						    .len = TASK_COMM_LEN },
> > > +	[RDMA_NLDEV_ATTR_RES_CM_ID]		= { .type =
> > NLA_NESTED },
> >
> > I would like to use this opportunity. There is CM_ID, so users will be
> > able to query nldev directly on this ID (once we implement .doit), but
> > can we found a proper abstraction for other objects (PD, CQ, QP e.t.c.)?
> >
> > I want to have that all resources will have something similar to
> ifindex/ibindex.
> >
>
> Pds, cqs, and qps, all have  a device-unique number.  So
> ibindex/restrack_type/object_id should work.  But cm_id's don't have that.
> Similar to a socket I guess.  So I'm not sure how to identify cm_ids other
> than by the ipaddresses/ip ports.

It is opposite, cm_id is a unique number, but other objects don't have
such. What about PD and CQ?

We can declare that access to QP .doit willbe based on QPN, PD .doit
will be based on local_dma_lkey, but what will be CQ identifier?

Thanks

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp3IVEACgkQ5GN7iDZy
WKeVpw/+JVDybRSUuXiiqzbahlblf+yFRkCR5iWybKN5IY9Ry0yYlTccBVPbcZ6Y
f7rRPu1tJUDoGXTjANYcbknX1DC1jm02Omq3Lr06cehVFXs6D18xhEhtgDdrHvyB
ayFYpv0j9jfFOahzyP/a5OdeaR7un+2hPY8WhnjsFyqCODZL6zbTPd3ycxOfNExI
fn9rvYQyW7jLwZqf/VDGUK3kBDOd3gim/7n+IIKE0aIZF0EpKKgRR5lBhvdEynxi
TzbPjYqiek1bDSbDaiM+PI7ziEZWPYFpJ6DiCjvSm9/IGR1qMgCi0bVGJNV7lNLR
qwZlCYg1+VPSqf9FeFqOn2v8xe1lFV5pPlVT968zZ6idE3HEvlBdTfp6vRY772mp
5Yd30GZfeIRVkIauaADQqM/chNAdWTB+qi4ZwL8lTu3ZmTZdNatNHUfn3iMt3rPj
7idFoKP7INmW8kp4Mi2vi8cGphMUa4Tg+6JheC5pQr4wJxCx10Uu+pq0BjTCYKfL
qW2IYgsu9+fCwefN5nsStgs6rwKpgC+qSQEujtBcXxYrbGWqckkUPerltxK0zD/T
Tr8JPYwLRgRumjAdfa0zcyqNb4n8P9hR2Sw1N3dxbSzEJ2xk1KAnM55RUiH8Ohxl
iD1nf707T+8s63UUcLhPSccu4ibyWsTxuCqJrmTnpixpenvBWqg=
=qtYP
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
