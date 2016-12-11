From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 1/4] libqedr: ignore inline flag in read verbs
Date: Sun, 11 Dec 2016 16:18:08 +0200
Message-ID: <1481465891-14789-2-git-send-email-Ram.Amrani@Cavium.com>
References: <1481465891-14789-1-git-send-email-Ram.Amrani@Cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481465891-14789-1-git-send-email-Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the current implementation a read verb with IBV_SEND_INLINE may be
illegally configured.
In this fix we ignore the inline bit in the case of a read verb.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index d2b34ee..fae823c 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -1027,7 +1027,9 @@ static uint32_t qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
 	rwqe2->r_key = htole32(wr->wr.rdma.rkey);
 	TYPEPTR_ADDR_SET(rwqe2, remote_va, wr->wr.rdma.remote_addr);
 
-	if (wr->send_flags & IBV_SEND_INLINE) {
+	if (wr->send_flags & IBV_SEND_INLINE &&
+	    (wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM ||
+	     wr->opcode == IBV_WR_RDMA_WRITE)) {
 		uint8_t flags = 0;
 
 		SET_FIELD2(flags, RDMA_SQ_RDMA_WQE_1ST_INLINE_FLG, 1);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
