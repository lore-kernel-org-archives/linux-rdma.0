From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/4] IB/mad: Add const qualifiers to query only functions
Date: Fri,  8 May 2015 14:27:24 -0400
Message-ID: <1431109644-27226-5-git-send-email-ira.weiny@intel.com>
References: <1431109644-27226-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431109644-27226-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following functions only need read access to the data passed to them.

ib_mad_kernel_rmpp_agent
is_rmpp_data_mad
rcv_has_same_gid
ib_find_send_mad

Clarify with const specifiers

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 16 ++++++++--------
 drivers/infiniband/core/mad_priv.h |  4 ++--
 include/rdma/ib_mad.h              |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 844817d..600af26 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -910,7 +910,7 @@ static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
 	return 0;
 }
 
-int ib_mad_kernel_rmpp_agent(struct ib_mad_agent *agent)
+int ib_mad_kernel_rmpp_agent(const struct ib_mad_agent *agent)
 {
 	return agent->rmpp_version && !(agent->flags & IB_MAD_USER_RMPP);
 }
@@ -1734,8 +1734,8 @@ out:
 	return valid;
 }
 
-static int is_rmpp_data_mad(struct ib_mad_agent_private *mad_agent_priv,
-		       struct ib_mad_hdr *mad_hdr)
+static int is_rmpp_data_mad(const struct ib_mad_agent_private *mad_agent_priv,
+			    const struct ib_mad_hdr *mad_hdr)
 {
 	struct ib_rmpp_mad *rmpp_mad;
 
@@ -1754,9 +1754,9 @@ static inline int rcv_has_same_class(const struct ib_mad_send_wr_private *wr,
 		rwc->recv_buf.mad->mad_hdr.mgmt_class;
 }
 
-static inline int rcv_has_same_gid(struct ib_mad_agent_private *mad_agent_priv,
-				   struct ib_mad_send_wr_private *wr,
-				   struct ib_mad_recv_wc *rwc )
+static inline int rcv_has_same_gid(const struct ib_mad_agent_private *mad_agent_priv,
+				   const struct ib_mad_send_wr_private *wr,
+				   const struct ib_mad_recv_wc *rwc )
 {
 	struct ib_ah_attr attr;
 	u8 send_resp, rcv_resp;
@@ -1811,8 +1811,8 @@ static inline int is_direct(u8 class)
 }
 
 struct ib_mad_send_wr_private*
-ib_find_send_mad(struct ib_mad_agent_private *mad_agent_priv,
-		 struct ib_mad_recv_wc *wc)
+ib_find_send_mad(const struct ib_mad_agent_private *mad_agent_priv,
+		 const struct ib_mad_recv_wc *wc)
 {
 	struct ib_mad_send_wr_private *wr;
 	struct ib_mad *mad;
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index d1a0b0e..7b19cba 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -213,8 +213,8 @@ struct ib_mad_port_private {
 int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr);
 
 struct ib_mad_send_wr_private *
-ib_find_send_mad(struct ib_mad_agent_private *mad_agent_priv,
-		 struct ib_mad_recv_wc *mad_recv_wc);
+ib_find_send_mad(const struct ib_mad_agent_private *mad_agent_priv,
+		 const struct ib_mad_recv_wc *mad_recv_wc);
 
 void ib_mad_complete_send_wr(struct ib_mad_send_wr_private *mad_send_wr,
 			     struct ib_mad_send_wc *mad_send_wc);
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 69e3c45..c0ea51f 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -675,6 +675,6 @@ void ib_free_send_mad(struct ib_mad_send_buf *send_buf);
  * @agent: the agent in question
  * @return: true if agent is performing rmpp, false otherwise.
  */
-int ib_mad_kernel_rmpp_agent(struct ib_mad_agent *agent);
+int ib_mad_kernel_rmpp_agent(const struct ib_mad_agent *agent);
 
 #endif /* IB_MAD_H */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
