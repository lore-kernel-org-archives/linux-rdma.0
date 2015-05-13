From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] IB/mad: Clean up ib_find_send_mad to use only the ib_mad_hdr
Date: Wed, 13 May 2015 19:20:14 -0400
Message-ID: <1431559214-12474-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

ib_find_send_mad only needs access to the MAD header.  Change the MAD cast.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 600af266838c..deefe5df9697 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1815,18 +1815,18 @@ ib_find_send_mad(const struct ib_mad_agent_private *mad_agent_priv,
 		 const struct ib_mad_recv_wc *wc)
 {
 	struct ib_mad_send_wr_private *wr;
-	struct ib_mad *mad;
+	struct ib_mad_hdr *mad_hdr;
 
-	mad = (struct ib_mad *)wc->recv_buf.mad;
+	mad_hdr = (struct ib_mad_hdr *)wc->recv_buf.mad;
 
 	list_for_each_entry(wr, &mad_agent_priv->wait_list, agent_list) {
-		if ((wr->tid == mad->mad_hdr.tid) &&
+		if ((wr->tid == mad_hdr->tid) &&
 		    rcv_has_same_class(wr, wc) &&
 		    /*
 		     * Don't check GID for direct routed MADs.
 		     * These might have permissive LIDs.
 		     */
-		    (is_direct(wc->recv_buf.mad->mad_hdr.mgmt_class) ||
+		    (is_direct(mad_hdr->mgmt_class) ||
 		     rcv_has_same_gid(mad_agent_priv, wr, wc)))
 			return (wr->status == IB_WC_SUCCESS) ? wr : NULL;
 	}
@@ -1837,14 +1837,14 @@ ib_find_send_mad(const struct ib_mad_agent_private *mad_agent_priv,
 	 */
 	list_for_each_entry(wr, &mad_agent_priv->send_list, agent_list) {
 		if (is_rmpp_data_mad(mad_agent_priv, wr->send_buf.mad) &&
-		    wr->tid == mad->mad_hdr.tid &&
+		    wr->tid == mad_hdr->tid &&
 		    wr->timeout &&
 		    rcv_has_same_class(wr, wc) &&
 		    /*
 		     * Don't check GID for direct routed MADs.
 		     * These might have permissive LIDs.
 		     */
-		    (is_direct(wc->recv_buf.mad->mad_hdr.mgmt_class) ||
+		    (is_direct(mad_hdr->mgmt_class) ||
 		     rcv_has_same_gid(mad_agent_priv, wr, wc)))
 			/* Verify request has not been canceled */
 			return (wr->status == IB_WC_SUCCESS) ? wr : NULL;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
