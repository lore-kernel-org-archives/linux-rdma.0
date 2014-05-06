From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/5] ib/mad: Add pr_notice messages for various umad/mad registration failures
Date: Mon,  5 May 2014 21:44:48 -0400
Message-ID: <1399340690-27677-4-git-send-email-ira.weiny@intel.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399340690-27677-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 47 ++++++++++++++++++++++++++++++--------
 drivers/infiniband/core/user_mad.c |  5 ++++
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 7395e23..c48e9a8 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -214,58 +214,85 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 
 	/* Validate parameters */
 	qpn = get_spl_qp_index(qp_type);
-	if (qpn == -1)
+	if (qpn == -1) {
+		pr_notice("ib_register_mad_agent: invalid QP Type %d\n",
+			qp_type);
 		goto error1;
+	}
 
-	if (rmpp_version && rmpp_version != IB_MGMT_RMPP_VERSION)
+	if (rmpp_version && rmpp_version != IB_MGMT_RMPP_VERSION) {
+		pr_notice("ib_register_mad_agent: invalid RMPP Version %u\n",
+			rmpp_version);
 		goto error1;
+	}
 
 	/* Validate MAD registration request if supplied */
 	if (mad_reg_req) {
-		if (mad_reg_req->mgmt_class_version >= MAX_MGMT_VERSION)
+		if (mad_reg_req->mgmt_class_version >= MAX_MGMT_VERSION) {
+			pr_notice("ib_register_mad_agent: invalid Class Version %u\n",
+				mad_reg_req->mgmt_class_version);
 			goto error1;
-		if (!recv_handler)
+		}
+		if (!recv_handler) {
+			pr_notice("ib_register_mad_agent: no recv_handler\n");
 			goto error1;
+		}
 		if (mad_reg_req->mgmt_class >= MAX_MGMT_CLASS) {
 			/*
 			 * IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE is the only
 			 * one in this range currently allowed
 			 */
 			if (mad_reg_req->mgmt_class !=
-			    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+			    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
+				pr_notice("ib_register_mad_agent: Invalid Mgmt Class 0x%x\n",
+					mad_reg_req->mgmt_class);
 				goto error1;
+			}
 		} else if (mad_reg_req->mgmt_class == 0) {
 			/*
 			 * Class 0 is reserved in IBA and is used for
 			 * aliasing of IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE
 			 */
+			pr_notice("ib_register_mad_agent: Invalid Mgmt Class 0\n");
 			goto error1;
 		} else if (is_vendor_class(mad_reg_req->mgmt_class)) {
 			/*
 			 * If class is in "new" vendor range,
 			 * ensure supplied OUI is not zero
 			 */
-			if (!is_vendor_oui(mad_reg_req->oui))
+			if (!is_vendor_oui(mad_reg_req->oui)) {
+				pr_notice("ib_register_mad_agent: No OUI specified for class 0x%x\n",
+					mad_reg_req->mgmt_class);
 				goto error1;
+			}
 		}
 		/* Make sure class supplied is consistent with RMPP */
 		if (!ib_is_mad_class_rmpp(mad_reg_req->mgmt_class)) {
-			if (rmpp_version)
+			if (rmpp_version) {
+				pr_notice("ib_register_mad_agent: RMPP version for non-RMPP class 0x%x\n",
+					mad_reg_req->mgmt_class);
 				goto error1;
+			}
 		}
 		/* Make sure class supplied is consistent with QP type */
 		if (qp_type == IB_QPT_SMI) {
 			if ((mad_reg_req->mgmt_class !=
 					IB_MGMT_CLASS_SUBN_LID_ROUTED) &&
 			    (mad_reg_req->mgmt_class !=
-					IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE))
+					IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)) {
+				pr_notice("ib_register_mad_agent: Invalid SM QP type: class 0x%x\n",
+					mad_reg_req->mgmt_class);
 				goto error1;
+			}
 		} else {
 			if ((mad_reg_req->mgmt_class ==
 					IB_MGMT_CLASS_SUBN_LID_ROUTED) ||
 			    (mad_reg_req->mgmt_class ==
-					IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE))
+					IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)) {
+				pr_notice("ib_register_mad_agent: Invalid GS QP type: class 0x%x\n",
+					mad_reg_req->mgmt_class);
 				goto error1;
+			}
 		}
 	} else {
 		/* No registration request supplied */
@@ -276,6 +303,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	/* Validate device and port */
 	port_priv = ib_get_mad_port(device, port_num);
 	if (!port_priv) {
+		pr_notice("ib_register_mad_agent: Invalid port\n");
 		ret = ERR_PTR(-ENODEV);
 		goto error1;
 	}
@@ -283,6 +311,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	/* Verify the QP requested is supported.  For example, Ethernet devices
 	 * will not have QP0 */
 	if (!port_priv->qp_info[qpn].qp) {
+		pr_notice("ib_register_mad_agent: QP %d not supported\n", qpn);
 		ret = ERR_PTR(-EPROTONOSUPPORT);
 		goto error1;
 	}
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 0df292a..1341282 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -612,6 +612,7 @@ static int ib_umad_reg_agent(struct ib_umad_file *file, void __user *arg,
 	mutex_lock(&file->mutex);
 
 	if (!file->port->ib_dev) {
+		pr_notice("ib_umad_reg_agent: invalid device\n");
 		ret = -EPIPE;
 		goto out;
 	}
@@ -622,6 +623,8 @@ static int ib_umad_reg_agent(struct ib_umad_file *file, void __user *arg,
 	}
 
 	if (ureq.qpn != 0 && ureq.qpn != 1) {
+		pr_notice("ib_umad_reg_agent: invalid QPN %d specified\n",
+			ureq.qpn);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -630,6 +633,8 @@ static int ib_umad_reg_agent(struct ib_umad_file *file, void __user *arg,
 		if (!__get_agent(file, agent_id))
 			goto found;
 
+	pr_notice("ib_umad_reg_agent: Max Agents (%u) reached\n",
+		IB_UMAD_MAX_AGENTS);
 	ret = -ENOMEM;
 	goto out;
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
