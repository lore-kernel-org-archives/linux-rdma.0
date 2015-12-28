From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 04/36] IB/rdmavt: Add ib core device attributes to rvt
 driver params list
Date: Mon, 28 Dec 2015 13:02:00 -0800
Message-ID: <20151228210130.29850.68479.stgit@scvm10.sc.intel.com>
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

Instead of trying to handle each parameter separately, add ib_device_attr
to rvt_driver_params. This means drivers will fill this in and pass to the
rvt registration function.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
remove comment on alternative design for private data

 drivers/infiniband/sw/rdmavt/pd.c |    2 +
 include/rdma/rdma_vt.h            |   57 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/pd.c b/drivers/infiniband/sw/rdmavt/pd.c
index e6e153f..f8dba88 100644
--- a/drivers/infiniband/sw/rdmavt/pd.c
+++ b/drivers/infiniband/sw/rdmavt/pd.c
@@ -69,7 +69,7 @@ struct ib_pd *rvt_alloc_pd(struct ib_device *ibdev,
 	 */
 
 	spin_lock(&dev->n_pds_lock);
-	if (dev->n_pds_allocated == dev->dparms.max_pds) {
+	if (dev->n_pds_allocated == dev->dparms.props.max_pd) {
 		spin_unlock(&dev->n_pds_lock);
 		kfree(pd);
 		ret = ERR_PTR(-ENOMEM);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 6bf5fd4..2990e03 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -59,7 +59,45 @@
  * Things that are driver specific, module parameters in hfi1 and qib
  */
 struct rvt_driver_params {
-	int max_pds;
+	/*
+	 * driver required fields:
+	 *	node_guid
+	 *	phys_port_cnt
+	 *	dma_device
+	 *	owner
+	 * driver optional fields (rvt will provide generic value if blank):
+	 *	name
+	 *	node_desc
+	 * rvt fields, driver value ignored:
+	 *	uverbs_abi_ver
+	 *	node_type
+	 *	num_comp_vectors
+	 *	uverbs_cmd_mask
+	 */
+	struct ib_device_attr props;
+
+	/*
+	 * Drivers will need to support a number of notifications to rvt in
+	 * accordance with certain events. This structure should contain a mask
+	 * of the supported events. Such events that the rvt may need to know
+	 * about include:
+	 * port errors
+	 * port active
+	 * lid change
+	 * sm change
+	 * client reregister
+	 * pkey change
+	 *
+	 * There may also be other events that the rvt layers needs to know
+	 * about this is not an exhaustive list. Some events though rvt does not
+	 * need to rely on the driver for such as completion queue error.
+	 */
+	 int rvt_signal_supported;
+
+	/*
+	 * Anything driver specific that is not covered by props
+	 * For instance special module parameters. Goes here.
+	 */
 };
 
 /* Protection domain */
@@ -69,10 +107,25 @@ struct rvt_pd {
 };
 
 struct rvt_dev_info {
+	/*
+	 * Prior to calling for registration the driver will be responsible for
+	 * allocating space for this structure.
+	 *
+	 * The driver will also be responsible for filling in certain members of
+	 * dparms.props
+	 */
+
 	struct ib_device ibdev;
 
-	/* Driver specific */
+	/* Driver specific properties */
 	struct rvt_driver_params dparms;
+
+	/*
+	 * The work to create port files in /sys/class Infiniband is different
+	 * depending on the driver. This should not be extracted away and
+	 * instead drivers are responsible for setting the correct callback for
+	 * this.
+	 */
 	int (*port_callback)(struct ib_device *, u8, struct kobject *);
 
 	/* Internal use */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
