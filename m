From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/5] ibverbs: Align ibv_create_flow with man page
Date: Sun,  6 Nov 2016 16:42:45 +0200
Message-ID: <1478443369-8208-2-git-send-email-yishaih@mellanox.com>
References: <1478443369-8208-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478443369-8208-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Based on man page:
".. or NULL if the request fails. In case of an error, errno is updated".

Align some error flows with above statement.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c   | 6 ++++--
 libibverbs/verbs.h | 4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 06a017b..496d27b 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1619,7 +1619,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		       sizeof(struct ibv_flow_tcp_udp_filter));
 		break;
 	default:
-		return -EINVAL;
+		return EINVAL;
 	}
 	return 0;
 }
@@ -1656,8 +1656,10 @@ struct ibv_flow *ibv_cmd_create_flow(struct ibv_qp *qp,
 	ib_spec = flow_attr + 1;
 	for (i = 0; i < flow_attr->num_of_specs; i++) {
 		err = ib_spec_to_kern_spec(ib_spec, kern_spec);
-		if (err)
+		if (err) {
+			errno = err;
 			goto err;
+		}
 		cmd->flow_attr.size +=
 			((struct ibv_kern_spec *)kern_spec)->hdr.size;
 		kern_spec += ((struct ibv_kern_spec *)kern_spec)->hdr.size;
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index a2ccaaf..67a44a7 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1590,8 +1590,10 @@ static inline struct ibv_flow *ibv_create_flow(struct ibv_qp *qp,
 {
 	struct verbs_context *vctx = verbs_get_ctx_op(qp->context,
 						      ibv_create_flow);
-	if (!vctx || !vctx->ibv_create_flow)
+	if (!vctx || !vctx->ibv_create_flow) {
+		errno = ENOSYS;
 		return NULL;
+	}
 
 	return vctx->ibv_create_flow(qp, flow);
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
