From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/ipoib: fix dangling pointer references to
 ipoib_neigh and ipoib_path
Date: Mon, 29 Mar 2010 11:03:43 -0700
Message-ID: <1269885823.4192.173.camel@chromite.mv.qlogic.com>
References: <1267729108.3001.83.camel@chromite.mv.qlogic.com>
	 <20100328160211.GA19300@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100328160211.GA19300-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2010-03-28 at 09:02 -0700, Eli Cohen wrote:
> On Thu, Mar 04, 2010 at 10:58:27AM -0800, Ralph Campbell wrote:
> > Subject: [PATCH v3] IB/ipoib: fix dangling pointer references to ipoib_neigh and ipoib_path
> > 
> > When using connected mode, ipoib_cm_create_tx() kmallocs a
> > struct ipoib_cm_tx which contains pointers to ipoib_neigh and
> > ipoib_path. If the paths are flushed or the struct neighbour is
> > destroyed, the pointers held by struct ipoib_cm_tx can reference
> > freed memory.
> > 
> I could use some more content here as this is quite a large patch.
> Anyway below are some comments. I think besides reviewing this patch
> we need to make sure it has been checked in real life.

Do you mean more details about how ipoib_cm_tx can be used after
being freed or more about how the changes fix the problem?

I have been waiting for our internal regression tests to finish
and to collect review feedback before sending out the final version
of the patch.

> > +/*
> > + * Search the list of connections to be started and remove any entries
> > + * which match the path being destroyed.
> > + *
> > + * This should be called with netif_tx_lock_bh() and priv->lock held.
> > + */
> > +void ipoib_cm_flush_path(struct net_device *dev, struct ipoib_path *path)
> > +{
> > +	struct ipoib_dev_priv *priv = netdev_priv(dev);
> > +	struct ipoib_cm_tx *tx;
> > +
> > +	list_for_each_entry(tx, &priv->cm.start_list, list) {
> > +		tx = list_entry(priv->cm.start_list.next, typeof(*tx), list);
> > +		if (tx->path == path) {
> > +			tx->path = NULL;
> > +			list_del_init(&tx->list);
> > +			break;
> > +		}
> >  	}
> >  }
> 
> Looks to me like we may find struct ipoib_cm_tx objects hanging and
> not freed. This could happen if they were just added to start_list and
> removed by ipoib_cm_flush_path() before being processed by
> ipoib_cm_tx_start().

Quite right. I should also use list_for_each_entry_safe().
I will fix this.

> > -static int __path_add(struct net_device *dev, struct ipoib_path *path)
> > +static void __path_add(struct net_device *dev, struct ipoib_path *path)
> >  {
> >  	struct ipoib_dev_priv *priv = netdev_priv(dev);
> >  	struct rb_node **n = &priv->path_tree.rb_node;
> > @@ -249,44 +252,26 @@ static int __path_add(struct net_device *dev, struct ipoib_path *path)
> >  			n = &pn->rb_left;
> >  		else if (ret > 0)
> >  			n = &pn->rb_right;
> > -		else
> > -			return -EEXIST;
> > +		else /* Should never happen since we always search first */
> > +			return;
> >  	}
> 
> Why not remove the last else and change the "else if" into else?

I don't understand. This is left, right, or return.
I'm only changing the return value to void since it is
never used.

> >  	}
> > @@ -460,19 +446,13 @@ static void path_rec_completion(int status,
> >  			memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
> >  			       sizeof(union ib_gid));
> >  
> > -			if (ipoib_cm_enabled(dev, neigh->neighbour)) {
> > -				if (!ipoib_cm_get(neigh))
> > -					ipoib_cm_set(neigh, ipoib_cm_create_tx(dev,
> > -									       path,
> > -									       neigh));
> > -				if (!ipoib_cm_get(neigh)) {
> > -					list_del(&neigh->list);
> > -					if (neigh->ah)
> > -						ipoib_put_ah(neigh->ah);
> > -					ipoib_neigh_free(dev, neigh);
> > -					continue;
> > -				}
> > -			}
> ipoib_cm_set() is called only once in neigh_alloc(), setting neigh->cm
> to  NULL, and never again so all calls to ipoib_cm_get() will return
> NULL.

ipoib_cm_set() is only called once since I changed
ipoib_cm_create_tx() to initialize neigh->cm and return void.
To me, it is more clear to let ipoib_cm.c do as much of
the CM specific work as possible instead of defining two
versions of a function for when CM is compiled in or not.
I guess I could change neigh_alloc() to call kzmalloc()
and remove ipoib_cm_set().
Normally, I would define set/get pairs but ipoib_main.c
doesn't really need to use the pointer, just know that it
has been allocated and be able to pass it to ipoib_cm.c
I guess we could hide more of the details by just passing
neigh and letting the CM functions get the ipoib_cm_tx pointer.
It is all a matter of style so I'm OK with changing it back
to the original or making it a separate patch (probably wiser).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
