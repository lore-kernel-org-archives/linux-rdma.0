From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/37] IB/rdmavt: Add query and modify device stubs
Date: Mon, 07 Dec 2015 15:43:24 -0500
Message-ID: <20151207204322.8144.60452.stgit@phlsvslse11.ph.intel.com>
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

Adds the stubs which will handle the query and modify device functions. At
this time the only intention is to support changing the node desc and the
guid via these calls.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index aaf10e7..b807ee8 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -70,6 +70,33 @@ static void rvt_cleanup(void)
 }
 module_exit(rvt_cleanup);
 
+static int rvt_query_device(struct ib_device *ibdev,
+			    struct ib_device_attr *props,
+			    struct ib_udata *uhw)
+{
+	/*
+	 * Return rvt_dev_info.props contents
+	 */
+	return -EINVAL;
+}
+
+static int rvt_modify_device(struct ib_device *device,
+			     int device_modify_mask,
+			     struct ib_device_modify *device_modify)
+{
+	/*
+	 * Change dev props. Planned support is for node desc change and sys
+	 * guid change only. This matches hfi1 and qib behavior. Other drivers
+	 * that support existing modifications will need to add their support.
+	 */
+
+	/*
+	 * VT-DRIVER-API: node_desc_change()
+	 * VT-DRIVER-API: sys_guid_change()
+	 */
+	return -EINVAL;
+}
+
 /*
  * Check driver override. If driver passes a value use it, otherwise we use our
  * own value.
@@ -82,6 +109,10 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	if (!rdi)
 		return -EINVAL;
 
+	/* Dev Ops */
+	CDR(rdi, query_device);
+	CDR(rdi, modify_device);
+
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =
 		rdi->ibdev.dma_ops ? : &rvt_default_dma_mapping_ops;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
