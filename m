From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/37] IB/rdmavt: Add ib core device attributes to rvt
 driver params list
Date: Mon, 07 Dec 2015 15:43:15 -0500
Message-ID: <20151207204314.8144.46170.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
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
 drivers/infiniband/sw/rdmavt/pd.c |    2 +
 include/rdma/rdma_vt.h            |   60 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/pd.c b/drivers/infiniband/sw/rdmavt/pd.c
index 2f7a97f..1522880 100644
--- a/drivers/infiniband/sw/rdmavt/pd.c
+++ b/drivers/infiniband/sw/rdmavt/pd.c
@@ -72,7 +72,7 @@ struct ib_pd *rvt_alloc_pd(struct ib_device *ibdev,
 	 */
 
 	spin_lock(&dev->n_pds_lock);
-	if (dev->n_pds_allocated == dev->dparms.max_pds) {
+	if (dev->n_pds_allocated == dev->dparms.props.max_pd) {
 		spin_unlock(&dev->n_pds_lock);
 		kfree(pd);
 		ret = ERR_PTR(-ENOMEM);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index b4ddcd3..89b8cd9 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -62,7 +62,45 @@
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
@@ -72,10 +110,28 @@ struct rvt_pd {
 };
 
 struct rvt_dev_info {
+	/*
+	 * Prior to calling for registration the driver will be responsible for
+	 * allocating space for this structure. The driver will also need to
+	 * allocate space for any private device or per port data structures.
+	 * Alternatively rvt could do this allocation and the registration API
+	 * would then change to accept an "extra" piece to allocate.
+	 *
+	 * The driver will also be
+	 * responsible for filling in certain members of dparms.props
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
