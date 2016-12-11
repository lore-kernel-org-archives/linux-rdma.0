From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 3/4] libqedr: fix EDPM configuration
Date: Sun, 11 Dec 2016 16:18:10 +0200
Message-ID: <1481465891-14789-4-git-send-email-Ram.Amrani@Cavium.com>
References: <1481465891-14789-1-git-send-email-Ram.Amrani@Cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481465891-14789-1-git-send-email-Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The DMA length should be configured to the Enhanced Direct Packet Mode
extension header only in write and write with immediate commands.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 80e4263..bdcf132 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -989,7 +989,10 @@ static uint32_t qelr_prepare_sq_inline_data(struct qelr_qp *qp,
 
 	if (qp->edpm.is_edpm) {
 		qp->edpm.dpm_payload_size += data_size;
-		qp->edpm.rdma_ext->dma_length = htonl(data_size);
+
+		if (wr->opcode == IBV_WR_RDMA_WRITE ||
+		    wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM)
+			qp->edpm.rdma_ext->dma_length = htonl(data_size);
 	}
 
 	return data_size;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
