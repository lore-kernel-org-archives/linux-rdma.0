From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v3 11/12] ib/core: Enforce Infiniband device SMI security
Date: Tue, 19 Apr 2016 22:51:28 +0300
Message-ID: <1461095489-18732-12-git-send-email-danielj@mellanox.com>
References: <1461095489-18732-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461095489-18732-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

During MAD and snoop agent registration for SMI QPs check that the
calling process has permission to access the SMI.

When sending and receiving MADs check that the agent has access to the
SMI if it's on an SMI QP.  Because security policy can change it's
possible permission was allowed when creating the agent, but no longer
is.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
v2: Added patch to series.

v3:
1. Changed ibdev and smi to endport and smp respectively. Jason
---
 drivers/infiniband/core/mad.c |   44 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index f76a409..d749b74 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -349,6 +349,16 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		goto error3;
 	}
 
+	if (qp_type == IB_QPT_SMI) {
+		ret2 = security_ib_end_port_smp(device->name,
+						port_num,
+						&mad_agent_priv->agent);
+		if (ret2) {
+			ret = ERR_PTR(ret2);
+			goto error4;
+		}
+	}
+
 	if (mad_reg_req) {
 		reg_req = kmemdup(mad_reg_req, sizeof *reg_req, GFP_KERNEL);
 		if (!reg_req) {
@@ -535,6 +545,17 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 		goto error2;
 	}
 
+	if (qp_type == IB_QPT_SMI) {
+		err = security_ib_end_port_smp(device->name,
+					       port_num,
+					       &mad_snoop_priv->agent);
+
+		if (err) {
+			ret = ERR_PTR(err);
+			goto error3;
+		}
+	}
+
 	/* Now, fill in the various structures */
 	mad_snoop_priv->qp_info = &port_priv->qp_info[qpn];
 	mad_snoop_priv->agent.device = device;
@@ -1248,6 +1269,7 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 
 	/* Walk list of send WRs and post each on send list */
 	for (; send_buf; send_buf = next_send_buf) {
+		int err = 0;
 
 		mad_send_wr = container_of(send_buf,
 					   struct ib_mad_send_wr_private,
@@ -1255,6 +1277,17 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 		mad_agent_priv = mad_send_wr->mad_agent_priv;
 		pkey_index = mad_send_wr->send_wr.pkey_index;
 
+		if (mad_agent_priv->agent.qp->qp_type == IB_QPT_SMI)
+			err = security_ib_end_port_smp(
+					mad_agent_priv->agent.device->name,
+					mad_agent_priv->agent.port_num,
+					&mad_agent_priv->agent);
+
+		if (err) {
+			ret = err;
+			goto error;
+		}
+
 		ret = ib_security_ma_pkey_access(mad_agent_priv->agent.device,
 						 mad_agent_priv->agent.port_num,
 						 pkey_index,
@@ -1996,7 +2029,16 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_mad_send_wr_private *mad_send_wr;
 	struct ib_mad_send_wc mad_send_wc;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
+
+	if (mad_agent_priv->agent.qp->qp_type == IB_QPT_SMI)
+		ret = security_ib_end_port_smp(
+					mad_agent_priv->agent.device->name,
+					mad_agent_priv->agent.port_num,
+					&mad_agent_priv->agent);
+
+	if (ret)
+		goto security_error;
 
 	ret = ib_security_ma_pkey_access(mad_agent_priv->agent.device,
 					 mad_agent_priv->agent.port_num,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
