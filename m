From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 08/11] RDMA/cxgb4: don't reconnect on abort for mpa_rev 1
Date: Mon,  7 Jan 2013 18:41:57 +0530
Message-ID: <1357564320-15022-9-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

only reconnect if the endpoint wasn't freed.

peer_abort() should only attempt to reconnect if the endpoint wasn't freed.
Also remove hwtid from the debugfs idr.

Add missing check for peer2peer in MPAv2 code

use correct mpa version on reject.

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index ab5b4dd..88933af 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -284,10 +284,10 @@ void _c4iw_free_ep(struct kref *kref)
 	if (test_bit(QP_REFERENCED, &ep->com.flags))
 		deref_qp(ep);
 	if (test_bit(RELEASE_RESOURCES, &ep->com.flags)) {
+		remove_handle(ep->com.dev, &ep->com.dev->hwtid_idr, ep->hwtid);
 		cxgb4_remove_tid(ep->com.dev->rdev.lldi.tids, 0, ep->hwtid);
 		dst_release(ep->dst);
 		cxgb4_l2t_release(ep->l2t);
-		remove_handle(ep->com.dev, &ep->com.dev->hwtid_idr, ep->hwtid);
 	}
 	kfree(ep);
 }
@@ -699,7 +699,7 @@ static int send_mpa_reject(struct c4iw_ep *ep, const void *pdata, u8 plen)
 	memset(mpa, 0, sizeof(*mpa));
 	memcpy(mpa->key, MPA_KEY_REP, sizeof(mpa->key));
 	mpa->flags = MPA_REJECT;
-	mpa->revision = mpa_rev;
+	mpa->revision = ep->mpa_attr.version;
 	mpa->private_data_size = htons(plen);
 
 	if (ep->mpa_attr.version == 2 && ep->mpa_attr.enhanced_rdma_conn) {
@@ -2176,7 +2176,7 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		break;
 	case MPA_REQ_SENT:
 		stop_ep_timer(ep);
-		if (mpa_rev == 2 && ep->tried_with_mpa_v1)
+		if (mpa_rev == 1 || (mpa_rev == 2 && ep->tried_with_mpa_v1))
 			connect_reply_upcall(ep, -ECONNRESET);
 		else {
 			/*
@@ -2248,9 +2248,8 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 out:
 	if (release)
 		release_ep_resources(ep);
-
-	/* retry with mpa-v1 */
-	if (ep && ep->retry_with_mpa_v1) {
+	else if (ep->retry_with_mpa_v1) {
+		remove_handle(ep->com.dev, &ep->com.dev->hwtid_idr, ep->hwtid);
 		cxgb4_remove_tid(ep->com.dev->rdev.lldi.tids, 0, ep->hwtid);
 		dst_release(ep->dst);
 		cxgb4_l2t_release(ep->l2t);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
