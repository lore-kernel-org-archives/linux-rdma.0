From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 24/36] IB/rdmavt: Add device specific info prints
Date: Wed, 06 Jan 2016 10:02:59 -0800
Message-ID: <20160106180257.8747.15158.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Follow hfi1's example for printing information about the driver and
incorporate into rdmavt. This requires two new functions to be
provided by the driver, one to get_card_name and one to get_pci_dev.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   13 ++++++++++---
 drivers/infiniband/sw/rdmavt/vt.h |   28 ++++++++++++++++++++++++++++
 include/rdma/rdma_vt.h            |    3 +++
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index b4ce97e..2a13e36 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -213,9 +213,18 @@ static int rvt_get_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 int rvt_register_device(struct rvt_dev_info *rdi)
 {
+	/* Validate that drivers have provided the right information */
 	if (!rdi)
 		return -EINVAL;
 
+	if ((!rdi->driver_f.port_callback) ||
+	    (!rdi->driver_f.get_card_name) ||
+	    (!rdi->driver_f.get_pci_dev)) {
+		return -EINVAL;
+	}
+
+	/* Once we get past here we can use the rvt_pr macros */
+
 	/* Dev Ops */
 	CHECK_DRIVER_OVERRIDE(rdi, query_device);
 	CHECK_DRIVER_OVERRIDE(rdi, modify_device);
@@ -280,9 +289,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	spin_lock_init(&rdi->n_pds_lock);
 	rdi->n_pds_allocated = 0;
 
-	/* Validate that drivers have provided the right functions */
-	if (!rdi->driver_f.port_callback)
-		return -EINVAL;
+	rvt_pr_info(rdi, "Registration with rdmavt done.\n");
 
 	/* We are now good to announce we exist */
 	return ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index fdb52a8..54ee05a 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -49,6 +49,7 @@
  */
 
 #include <rdma/rdma_vt.h>
+#include <linux/pci.h>
 #include "dma.h"
 #include "pd.h"
 #include "qp.h"
@@ -59,4 +60,31 @@
 #include "mmap.h"
 #include "cq.h"
 
+#define rvt_pr_info(rdi, fmt, ...) \
+	__rvt_pr_info(rdi->driver_f.get_pci_dev(rdi), \
+		      rdi->driver_f.get_card_name(rdi), \
+		      fmt, \
+		      ##__VA_ARGS__)
+
+#define rvt_pr_warn(rdi, fmt, ...) \
+	__rvt_pr_warn(rdi->driver_f.get_pci_dev(rdi), \
+		      rdi->driver_f.get_card_name(rdi), \
+		      fmt, \
+		      ##__VA_ARGS__)
+
+#define rvt_pr_err(rdi, fmt, ...) \
+	__rvt_pr_err(rdi->driver_f.get_pci_dev(rdi), \
+		     rdi->driver_f.get_card_name(rdi), \
+		     fmt, \
+		     ##__VA_ARGS__)
+
+#define __rvt_pr_info(pdev, name, fmt, ...) \
+	dev_info(&pdev->dev, "%s: " fmt, name, ##__VA_ARGS__)
+
+#define __rvt_pr_warn(pdev, name, fmt, ...) \
+	dev_warn(&pdev->dev, "%s: " fmt, name, ##__VA_ARGS__)
+
+#define __rvt_pr_err(pdev, name, fmt, ...) \
+	dev_err(&pdev->dev, "%s: " fmt, name, ##__VA_ARGS__)
+
 #endif          /* DEF_RDMAVT_H */
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index e0beedc..4b83770 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -386,6 +386,7 @@ struct rvt_driver_params {
 /*
  * Functions that drivers are required to support
  */
+struct rvt_dev_info;
 struct rvt_driver_provided {
 	/*
 	 * The work to create port files in /sys/class Infiniband is different
@@ -394,6 +395,8 @@ struct rvt_driver_provided {
 	 * this.
 	 */
 	int (*port_callback)(struct ib_device *, u8, struct kobject *);
+	const char * (*get_card_name)(struct rvt_dev_info *rdi);
+	struct pci_dev * (*get_pci_dev)(struct rvt_dev_info *rdi);
 };
 
 /* Protection domain */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
