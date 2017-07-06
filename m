From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH resend] RDMA/iser: don't send an rkey if all data is written as immadiate-data
Date: Thu,  6 Jul 2017 10:21:36 +0300
Message-ID: <1499325696-18310-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We might get some bogus error completions in case the target will
remotely invalidate the rkey and the HCA will need to retransmit
from this buffer.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 12ed62ce9ff7..2a07692007bd 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -137,8 +137,10 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 
 	if (unsol_sz < edtl) {
 		hdr->flags     |= ISER_WSV;
-		hdr->write_stag = cpu_to_be32(mem_reg->rkey);
-		hdr->write_va   = cpu_to_be64(mem_reg->sge.addr + unsol_sz);
+		if (buf_out->data_len > imm_sz) {
+			hdr->write_stag = cpu_to_be32(mem_reg->rkey);
+			hdr->write_va = cpu_to_be64(mem_reg->sge.addr + unsol_sz);
+		}
 
 		iser_dbg("Cmd itt:%d, WRITE tags, RKEY:%#.4X "
 			 "VA:%#llX + unsol:%d\n",
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
