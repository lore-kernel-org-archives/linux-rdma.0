From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4_core: Workaround firmware bug in query dev cap
Date: Wed, 10 Nov 2010 14:52:37 +0200
Message-ID: <20101110125237.GA12324@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CX firmware reports the number blue flame registers per page as log2 based
number. However, due to a firmware bug, it reports the native number. This
patch workaround this by checking if the number of calcualted fits within a
page. If it does not, it set the value to 3 which means 8 registers per page.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/fw.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 2327f9e..f1bfa8d 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -299,6 +299,10 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		MLX4_GET(field, outbox, QUERY_DEV_CAP_LOG_BF_REG_SZ_OFFSET);
 		dev_cap->bf_reg_size = 1 << (field & 0x1f);
 		MLX4_GET(field, outbox, QUERY_DEV_CAP_LOG_MAX_BF_REGS_PER_PAGE_OFFSET);
+		if ((1 << (field & 0x3f)) > (PAGE_SIZE / dev_cap->bf_reg_size)) {
+			mlx4_warn(dev, "log blue flame is invalid (%d), forcing 3\n", field & 0x1f);
+			field = 3;
+		}
 		dev_cap->bf_regs_per_page = 1 << (field & 0x3f);
 		mlx4_dbg(dev, "BlueFlame available (reg size %d, regs/page %d)\n",
 			 dev_cap->bf_reg_size, dev_cap->bf_regs_per_page);
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
