From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5 6/6] fix undefined uuar_index value assignment
Date: Wed, 27 Jul 2016 15:17:27 -0400
Message-ID: <1469647047-7544-7-git-send-email-jarod@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469647047-7544-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the case of (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK) being not
true, uuar_index gets set to resp.uuar_index, but nothing ever initializes
resp.uuar_index.

That said, both this case, and the true case, it looks like uuar_index
never gets assigned to anything but 0. In the true path, resp_ex gets
memset to 0, and then nothing ever sets uuar_index. Not sure what the
intended use was here, but ultimately, uuar_index is always going to be 0
with this patch (0 or undetermined garbage before).

Additionally, I'm not sure if the cmd and resp size parameters passed to
ibv_cmd_create_qp_ex() are correct, but they're at least larger than they
might be, which should be fine. I think. But I'm just guessing here.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/verbs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index d64e406..e88253e 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1235,12 +1235,14 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 		cmd.uidx = usr_idx;
 	}
 
-	if (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK)
+	if (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK) {
 		ret = mlx5_cmd_create_qp_ex(context, attr, &cmd, qp, &resp_ex);
-	else
+	} else {
+		memset(&resp, 0, sizeof(resp));
 		ret = ibv_cmd_create_qp_ex(context, &qp->verbs_qp, sizeof(qp->verbs_qp),
 					   attr, &cmd.ibv_cmd, sizeof(cmd),
 					   &resp.ibv_resp, sizeof(resp));
+	}
 	if (ret) {
 		mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
 		goto err_free_uidx;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
