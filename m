From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 2/4] IB/core: Support rate limit for packet pacing
Date: Thu,  1 Dec 2016 13:43:14 +0200
Message-ID: <1480592596-20126-3-git-send-email-leon@kernel.org>
References: <1480592596-20126-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480592596-20126-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add new member rate_limit to ib_qp_attr which holds the packet pacing rate
in kbps, 0 means unlimited.

IB_QP_RATE_LIMIT is added to ib_attr_mask and could be used by RAW
QPs when changing QP state from RTR to RTS, RTS to RTS.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 2 ++
 include/rdma/ib_verbs.h         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8368764..3e688b3 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1014,6 +1014,7 @@ static const struct {
 						 IB_QP_QKEY),
 				 [IB_QPT_GSI] = (IB_QP_CUR_STATE		|
 						 IB_QP_QKEY),
+				 [IB_QPT_RAW_PACKET] = IB_QP_RATE_LIMIT,
 			 }
 		}
 	},
@@ -1047,6 +1048,7 @@ static const struct {
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_CUR_STATE			|
 						IB_QP_QKEY),
+				[IB_QPT_RAW_PACKET] = IB_QP_RATE_LIMIT,
 			}
 		},
 		[IB_QPS_SQD]   = {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..a065361 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1102,6 +1102,7 @@ enum ib_qp_attr_mask {
 	IB_QP_RESERVED2			= (1<<22),
 	IB_QP_RESERVED3			= (1<<23),
 	IB_QP_RESERVED4			= (1<<24),
+	IB_QP_RATE_LIMIT		= (1<<25),
 };
 
 enum ib_qp_state {
@@ -1151,6 +1152,7 @@ struct ib_qp_attr {
 	u8			rnr_retry;
 	u8			alt_port_num;
 	u8			alt_timeout;
+	u32			rate_limit;
 };
 
 enum ib_wr_opcode {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
