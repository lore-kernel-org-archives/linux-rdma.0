From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/3] IB/mad: Change ib_response_mad signature to take ib_mad_hdr rather than ib_mad
Date: Fri,  1 May 2015 01:42:07 -0400
Message-ID: <1430458928-28465-3-git-send-email-ira.weiny@intel.com>
References: <1430458928-28465-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430458928-28465-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

ib_response_mad only needs access to the MAD header

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 20 ++++++++++----------
 drivers/infiniband/core/user_mad.c |  6 +++---
 include/rdma/ib_mad.h              |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 19cd91b..2f5a4ab 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -179,12 +179,12 @@ static int is_vendor_method_in_use(
 	return 0;
 }
 
-int ib_response_mad(struct ib_mad *mad)
+int ib_response_mad(struct ib_mad_hdr *hdr)
 {
-	return ((mad->mad_hdr.method & IB_MGMT_METHOD_RESP) ||
-		(mad->mad_hdr.method == IB_MGMT_METHOD_TRAP_REPRESS) ||
-		((mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_BM) &&
-		 (mad->mad_hdr.attr_mod & IB_BM_ATTR_MOD_RESP)));
+	return ((hdr->method & IB_MGMT_METHOD_RESP) ||
+		(hdr->method == IB_MGMT_METHOD_TRAP_REPRESS) ||
+		((hdr->mgmt_class == IB_MGMT_CLASS_BM) &&
+		 (hdr->attr_mod & IB_BM_ATTR_MOD_RESP)));
 }
 EXPORT_SYMBOL(ib_response_mad);
 
@@ -791,7 +791,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	switch (ret)
 	{
 	case IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY:
-		if (ib_response_mad(&mad_priv->mad.mad) &&
+		if (ib_response_mad(&mad_priv->mad.mad.mad_hdr) &&
 		    mad_agent_priv->agent.recv_handler) {
 			local->mad_priv = mad_priv;
 			local->recv_mad_agent = mad_agent_priv;
@@ -1628,7 +1628,7 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
 	unsigned long flags;
 
 	spin_lock_irqsave(&port_priv->reg_lock, flags);
-	if (ib_response_mad(mad)) {
+	if (ib_response_mad(&mad->mad_hdr)) {
 		u32 hi_tid;
 		struct ib_mad_agent_private *entry;
 
@@ -1765,8 +1765,8 @@ static inline int rcv_has_same_gid(struct ib_mad_agent_private *mad_agent_priv,
 	u8 port_num = mad_agent_priv->agent.port_num;
 	u8 lmc;
 
-	send_resp = ib_response_mad((struct ib_mad *)wr->send_buf.mad);
-	rcv_resp = ib_response_mad(rwc->recv_buf.mad);
+	send_resp = ib_response_mad((struct ib_mad_hdr *)wr->send_buf.mad);
+	rcv_resp = ib_response_mad(&rwc->recv_buf.mad->mad_hdr);
 
 	if (send_resp == rcv_resp)
 		/* both requests, or both responses. GIDs different */
@@ -1879,7 +1879,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	}
 
 	/* Complete corresponding request */
-	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
+	if (ib_response_mad(&mad_recv_wc->recv_buf.mad->mad_hdr)) {
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
 		if (!mad_send_wr) {
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index e3ccbf2..4cd3a86 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -426,11 +426,11 @@ static int is_duplicate(struct ib_umad_file *file,
 		 * the same TID, reject the second as a duplicate.  This is more
 		 * restrictive than required by the spec.
 		 */
-		if (!ib_response_mad((struct ib_mad *) hdr)) {
-			if (!ib_response_mad((struct ib_mad *) sent_hdr))
+		if (!ib_response_mad(hdr)) {
+			if (!ib_response_mad(sent_hdr))
 				return 1;
 			continue;
-		} else if (!ib_response_mad((struct ib_mad *) sent_hdr))
+		} else if (!ib_response_mad(sent_hdr))
 			continue;
 
 		if (same_destination(&packet->mad.hdr, &sent_packet->mad.hdr))
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 9bb99e9..9c89939 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -263,7 +263,7 @@ struct ib_mad_send_buf {
  * ib_response_mad - Returns if the specified MAD has been generated in
  *   response to a sent request or trap.
  */
-int ib_response_mad(struct ib_mad *mad);
+int ib_response_mad(struct ib_mad_hdr *hdr);
 
 /**
  * ib_get_rmpp_resptime - Returns the RMPP response time.
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
