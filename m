From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 01/13] IB/mlx5: Fix data validation in mlx5_ib_alloc_ucontext
Date: Thu, 14 Jan 2016 19:12:56 +0200
Message-ID: <1452791588-19895-2-git-send-email-majd@mellanox.com>
References: <1452791588-19895-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452791588-19895-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The wrong buffer size was passed to ib_is_udata_cleared.

Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5e3d3ae..b02bf8d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -844,6 +844,9 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (!dev->ib_active)
 		return ERR_PTR(-EAGAIN);
 
+	if (udata->inlen < sizeof(struct ib_uverbs_cmd_hdr))
+		return ERR_PTR(-EINVAL);
+
 	reqlen = udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
 	if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req))
 		ver = 0;
@@ -870,7 +873,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 
 	if (reqlen > sizeof(req) &&
 	    !ib_is_udata_cleared(udata, sizeof(req),
-				 udata->inlen - sizeof(req)))
+				 reqlen - sizeof(req)))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	req.total_num_uuars = ALIGN(req.total_num_uuars,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
