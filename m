From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Mon, 5 Feb 2018 11:12:06 -0600
Message-ID: <01c601d39ea4$7311fc20$5935f460$@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com> <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com> <20180201084944.GH2055@mtr-leonro.local> <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com> <20180204150553.GH27780@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Hey Leon,
> 

...

> > > > > diff --git a/drivers/infiniband/core/cma.c
> > > b/drivers/infiniband/core/cma.c
> > > > > index 72ad52b..51fbfa1 100644
> > > > > --- a/drivers/infiniband/core/cma.c
> > > > > +++ b/drivers/infiniband/core/cma.c
> > > > > @@ -465,6 +465,9 @@ static void _cma_attach_to_dev(struct
> > > > rdma_id_private *id_priv,
> > > > >  	id_priv->id.route.addr.dev_addr.transport =
> > > > >  		rdma_node_get_transport(cma_dev->device->node_type);
> > > > >  	list_add_tail(&id_priv->list, &cma_dev->id_list);
> > > > > +	id_priv->id.res.type = RDMA_RESTRACK_CM_ID;
> > > > > +	id_priv->id.res.kern_name = id_priv->id.caller;
> > > >
> > > > Steve, I don't like it, I worked hard to hide it from the users of
> > > restrack,
> > > > and don't see reason why the same trick as with
> ib_create_cq/ib_create_pd
> > > > won't
> > > > work here.
> > >
> > > I am doing the same trick, no?  rdma_create_id() is a static inline
that
> > > passes KBUILD_MODNAME.  The issue is that at the time the rdma_cm_id
is
> > > created, it is not associated with any ib_device.  That only happens
at
> > > cma_attach time.  So how can the resource be added if there is no
device?
> > >
> >
> > So maybe, we don't need to add resource to the DB at rdma_create_id
> > stage and do it in cma_attach only, and in that stage you will update
> > the kern_name with KBUILD_MODNAME.
> 
> Yea, I'll look into this.

The current patch is only adding the resource in _cma_attach_to_dev().  And
using KBUILD_MODNAME in _cma_attach_to_dev() would always end up with
"[rdma_cm]".   That's why the caller string is saved in rdma_create_id()
static inline function; so it will get the true module name.  

I don't see any change needed here.

Thanks,

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
