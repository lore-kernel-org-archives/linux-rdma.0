From: Dan Jurgens <danielj@mellanox.com>
Subject: [RFC PATCH v2 11/13] ib/core: Enforce Infiniband device SMI security
Date: Thu,  7 Apr 2016 02:33:56 +0300
Message-ID: <1459985638-37233-12-git-send-email-danielj@mellanox.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

During MAD and snoop agent registration for SMI QPs check that the
calling process has permission to access the SMI.

When sending and receiving MADs check that the agent has access to the
SMI if it's on an SMI QP.  Because security policy can change it's
possible permission was allowed when creating the agent, but no longer
is.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
---
 drivers/infiniband/core/mad.c |   52 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 907f8ee..b5f42ad 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -349,6 +349,21 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		goto error3;
 	}
 
+	if (qp_type == IB_QPT_SMI) {
+		ret2 = security_ibdev_smi(device->name,
+					  port_num,
+					  &mad_agent_priv->agent);
+		if (ret2) {
+			dev_err(&device->dev,
+				"%s: Access Denied. Err: %d\n",
+				__func__,
+				ret2);
+
+			ret = ERR_PTR(ret2);
+			goto error4;
+		}
+	}
+
 	if (mad_reg_req) {
 		reg_req = kmemdup(mad_reg_req, sizeof *reg_req, GFP_KERNEL);
 		if (!reg_req) {
@@ -535,6 +550,22 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 		goto error2;
 	}
 
+	if (qp_type == IB_QPT_SMI) {
+		err = security_ibdev_smi(device->name,
+					 port_num,
+					 &mad_snoop_priv->agent);
+
+		if (err) {
+			dev_err(&device->dev,
+				"%s: Access Denied. Err: %d\n",
+				__func__,
+				err);
+
+			ret = ERR_PTR(err);
+			goto error3;
+		}
+	}
+
 	/* Now, fill in the various structures */
 	mad_snoop_priv->qp_info = &port_priv->qp_info[qpn];
 	mad_snoop_priv->agent.device = device;
@@ -1248,6 +1279,7 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 
 	/* Walk list of send WRs and post each on send list */
 	for (; send_buf; send_buf = next_send_buf) {
+		int err = 0;
 
 		mad_send_wr = container_of(send_buf,
 					   struct ib_mad_send_wr_private,
@@ -1255,6 +1287,16 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 		mad_agent_priv = mad_send_wr->mad_agent_priv;
 		pkey_index = mad_send_wr->send_wr.pkey_index;
 
+		if (mad_agent_priv->agent.qp->qp_type == IB_QPT_SMI)
+			err = security_ibdev_smi(mad_agent_priv->agent.device->name,
+						 mad_agent_priv->agent.port_num,
+						 &mad_agent_priv->agent);
+
+		if (err) {
+			ret = err;
+			goto error;
+		}
+
 		ret = ib_security_enforce_mad_agent_pkey_access(
 					mad_agent_priv->agent.device,
 					mad_agent_priv->agent.port_num,
@@ -1997,7 +2039,15 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_mad_send_wr_private *mad_send_wr;
 	struct ib_mad_send_wc mad_send_wc;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
+
+	if (mad_agent_priv->agent.qp->qp_type == IB_QPT_SMI)
+		ret = security_ibdev_smi(mad_agent_priv->agent.device->name,
+					 mad_agent_priv->agent.port_num,
+					 &mad_agent_priv->agent);
+
+	if (ret)
+		goto security_error;
 
 	ret = ib_security_enforce_mad_agent_pkey_access(
 					      mad_agent_priv->agent.device,
-- 
1.7.1

