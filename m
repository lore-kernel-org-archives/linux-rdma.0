From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 23/36] IB/rdmavt: Move driver helper functions to a
 common structure
Date: Mon, 28 Dec 2015 13:15:15 -0800
Message-ID: <20151228211508.29850.38387.stgit@scvm10.sc.intel.com>
References: <20151228205612.29850.7328.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151228205612.29850.7328.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Drivers are going to need to provide multiple functions for rdmavt to
call in to. We already have one, so go ahead and push this into a
data structure designated for driver supplied functions.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |    6 +++++-
 include/rdma/rdma_vt.h            |   22 +++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 0cf80d1..e4881ca 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -281,8 +281,12 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	spin_lock_init(&rdi->n_pds_lock);
 	rdi->n_pds_allocated = 0;
 
+	/* Validate that drivers have provided the right functions */
+	if (!rdi->driver_f.port_callback)
+		return -EINVAL;
+
 	/* We are now good to announce we exist */
-	return ib_register_device(&rdi->ibdev, rdi->port_callback);
+	return ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
 }
 EXPORT_SYMBOL(rvt_register_device);
 
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 9baa7f0..e0beedc 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -383,6 +383,19 @@ struct rvt_driver_params {
 	 */
 };
 
+/*
+ * Functions that drivers are required to support
+ */
+struct rvt_driver_provided {
+	/*
+	 * The work to create port files in /sys/class Infiniband is different
+	 * depending on the driver. This should not be extracted away and
+	 * instead drivers are responsible for setting the correct callback for
+	 * this.
+	 */
+	int (*port_callback)(struct ib_device *, u8, struct kobject *);
+};
+
 /* Protection domain */
 struct rvt_pd {
 	struct ib_pd ibpd;
@@ -407,13 +420,8 @@ struct rvt_dev_info {
 
 	/* PKey Table goes here */
 
-	/*
-	 * The work to create port files in /sys/class Infiniband is different
-	 * depending on the driver. This should not be extracted away and
-	 * instead drivers are responsible for setting the correct callback for
-	 * this.
-	 */
-	int (*port_callback)(struct ib_device *, u8, struct kobject *);
+	/* Driver specific helper functions */
+	struct rvt_driver_provided driver_f;
 
 	/* Internal use */
 	int n_pds_allocated;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
