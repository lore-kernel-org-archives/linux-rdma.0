From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/6] Annotate correct switch fall throughs with SWITCH_FALLTHROUGH
Date: Tue, 31 Jan 2017 14:08:04 -0700
Message-ID: <1485896886-23517-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1485896886-23517-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485896886-23517-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

gcc 7.0.1 now warns on these, which actually found a bug. So lets
suppress the warning in OK places since there are not too many.

providers/mlx4/cq.c:263:17: warning: this statement may fall through [-Wimplicit-fallthrough=]
    wc->wc_flags |= IBV_WC_WITH_IMM;
    ~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/examples/asyncwatch.c | 2 ++
 librdmacm/examples/riostream.c   | 2 ++
 librdmacm/examples/rstream.c     | 2 ++
 librdmacm/examples/udpong.c      | 2 ++
 providers/mlx4/cq.c              | 3 +++
 providers/mlx5/cq.c              | 3 +++
 providers/ocrdma/ocrdma_verbs.c  | 3 +++
 providers/qedr/qelr_verbs.c      | 3 ++-
 util/compiler.h                  | 7 +++++++
 9 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/libibverbs/examples/asyncwatch.c b/libibverbs/examples/asyncwatch.c
index 7af13bf936ec10..f2234e3e540159 100644
--- a/libibverbs/examples/asyncwatch.c
+++ b/libibverbs/examples/asyncwatch.c
@@ -38,6 +38,7 @@
 #include <getopt.h>
 #include <string.h>
 
+#include <util/compiler.h>
 #include <infiniband/verbs.h>
 
 static const char *event_name_str(enum ibv_event_type event_type)
@@ -115,6 +116,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'h':
 			ret = 0;
+			SWITCH_FALLTHROUGH;
 		default:
 			usage(argv[0]);
 			return ret;
diff --git a/librdmacm/examples/riostream.c b/librdmacm/examples/riostream.c
index d9e5fd6eb0a601..2b1b3bd70cc7d4 100644
--- a/librdmacm/examples/riostream.c
+++ b/librdmacm/examples/riostream.c
@@ -46,6 +46,7 @@
 
 #include <rdma/rdma_cma.h>
 #include <rdma/rsocket.h>
