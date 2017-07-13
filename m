From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] bnxt_re: Fix -Wimplicit-fallthrough warnings in GCC 7.1
Date: Thu, 13 Jul 2017 16:39:35 +0300
Message-ID: <20170713133935.1206-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

[59/189] Building C object providers/bnxt_re/CMakeFiles/bnxt_re-rdmav2.dir/verbs.c.o
../providers/bnxt_re/verbs.c: In function ‘bnxt_re_post_send’:
../providers/bnxt_re/verbs.c:1222:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
    hdr->key_immd = htole32(be32toh(wr->imm_data));
                  ^
../providers/bnxt_re/verbs.c:1223:3: note: here
   case IBV_WR_SEND:
   ^~~~
../providers/bnxt_re/verbs.c:1232:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
    hdr->key_immd = htole32(be32toh(wr->imm_data));
                  ^
../providers/bnxt_re/verbs.c:1233:3: note: here
   case IBV_WR_RDMA_WRITE:

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 1fe79671..da0fe733 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -1220,6 +1220,7 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 			 * LE platform be32toh will do the job.
 			 */
 			hdr->key_immd = htole32(be32toh(wr->imm_data));
+			/* FALLTHROUGH */
 		case IBV_WR_SEND:
 			if (qp->qptyp == IBV_QPT_UD)
 				bytes = bnxt_re_build_ud_sqe(qp, sqe, wr,
@@ -1230,6 +1231,7 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 			break;
 		case IBV_WR_RDMA_WRITE_WITH_IMM:
 			hdr->key_immd = htole32(be32toh(wr->imm_data));
+			/* FALLTHROUGH */
 		case IBV_WR_RDMA_WRITE:
 			bytes = bnxt_re_build_rdma_sqe(qp, sqe, wr, is_inline);
 			break;
-- 
2.13.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
