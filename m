From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: re-fix 32-bit build warning
Date: Wed, 07 Oct 2015 14:10:04 +0200
Message-ID: <13543971.LQ3Q8CCxhL@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Casting a pointer to __be64 produces a warning on 32-bit architectures:

drivers/infiniband/hw/cxgb4/mem.c:147:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    req->wr.wr_lo = (__force __be64)&wr_wait;

This was fixed at least twice for this driver in different places,
and accidentally reverted once more. This puts the correct version
back in place.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Fixes: 6198dd8d7a6a7 ("iw_cxgb4: 32b platform fixes")

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 026b91ebd5e2..140415d31bcc 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -144,7 +144,7 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev *rdev, u32 addr, u32 len,
 		if (i == (num_wqe-1)) {
 			req->wr.wr_hi = cpu_to_be32(FW_WR_OP_V(FW_ULPTX_WR) |
 						    FW_WR_COMPL_F);
-			req->wr.wr_lo = (__force __be64)&wr_wait;
+			req->wr.wr_lo = (__force __be64)(unsigned long)&wr_wait;
 		} else
 			req->wr.wr_hi = cpu_to_be32(FW_WR_OP_V(FW_ULPTX_WR));
 		req->wr.wr_mid = cpu_to_be32(

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
