From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 2/4] libqedr: clear the flags field in the WC
Date: Sun, 11 Dec 2016 16:18:09 +0200
Message-ID: <1481465891-14789-3-git-send-email-Ram.Amrani@Cavium.com>
References: <1481465891-14789-1-git-send-email-Ram.Amrani@Cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481465891-14789-1-git-send-email-Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since the responder's WC is not zeroed we clear the flags field to avoid
random flags.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index fae823c..80e4263 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -1676,6 +1676,7 @@ static void __process_resp_one(struct qelr_qp *qp, struct qelr_cq *cq,
 	uint8_t flags;
 
 	wc->opcode = IBV_WC_RECV;
+	wc->wc_flags = 0;
 
 	FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ, "\n");
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
