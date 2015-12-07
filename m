From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/37] IB/rdmavt: Add query and modify port stubs
Date: Mon, 07 Dec 2015 15:43:28 -0500
Message-ID: <20151207204327.8144.17959.stgit@phlsvslse11.ph.intel.com>
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

This patch adds the query and modify port stubs. The query will mostly
entail the driver returning everything in the ib_port_attr which will get
handed back to the verbs layer. The modify will need some API helpers in
the driver. The send_trap and post_mad_send are still issues to address.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   48 +++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index b807ee8..513b929 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -97,6 +97,52 @@ static int rvt_modify_device(struct ib_device *device,
 	return -EINVAL;
 }
 
+/**
+ * rvt_query_port: Passes the query port call to the driver
+ * ibdev: Verbs IB dev
+ * port: port number
+ * props: structure to hold returned properties
+ *
+ * Returns 0 on success
+ */
+static int rvt_query_port(struct ib_device *ibdev, u8 port,
+			  struct ib_port_attr *props)
+{
+	/*
+	 * VT-DRIVER-API: query_port_state()
+	 * driver returns pretty much everything in ib_port_attr
+	 */
+	return -EINVAL;
+}
+
+/**
+ * rvt_modify_port
+ * @ibdev: Verbs IB dev
+ * @port: Port number
+ * @port_modify_mask: How to change the port
+ * @props: Structure to fill in
+ *
+ * Returns 0 on success
+ */
+static int rvt_modify_port(struct ib_device *ibdev, u8 port,
+			   int port_modify_mask, struct ib_port_modify *props)
+{
+	/*
+	 * VT-DRIVER-API: set_link_state()
+	 * driver will set the link state using the IB enumeration
+	 *
+	 * VT-DRIVER-API: clear_qkey_violations()
+	 * clears driver private qkey counter
+	 *
+	 * VT-DRIVER-API: get_lid()
+	 * driver needs to return the LID
+	 *
+	 * TBD: send_trap() and post_mad_send() need examined to see where they
+	 * fit in.
+	 */
+	return -EINVAL;
+}
+
 /*
  * Check driver override. If driver passes a value use it, otherwise we use our
  * own value.
@@ -112,6 +158,8 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	/* Dev Ops */
 	CDR(rdi, query_device);
 	CDR(rdi, modify_device);
+	CDR(rdi, query_port);
+	CDR(rdi, modify_port);
 
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
