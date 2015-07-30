From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 21/22] IB/iser: Add debug prints to the various memory registration methods
Date: Thu, 30 Jul 2015 11:06:34 +0300
Message-ID: <1438243595-32288-22-git-send-email-sagig@mellanox.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Easier to debug when we have the registration details.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index cbf6152..750f03f 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -554,6 +554,10 @@ int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
 	reg->sge.length = page_vec->data_size;
 	reg->mem_h = fmr;
 
+	iser_dbg("fmr reg: lkey=0x%x, rkey=0x%x, addr=0x%llx,"
+		 " length=0x%x\n", reg->sge.lkey, reg->rkey,
+		 reg->sge.addr, reg->sge.length);
+
 	return 0;
 }
 
@@ -724,7 +728,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	sig_reg->sge.addr = 0;
 	sig_reg->sge.length = scsi_transfer_length(iser_task->sc);
 
-	iser_dbg("sig_sge: lkey: 0x%x, rkey: 0x%x, addr: 0x%llx, length: %u\n",
+	iser_dbg("sig reg: lkey: 0x%x, rkey: 0x%x, addr: 0x%llx, length: %u\n",
 		 sig_reg->sge.lkey, sig_reg->rkey, sig_reg->sge.addr,
 		 sig_reg->sge.length);
 err:
@@ -787,6 +791,10 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	reg->sge.addr = frpl->page_list[0] + offset;
 	reg->sge.length = size;
 
+	iser_dbg("fast reg: lkey=0x%x, rkey=0x%x, addr=0x%llx,"
+		 " length=0x%x\n", reg->sge.lkey, reg->rkey,
+		 reg->sge.addr, reg->sge.length);
+
 	return ret;
 }
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
