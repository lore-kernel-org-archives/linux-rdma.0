From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 4/4] libqedr: lower the verbosity of the destroy CQ failure message
Date: Sun, 11 Dec 2016 16:18:11 +0200
Message-ID: <1481465891-14789-5-git-send-email-Ram.Amrani@Cavium.com>
References: <1481465891-14789-1-git-send-email-Ram.Amrani@Cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481465891-14789-1-git-send-email-Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index bdcf132..415efc0 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -293,8 +293,9 @@ int qelr_destroy_cq(struct ibv_cq *ibv_cq)
 
 	rc = ibv_cmd_destroy_cq(ibv_cq);
 	if (rc) {
-		DP_ERR(cxt->dbg_fp,
-		       "destroy cq: failed to destroy %p, got %d.\n", cq, rc);
+		DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+		           "destroy cq: failed to destroy %p, got %d.\n", cq,
+			   rc);
 		return rc;
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
