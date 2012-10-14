From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch libibverbs 3/5] Fix the compatibility wrapper on ppc
Date: Sun, 14 Oct 2012 13:03:01 -0400
Message-ID: <b0153c227428b8d779ac3fcabf3d1619ffbfd11b.1350234101.git.dledford@redhat.com>
References: <cover.1350234101.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1350234101.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ppc arch packs the work request struct 1.0 in such a way that
a straight memcpy won't work.  Instead, break the copy out into
chunks whenever the sizes don't match for given portions of the
struct.

Found by built in gcc memcpy buffer overflow checks.

Help on the right fix provided by Jakub Jelinek from the gcc
team inside Red Hat.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/compat-1_0.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/src/compat-1_0.c b/src/compat-1_0.c
index fff6412..36884bb 100644
--- a/src/compat-1_0.c
+++ b/src/compat-1_0.c
@@ -353,8 +353,46 @@ static int post_send_wrapper_1_0(struct ibv_qp_1_0 *qp, struct ibv_send_wr_1_0 *
 		real_wr->wr_id = w->wr_id;
 		real_wr->next  = NULL;
 
-		memcpy(&real_wr->sg_list, &w->sg_list,
-		       sizeof *w - offsetof(struct ibv_send_wr, sg_list));
+#define TEST_SIZE_2_POINT(f1, f2) \
+((offsetof(struct ibv_send_wr, f1) - offsetof(struct ibv_send_wr, f2)) \
+== offsetof(struct ibv_send_wr_1_0, f1) - offsetof(struct ibv_send_wr_1_0, f2))
+#define TEST_SIZE_TO_END(f1) \
+((sizeof(struct ibv_send_wr) - offsetof(struct ibv_send_wr, f1)) == \
+ (sizeof(struct ibv_send_wr_1_0) - offsetof(struct ibv_send_wr_1_0, f1)))
+
+		if (TEST_SIZE_TO_END (sg_list))
+			memcpy(&real_wr->sg_list, &w->sg_list, sizeof *real_wr
+			       - offsetof(struct ibv_send_wr, sg_list));
+		else if (TEST_SIZE_2_POINT (imm_data, sg_list) &&
+			 TEST_SIZE_TO_END (wr)) {
+			/* we have alignment up to wr, but padding between
+			 * imm_data and wr, and we know wr itself is the
+			 * same size */
+			memcpy(&real_wr->sg_list, &w->sg_list,
+			       offsetof(struct ibv_send_wr, imm_data) -
+			       offsetof(struct ibv_send_wr, sg_list) +
+			       sizeof real_wr->imm_data);
+			memcpy(&real_wr->wr, &w->wr, sizeof real_wr->wr);
+		} else {
+			real_wr->sg_list = w->sg_list;
+			real_wr->num_sge = w->num_sge;
+			real_wr->opcode = w->opcode;
+			real_wr->send_flags = w->send_flags;
+			real_wr->imm_data = w->imm_data;
+			if (TEST_SIZE_TO_END (wr))
+				memcpy(&real_wr->wr, &w->wr,
+				       sizeof real_wr->wr);
+			else {
+				real_wr->wr.atomic.remote_addr = 
+					w->wr.atomic.remote_addr;
+				real_wr->wr.atomic.compare_add = 
+					w->wr.atomic.compare_add;
+				real_wr->wr.atomic.swap = 
+					w->wr.atomic.swap;
+				real_wr->wr.atomic.rkey = 
+					w->wr.atomic.rkey;
+			}
+		}
 
 		if (is_ud)
 			real_wr->wr.ud.ah = w->wr.ud.ah->real_ah;
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