+#include <util/compiler.h>
 #include "common.h"
 
 struct test_size_param {
@@ -644,6 +645,7 @@ int main(int argc, char **argv)
 			if (!set_test_opt(optarg))
 				break;
 			/* invalid option - fall through */
+			SWITCH_FALLTHROUGH;
 		default:
 			printf("usage: %s\n", argv[0]);
 			printf("\t[-s server_address]\n");
diff --git a/librdmacm/examples/rstream.c b/librdmacm/examples/rstream.c
index 14799c99712819..147466e72f9014 100644
--- a/librdmacm/examples/rstream.c
+++ b/librdmacm/examples/rstream.c
@@ -46,6 +46,7 @@
 
 #include <rdma/rdma_cma.h>
 #include <rdma/rsocket.h>
+#include <util/compiler.h>
 #include "common.h"
 
 struct test_size_param {
@@ -673,6 +674,7 @@ int main(int argc, char **argv)
 			if (!set_test_opt(optarg))
 				break;
 			/* invalid option - fall through */
+			SWITCH_FALLTHROUGH;
 		default:
 			printf("usage: %s\n", argv[0]);
 			printf("\t[-s server_address]\n");
diff --git a/librdmacm/examples/udpong.c b/librdmacm/examples/udpong.c
index 71528f22676937..37653e928a1678 100644
--- a/librdmacm/examples/udpong.c
+++ b/librdmacm/examples/udpong.c
@@ -46,6 +46,7 @@
 
 #include <rdma/rdma_cma.h>
 #include <rdma/rsocket.h>
+#include <util/compiler.h>
 #include "common.h"
 
 static int test_size[] = {
@@ -543,6 +544,7 @@ int main(int argc, char **argv)
 			if (!set_test_opt(optarg))
 				break;
 			/* invalid option - fall through */
+			SWITCH_FALLTHROUGH;
 		default:
 			printf("usage: %s\n", argv[0]);
 			printf("\t[-s server_address]\n");
diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 23cc3ed69dc8bc..4c0fb1023bd9d4 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -40,6 +40,7 @@
 #include <netinet/in.h>
 #include <string.h>
 
+#include <util/compiler.h>
 #include <infiniband/opcode.h>
 
 #include "mlx4.h"
@@ -261,11 +262,13 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
 		case MLX4_OPCODE_RDMA_WRITE_IMM:
 			wc->wc_flags |= IBV_WC_WITH_IMM;
+			SWITCH_FALLTHROUGH;
 		case MLX4_OPCODE_RDMA_WRITE:
 			wc->opcode    = IBV_WC_RDMA_WRITE;
 			break;
 		case MLX4_OPCODE_SEND_IMM:
 			wc->wc_flags |= IBV_WC_WITH_IMM;
+			SWITCH_FALLTHROUGH;
 		case MLX4_OPCODE_SEND:
 			wc->opcode    = IBV_WC_SEND;
 			break;
diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 7ad27a97f3fffd..b53fa663b01727 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -40,6 +40,7 @@
 #include <errno.h>
 #include <unistd.h>
 
+#include <util/compiler.h>
 #include <infiniband/opcode.h>
 
 #include "mlx5.h"
@@ -189,11 +190,13 @@ static inline void handle_good_req(struct ibv_wc *wc, struct mlx5_cqe64 *cqe, st
 	switch (ntohl(cqe->sop_drop_qpn) >> 24) {
 	case MLX5_OPCODE_RDMA_WRITE_IMM:
 		wc->wc_flags |= IBV_WC_WITH_IMM;
+		SWITCH_FALLTHROUGH;
 	case MLX5_OPCODE_RDMA_WRITE:
 		wc->opcode    = IBV_WC_RDMA_WRITE;
 		break;
 	case MLX5_OPCODE_SEND_IMM:
 		wc->wc_flags |= IBV_WC_WITH_IMM;
+		SWITCH_FALLTHROUGH;
 	case MLX5_OPCODE_SEND:
 	case MLX5_OPCODE_SEND_INVAL:
 		wc->opcode    = IBV_WC_SEND;
diff --git a/providers/ocrdma/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
index b11f3ecb92b3b9..4d26a720e05881 100644
--- a/providers/ocrdma/ocrdma_verbs.c
+++ b/providers/ocrdma/ocrdma_verbs.c
@@ -51,6 +51,7 @@
 #include "ocrdma_main.h"
 #include "ocrdma_abi.h"
 #include <ccan/list.h>
+#include <util/compiler.h>
 
 static void ocrdma_ring_cq_db(struct ocrdma_cq *cq, uint32_t armed,
 			      int solicited, uint32_t num_cqe);
@@ -1402,6 +1403,7 @@ int ocrdma_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 		case IBV_WR_SEND_WITH_IMM:
 			hdr->cw |= (OCRDMA_FLAG_IMM << OCRDMA_WQE_FLAGS_SHIFT);
 			hdr->immdt = ntohl(wr->imm_data);
+			SWITCH_FALLTHROUGH;
 		case IBV_WR_SEND:
 			hdr->cw |= (OCRDMA_SEND << OCRDMA_WQE_OPCODE_SHIFT);
 			status = ocrdma_build_send(qp, hdr, wr);
@@ -1409,6 +1411,7 @@ int ocrdma_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 		case IBV_WR_RDMA_WRITE_WITH_IMM:
 			hdr->cw |= (OCRDMA_FLAG_IMM << OCRDMA_WQE_FLAGS_SHIFT);
 			hdr->immdt = ntohl(wr->imm_data);
+			SWITCH_FALLTHROUGH;
 		case IBV_WR_RDMA_WRITE:
 			hdr->cw |= (OCRDMA_WRITE << OCRDMA_WQE_OPCODE_SHIFT);
 			status = ocrdma_build_write(qp, hdr, wr);
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index bb09deacbf7e55..b445991c93b9a9 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -49,6 +49,7 @@
 #include "qelr_abi.h"
 #include "qelr_chain.h"
 #include "qelr_verbs.h"
+#include <util/compiler.h>
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -1686,7 +1687,7 @@ static void __process_resp_one(struct qelr_qp *qp, struct qelr_cq *cq,
 		case QELR_RESP_RDMA_IMM:
 			/* update opcode */
 			wc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
-			/* fall to set imm data */
+			SWITCH_FALLTHROUGH;
 		case QELR_RESP_IMM:
 			wc->imm_data =
 				ntohl(le32toh(resp->imm_data_or_inv_r_Key));
diff --git a/util/compiler.h b/util/compiler.h
index 9b57e048df4b44..b2310c301b61c3 100644
--- a/util/compiler.h
+++ b/util/compiler.h
@@ -15,4 +15,11 @@
 #define uninitialized_var(x) x = x
 #endif
 
+/* Use to mark fall through on switch statements as desired. */
+#if __GNUC__ >= 7
+#define SWITCH_FALLTHROUGH __attribute__ ((fallthrough))
+#else
+#define SWITCH_FALLTHROUGH
+#endif
+
 #endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
