From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v4 05/19] IB/mad: Change cast in rcv_has_same_class
Date: Wed,  4 Feb 2015 18:29:31 -0500
Message-ID: <1423092585-26692-6-git-send-email-ira.weiny@intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423092585-26692-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rcv_has_same_class only needs access to the MAD header and can be used for both IB
and Jumbo MADs.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 drivers/infiniband/core/mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 66b3940..819b794 100644
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
