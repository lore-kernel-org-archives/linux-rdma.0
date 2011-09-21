From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4_core: fix allocation size
Date: Wed, 21 Sep 2011 16:31:17 +0300
Message-ID: <20110921133117.GA19540@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The num_free field of mlx4_buddy has a type of array of unsigned int while it
was allocated as an array of pointers. On 64 bit platforms it would allocate
twice more than required. Fix this by allocating the correct size for the type.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/mr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index 9c188bd..1601942 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -139,7 +139,7 @@ static int mlx4_buddy_init(struct mlx4_buddy *buddy, int max_order)
 
 	buddy->bits = kzalloc((buddy->max_order + 1) * sizeof (long *),
 			      GFP_KERNEL);
-	buddy->num_free = kzalloc((buddy->max_order + 1) * sizeof (int *),
+	buddy->num_free = kzalloc((buddy->max_order + 1) * sizeof (*buddy->num_free),
 				  GFP_KERNEL);
 	if (!buddy->bits || !buddy->num_free)
 		goto err_out;
-- 
1.7.7.rc0.70.g82660

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
