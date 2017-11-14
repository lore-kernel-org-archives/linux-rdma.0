From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core stable-v15] verbs: Do not block QP attr_masks used
 by older kernels
Date: Tue, 14 Nov 2017 15:40:25 +0100
Message-ID: <636b5412-e41e-40ed-46da-a0e83bd5b049@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

At least the RDMA CM in 4.3 will give user space structs with these bits
set. Those kernels require user space to pass those set bits back to the
kernel. Blocking them causes RDMA CM to be unusable on older kernels.

Stable-fix: Drop changes to verbs.h of the original fix,
 that are not needed for the fix itself.

Fixes: 3ca7a1031486 ("ibverbs: Add support for packet pacing")
Commit-id: ce88cef301b ("verbs: Do not block QP attr_masks used by older kernels")
Reported-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-uk2M96/98Pc@public.gmane.org>
---

Backport from Jason's patch without the verbs.h changes to not modify the API.

 libibverbs/cmd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 9d2140fb..77aba334 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1154,10 +1154,10 @@ int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	struct ibv_query_qp_resp resp;
 
 	/*
-	 * Masks over IBV_QP_DEST_QPN are not supported by
-	 * that not extended command.
+	 * Starting with IBV_QP_RATE_LIMIT the attribute must go through the
+	 * _ex path.
 	 */
-	if (attr_mask & ~((IBV_QP_DEST_QPN << 1) - 1))
+	if (attr_mask & ~(IBV_QP_RATE_LIMIT - 1))
 		return EOPNOTSUPP;
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, QUERY_QP, &resp, sizeof resp);
@@ -1324,10 +1324,10 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		      struct ibv_modify_qp *cmd, size_t cmd_size)
 {
 	/*
-	 * Masks over IBV_QP_DEST_QPN are only supported by
-	 * ibv_cmd_modify_qp_ex.
+	 * Starting with IBV_QP_RATE_LIMIT the attribute must go through the
+	 * _ex path.
 	 */
-	if (attr_mask & ~((IBV_QP_DEST_QPN << 1) - 1))
+	if (attr_mask & ~(IBV_QP_RATE_LIMIT - 1))
 		return EOPNOTSUPP;
 
 	IBV_INIT_CMD(cmd, cmd_size, MODIFY_QP);
-- 
2.15.0.169.g3d3eebb67.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
