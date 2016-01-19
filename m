From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] IB/rdmavt: Add mad agents to rdmavt
Date: Tue, 19 Jan 2016 14:27:57 -0800
Message-ID: <20160119222757.27985.29986.stgit@scvm10.sc.intel.com>
References: <20160119222314.27985.81482.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119222314.27985.81482.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds mad agent create and free to rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mad.c |   72 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/mad.h |    3 +-
 drivers/infiniband/sw/rdmavt/vt.c  |    4 ++
 drivers/infiniband/sw/rdmavt/vt.h  |    1 +
 include/rdma/rdma_vt.h             |    6 +++
 5 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mad.c b/drivers/infiniband/sw/rdmavt/mad.c
index eef7029..e01f3fb 100644
--- a/drivers/infiniband/sw/rdmavt/mad.c
+++ b/drivers/infiniband/sw/rdmavt/mad.c
@@ -45,6 +45,7 @@
  *
  */
 
+#include <rdma/ib_mad.h>
 #include "mad.h"
 
 /**
@@ -83,3 +84,74 @@ int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 	 */
 	return IB_MAD_RESULT_FAILURE;
 }
+
+static void rvt_send_mad_handler(struct ib_mad_agent *agent,
+				 struct ib_mad_send_wc *mad_send_wc)
+{
+	ib_free_send_mad(mad_send_wc->send_buf);
+}
+
+int rvt_create_mad_agents(struct rvt_dev_info *rdi)
+{
+	struct ib_mad_agent *agent;
+	struct rvt_ibport *rvp;
+	int p;
+	int ret;
+
+	for (p = 0; p < rdi->dparms.nports; p++) {
+		rvp = rdi->ports[p];
+		agent = ib_register_mad_agent(&rdi->ibdev, p + 1,
+					      IB_QPT_SMI,
+					      NULL, 0, rvt_send_mad_handler,
+					      NULL, NULL, 0);
+		if (IS_ERR(agent)) {
+			ret = PTR_ERR(agent);
+			goto err;
+		}
+
+		rvp->send_agent = agent;
+
+		if (rdi->driver_f.notify_create_mad_agent)
+			rdi->driver_f.notify_create_mad_agent(rdi, p);
+	}
+
+	return 0;
+
+err:
+	for (p = 0; p < rdi->dparms.nports; p++) {
+		rvp = rdi->ports[p];
+		if (rvp->send_agent) {
+			agent = rvp->send_agent;
+			rvp->send_agent = NULL;
+			ib_unregister_mad_agent(agent);
+			if (rdi->driver_f.notify_free_mad_agent)
+				rdi->driver_f.notify_free_mad_agent(rdi, p);
+		}
+	}
+
+	return ret;
+}
+
+void rvt_free_mad_agents(struct rvt_dev_info *rdi)
+{
+	struct ib_mad_agent *agent;
+	struct rvt_ibport *rvp;
+	int p;
+
+	for (p = 0; p < rdi->dparms.nports; p++) {
+		rvp = rdi->ports[p];
+		if (rvp->send_agent) {
+			agent = rvp->send_agent;
+			rvp->send_agent = NULL;
+			ib_unregister_mad_agent(agent);
+		}
+		if (rvp->sm_ah) {
+			ib_destroy_ah(&rvp->sm_ah->ibah);
+			rvp->sm_ah = NULL;
+		}
+
+		if (rdi->driver_f.notify_free_mad_agent)
+			rdi->driver_f.notify_free_mad_agent(rdi, p);
+	}
+}
+
diff --git a/drivers/infiniband/sw/rdmavt/mad.h b/drivers/infiniband/sw/rdmavt/mad.h
index ee740e9..5d8a6a9 100644
--- a/drivers/infiniband/sw/rdmavt/mad.h
+++ b/drivers/infiniband/sw/rdmavt/mad.h
@@ -55,5 +55,6 @@ int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 		    const struct ib_mad_hdr *in, size_t in_mad_size,
 		    struct ib_mad_hdr *out, size_t *out_mad_size,
 		    u16 *out_mad_pkey_index);
-
+int rvt_create_mad_agents(struct rvt_dev_info *rdi);
+void rvt_free_mad_agents(struct rvt_dev_info *rdi);
 #endif          /* DEF_RVTMAD_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 450caa7..7496d43 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -416,6 +416,8 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 		goto bail_cq;
 	}
 
+	rvt_create_mad_agents(rdi);
+
 	rvt_pr_info(rdi, "Registration with rdmavt done.\n");
 	return ret;
 
@@ -438,6 +440,8 @@ void rvt_unregister_device(struct rvt_dev_info *rdi)
 	if (!rdi)
 		return;
 
+	rvt_free_mad_agents(rdi);
+
 	ib_unregister_device(&rdi->ibdev);
 	rvt_cq_exit(rdi);
 	rvt_mr_exit(rdi);
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index 54ee05a..d9f78cc 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -59,6 +59,7 @@
 #include "mcast.h"
 #include "mmap.h"
 #include "cq.h"
+#include "mad.h"
 
 #define rvt_pr_info(rdi, fmt, ...) \
 	__rvt_pr_info(rdi->driver_f.get_pci_dev(rdi), \
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index b7931bd..eb1c17a 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -136,7 +136,8 @@ struct rvt_ibport {
 	 */
 	u16 *pkey_table;
 
-	/* TODO: Move sm_ah and smi_ah into here as well*/
+	struct rvt_ah *sm_ah;
+	struct rvt_ah *smi_ah;
 };
 
 #define RVT_CQN_MAX 16 /* maximum length of cq name */
@@ -262,6 +263,9 @@ struct rvt_driver_provided {
 			       int attr_mask, struct ib_udata *udata);
 	void (*modify_qp)(struct rvt_qp *qp, struct ib_qp_attr *attr,
 			  int attr_mask, struct ib_udata *udata);
+
+	void (*notify_create_mad_agent)(struct rvt_dev_info *rdi, int port_idx);
+	void (*notify_free_mad_agent)(struct rvt_dev_info *rdi, int port_idx);
 };
 
 struct rvt_dev_info {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
