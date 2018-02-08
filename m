From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
Date: Thu, 8 Feb 2018 16:38:29 -0700
Message-ID: <20180208233829.GA16128@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

They produce the value INT32_MIN not 0x80000000. This is sometimes OK
if it is casted appropriately but leaves a subtle trap to the user.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4dv.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index d47d3cd2e1f135..5312a866b6e281 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -288,12 +288,12 @@ enum {
 };
 
 enum {
-	MLX4_WQE_BIND_TYPE_2		= (1<<31),
+	MLX4_WQE_BIND_TYPE_2		= (1UL<<31),
 	MLX4_WQE_BIND_ZERO_BASED	= (1<<30),
 };
 
 enum {
-	MLX4_INLINE_SEG		= 1 << 31,
+	MLX4_INLINE_SEG		= 1UL << 31,
 	MLX4_INLINE_ALIGN	= 64,
 };
 
@@ -304,7 +304,7 @@ enum {
 enum {
 	MLX4_WQE_MW_REMOTE_READ   = 1 << 29,
 	MLX4_WQE_MW_REMOTE_WRITE  = 1 << 30,
-	MLX4_WQE_MW_ATOMIC        = 1 << 31
+	MLX4_WQE_MW_ATOMIC        = 1UL << 31
 };
 
 struct mlx4_wqe_local_inval_seg {
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
