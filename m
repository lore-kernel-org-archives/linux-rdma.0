From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 29/36] IB/rdmavt: Add AH to rdmavt
Date: Wed, 06 Jan 2016 10:03:59 -0800
Message-ID: <20160106180352.8747.44248.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Original patch is from Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>. It has
been split into three separate patches. This one for rdmavt,
a follow on for qib, and one for hfi1.

Create datastructure for address handle and implement the
create/destroy/modify/query of address handle for rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/ah.c |   98 +++++++++++++++++++++++++++++++++++--
 drivers/infiniband/sw/rdmavt/vt.c |    5 ++
 include/rdma/rdma_vt.h            |   17 ++++++
 3 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
index d368955..2519db9 100644
--- a/drivers/infiniband/sw/rdmavt/ah.c
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -45,7 +45,49 @@
  *
  */
 
+#include <linux/slab.h>
 #include "ah.h"
+#include "vt.h" /* for prints */
+
+/**
+ * rvt_check_ah - validate the attributes of AH
+ * @ibdev: the ib device
+ * @ah_attr: the attributes of the AH
+ */
+int rvt_check_ah(struct ib_device *ibdev,
+		 struct ib_ah_attr *ah_attr)
+{
+	int err;
+	struct ib_port_attr port_attr;
+	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
+	enum rdma_link_layer link = rdma_port_get_link_layer(ibdev,
+							     ah_attr->port_num);
+
+	err = ib_query_port(ibdev, ah_attr->port_num, &port_attr);
+	if (err)
+		return -EINVAL;
+	if (ah_attr->port_num < 1 ||
+	    ah_attr->port_num > ibdev->phys_port_cnt)
+		return -EINVAL;
+	if (ah_attr->static_rate != IB_RATE_PORT_CURRENT &&
+	    ib_rate_to_mbps(ah_attr->static_rate) < 0)
+		return -EINVAL;
+	if ((ah_attr->ah_flags & IB_AH_GRH) &&
+	    ah_attr->grh.sgid_index >= port_attr.gid_tbl_len)
+		return -EINVAL;
+	if (link != IB_LINK_LAYER_ETHERNET) {
+		if (ah_attr->dlid == 0)
+			return -EINVAL;
+		if (ah_attr->dlid >= RVT_MULTICAST_LID_BASE &&
+		    ah_attr->dlid != RVT_PERMISSIVE_LID &&
+		    !(ah_attr->ah_flags & IB_AH_GRH))
+			return -EINVAL;
+	}
+	if (rdi->driver_f.check_ah(ibdev, ah_attr))
+		return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL(rvt_check_ah);
 
 /**
  * rvt_create_ah - create an address handle
@@ -57,20 +99,68 @@
 struct ib_ah *rvt_create_ah(struct ib_pd *pd,
 			    struct ib_ah_attr *ah_attr)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct rvt_ah *ah;
+	struct rvt_dev_info *dev = ib_to_rvt(pd->device);
+	unsigned long flags;
+
+	if (rvt_check_ah(pd->device, ah_attr))
+		return ERR_PTR(-EINVAL);
+
+	ah = kmalloc(sizeof(*ah), GFP_ATOMIC);
+	if (!ah)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_irqsave(&dev->n_ahs_lock, flags);
+	if (dev->n_ahs_allocated == dev->dparms.props.max_ah) {
+		spin_unlock(&dev->n_ahs_lock);
+		kfree(ah);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	dev->n_ahs_allocated++;
+	spin_unlock_irqrestore(&dev->n_ahs_lock, flags);
+
+	ah->attr = *ah_attr;
+	atomic_set(&ah->refcount, 0);
+
+	return &ah->ibah;
 }
 
 int rvt_destroy_ah(struct ib_ah *ibah)
 {
-	return -EOPNOTSUPP;
+	struct rvt_dev_info *dev = ib_to_rvt(ibah->device);
+	struct rvt_ah *ah = ibah_to_rvtah(ibah);
+	unsigned long flags;
+
+	if (atomic_read(&ah->refcount) != 0)
+		return -EBUSY;
+
+	spin_lock_irqsave(&dev->n_ahs_lock, flags);
+	dev->n_ahs_allocated--;
+	spin_unlock_irqrestore(&dev->n_ahs_lock, flags);
+
+	kfree(ah);
+
+	return 0;
 }
 
 int rvt_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
 {
-	return -EOPNOTSUPP;
+	struct rvt_ah *ah = ibah_to_rvtah(ibah);
+
+	if (rvt_check_ah(ibah->device, ah_attr))
+		return -EINVAL;
+
+	ah->attr = *ah_attr;
+
+	return 0;
 }
 
 int rvt_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
 {
-	return -EOPNOTSUPP;
+	struct rvt_ah *ah = ibah_to_rvtah(ibah);
+
+	*ah_attr = ah->attr;
+
+	return 0;
 }
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index e92af9c..7dab0ca 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -221,7 +221,8 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 
 	if ((!rdi->driver_f.port_callback) ||
 	    (!rdi->driver_f.get_card_name) ||
-	    (!rdi->driver_f.get_pci_dev)) {
+	    (!rdi->driver_f.get_pci_dev) ||
+	    (!rdi->driver_f.check_ah)) {
 		return -EINVAL;
 	}
 
@@ -252,6 +253,8 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, destroy_ah);
 	CHECK_DRIVER_OVERRIDE(rdi, modify_ah);
 	CHECK_DRIVER_OVERRIDE(rdi, query_ah);
+	spin_lock_init(&rdi->n_ahs_lock);
+	rdi->n_ahs_allocated = 0;
 
 	/* Shared Receive Queue */
 	CHECK_DRIVER_OVERRIDE(rdi, create_srq);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index dbb45bc..36cced6 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -411,6 +411,7 @@ struct rvt_driver_provided {
 	int (*port_callback)(struct ib_device *, u8, struct kobject *);
 	const char * (*get_card_name)(struct rvt_dev_info *rdi);
 	struct pci_dev * (*get_pci_dev)(struct rvt_dev_info *rdi);
+	int (*check_ah)(struct ib_device *, struct ib_ah_attr *);
 };
 
 /* Protection domain */
@@ -419,6 +420,13 @@ struct rvt_pd {
 	int user;               /* non-zero if created from user space */
 };
 
+/* Address handle */
+struct rvt_ah {
+	struct ib_ah ibah;
+	struct ib_ah_attr attr;
+	atomic_t refcount;
+};
+
 struct rvt_dev_info {
 	struct ib_device ibdev; /* Keep this first. Nothing above here */
 
@@ -445,6 +453,9 @@ struct rvt_dev_info {
 	int n_pds_allocated;
 	spinlock_t n_pds_lock; /* Protect pd allocated count */
 
+	int n_ahs_allocated;
+	spinlock_t n_ahs_lock; /* Protect ah allocated count */
+
 	int flags;
 };
 
@@ -453,6 +464,11 @@ static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
 	return container_of(ibpd, struct rvt_pd, ibpd);
 }
 
+static inline struct rvt_ah *ibah_to_rvtah(struct ib_ah *ibah)
+{
+	return container_of(ibah, struct rvt_ah, ibah);
+}
+
 static inline struct rvt_dev_info *ib_to_rvt(struct ib_device *ibdev)
 {
 	return  container_of(ibdev, struct rvt_dev_info, ibdev);
@@ -471,6 +487,7 @@ static inline void rvt_get_mr(struct rvt_mregion *mr)
 
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
+int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc);
 int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
