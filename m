From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 32/36] IB/rdmavt: Add driver notification for new AH
Date: Wed, 06 Jan 2016 10:04:23 -0800
Message-ID: <20160106180418.8747.56232.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
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
index 2519db9..621afc3 100644
--- a/drivers/infiniband/sw/rdmavt/ah.c
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -83,8 +83,8 @@ int rvt_check_ah(struct ib_device *ibdev,
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
@@ -123,6 +123,9 @@ struct ib_ah *rvt_create_ah(struct ib_pd *pd,
 	ah->attr = *ah_attr;
 	atomic_set(&ah->refcount, 0);
 
+	if (dev->driver_f.notify_new_ah)
+		dev->driver_f.notify_new_ah(pd->device, ah_attr, ah);
+
 	return &ah->ibah;
 }
 
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index a3d6a5b..ef66d2b 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -467,9 +467,21 @@ struct rvt_driver_params {
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
@@ -478,23 +490,20 @@ struct rvt_driver_provided {
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
