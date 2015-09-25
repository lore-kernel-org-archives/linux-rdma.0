From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Fri, 25 Sep 2015 18:32:43 +0300
Message-ID: <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
	<alpine.DEB.2.11.1509170940270.2052@east.gentwo.org>
	<CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com>
	<alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1509241158420.21198-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 24, 2015 at 8:00 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> Ok here is the fixed up and tested V2 of the patch. Can this go in with
> Doug's  patch?


Repeating myself... do you find some over complexity in Erez's
implementation? what's the rational for not using his patch and yes
using yours? Erez and Co were very busy with some internal deadlines
and he's now OOO (it's a high Holiday season now) - will be able to
review your patch once he's back (Oct 6, I believe). It seems that the
patch does the job, but there are locking/contexts and such to
consider here, so I can't just ack it, have you passed it through
testing?

Or.


> Subject: ipoib: Expire sendonly multicast joins on neighbor expiration V2
>
> Add mcast_leave functionality to __ipoib_reap_neighbor.
>
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>
> Index: linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
> ===================================================================
> --- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_main.c        2015-09-23 09:51:19.259274231 -0500
> +++ linux/drivers/infiniband/ulp/ipoib/ipoib_main.c     2015-09-23 09:59:59.803289023 -0500
> @@ -1149,6 +1149,9 @@
>         unsigned long dt;
>         unsigned long flags;
>         int i;
> +       LIST_HEAD(remove_list);
> +       struct ipoib_mcast *mcast, *tmcast;
> +       struct net_device *dev = priv->dev;
>
>         if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
>                 return;
> @@ -1176,6 +1179,19 @@
>                                                           lockdep_is_held(&priv->lock))) != NULL) {
>                         /* was the neigh idle for two GC periods */
>                         if (time_after(neigh_obsolete, neigh->alive)) {
> +                               u8 *mgid = neigh->daddr + 4;
> +
> +                               /* Is this multicast ? */
> +                               if (*mgid == 0xff) {
> +                                       mcast = __ipoib_mcast_find(dev, mgid);
> +
> +                                       if (mcast && test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)) {
> +                                               list_del(&mcast->list);
> +                                               rb_erase(&mcast->rb_node, &priv->multicast_tree);
> +                                               list_add_tail(&mcast->list, &remove_list);
> +                                       }
> +                               }
> +
>                                 rcu_assign_pointer(*np,
>                                                    rcu_dereference_protected(neigh->hnext,
>                                                                              lockdep_is_held(&priv->lock)));
> @@ -1191,6 +1207,8 @@
>
>  out_unlock:
>         spin_unlock_irqrestore(&priv->lock, flags);
> +       list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
> +               ipoib_mcast_leave(dev, mcast);
>  }
>
>  static void ipoib_reap_neigh(struct work_struct *work)
> Index: linux/drivers/infiniband/ulp/ipoib/ipoib.h
> ===================================================================
> --- linux.orig/drivers/infiniband/ulp/ipoib/ipoib.h     2015-09-23 09:51:19.259274231 -0500
> +++ linux/drivers/infiniband/ulp/ipoib/ipoib.h  2015-09-23 09:51:19.255274231 -0500
> @@ -548,6 +548,8 @@
>
>  int ipoib_mcast_attach(struct net_device *dev, u16 mlid,
>                        union ib_gid *mgid, int set_qkey);
> +int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast);
> +struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid);
>
>  int ipoib_init_qp(struct net_device *dev);
>  int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca);
> Index: linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> ===================================================================
> --- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_multicast.c   2015-09-23 09:51:19.259274231 -0500
> +++ linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c        2015-09-23 09:51:19.255274231 -0500
> @@ -158,7 +158,7 @@
>         return mcast;
>  }
>
> -static struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid)
> +struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid)
>  {
>         struct ipoib_dev_priv *priv = netdev_priv(dev);
>         struct rb_node *n = priv->multicast_tree.rb_node;
> @@ -705,7 +705,7 @@
>         return 0;
>  }
>
> -static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
> +int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
>  {
>         struct ipoib_dev_priv *priv = netdev_priv(dev);
>         int ret = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
