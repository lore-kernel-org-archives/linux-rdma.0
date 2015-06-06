From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 02/14] IB/mad cleanup: Generalize processing of MAD data
Date: Sat,  6 Jun 2015 14:38:23 -0400
Message-ID: <1433615915-24591-3-git-send-email-ira.weiny@intel.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433615915-24591-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

ib_find_send_mad only needs access to the MAD header not the full IB MAD.
Change the local variable to ib_mad_hdr and change the corresponding cast.

This allows for clean usage of this function with both IB and OPA MADs because
OPA MADs carry the same header as IB MADs.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1
	Make ib_mad_hdr const so as to not cast away the const of the WC
	parameter.

 drivers/infiniband/core/mad.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 71cf3d51dad0..fa9157db7b2e 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1815,18 +1815,18 @@ ib_find_send_mad(const struct ib_mad_agent_private *mad_agent_priv,
 		 const struct ib_mad_recv_wc *wc)
 {
 	struct ib_mad_send_wr_private *wr;
-	struct ib_mad *mad;
+	const struct ib_mad_hdr *mad_hdr;
 
-	mad = (struct ib_mad *)wc->recv_buf.mad;
+	mad_hdr = &wc->recv_buf.mad->mad_hdr;
 
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
