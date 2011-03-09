From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH/libmlx4] Return ERRNO codes from ibv_post_send/recv instead
 of -1
Date: Tue, 8 Mar 2011 18:28:10 -0700
Message-ID: <20110309012810.GM22729@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The man pages for these functions document a positive return of errno
not -1.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 src/qp.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

Noticed this.. What do you think?

I did not check the other drivers.

diff --git a/src/qp.c b/src/qp.c
index d194ae3..ec138cd 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -40,6 +40,7 @@
 #include <netinet/in.h>
 #include <pthread.h>
 #include <string.h>
+#include <errno.h>
 
 #include "mlx4.h"
 #include "doorbell.h"
@@ -206,19 +207,19 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (wq_overflow(&qp->sq, nreq, to_mcq(qp->ibv_qp.send_cq))) {
-			ret = -1;
+			ret = ENOMEM;
 			*bad_wr = wr;
 			goto out;
 		}
 
 		if (wr->num_sge > qp->sq.max_gs) {
-			ret = -1;
+			ret = ENOMEM;
 			*bad_wr = wr;
 			goto out;
 		}
 
 		if (wr->opcode >= sizeof mlx4_ib_opcode / sizeof mlx4_ib_opcode[0]) {
-			ret = -1;
+			ret = EINVAL;
 			*bad_wr = wr;
 			goto out;
 		}
@@ -309,7 +310,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 
 				if (inl > qp->max_inline_data) {
 					inl = 0;
-					ret = -1;
+					ret = ENOMEM;
 					*bad_wr = wr;
 					goto out;
 				}
@@ -450,13 +451,13 @@ int mlx4_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (wq_overflow(&qp->rq, nreq, to_mcq(qp->ibv_qp.recv_cq))) {
-			ret = -1;
+			ret = ENOMEM;
 			*bad_wr = wr;
 			goto out;
 		}
 
 		if (wr->num_sge > qp->rq.max_gs) {
-			ret = -1;
+			ret = ENOMEM;
 			*bad_wr = wr;
 			goto out;
 		}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
