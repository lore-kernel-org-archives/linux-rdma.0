From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/11] RDMA/nes: MPA request/response error checking
Date: Wed, 9 Dec 2009 16:39:32 -0600
Message-ID: <20091209223932.GA127656@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

During Xansation testing, error handling of MPA frame msg/response is not
handled properly.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index dbe5455..ae09463 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -251,6 +251,33 @@ static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 *type,
 
 	mpa_frame = (struct ietf_mpa_frame *)buffer;
 	cm_node->mpa_frame_size = ntohs(mpa_frame->priv_data_len);
+	/* make sure mpa private data len is less than 512 bytes */
+	if (cm_node->mpa_frame_size > IETF_MAX_PRIV_DATA_LEN) {
+		nes_debug(NES_DBG_CM, "The received Length of Private"
+			" Data field exceeds 512 octets\n");
+		return -EINVAL;
+	}
+	/*
+	 * make sure MPA receiver interoperate with the
+	 * received MPA version and MPA key information
+	 *
+	 */
+	if (mpa_frame->rev != mpa_version) {
+		nes_debug(NES_DBG_CM, "The received mpa version"
+				" can not be interoperated\n");
+		return -EINVAL;
+	}
+	if (cm_node->state != NES_CM_STATE_MPAREQ_SENT) {
+		if (memcmp(mpa_frame->key, IEFT_MPA_KEY_REQ, IETF_MPA_KEY_SIZE)) {
+			nes_debug(NES_DBG_CM, "Unexpected MPA Key received \n");
+			return -EINVAL;
+		}
+	} else {
+		if (memcmp(mpa_frame->key, IEFT_MPA_KEY_REP, IETF_MPA_KEY_SIZE)) {
+			nes_debug(NES_DBG_CM, "Unexpected MPA Key received \n");
+			return -EINVAL;
+		}
+	}
 
 	if (cm_node->mpa_frame_size + sizeof(struct ietf_mpa_frame) != len) {
 		nes_debug(NES_DBG_CM, "The received ietf buffer was not right"
@@ -1974,7 +2001,7 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 	if (!cm_node)
 		return NULL;
 	mpa_frame = &cm_node->mpa_frame;
-	strcpy(mpa_frame->key, IEFT_MPA_KEY_REQ);
+	memcpy(mpa_frame->key, IEFT_MPA_KEY_REQ, IETF_MPA_KEY_SIZE);
 	mpa_frame->flags = IETF_MPA_FLAGS_CRC;
 	mpa_frame->rev =  IETF_MPA_VERSION;
 	mpa_frame->priv_data_len = htons(private_data_len);
@@ -2929,7 +2956,7 @@ int nes_reject(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 	if (cm_node->mpa_frame_size > MAX_CM_BUFFER)
 		return -EINVAL;
 
-	strcpy(&cm_node->mpa_frame.key[0], IEFT_MPA_KEY_REP);
+	memcpy(&cm_node->mpa_frame.key[0], IEFT_MPA_KEY_REP, IETF_MPA_KEY_SIZE);
 	if (loopback) {
 		memcpy(&loopback->mpa_frame.priv_data, pdata, pdata_len);
 		loopback->mpa_frame.priv_data_len = pdata_len;
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
