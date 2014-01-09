From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] RDMA/cxgb4: silence GCC warning
Date: Thu, 09 Jan 2014 11:53:27 +0100
Message-ID: <1389264807.11777.6.camel@x41>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Building mem.o for 32 bits x86 triggers a GCC warning:
    drivers/infiniband/hw/cxgb4/mem.c: In function '_c4iw_write_mem_dma_aligned':
    drivers/infiniband/hw/cxgb4/mem.c:79:25: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Silence that warning by casting "&wr_wait" to unsigned long before
casting it to __be64. That's what _c4iw_write_mem_inline() already does.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only (on 32 bit x86): I do not have this hardware.

1) This warning was introduced in v3.10-rc1, through commit 42b6a949903d
("RDMA/cxgb4: Use DSGLs for fastreg and adapter memory writes for T5.").

 drivers/infiniband/hw/cxgb4/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 84e4500..41b1195 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -76,7 +76,7 @@ static int _c4iw_write_mem_dma_aligned(struct c4iw_rdev *rdev, u32 addr,
 	INIT_ULPTX_WR(req, wr_len, 0, 0);
 	req->wr.wr_hi = cpu_to_be32(FW_WR_OP(FW_ULPTX_WR) |
 			(wait ? FW_WR_COMPL(1) : 0));
-	req->wr.wr_lo = wait ? (__force __be64)&wr_wait : 0;
+	req->wr.wr_lo = wait ? (__force __be64)(unsigned long) &wr_wait : 0L;
 	req->wr.wr_mid = cpu_to_be32(FW_WR_LEN16(DIV_ROUND_UP(wr_len, 16)));
 	req->cmd = cpu_to_be32(ULPTX_CMD(ULP_TX_MEM_WRITE));
 	req->cmd |= cpu_to_be32(V_T5_ULP_MEMIO_ORDER(1));
-- 
1.8.4.2
