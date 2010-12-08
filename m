From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Change a warning message to debug
Date: Wed, 8 Dec 2010 10:06:02 +0200
Message-ID: <20101208080602.GA9649@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This workaround presented in 58d74bb is not something we should alert the user
on.  Debug level message is enough.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/fw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 7a7e18b..9f415df 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -290,7 +290,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		dev_cap->bf_reg_size = 1 << (field & 0x1f);
 		MLX4_GET(field, outbox, QUERY_DEV_CAP_LOG_MAX_BF_REGS_PER_PAGE_OFFSET);
 		if ((1 << (field & 0x3f)) > (PAGE_SIZE / dev_cap->bf_reg_size)) {
-			mlx4_warn(dev, "firmware bug: log2 # of blue flame regs is invalid (%d), forcing 3\n", field & 0x1f);
+			mlx4_dbg(dev, "firmware bug: log2 # of blue flame regs is invalid (%d), forcing 3\n", field & 0x1f);
 			field = 3;
 		}
 		dev_cap->bf_regs_per_page = 1 << (field & 0x3f);
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
