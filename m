From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 01/10] IB/core: Introduce protected memory regions
Date: Thu,  7 Nov 2013 17:53:59 +0200
Message-ID: <1383839648-19000-2-git-send-email-sagig@mellanox.com>
References: <1383839648-19000-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383839648-19000-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This commit introduces verbs for creating/destoying memory
regions which will allow new types of memory key operations such
as protected memory registration.

Indirect memory registration is registering several (one
of more) pre-registered memory regions in a specific layout.
The Indirect region may potentialy describe several regions
and some repitition format between them.

Protected Memory registration is registering a memory region
with various data integrity attributes which will describe protection
schemes that will be handled by the HCA in an offloaded manner.
These memory regions will be applicable for a new REG_SIG_MR
work request introduced later in this patchset.

In the future these routines may replace or implement current memory
regions creation routines existing today:
- ib_reg_user_mr
- ib_alloc_fast_reg_mr
- ib_get_dma_mr
- ib_dereg_mr

issue: 333508
Change-Id: Id3d221a002af9a95716a44d0163ca0de1c6dbbb8
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   39 +++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a321df2..ef47667 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1055,6 +1055,45 @@ int ib_dereg_mr(struct ib_mr *mr)
 }
 EXPORT_SYMBOL(ib_dereg_mr);
 
+struct ib_mr *ib_create_mr(struct ib_pd *pd,
+			   struct ib_mr_init_attr *mr_init_attr)
+{
+	struct ib_mr *mr;
+
+	if (!pd->device->create_mr)
+		return ERR_PTR(-ENOSYS);
+
+	mr = pd->device->create_mr(pd, mr_init_attr);
+
+	if (!IS_ERR(mr)) {
+		mr->device  = pd->device;
+		mr->pd      = pd;
+		mr->uobject = NULL;
+		atomic_inc(&pd->usecnt);
+		atomic_set(&mr->usecnt, 0);
+	}
+
+	return mr;
+}
+EXPORT_SYMBOL(ib_create_mr);
+
+int ib_destroy_mr(struct ib_mr *mr)
+{
+	struct ib_pd *pd;
+	int ret;
+
+	if (atomic_read(&mr->usecnt))
+		return -EBUSY;
+
+	pd = mr->pd;
+	ret = mr->device->destroy_mr(mr);
+	if (!ret)
+		atomic_dec(&pd->usecnt);
+
+	return ret;
+}
+EXPORT_SYMBOL(ib_destroy_mr);
+
 struct ib_mr *ib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)
 {
 	struct ib_mr *mr;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e393171..af1bd1a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -455,6 +455,22 @@ int ib_rate_to_mult(enum ib_rate rate) __attribute_const__;
  */
 int ib_rate_to_mbps(enum ib_rate rate) __attribute_const__;
 
+enum ib_mr_create_flags {
+		IB_MR_SIGNATURE_EN = 1,
+};
+
+/**
+ * ib_mr_init_attr - Memory region init attributes passed to routine
+ *     ib_create_mr.
+ * @max_reg_descriptors: max number of registration descriptors that
+ *     may be used with registration work requests.
+ * @flags: MR creation flags bit mask.
+ */
+struct ib_mr_init_attr {
+	int	    max_reg_descriptors;
+	u32	    flags;
+};
+
 /**
  * mult_to_ib_rate - Convert a multiple of 2.5 Gbit/sec to an IB rate
  * enum.
@@ -1372,6 +1388,9 @@ struct ib_device {
 	int                        (*query_mr)(struct ib_mr *mr,
 					       struct ib_mr_attr *mr_attr);
 	int                        (*dereg_mr)(struct ib_mr *mr);
+	int                        (*destroy_mr)(struct ib_mr *mr);
+	struct ib_mr *		   (*create_mr)(struct ib_pd *pd,
+						struct ib_mr_init_attr *mr_init_attr);
 	struct ib_mr *		   (*alloc_fast_reg_mr)(struct ib_pd *pd,
 					       int max_page_list_len);
 	struct ib_fast_reg_page_list * (*alloc_fast_reg_page_list)(struct ib_device *device,
@@ -2212,6 +2231,25 @@ int ib_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr);
  */
 int ib_dereg_mr(struct ib_mr *mr);
 
+
+/**
+ * ib_create_mr - Allocates a memory region that may be used for
+ *     signature handover operations.
+ * @pd: The protection domain associated with the region.
+ * @mr_init_attr: memory region init attributes.
+ */
+struct ib_mr *ib_create_mr(struct ib_pd *pd,
+			   struct ib_mr_init_attr *mr_init_attr);
+
+/**
+ * ib_destroy_mr - Destroys a memory region that was created using
+ *     ib_create_mr and removes it from HW translation tables.
+ * @mr: The memory region to destroy.
+ *
+ * This function can fail, if the memory region has memory windows bound to it.
+ */
+int ib_destroy_mr(struct ib_mr *mr);
+
 /**
  * ib_alloc_fast_reg_mr - Allocates memory region usable with the
  *   IB_WR_FAST_REG_MR send work request.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
