From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/9] IB/rdmavt: Remove duplicated functions
Date: Mon, 29 May 2017 17:17:28 -0700
Message-ID: <20170530001646.534.64909.stgit@scvm10.sc.intel.com>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530000314.534.72983.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The free_qpn() function from the hfi1/qib driver which was the basis for
rdmavt_free_qpn() function was accidentally left in the code. Remove it.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   37 ++++++++++++++-----------------------
 1 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index a3dd1e5..a372afb 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -422,15 +422,6 @@ static int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 	return ret;
 }
 
-static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
-{
-	struct rvt_qpn_map *map;
-
-	map = qpt->map + qpn / RVT_BITS_PER_PAGE;
-	if (map->page)
-		clear_bit(qpn & RVT_BITS_PER_PAGE_MASK, map->page);
-}
-
 /**
  * rvt_clear_mr_refs - Drop help mr refs
  * @qp: rvt qp data structure
@@ -646,6 +637,19 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 	lockdep_assert_held(&qp->s_lock);
 }
 
+/** rvt_free_qpn - Free a qpn from the bit map
+ * @qpt: QP table
+ * @qpn: queue pair number to free
+ */
+static void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
+{
+	struct rvt_qpn_map *map;
+
+	map = qpt->map + qpn / RVT_BITS_PER_PAGE;
+	if (map->page)
+		clear_bit(qpn & RVT_BITS_PER_PAGE_MASK, map->page);
+}
+
 /**
  * rvt_create_qp - create a queue pair for a device
  * @ibpd: the protection domain who's device we create the queue pair for
@@ -936,7 +940,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		kref_put(&qp->ip->ref, rvt_release_mmap_info);
 
 bail_qpn:
-	free_qpn(&rdi->qp_dev->qpn_table, qp->ibqp.qp_num);
+	rvt_free_qpn(&rdi->qp_dev->qpn_table, qp->ibqp.qp_num);
 
 bail_rq_wq:
 	if (!qp->ip)
@@ -1325,19 +1329,6 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	return -EINVAL;
 }
 
-/** rvt_free_qpn - Free a qpn from the bit map
- * @qpt: QP table
- * @qpn: queue pair number to free
- */
-static void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
-{
-	struct rvt_qpn_map *map;
-
-	map = qpt->map + qpn / RVT_BITS_PER_PAGE;
-	if (map->page)
-		clear_bit(qpn & RVT_BITS_PER_PAGE_MASK, map->page);
-}
-
 /**
  * rvt_destroy_qp - destroy a queue pair
  * @ibqp: the queue pair to destroy

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
