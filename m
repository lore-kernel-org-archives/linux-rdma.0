From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Seeing WARN_ON in ib_dealloc_pd from ipoib in kernel
 4.3-rc1-debug
Date: Sun, 11 Oct 2015 18:49:42 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1510111848560.10812@east.gentwo.org>
References: <56153F71.2010801@dev.mellanox.co.il> <5615442D.2020007@redhat.com> <561A8591.4020608@dev.mellanox.co.il>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561A8591.4020608-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 11 Oct 2015, Sagi Grimberg wrote:

> Is someone looking at this? It really should be fixed before 4.3
> final...

The following fixup patch is needed:



Subject: ipoib: For sendonly join free the multicast group on leave

When we leave the multicast group on expiration of a neighbor we
do not free the mcast structure. This results in a memory leak.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/ulp/ipoib/ipoib.h
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib.h
+++ linux/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -495,6 +495,7 @@ void ipoib_dev_cleanup(struct net_device
 void ipoib_mcast_join_task(struct work_struct *work);
 void ipoib_mcast_carrier_on_task(struct work_struct *work);
 void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb);
+void ipoib_mcast_free(struct ipoib_mcast *mc);

 void ipoib_mcast_restart_task(struct work_struct *work);
 int ipoib_mcast_start_thread(struct net_device *dev);
Index: linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1207,8 +1207,10 @@ static void __ipoib_reap_neigh(struct ip

 out_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
-	list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
+	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
 		ipoib_mcast_leave(dev, mcast);
+		ipoib_mcast_free(mcast);
+	}
 }

 static void ipoib_reap_neigh(struct work_struct *work)
Index: linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -106,7 +106,7 @@ static void __ipoib_mcast_schedule_join_
 		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
 }

-static void ipoib_mcast_free(struct ipoib_mcast *mcast)
+void ipoib_mcast_free(struct ipoib_mcast *mcast)
 {
 	struct net_device *dev = mcast->dev;
 	int tx_dropped = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
