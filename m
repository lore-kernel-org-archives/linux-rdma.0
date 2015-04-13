From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v3 24/28] IB/Verbs: Use management helper cap_ib_cm_dev()
Date: Mon, 13 Apr 2015 14:34:40 +0200
Message-ID: <552BB7E0.70408@profitbricks.com>
References: <552BB470.4090407@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552BB470.4090407-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Introduce helper cap_ib_cm_dev() to help us check if any port of
an IB device has the capability Infiniband Communication Manager.

Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c |  5 ++---
 drivers/infiniband/core/ucm.c |  3 +--
 include/rdma/ib_verbs.h       | 20 ++++++++++++++++++++
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 4ed582e..65e41f4 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1639,8 +1639,7 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 	struct rdma_cm_id *id;
 	int ret;
 
-	if (cma_family(id_priv) == AF_IB &&
-	    rdma_node_get_transport(cma_dev->device->node_type) != RDMA_TRANSPORT_IB)
+	if (cma_family(id_priv) == AF_IB && !cap_ib_cm_dev(cma_dev->device))
 		return;
 
 	id = rdma_create_id(cma_listen_handler, id_priv, id_priv->id.ps,
@@ -2031,7 +2030,7 @@ static int cma_bind_loopback(struct rdma_id_private *id_priv)
 	mutex_lock(&lock);
 	list_for_each_entry(cur_dev, &dev_list, list) {
 		if (cma_family(id_priv) == AF_IB &&
-		    rdma_node_get_transport(cur_dev->device->node_type) != RDMA_TRANSPORT_IB)
+		    !cap_ib_cm_dev(cur_dev->device))
 			continue;
 
 		if (!cma_dev)
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index f2f6393..065405e 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1253,8 +1253,7 @@ static void ib_ucm_add_one(struct ib_device *device)
 	dev_t base;
 	struct ib_ucm_device *ucm_dev;
 
-	if (!device->alloc_ucontext ||
-	    rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
+	if (!device->alloc_ucontext || !cap_ib_cm_dev(device))
 		return;
 
 	ucm_dev = kzalloc(sizeof *ucm_dev, GFP_KERNEL);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 60f7efb..29ddd14 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1893,6 +1893,26 @@ static inline int cap_read_multi_sge(struct ib_device *device, u8 port_num)
 	return !rdma_tech_iwarp(device, port_num);
 }
 
+/**
+ * cap_ib_cm_dev - Check if any port of device has the capability Infiniband
+ * Communication Manager.
+ *
+ * @device: Device to be checked
+ *
+ * Return 0 when all port of the device don't support Infiniband
+ * Communication Manager.
+ */
+static inline int cap_ib_cm_dev(struct ib_device *device)
+{
+	int i;
+
+	for (i = 1; i <= device->phys_port_cnt; i++) {
+		if (cap_ib_cm(device, i))
+			return 1;
+	}
+	return 0;
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
