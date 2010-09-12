From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: RDS/IB: add _to_node() macros for numa and use {k,v}malloc_node()
Date: Sun, 12 Sep 2010 10:52:08 +0200
Message-ID: <4C8C94B8.9030107@Voltaire.com>
References: <4C892C9C.4060304@oracle.com> <4C8C9422.2070306@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C8C9422.2070306-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Andy, looking on this net-next-2.6 patch, I wonder if you can elaborate on your "significantly helps performance" comment - what improvement you see with this patch? 

What about the QP/CQ memory, are they better be placed in node-local to the HCA manner?

Or.

commit e4c52c98e04937ea87b0979a81354d0040d284f9
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Fri Apr 23 10:49:53 2010 -0700

    RDS/IB: add _to_node() macros for numa and use {k,v}malloc_node()
    
    Allocate send/recv rings in memory that is node-local to the HCA.
    This significantly helps performance.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 7a2131d..7d289d7 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -77,7 +77,7 @@ void rds_ib_add_one(struct ib_device *device)
 		goto free_attr;
 	}
 
-	rds_ibdev = kmalloc(sizeof *rds_ibdev, GFP_KERNEL);
+	rds_ibdev = kmalloc_node(sizeof *rds_ibdev, GFP_KERNEL, ibdev_to_node(device));
 	if (!rds_ibdev)
 		goto free_attr;
 
diff --git a/net/rds/ib.h b/net/rds/ib.h
index c506604..4bc3e2f 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -3,6 +3,8 @@
 
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
 #include "rds.h"
 #include "rdma_transport.h"
 
@@ -167,6 +169,10 @@ struct rds_ib_device {
 	spinlock_t		spinlock;	/* protect the above */
 };
 
+#define pcidev_to_node(pcidev) pcibus_to_node(pcidev->bus)
+#define ibdev_to_node(ibdev) pcidev_to_node(to_pci_dev(ibdev->dma_device))
+#define rdsibdev_to_node(rdsibdev) ibdev_to_node(rdsibdev->dev)
+
 /* bits for i_ack_flags */
 #define IB_ACK_IN_FLIGHT	0
 #define IB_ACK_REQUESTED	1
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 75eda9c..b5d0b60 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -347,7 +347,8 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		goto out;
 	}
 
-	ic->i_sends = vmalloc(ic->i_send_ring.w_nr * sizeof(struct rds_ib_send_work));
+	ic->i_sends = vmalloc_node(ic->i_send_ring.w_nr * sizeof(struct rds_ib_send_work),
+				   ibdev_to_node(dev));
 	if (!ic->i_sends) {
 		ret = -ENOMEM;
 		rdsdebug("send allocation failed\n");
@@ -355,7 +356,8 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	}
 	memset(ic->i_sends, 0, ic->i_send_ring.w_nr * sizeof(struct rds_ib_send_work));
 
-	ic->i_recvs = vmalloc(ic->i_recv_ring.w_nr * sizeof(struct rds_ib_recv_work));
+	ic->i_recvs = vmalloc_node(ic->i_recv_ring.w_nr * sizeof(struct rds_ib_recv_work),
+				   ibdev_to_node(dev));
 	if (!ic->i_recvs) {
 		ret = -ENOMEM;
 		rdsdebug("recv allocation failed\n");
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 7315fff..cc341cd 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -297,7 +297,7 @@ static struct rds_ib_mr *rds_ib_alloc_fmr(struct rds_ib_device *rds_ibdev)
 		rds_ib_flush_mr_pool(pool, 0);
 	}
 
-	ibmr = kzalloc(sizeof(*ibmr), GFP_KERNEL);
+	ibmr = kzalloc_node(sizeof(*ibmr), GFP_KERNEL, rdsibdev_to_node(rds_ibdev));
 	if (!ibmr) {
 		err = -ENOMEM;
 		goto out_no_cigar;
@@ -376,7 +376,8 @@ static int rds_ib_map_fmr(struct rds_ib_device *rds_ibdev, struct rds_ib_mr *ibm
 	if (page_cnt > fmr_message_size)
 		return -EINVAL;
 
-	dma_pages = kmalloc(sizeof(u64) * page_cnt, GFP_ATOMIC);
+	dma_pages = kmalloc_node(sizeof(u64) * page_cnt, GFP_ATOMIC,
+				 rdsibdev_to_node(rds_ibdev));
 	if (!dma_pages)
 		return -ENOMEM;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
