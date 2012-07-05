From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Fix endianness of addition to mpa->private_data_size
Date: Thu,  5 Jul 2012 14:17:43 -0700
Message-ID: <1341523063-7747-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

sparse correctly warns that if mpa->private_data_size is __be16, then
doing += on it is wrong, even if we do += htons(<something>) -- on a
little endian system, carries will go the wrong way.  Fix this up by
doing the addition in native byte order.
---
Looks pretty clear to me -- I assume there's no problem merging this?

 drivers/infiniband/hw/cxgb4/cm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b18870c..51f4206 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -548,8 +548,8 @@ static void send_mpa_req(struct c4iw_ep *ep, struct sk_buff *skb,
 	}
 
 	if (mpa_rev_to_use == 2) {
-		mpa->private_data_size +=
-			htons(sizeof(struct mpa_v2_conn_params));
+		mpa->private_data_size = htons(ntohs(mpa->private_data_size) +
+					       sizeof (struct mpa_v2_conn_params));
 		mpa_v2_params.ird = htons((u16)ep->ird);
 		mpa_v2_params.ord = htons((u16)ep->ord);
 
@@ -635,8 +635,8 @@ static int send_mpa_reject(struct c4iw_ep *ep, const void *pdata, u8 plen)
 
 	if (ep->mpa_attr.version == 2 && ep->mpa_attr.enhanced_rdma_conn) {
 		mpa->flags |= MPA_ENHANCED_RDMA_CONN;
-		mpa->private_data_size +=
-			htons(sizeof(struct mpa_v2_conn_params));
+		mpa->private_data_size = htons(ntohs(mpa->private_data_size) +
+					       sizeof (struct mpa_v2_conn_params));
 		mpa_v2_params.ird = htons(((u16)ep->ird) |
 					  (peer2peer ? MPA_V2_PEER2PEER_MODEL :
 					   0));
@@ -715,8 +715,8 @@ static int send_mpa_reply(struct c4iw_ep *ep, const void *pdata, u8 plen)
 
 	if (ep->mpa_attr.version == 2 && ep->mpa_attr.enhanced_rdma_conn) {
 		mpa->flags |= MPA_ENHANCED_RDMA_CONN;
-		mpa->private_data_size +=
-			htons(sizeof(struct mpa_v2_conn_params));
+		mpa->private_data_size = htons(ntohs(mpa->private_data_size) +
+					       sizeof (struct mpa_v2_conn_params));
 		mpa_v2_params.ird = htons((u16)ep->ird);
 		mpa_v2_params.ord = htons((u16)ep->ord);
 		if (peer2peer && (ep->mpa_attr.p2p_type !=
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
