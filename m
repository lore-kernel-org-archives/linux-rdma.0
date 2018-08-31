From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH] cxgb4: fix abort_req_rss6 struct
Date: Fri, 31 Aug 2018 11:52:00 -0700
Message-ID: <1e9f55943699dcc2bc921000ee7ee5353cbf7480.1535742195.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: jgg@ziepe.ca, dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Remove the incorrect WR_HDR field which can cause a misinterpretation
of this CPL by ULDs.

Fixes: a3cdaa69e4ae ("cxgb4: Adds CPL support for Shared Receive Queues")
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

Dave, Doug, and Jason,

I request this merge through the rdma repo since the only user of this
structure is iw_cxgb4.

---
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index b8f75a22fb6c..f152da1ce046 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -753,7 +753,6 @@ struct cpl_abort_req_rss {
 };
 
 struct cpl_abort_req_rss6 {
-	WR_HDR;
 	union opcode_tid ot;
 	__be32 srqidx_status;
 };
-- 
1.8.3.1
