From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 2/2] qedr: Convert immediate data to network order
Date: Mon, 12 Jun 2017 18:04:12 +0300
Message-ID: <1497279852-30901-3-git-send-email-Ram.Amrani@cavium.com>
References: <1497279852-30901-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497279852-30901-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Convert immediate data sent over EDPM to network order.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 358f3f7..193b274 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -922,14 +922,17 @@ static inline void qelr_edpm_set_inv_imm(struct qelr_qp *qp,
 					 struct qelr_edpm *edpm,
 					 uint32_t inv_key_or_imm_data)
 {
+	uint32_t data;
+
 	if (!edpm->is_edpm)
 		return;
 
-	memcpy(&edpm->dpm_payload[edpm->dpm_payload_offset],
-	       &inv_key_or_imm_data, sizeof(inv_key_or_imm_data));
+	data = htobe32(inv_key_or_imm_data);
+
+	memcpy(&edpm->dpm_payload[edpm->dpm_payload_offset], &data, sizeof(data));
 
-	edpm->dpm_payload_offset += sizeof(inv_key_or_imm_data);
-	edpm->dpm_payload_size += sizeof(inv_key_or_imm_data);
+	edpm->dpm_payload_offset += sizeof(data);
+	edpm->dpm_payload_size += sizeof(data);
 }
 
 static inline void qelr_edpm_set_rdma_ext(struct qelr_qp *qp,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
