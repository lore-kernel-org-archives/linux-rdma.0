From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Fix for sending MPA reject frame
Date: Tue, 17 Jan 2012 10:17:30 -0600
Message-ID: <20120117161730.GA7368@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Set a reject flag, when sending MPA reject message to inform the peer
that the application has rejected the connection.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 47713f2..53c7e32 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -233,6 +233,7 @@ static int send_mpa_reject(struct nes_cm_node *cm_node)
 	u8 *start_ptr = &start_addr;
 	u8 **start_buff = &start_ptr;
 	u16 buff_len = 0;
+	struct ietf_mpa_v1 *mpa_frame;

 	skb = dev_alloc_skb(MAX_CM_BUFFER);
 	if (!skb) {
@@ -242,6 +243,8 @@ static int send_mpa_reject(struct nes_cm_node *cm_node)

 	/* send an MPA reject frame */
 	cm_build_mpa_frame(cm_node, start_buff, &buff_len, NULL, MPA_KEY_REPLY);
+	mpa_frame = (struct ietf_mpa_v1 *)*start_buff;
+	mpa_frame->flags |= IETF_MPA_FLAGS_REJECT;
 	form_cm_frame(skb, cm_node, NULL, 0, *start_buff, buff_len, SET_ACK | SET_FIN);

 	cm_node->state = NES_CM_STATE_FIN_WAIT1;
--
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
