From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 32/37] IB/rdmavt: Add driver notification for new AH
Date: Mon, 07 Dec 2015 15:45:19 -0500
Message-ID: <20151207204518.8144.70730.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Drivers may need to do some work once an address handle has been
created. Add a driver function for this purpose.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/ah.c |    7 +++++-
 include/rdma/rdma_vt.h            |   41 +++++++++++++++++++++++--------------
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
index 3e3d758..982c2ae 100644
--- a/drivers/infiniband/sw/rdmavt/ah.c
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -86,8 +86,8 @@ int rvt_check_ah(struct ib_device *ibdev,
 		    !(ah_attr->ah_flags & IB_AH_GRH))
 			return -EINVAL;
 	}
-	if (rdi->driver_f.check_ah(ibdev, ah_attr))
-		return -EINVAL;
+	if (rdi->driver_f.check_ah)
+		return rdi->driver_f.check_ah(ibdev, ah_attr);
 	return 0;
 }
 EXPORT_SYMBOL(rvt_check_ah);
@@ -126,6 +126,9 @@ struct ib_ah *rvt_create_ah(struct ib_pd *pd,
 	ah->attr = *ah_attr;
 	atomic_set(&ah->refcount, 0);
 
+	if (dev->driver_f.notify_new_ah)
+		dev->driver_f.notify_new_ah(pd->device, ah_attr, ah);
+
 	return &ah->ibah;
 }
 
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 4ccae84..f75e7c7 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -470,9 +470,21 @@ struct rvt_driver_params {
 	int nports;
 };
 
-/*
- * Functions that drivers are required to support
- */
+/* Protection domain */
+struct rvt_pd {
+	struct ib_pd ibpd;
+	int user;               /* non-zero if created from user space */
+};
+
+/* Address handle */
+struct rvt_ah {
+	struct ib_ah ibah;
+	struct ib_ah_attr attr;
+	atomic_t refcount;
+	u8 vl;
+	u8 log_pmtu;
+};
+
 struct rvt_dev_info;
 struct rvt_driver_provided {
 	/*
@@ -481,23 +493,20 @@ struct rvt_driver_provided {
 	 * instead drivers are responsible for setting the correct callback for
 	 * this.
 	 */
+
+	/* -------------------*/
+	/* Required functions */
+	/* -------------------*/
 	int (*port_callback)(struct ib_device *, u8, struct kobject *);
 	const char * (*get_card_name)(struct rvt_dev_info *rdi);
 	struct pci_dev * (*get_pci_dev)(struct rvt_dev_info *rdi);
-	int (*check_ah)(struct ib_device *, struct ib_ah_attr *);
-};
 
-/* Protection domain */
-struct rvt_pd {
-	struct ib_pd ibpd;
-	int user;               /* non-zero if created from user space */
-};
-
-/* Address handle */
-struct rvt_ah {
-	struct ib_ah ibah;
-	struct ib_ah_attr attr;
-	atomic_t refcount;
+	/*--------------------*/
+	/* Optional functions */
+	/*--------------------*/
+	int (*check_ah)(struct ib_device *, struct ib_ah_attr *);
+	void (*notify_new_ah)(struct ib_device *, struct ib_ah_attr *,
+			      struct rvt_ah *);
 };
 
 struct rvt_dev_info {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
