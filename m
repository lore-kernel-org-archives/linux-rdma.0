From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] RDMA/nes: Print hardware resource type
Date: Thu, 20 Sep 2012 16:08:04 -0500
Message-ID: <20120920210803.GA4540@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hardware resource types are added and when a resource isn't available, its type is printed. 

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.h       |   15 ++++++++++++---
 drivers/infiniband/hw/nes/nes_utils.c |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c |   14 +++++++-------
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index c438e46..48e4238 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -399,11 +399,20 @@ static inline void nes_write8(void __iomem *addr, u8 val)
 	writeb(val, addr);
 }
 
-
+typedef enum nes_resource_t {
+	NES_RESOURCE_MW = 1,
+	NES_RESOURCE_FAST_MR,
+	NES_RESOURCE_PHYS_MR,
+	NES_RESOURCE_USER_MR,
+	NES_RESOURCE_PD,
+	NES_RESOURCE_QP,
+	NES_RESOURCE_CQ,
+	NES_RESOURCE_ARP
+} nes_resource_t;
 
 static inline int nes_alloc_resource(struct nes_adapter *nesadapter,
 		unsigned long *resource_array, u32 max_resources,
-		u32 *req_resource_num, u32 *next)
+		u32 *req_resource_num, u32 *next, nes_resource_t resource_type)
 {
 	unsigned long flags;
 	u32 resource_num;
@@ -414,7 +423,7 @@ static inline int nes_alloc_resource(struct nes_adapter *nesadapter,
 	if (resource_num >= max_resources) {
 		resource_num = find_first_zero_bit(resource_array, max_resources);
 		if (resource_num >= max_resources) {
-			printk(KERN_ERR PFX "%s: No available resourcess.\n", __func__);
+			printk(KERN_ERR PFX "%s: No available resources [type=%u].\n", __func__, resource_type);
 			spin_unlock_irqrestore(&nesadapter->resource_lock, flags);
 			return -EMFILE;
 		}
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index e98f4fc..2042c0f 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -699,7 +699,7 @@ int nes_arp_table(struct nes_device *nesdev, u32 ip_addr, u8 *mac_addr, u32 acti
 
 		arp_index = 0;
 		err = nes_alloc_resource(nesadapter, nesadapter->allocated_arps,
-				nesadapter->arp_table_size, (u32 *)&arp_index, &nesadapter->next_arp_index);
+				nesadapter->arp_table_size, (u32 *)&arp_index, &nesadapter->next_arp_index, NES_RESOURCE_ARP);
 		if (err) {
 			nes_debug(NES_DBG_NETDEV, "nes_alloc_resource returned error = %u\n", err);
 			return err;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 8b8812d..1dadcf3 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -80,7 +80,7 @@ static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd) {
 	next_stag_index %= nesadapter->max_mr;
 
 	ret = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs,
-			nesadapter->max_mr, &stag_index, &next_stag_index);
+			nesadapter->max_mr, &stag_index, &next_stag_index, NES_RESOURCE_MW);
 	if (ret) {
 		return ERR_PTR(ret);
 	}
@@ -404,7 +404,7 @@ static struct ib_mr *nes_alloc_fast_reg_mr(struct ib_pd *ibpd, int max_page_list
 
 	err = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs,
 				 nesadapter->max_mr, &stag_index,
-				 &next_stag_index);
+				 &next_stag_index, NES_RESOURCE_FAST_MR);
 	if (err)
 		return ERR_PTR(err);
 
@@ -780,7 +780,7 @@ static struct ib_pd *nes_alloc_pd(struct ib_device *ibdev,
 			netdev_refcnt_read(nesvnic->netdev));
 
 	err = nes_alloc_resource(nesadapter, nesadapter->allocated_pds,
-			nesadapter->max_pd, &pd_num, &nesadapter->next_pd);
+			nesadapter->max_pd, &pd_num, &nesadapter->next_pd, NES_RESOURCE_PD);
 	if (err) {
 		return ERR_PTR(err);
 	}
@@ -1157,7 +1157,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 			nes_debug(NES_DBG_QP, "RQ size=%u, SQ Size=%u\n", rq_size, sq_size);
 
 			ret = nes_alloc_resource(nesadapter, nesadapter->allocated_qps,
-					nesadapter->max_qp, &qp_num, &nesadapter->next_qp);
+					nesadapter->max_qp, &qp_num, &nesadapter->next_qp, NES_RESOURCE_QP);
 			if (ret) {
 				return ERR_PTR(ret);
 			}
@@ -1546,7 +1546,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 		return ERR_PTR(-EINVAL);
 
 	err = nes_alloc_resource(nesadapter, nesadapter->allocated_cqs,
-			nesadapter->max_cq, &cq_num, &nesadapter->next_cq);
+			nesadapter->max_cq, &cq_num, &nesadapter->next_cq, NES_RESOURCE_CQ);
 	if (err) {
 		return ERR_PTR(err);
 	}
@@ -2129,7 +2129,7 @@ static struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
 		return ERR_PTR(-EINVAL);
 
 	err = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs, nesadapter->max_mr,
-			&stag_index, &next_stag_index);
+			&stag_index, &next_stag_index, NES_RESOURCE_PHYS_MR);
 	if (err) {
 		return ERR_PTR(err);
 	}
@@ -2360,7 +2360,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			next_stag_index %= nesadapter->max_mr;
 
 			err = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs,
-					nesadapter->max_mr, &stag_index, &next_stag_index);
+					nesadapter->max_mr, &stag_index, &next_stag_index, NES_RESOURCE_USER_MR);
 			if (err) {
 				ib_umem_release(region);
 				return ERR_PTR(err);
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
