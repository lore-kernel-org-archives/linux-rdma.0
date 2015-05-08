From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/4] IB/mad: Clean up rcv_has_same_class
Date: Fri,  8 May 2015 14:27:23 -0400
Message-ID: <1431109644-27226-4-git-send-email-ira.weiny@intel.com>
References: <1431109644-27226-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431109644-27226-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rcv_has_same_class only needs access to the MAD header
specify WR and Receive WC as const

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 9365da9..844817d 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1747,10 +1747,10 @@ static int is_rmpp_data_mad(struct ib_mad_agent_private *mad_agent_priv,
 		(rmpp_mad->rmpp_hdr.rmpp_type == IB_MGMT_RMPP_TYPE_DATA);
 }
 
-static inline int rcv_has_same_class(struct ib_mad_send_wr_private *wr,
-				     struct ib_mad_recv_wc *rwc)
+static inline int rcv_has_same_class(const struct ib_mad_send_wr_private *wr,
+				     const struct ib_mad_recv_wc *rwc)
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
