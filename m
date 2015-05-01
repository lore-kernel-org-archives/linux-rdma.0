From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] IB/mad: Rename is_data_mad to is_rmpp_data_mad
Date: Fri,  1 May 2015 00:07:20 -0400
Message-ID: <1430453241-20869-2-git-send-email-ira.weiny@intel.com>
References: <1430453241-20869-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430453241-20869-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

is_rmpp_data_mad is more descriptive for this function.

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index ee3a05e..7af6ca7 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1734,7 +1734,7 @@ out:
 	return valid;
 }
 
-static int is_data_mad(struct ib_mad_agent_private *mad_agent_priv,
+static int is_rmpp_data_mad(struct ib_mad_agent_private *mad_agent_priv,
 		       struct ib_mad_hdr *mad_hdr)
 {
 	struct ib_rmpp_mad *rmpp_mad;
@@ -1836,7 +1836,7 @@ ib_find_send_mad(struct ib_mad_agent_private *mad_agent_priv,
 	 * been notified that the send has completed
 	 */
 	list_for_each_entry(wr, &mad_agent_priv->send_list, agent_list) {
-		if (is_data_mad(mad_agent_priv, wr->send_buf.mad) &&
+		if (is_rmpp_data_mad(mad_agent_priv, wr->send_buf.mad) &&
 		    wr->tid == mad->mad_hdr.tid &&
 		    wr->timeout &&
 		    rcv_has_same_class(wr, wc) &&
@@ -2411,7 +2411,8 @@ find_send_wr(struct ib_mad_agent_private *mad_agent_priv,
 
 	list_for_each_entry(mad_send_wr, &mad_agent_priv->send_list,
 			    agent_list) {
-		if (is_data_mad(mad_agent_priv, mad_send_wr->send_buf.mad) &&
+		if (is_rmpp_data_mad(mad_agent_priv,
+				     mad_send_wr->send_buf.mad) &&
 		    &mad_send_wr->send_buf == send_buf)
 			return mad_send_wr;
 	}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
