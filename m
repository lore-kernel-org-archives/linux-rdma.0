From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH 3.4] IB/qib: Change lkey table allocation to support more MRs
Date: Tue, 29 Sep 2015 10:48:44 -0400
Message-ID: <20150929144844.27235.21244.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
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

Cc: stable@vger.kernel.org # 3.4
Reviewed-by: Vinit Agnihotri <vinit.abhay.agnihotri@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 drivers/infiniband/hw/qib/qib_keys.c  |    4 ++++
 drivers/infiniband/hw/qib/qib_verbs.c |   16 +++++++++++-----
 drivers/infiniband/hw/qib/qib_verbs.h |    2 ++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 8fd19a4..ca6e6cf 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -69,6 +69,10 @@ int qib_alloc_lkey(struct qib_lkey_table *rkt, struct qib_mregion *mr)
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
index 7b6c3bf..3840137 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -40,6 +40,7 @@
 #include <linux/rculist.h>
 #include <linux/mm.h>
 #include <linux/random.h>
+#include <linux/vmalloc.h>
 
 #include "qib.h"
 #include "qib_common.h"
@@ -2058,10 +2059,16 @@ int qib_register_ib_device(struct qib_devdata *dd)
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
-	dev->lk_table.table = (struct qib_mregion **)
-		__get_free_pages(GFP_KERNEL, get_order(lk_tab_size));
+	dev->lk_table.table = (struct qib_mregion __rcu **)
+		vmalloc(lk_tab_size);
 	if (dev->lk_table.table == NULL) {
 		ret = -ENOMEM;
 		goto err_lk;
@@ -2231,7 +2238,7 @@ err_tx:
 					sizeof(struct qib_pio_header),
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
 err_hdrs:
-	free_pages((unsigned long) dev->lk_table.table, get_order(lk_tab_size));
+	vfree(dev->lk_table.table);
 err_lk:
 	kfree(dev->qp_table);
 err_qpt:
@@ -2285,7 +2292,6 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 					sizeof(struct qib_pio_header),
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
 	lk_tab_size = dev->lk_table.max * sizeof(*dev->lk_table.table);
-	free_pages((unsigned long) dev->lk_table.table,
-		   get_order(lk_tab_size));
+	vfree(dev->lk_table.table);
 	kfree(dev->qp_table);
 }
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 0c19ef0..66f7f62 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -622,6 +622,8 @@ struct qib_qpn_table {
 	struct qpn_map map[QPNMAP_ENTRIES];
 };
 
+#define MAX_LKEY_TABLE_BITS 23
+
 struct qib_lkey_table {
 	spinlock_t lock; /* protect changes in this struct */
 	u32 next;               /* next unused index (speeds search) */
