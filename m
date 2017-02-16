From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 3/3] libqedr: Remove duplication of RQ configuration
Date: Thu, 16 Feb 2017 07:56:11 +0200
Message-ID: <1487224571-18627-4-git-send-email-Ram.Amrani@cavium.com>
References: <1487224571-18627-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487224571-18627-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The max_wr and max_sges are configured twice in the same function.
Remove the redundant configuration.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 932115c..95cd429 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -366,8 +366,6 @@ static inline int qelr_create_qp_buffers_rq(struct qelr_devctx *cxt,
 	max_recv_wr = min_t(uint32_t, max_recv_wr, cxt->max_recv_wr);
 	max_recv_sges = max_recv_wr * cxt->sges_per_recv_wr;
 	max_recv_buf = max_recv_sges * QELR_RQE_ELEMENT_SIZE;
-	qp->rq.max_wr = max_recv_wr;
-	qp->rq.max_sges = RDMA_MAX_SGE_PER_RQ_WQE;
 
 	chain_size = max_recv_buf;
 	rc = qelr_chain_alloc(&qp->rq.chain, chain_size, cxt->kernel_page_size,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
