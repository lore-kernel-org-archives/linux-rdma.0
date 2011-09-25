From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/4] amso1100/iw_cxgb3: Minimal MPAv2 support
Date: Sun, 25 Sep 2011 20:17:45 +0530
Message-ID: <1316962066-28701-4-git-send-email-kumaras@chelsio.com>
References: <1316962066-28701-1-git-send-email-kumaras@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316962066-28701-1-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As part of MPAv2 Enhanced RDMA Negotiation, pass max supported
ird/ord values upwards for the time-being in iw-cxgb3 and
amso1100.

Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2_ae.c   |    5 +++++
 drivers/infiniband/hw/amso1100/c2_intr.c |    5 +++++
 drivers/infiniband/hw/cxgb3/iwch_cm.c    |   10 ++++++++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_ae.c b/drivers/infiniband/hw/amso1100/c2_ae.c
index 24f9e3a..6eb6fce 100644
--- a/drivers/infiniband/hw/amso1100/c2_ae.c
+++ b/drivers/infiniband/hw/amso1100/c2_ae.c
@@ -288,6 +288,11 @@ void c2_ae_event(struct c2_dev *c2dev, u32 mq_index)
 		cm_event.private_data_len =
 			be32_to_cpu(req->private_data_length);
 		cm_event.private_data = req->private_data;
+		/*
+		 * Until ird/ord negotiation via MPA_v2 support is added, send
+		 * max supported values
+		 */
+		cm_event.ird = cm_event.ord = 128;
 
 		if (cm_id->event_handler)
 			cm_id->event_handler(cm_id, &cm_event);
diff --git a/drivers/infiniband/hw/amso1100/c2_intr.c b/drivers/infiniband/hw/amso1100/c2_intr.c
index 0ebe4e8..846e9bd 100644
--- a/drivers/infiniband/hw/amso1100/c2_intr.c
+++ b/drivers/infiniband/hw/amso1100/c2_intr.c
@@ -183,6 +183,11 @@ static void handle_vq(struct c2_dev *c2dev, u32 mq_index)
 	case IW_CM_EVENT_ESTABLISHED:
 		c2_set_qp_state(req->qp,
 				C2_QP_STATE_RTS);
+		/*
+		 * Until ird/ord negotiation via MPA_v2 support is added, send
+		 * max supported values
+		 */
+		cm_event.ird = cm_event.ord = 128;
 	case IW_CM_EVENT_CLOSE:
 
 		/*
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 17bf9d9..9c552d1 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -753,6 +753,11 @@ static void connect_request_upcall(struct iwch_ep *ep)
 	event.private_data_len = ep->plen;
 	event.private_data = ep->mpa_pkt + sizeof(struct mpa_message);
 	event.provider_data = ep;
+	/*
+	 * Until ird/ord negotiation via MPA_v2 support is added, send max
+	 * supported values
+	 */
+	event.ird = event.ord = 8;
 	if (state_read(&ep->parent_ep->com) != DEAD) {
 		get_ep(&ep->com);
 		ep->parent_ep->com.cm_id->event_handler(
@@ -770,6 +775,11 @@ static void established_upcall(struct iwch_ep *ep)
 	PDBG("%s ep %p\n", __func__, ep);
 	memset(&event, 0, sizeof(event));
 	event.event = IW_CM_EVENT_ESTABLISHED;
+	/*
+	 * Until ird/ord negotiation via MPA_v2 support is added, send max
+	 * supported values
+	 */
+	event.ird = event.ord = 8;
 	if (ep->com.cm_id) {
 		PDBG("%s ep %p tid %d\n", __func__, ep, ep->hwtid);
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
