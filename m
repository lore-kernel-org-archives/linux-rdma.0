From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH net-next 1/7] RDMA/iw_cxgb4: markers_enabled module parameter should be read only once
Date: Fri, 10 Jun 2016 01:05:11 +0530
Message-ID: <1465500917-18491-2-git-send-email-hariprasad@chelsio.com>
References: <1465500917-18491-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465500917-18491-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

markers_enabled should be read only once during MPA negotiation.
The present code does read markers_enabled twice during negotiation
which results in setting wrong recv/xmit markers if the markers_enabled is
changed in the middle of negotiation.
With this change the markers_enabled is read only once during MPA
negotiation. recv markers are set based on markers enabled module
parameter and xmit markers are set based on markers flag from the
MPA_START_REQ/MPA_START_REP.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a3a67216bce6..2ba3403d8101 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -992,9 +992,19 @@ static int send_mpa_req(struct c4iw_ep *ep, struct sk_buff *skb,
 
 	mpa = (struct mpa_message *)(req + 1);
 	memcpy(mpa->key, MPA_KEY_REQ, sizeof(mpa->key));
-	mpa->flags = (crc_enabled ? MPA_CRC : 0) |
-		     (markers_enabled ? MPA_MARKERS : 0) |
-		     (mpa_rev_to_use == 2 ? MPA_ENHANCED_RDMA_CONN : 0);
+
+	mpa->flags = 0;
+	if (crc_enabled)
+		mpa->flags |= MPA_CRC;
+	if (markers_enabled) {
+		mpa->flags |= MPA_MARKERS;
+		ep->mpa_attr.recv_marker_enabled = 1;
+	} else {
+		ep->mpa_attr.recv_marker_enabled = 0;
+	}
+	if (mpa_rev_to_use == 2)
+		mpa->flags |= MPA_ENHANCED_RDMA_CONN;
+
 	mpa->private_data_size = htons(ep->plen);
 	mpa->revision = mpa_rev_to_use;
 	if (mpa_rev_to_use == 1) {
@@ -1169,8 +1179,11 @@ static int send_mpa_reply(struct c4iw_ep *ep, const void *pdata, u8 plen)
 	mpa = (struct mpa_message *)(req + 1);
 	memset(mpa, 0, sizeof(*mpa));
 	memcpy(mpa->key, MPA_KEY_REP, sizeof(mpa->key));
-	mpa->flags = (ep->mpa_attr.crc_enabled ? MPA_CRC : 0) |
-		     (markers_enabled ? MPA_MARKERS : 0);
+	mpa->flags = 0;
+	if (ep->mpa_attr.crc_enabled)
+		mpa->flags |= MPA_CRC;
+	if (ep->mpa_attr.recv_marker_enabled)
+		mpa->flags |= MPA_MARKERS;
 	mpa->revision = ep->mpa_attr.version;
 	mpa->private_data_size = htons(plen);
 
@@ -1555,7 +1568,6 @@ static int process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 	 */
 	__state_set(&ep->com, FPDU_MODE);
 	ep->mpa_attr.crc_enabled = (mpa->flags & MPA_CRC) | crc_enabled ? 1 : 0;
-	ep->mpa_attr.recv_marker_enabled = markers_enabled;
 	ep->mpa_attr.xmit_marker_enabled = mpa->flags & MPA_MARKERS ? 1 : 0;
 	ep->mpa_attr.version = mpa->revision;
 	ep->mpa_attr.p2p_type = FW_RI_INIT_P2PTYPE_DISABLED;
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
