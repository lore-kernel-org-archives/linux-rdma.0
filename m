From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc1 2/5] IB/mlx5: Fix reqlen validation in mlx5_ib_alloc_ucontext
Date: Thu, 28 Jan 2016 13:04:12 +0200
Message-ID: <1453979055-25285-3-git-send-email-matanb@mellanox.com>
References: <1453979055-25285-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453979055-25285-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Older libraries that don't have all the new req_v2 fields
should be able to work as well. Today, if the library uses v2, it
will fail to allocate context since the size of reqlen is smaller
than the req_v2 size.

Fix the validation to be with the original req_v2 size and not
the current.

Fixes: f72300c56c3b ('IB/mlx5: Expose CQE version to user-space')
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6f67412..03c418c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -844,6 +844,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	int err;
 	int i;
 	size_t reqlen;
+	size_t min_req_v2 = offsetof(struct mlx5_ib_alloc_ucontext_req_v2,
+				     max_cqe_version);
 
 	if (!dev->ib_active)
 		return ERR_PTR(-EAGAIN);
@@ -854,7 +856,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	reqlen = udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
 	if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req))
 		ver = 0;
-	else if (reqlen >= sizeof(struct mlx5_ib_alloc_ucontext_req_v2))
+	else if (reqlen >= min_req_v2)
 		ver = 2;
 	else
 		return ERR_PTR(-EINVAL);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
