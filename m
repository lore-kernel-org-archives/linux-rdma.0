From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] ipoib mcast sendonly join: Move multicast specific
 code out of ipoib_main.c.
Date: Mon, 14 Dec 2015 10:24:07 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512141023380.26779@east.gentwo.org>
References: <20151211181652.187735744@linux.com> <20151211181724.290844844@linux.com> <20151211232143.GC7855@phlsvsds.ph.intel.com> <alpine.DEB.2.20.1512141000470.25235@east.gentwo.org>
 <2807E5FD2F6FDA4886F6618EAC48510E1CC1C353@CRSMSX101.amr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1CC1C353-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 14 Dec 2015, Weiny, Ira wrote:

> > How about
> >=20
> > 		ipoib_check_and_add_mcast_sendonly()
>
> Better.

Fixup patch:


Subject: ipoib: Fix up naming of ipoib_check_and_add_mcast_sendonly

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/ulp/ipoib/ipoib.h
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib.h
+++ linux/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -549,7 +549,7 @@ void ipoib_path_iter_read(struct ipoib_p
 int ipoib_mcast_attach(struct net_device *dev, u16 mlid,
 		       union ib_gid *mgid, int set_qkey);
 void ipoib_mcast_remove_list(struct net_device *dev, struct list_head *remove_list);
-void ipoib_check_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
+void ipoib_check_and_add_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
 				struct list_head *remove_list);

 int ipoib_init_qp(struct net_device *dev);
Index: linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1179,7 +1179,7 @@ static void __ipoib_reap_neigh(struct ip
 			/* was the neigh idle for two GC periods */
 			if (time_after(neigh_obsolete, neigh->alive)) {

-				ipoib_check_mcast_sendonly(priv, neigh->daddr + 4, &remove_list);
+				ipoib_check_and_add_mcast_sendonly(priv, neigh->daddr + 4, &remove_list);

 				rcu_assign_pointer(*np,
 						   rcu_dereference_protected(neigh->hnext,
Index: linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -708,7 +708,7 @@ static int ipoib_mcast_leave(struct net_
  * Check if the multicast group is sendonly. If so remove it from the maps
  * and add to the remove list
  */
-void ipoib_check_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
+void ipoib_check_and_add_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
 				struct list_head *remove_list)
 {
 	/* Is this multicast ? */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
