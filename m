From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/5] IB/mlx5: Report that device supports user data response in create_ah
Date: Wed, 23 Nov 2016 08:23:23 +0200
Message-ID: <1479882206-31212-3-git-send-email-leon@kernel.org>
References: <1479882206-31212-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479882206-31212-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

To make mlx5 user driver aware of whether kernel driver returns dmac
in user data response add a new flag that will be returned back to
user-space through alloc_ucontext.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 3 ++-
 include/uapi/rdma/mlx5-abi.h      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8e0dbd5..527e4f5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1093,7 +1093,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 		resp.response_length += sizeof(resp.cqe_version);
 
 	if (field_avail(typeof(resp), cmds_supp_uhw, udata->outlen)) {
-		resp.cmds_supp_uhw |= MLX5_USER_CMDS_SUPP_UHW_QUERY_DEVICE;
+		resp.cmds_supp_uhw |= MLX5_USER_CMDS_SUPP_UHW_QUERY_DEVICE |
+				      MLX5_USER_CMDS_SUPP_UHW_CREATE_AH;
 		resp.response_length += sizeof(resp.cmds_supp_uhw);
 	}
 
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index f5d0f4e..ef05a98 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -82,6 +82,7 @@ enum mlx5_ib_alloc_ucontext_resp_mask {
 
 enum mlx5_user_cmds_supp_uhw {
 	MLX5_USER_CMDS_SUPP_UHW_QUERY_DEVICE = 1 << 0,
+	MLX5_USER_CMDS_SUPP_UHW_CREATE_AH    = 1 << 1,
 };
 
 struct mlx5_ib_alloc_ucontext_resp {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
