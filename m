From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/4] IB/nes: Fix incorrect type in assignment
Date: Sat, 22 Apr 2017 17:28:52 +0300
Message-ID: <20170422142852.18882-5-leon@kernel.org>
References: <20170422142852.18882-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170422142852.18882-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix mismatch between types, wqe_words are in le32 format, while opcode
in CPU format.

The following sparse warnings are helped to find it:

drivers/infiniband/hw/nes/nes_hw.c:3058:24: warning: incorrect type in assignment (different base types)
drivers/infiniband/hw/nes/nes_hw.c:3058:24:    expected unsigned int [unsigned] [assigned] [usertype] opcode
drivers/infiniband/hw/nes/nes_hw.c:3058:24:    got restricted __le32 <noident>

CC: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 19acd13c6cb1..4bbff7a33d18 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3055,7 +3055,7 @@ static void nes_cqp_ce_handler(struct nes_device *nesdev, struct nes_hw_cq *cq)
 		memcpy(cqp_wqe, &cqp_request->cqp_wqe, sizeof(*cqp_wqe));
 		barrier();

-		opcode = cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX];
+		opcode = le32_to_cpu(cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX]);
 		if ((opcode & NES_CQP_OPCODE_MASK) == NES_CQP_DOWNLOAD_SEGMENT)
 			ctx_index = NES_CQP_WQE_DL_COMP_CTX_LOW_IDX;
 		else
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
