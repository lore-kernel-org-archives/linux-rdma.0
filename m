From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Change lkey table allocation to support more MRs
Date: Tue, 21 Jul 2015 08:36:07 -0400
Message-ID: <20150721123607.22112.55950.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The lkey table is allocated with with a get_user_pages() with an
order based on a number of index bits from a module parameter.

The underlying kernel code cannot allocate that many contiguous pages.

There is no reason the underlying memory needs to be physically
contiguous.

This patch:
- switches the allocation/deallocation to vmalloc/vfree
- caps the number of bits to 23 to insure at least 1 generation bit
  o this matches the module parameter description

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_keys.c  |    4 ++++
 drivers/infiniband/hw/qib/qib_verbs.c |   14 ++++++++++----
 drivers/infiniband/hw/qib/qib_verbs.h |    2 ++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index ad843c7..5afaa21 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -86,6 +86,10 @@ int qib_alloc_lkey(struct qib_mregion *mr, int dma_region)
 	 * unrestricted LKEY.
 	 */
 	rkt->gen++;
+	/*
+	 * bits are capped in qib_verbs.c to insure enough bits
+	 * for generation number
+	 */
 	mr->lkey = (r << (32 - ib_qib_lkey_table_size)) |
 		((((1 << (24 - ib_qib_lkey_table_size)) - 1) & rkt->gen)
 		 << 8);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index a05d1a3..77e981a 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -40,6 +40,7 @@
 #include <linux/rculist.h>
 #include <linux/mm.h>
 #include <linux/random.h>
+#include <linux/vmalloc.h>
 
 #include "qib.h"
 #include "qib_common.h"
@@ -2109,10 +2110,16 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	 * the LKEY).  The remaining bits act as a generation number or tag.
 	 */
 	spin_lock_init(&dev->lk_table.lock);
+	/* insure generation is at least 4 bits see keys.c */
+	if (ib_qib_lkey_table_size > MAX_LKEY_TABLE_BITS) {
+		qib_dev_warn(dd, "lkey bits %u too large, reduced to %u\n",
+			ib_qib_lkey_table_size, MAX_LKEY_TABLE_BITS);
+		ib_qib_lkey_table_size = MAX_LKEY_TABLE_BITS;
+	}
 	dev->lk_table.max = 1 << ib_qib_lkey_table_size;
 	lk_tab_size = dev->lk_table.max * sizeof(*dev->lk_table.table);
 	dev->lk_table.table = (struct qib_mregion __rcu **)
-		__get_free_pages(GFP_KERNEL, get_order(lk_tab_size));
+		vmalloc(lk_tab_size);
 	if (dev->lk_table.table == NULL) {
 		ret = -ENOMEM;
 		goto err_lk;
@@ -2286,7 +2293,7 @@ err_tx:
 					sizeof(struct qib_pio_header),
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
 err_hdrs:
-	free_pages((unsigned long) dev->lk_table.table, get_order(lk_tab_size));
+	vfree(dev->lk_table.table);
 err_lk:
 	kfree(dev->qp_table);
 err_qpt:
@@ -2340,8 +2347,7 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 					sizeof(struct qib_pio_header),
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
 	lk_tab_size = dev->lk_table.max * sizeof(*dev->lk_table.table);
-	free_pages((unsigned long) dev->lk_table.table,
-		   get_order(lk_tab_size));
+	vfree(dev->lk_table.table);
 	kfree(dev->qp_table);
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 1635572..bce0fa5 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -647,6 +647,8 @@ struct qib_qpn_table {
 	struct qpn_map map[QPNMAP_ENTRIES];
 };
 
+#define MAX_LKEY_TABLE_BITS 23
+
 struct qib_lkey_table {
 	spinlock_t lock; /* protect changes in this struct */
 	u32 next;               /* next unused index (speeds search) */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
