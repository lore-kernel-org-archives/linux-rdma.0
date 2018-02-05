From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Mon, 5 Feb 2018 09:33:07 -0600
Message-ID: <015301d39e96$9f5e0b60$de1a2220$@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com> <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com> <20180201084944.GH2055@mtr-leonro.local> <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com> <20180204150553.GH27780@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180204150553.GH27780-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Leon,

> On Thu, Feb 01, 2018 at 10:07:20AM -0600, Steve Wise wrote:
> >
> > >
> > > On Tue, Jan 30, 2018 at 08:59:11AM -0800, Steve Wise wrote:
> > > > Implement RDMA nldev netlink interface to get detailed CM_ID
> > information.
> > > >
> > > > Because cm_id's are attached to rdma devices in various work queue
> > contexts,
> > > > the pid and task information at device-attach time is sometimes not
> > useful.
> > > > For example, an nvme/f host connection ends up being bound to a
device
> > > > in a work queue context and the resulting pid at attach time no
longer
> > exists
> > > > after connection setup.  So instead we mark all cm_id's created via
the
> > > > rdma_ucm as "user", and all others as "kernel".  This required
tweaking
> > > > the restrack code a little.  It also required wrapping some rdma_cm
> > > > functions to allow passing the module name string.
> > > >
> > > > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/core/cma.c      |  55 ++++++---
> > > >  drivers/infiniband/core/nldev.c    | 245
> > > +++++++++++++++++++++++++++++++++++++
> > > >  drivers/infiniband/core/restrack.c |  29 ++++-
> > > >  drivers/infiniband/core/ucma.c     |   8 +-
> > > >  include/rdma/rdma_cm.h             |  24 +++-
> > > >  include/rdma/restrack.h            |   4 +
> > > >  include/uapi/rdma/rdma_netlink.h   |  30 +++++
> > > >  7 files changed, 365 insertions(+), 30 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/core/cma.c
> > b/drivers/infiniband/core/cma.c
> > > > index 72ad52b..51fbfa1 100644
> > > > --- a/drivers/infiniband/core/cma.c
> > > > +++ b/drivers/infiniband/core/cma.c
> > > > @@ -465,6 +465,9 @@ static void _cma_attach_to_dev(struct
> > > rdma_id_private *id_priv,
> > > >  	id_priv->id.route.addr.dev_addr.transport =
> > > >  		rdma_node_get_transport(cma_dev->device->node_type);
> > > >  	list_add_tail(&id_priv->list, &cma_dev->id_list);
> > > > +	id_priv->id.res.type = RDMA_RESTRACK_CM_ID;
> > > > +	id_priv->id.res.kern_name = id_priv->id.caller;
> > >
> > > Steve, I don't like it, I worked hard to hide it from the users of
> > restrack,
> > > and don't see reason why the same trick as with
ib_create_cq/ib_create_pd
> > > won't
> > > work here.
> >
> > I am doing the same trick, no?  rdma_create_id() is a static inline that
> > passes KBUILD_MODNAME.  The issue is that at the time the rdma_cm_id is
> > created, it is not associated with any ib_device.  That only happens at
> > cma_attach time.  So how can the resource be added if there is no
device?
> >
> 
> So maybe, we don't need to add resource to the DB at rdma_create_id
> stage and do it in cma_attach only, and in that stage you will update
> the kern_name with KBUILD_MODNAME.

Yea, I'll look into this. 

> 
> > >
> > > > +	rdma_restrack_add(&id_priv->id.res);
> > > >  }
> > > >
> > > >  static void cma_attach_to_dev(struct rdma_id_private *id_priv,
> > > > @@ -737,10 +740,10 @@ static void cma_deref_id(struct
rdma_id_private
> > > *id_priv)
> > > >  		complete(&id_priv->comp);
> > > >  }
> > > >
> > > > -struct rdma_cm_id *rdma_create_id(struct net *net,
> > > > -				  rdma_cm_event_handler
event_handler,
> > > > -				  void *context, enum
rdma_port_space ps,
> > > > -				  enum ib_qp_type qp_type)
> > > > +struct rdma_cm_id *__rdma_create_id(struct net *net,
> > > > +				    rdma_cm_event_handler
event_handler,
> > > > +				    void *context, enum
rdma_port_space ps,
> > > > +				    enum ib_qp_type qp_type, const
char
> > *caller)
> > > >  {
> > > >  	struct rdma_id_private *id_priv;
> > > >
> > > > @@ -748,7 +751,10 @@ struct rdma_cm_id *rdma_create_id(struct net
> *net,
> > > >  	if (!id_priv)
> > > >  		return ERR_PTR(-ENOMEM);
> > > >
> > > > -	id_priv->owner = task_pid_nr(current);
> > > > +	if (caller)
> > > > +		id_priv->id.caller = caller;
> > > > +	else
> > > > +		id_priv->owner = task_pid_nr(current);
> > >
> > > See the comment above
> >
> > There is no ib_device at this point, so caller (and owner) must be saved
> > until the cm_id is bound to a device (or possibly devices for listening
> > ids).
> 
> Why do we need previous owner? Can it be that rdma_create_id was
> performed by one process and cma_attach by another?

Yes.  Connection setup events are processed on rdma_cm (and ib_cm/iw_cm)
workqueue threads.   Here's one example:  The application creates a cm_id,
binds to 0.0.0.0/0 and listens.  But there are no rdma devices at this
point.  There is a cm_id owned by the application, but not bound to any
device.  Then, lets say mlx4 and cxgb4 both get inserted.  The rdma_cm will
discover the new rdma devices, create and attach child cm_ids to those
devices.  This is done in a workq thread driven off of the ib_client
device_add upcall.  So what we really want to show is that these per-device
cm_ids are owned by the same application. 

There are other cases, that I've seen with just nvme/f host.   I'll produce
more examples to help us understand if there is a better path than what I've
proposed in this patch.

> 
> >
> > >
> > > >  	id_priv->state = RDMA_CM_IDLE;
> > > >  	id_priv->id.context = context;
> > > >  	id_priv->id.event_handler = event_handler;
> > >
> > > Not saying that we need to do it now, but it is important to write,
most
> > > probably we can drop certain initialization from rdma_create_id() adn
> > > reuse rdma_restrack_put/_get.
> > >
> >
> > I don't understand this comment.  Can you please elaborate?
> 
> Most probably, we will be able to drop id_priv->qp_mutex in the future,
> but let's not discuss it now, it is not related to this series.
> 
> >
> > > > @@ -768,7 +774,7 @@ struct rdma_cm_id *rdma_create_id(struct net
> *net,
> > > >
> > > >  	return &id_priv->id;
> > > >  }
> > > > -EXPORT_SYMBOL(rdma_create_id);
> > > > +EXPORT_SYMBOL(__rdma_create_id);
> > > >
> > > >  static int cma_init_ud_qp(struct rdma_id_private *id_priv, struct
ib_qp
> > *qp)
> > > >  {
> > > > @@ -1628,6 +1634,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
> > > >  	mutex_unlock(&id_priv->handler_mutex);
> > > >
> > > >  	if (id_priv->cma_dev) {
> > > > +		rdma_restrack_del(&id_priv->id.res);
> > >
> > > You should count all created cm_ids and not only binded.
> >
> > No ib_device if they aren't bound.
> >
> > >
> > > >  		if (rdma_cap_ib_cm(id_priv->id.device, 1)) {
> > > >  			if (id_priv->cm_id.ib)
> > > >  				ib_destroy_cm_id(id_priv->cm_id.ib);
> > > > @@ -1786,9 +1793,10 @@ static struct rdma_id_private
> > > *cma_new_conn_id(struct rdma_cm_id *listen_id,
> > > >  		ib_event->param.req_rcvd.primary_path->service_id;
> > > >  	int ret;
> > > >
> > > > -	id = rdma_create_id(listen_id->route.addr.dev_addr.net,
> > > > +	id = __rdma_create_id(listen_id->route.addr.dev_addr.net,
> > > >  			    listen_id->event_handler,
listen_id->context,
> > > > -			    listen_id->ps,
> > ib_event->param.req_rcvd.qp_type);
> > > > +			    listen_id->ps,
ib_event->param.req_rcvd.qp_type,
> > > > +			    listen_id->caller);
> > >
> > > I think the cleanest way will be to create some struct and pass
pointer to
> > it so
> > > you can unfold all relevant data inside of __rdma_create_id().
> > >
> >
> > Why is that cleaner?  Marshall up the data into a struct, pass a ptr,
> > unmarshall it all...
> 
> I counted 6 arguments, and for me, it smells like something wrong.
> 

I'll look into changing this. 

> >
> >
> > > >  	if (IS_ERR(id))
> > > >  		return NULL;
> > > >
> > > > @@ -1843,8 +1851,8 @@ static struct rdma_id_private
> > > *cma_new_udp_id(struct rdma_cm_id *listen_id,
> > > >  	struct net *net = listen_id->route.addr.dev_addr.net;
> > > >  	int ret;
> > > >
> > > > -	id = rdma_create_id(net, listen_id->event_handler,
> > listen_id->context,
> > > > -			    listen_id->ps, IB_QPT_UD);
> > > > +	id = __rdma_create_id(net, listen_id->event_handler,
listen_id-
> > > >context,
> > > > +			      listen_id->ps, IB_QPT_UD,
listen_id->caller);
> > > >  	if (IS_ERR(id))
> > > >  		return NULL;
> > > >
> > > > @@ -2110,10 +2118,11 @@ static int iw_conn_req_handler(struct
> iw_cm_id
> > > *cm_id,
> > > >  		goto out;
> > > >
> > > >  	/* Create a new RDMA id for the new IW CM ID */
> > > > -	new_cm_id =
rdma_create_id(listen_id->id.route.addr.dev_addr.net,
> > > > -				   listen_id->id.event_handler,
> > > > -				   listen_id->id.context,
> > > > -				   RDMA_PS_TCP, IB_QPT_RC);
> > > > +	new_cm_id =
__rdma_create_id(listen_id->id.route.addr.dev_addr.net,
> > > > +				     listen_id->id.event_handler,
> > > > +				     listen_id->id.context,
> > > > +				     RDMA_PS_TCP, IB_QPT_RC,
> > > > +				     listen_id->id.caller);
> > > >  	if (IS_ERR(new_cm_id)) {
> > > >  		ret = -ENOMEM;
> > > >  		goto out;
> > > > @@ -2238,8 +2247,8 @@ static void cma_listen_on_dev(struct
> > > rdma_id_private *id_priv,
> > > >  	if (cma_family(id_priv) == AF_IB && !rdma_cap_ib_cm(cma_dev-
> > > >device, 1))
> > > >  		return;
> > > >
> > > > -	id = rdma_create_id(net, cma_listen_handler, id_priv,
> > id_priv->id.ps,
> > > > -			    id_priv->id.qp_type);
> > > > +	id = __rdma_create_id(net, cma_listen_handler, id_priv,
> > id_priv->id.ps,
> > > > +			      id_priv->id.qp_type,
id_priv->id.caller);
> > > >  	if (IS_ERR(id))
> > > >  		return;
> > > >
> > > > @@ -3347,8 +3356,10 @@ int rdma_bind_addr(struct rdma_cm_id *id,
> struct
> > > sockaddr *addr)
> > > >
> > > >  	return 0;
> > > >  err2:
> > > > -	if (id_priv->cma_dev)
> > > > +	if (id_priv->cma_dev) {
> > > > +		rdma_restrack_del(&id_priv->id.res);
> > > >  		cma_release_dev(id_priv);
> > > > +	}
> > > >  err1:
> > > >  	cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_IDLE);
> > > >  	return ret;
> > > > @@ -3731,14 +3742,18 @@ static int cma_send_sidr_rep(struct
> > > rdma_id_private *id_priv,
> > > >  	return ib_send_cm_sidr_rep(id_priv->cm_id.ib, &rep);
> > > >  }
> > > >
> > > > -int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param
> > > *conn_param)
> > > > +int __rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param
> > > *conn_param,
> > > > +		  const char *caller)
> > > >  {
> > > >  	struct rdma_id_private *id_priv;
> > > >  	int ret;
> > > >
> > > >  	id_priv = container_of(id, struct rdma_id_private, id);
> > > >
> > > > -	id_priv->owner = task_pid_nr(current);
> > > > +	if (caller)
> > > > +		id_priv->id.caller = caller;
> > > > +	else
> > > > +		id_priv->owner = task_pid_nr(current);
> > > >
> > > >  	if (!cma_comp(id_priv, RDMA_CM_CONNECT))
> > > >  		return -EINVAL;
> > > > @@ -3778,7 +3793,7 @@ int rdma_accept(struct rdma_cm_id *id, struct
> > > rdma_conn_param *conn_param)
> > > >  	rdma_reject(id, NULL, 0);
> > > >  	return ret;
> > > >  }
> > > > -EXPORT_SYMBOL(rdma_accept);
> > > > +EXPORT_SYMBOL(__rdma_accept);
> > > >
> > > >  int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event)
> > > >  {
> > > > diff --git a/drivers/infiniband/core/nldev.c
> > b/drivers/infiniband/core/nldev.c
> > > > index fa8655e..a4091b5 100644
> > > > --- a/drivers/infiniband/core/nldev.c
> > > > +++ b/drivers/infiniband/core/nldev.c
> > > > @@ -34,6 +34,7 @@
> > > >  #include <linux/pid.h>
> > > >  #include <linux/pid_namespace.h>
> > > >  #include <net/netlink.h>
> > > > +#include <rdma/rdma_cm.h>
> > > >  #include <rdma/rdma_netlink.h>
> > > >
> > > >  #include "core_priv.h"
> > > > @@ -71,6 +72,22 @@
> > > >  	[RDMA_NLDEV_ATTR_RES_PID]		= { .type = NLA_U32
},
> > > >  	[RDMA_NLDEV_ATTR_RES_KERN_NAME]		= { .type =
> > > NLA_NUL_STRING,
> > > >  						    .len =
TASK_COMM_LEN },
> > > > +	[RDMA_NLDEV_ATTR_RES_CM_ID]		= { .type =
> > > NLA_NESTED },
> > >
> > > I would like to use this opportunity. There is CM_ID, so users will be
> > > able to query nldev directly on this ID (once we implement .doit), but
> > > can we found a proper abstraction for other objects (PD, CQ, QP
e.t.c.)?
> > >
> > > I want to have that all resources will have something similar to
> > ifindex/ibindex.
> > >
> >
> > Pds, cqs, and qps, all have  a device-unique number.  So
> > ibindex/restrack_type/object_id should work.  But cm_id's don't have
that.
> > Similar to a socket I guess.  So I'm not sure how to identify cm_ids
other
> > than by the ipaddresses/ip ports.
> 
> It is opposite, cm_id is a unique number, but other objects don't have
> such. What about PD and CQ?
> 
> We can declare that access to QP .doit willbe based on QPN, PD .doit
> will be based on local_dma_lkey, but what will be CQ identifier?
> 

Now that I've thought about this more, I realize the core verbs data
structures don't have identifiers for most objects.  I'm not sure why the
qp_num is exposed, but I guess it is because the qp num values must be
exchanged between both ends of an IB connection to setup the connection.    

The  local_dma_lkey  value will not be unique for each PD.  For all iwarp
devices the local_dma_lkey is 0.  (I think the same is true for IB devices).
So PD has the same issue as CQ.   

I suppose we can use rkey for MRs, but if the MR is not in the VALID state,
the rkey isn't necessarily accurate (the LSB of the rkey can be changed by
the application with each REG_MR operation).

The cm_id doesn't have any unique identifier either, except maybe the
combination of src/dst addresses and port space. 

With iw_cxgb4, CQs, PDs, and MRs all have a unique identifier just like a QP
does.  I expect all hw implementations of rdma have numeric identifiers for
CQs, PDs, QPs, etc.    They aren't exposed to the core API though.  

Perhaps we add a device-unique (or globally unique) identifier as part of
the restrack struct and use that for GET/SET?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
