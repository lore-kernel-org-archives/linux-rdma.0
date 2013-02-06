From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 01/10] IB/mlx4_ib: Remove local invalidate segment unused fields
Date: Wed,  6 Feb 2013 18:19:07 +0200
Message-ID: <1360167556-20756-2-git-send-email-ogerlitz@mellanox.com>
References: <1360167556-20756-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360167556-20756-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shanim-xlywION9k29BDgjK7y7TUQ@public.gmane.org, Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remove unused fields from the local invalidate WQE segment structure.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    6 ++----
 include/linux/mlx4/qp.h         |    8 +++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 19e0637..c6dde71 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1983,10 +1983,8 @@ static void set_fmr_seg(struct mlx4_wqe_fmr_seg *fseg, struct ib_send_wr *wr)
 
 static void set_local_inv_seg(struct mlx4_wqe_local_inval_seg *iseg, u32 rkey)
 {
-	iseg->flags	= 0;
-	iseg->mem_key	= cpu_to_be32(rkey);
-	iseg->guest_id	= 0;
-	iseg->pa	= 0;
+	memset(iseg, 0, sizeof(*iseg));
+	iseg->mem_key = cpu_to_be32(rkey);
 }
 
 static __always_inline void set_raddr_seg(struct mlx4_wqe_raddr_seg *rseg,
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 4b4ad6f..6c8a68c 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -304,12 +304,10 @@ struct mlx4_wqe_fmr_ext_seg {
 };
 
 struct mlx4_wqe_local_inval_seg {
-	__be32			flags;
-	u32			reserved1;
+	u64			reserved1;
 	__be32			mem_key;
-	u32			reserved2[2];
-	__be32			guest_id;
-	__be64			pa;
+	u32			reserved2;
+	u64			reserved3[2];
 };
 
 struct mlx4_wqe_raddr_seg {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
