From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v3 04/24] RDMA/mlx4: Fix create qp command alignment
Date: Thu, 17 Aug 2017 15:50:35 +0300
Message-ID: <20170817125055.31424-5-leon@kernel.org>
References: <20170817125055.31424-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125055.31424-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Avoid extra padding by replacing the order of inl_recv_sz and reserved,
otherwise 'mlx4_ib_create_qp' structure might be larger than legacy user
input leading to copy of some garbage data from the user space buffer.

Fixes: ea30b966f7dd ('IB/mlx4: Add inline-receive support')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/mlx4-abi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
index d915cab37ec3..21cce1a4c4dd 100644
--- a/include/uapi/rdma/mlx4-abi.h
+++ b/include/uapi/rdma/mlx4-abi.h
@@ -111,8 +111,8 @@ struct mlx4_ib_create_qp {
 	__u8	log_sq_bb_count;
 	__u8	log_sq_stride;
 	__u8	sq_no_prefetch;
-	__u32	inl_recv_sz;
 	__u8	reserved;
+	__u32	inl_recv_sz;
 };
 
 struct mlx4_ib_create_wq {
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
