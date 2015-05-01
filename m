From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/3] IB/mad: Change cast in rcv_has_same_class
Date: Fri,  1 May 2015 01:42:08 -0400
Message-ID: <1430458928-28465-4-git-send-email-ira.weiny@intel.com>
References: <1430458928-28465-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430458928-28465-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rcv_has_same_class only needs access to the MAD header

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 2f5a4ab..0749d7b 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1750,7 +1750,7 @@ static int is_rmpp_data_mad(struct ib_mad_agent_private *mad_agent_priv,
 static inline int rcv_has_same_class(struct ib_mad_send_wr_private *wr,
 				     struct ib_mad_recv_wc *rwc)
 {
-	return ((struct ib_mad *)(wr->send_buf.mad))->mad_hdr.mgmt_class ==
+	return ((struct ib_mad_hdr *)(wr->send_buf.mad))->mgmt_class ==
 		rwc->recv_buf.mad->mad_hdr.mgmt_class;
 }
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
