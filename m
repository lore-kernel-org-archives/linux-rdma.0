From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 10/45] RDMA/cxgb3: Remove a set-but-not-used variable
Date: Wed, 11 Oct 2017 10:48:52 -0700
Message-ID: <20171011174927.25113-11-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_cm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 86975370a4c0..edc1c549289e 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1760,8 +1760,8 @@ static void ep_timeout(unsigned long arg)
 
 int iwch_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 {
-	int err;
 	struct iwch_ep *ep = to_ep(cm_id);
+
 	pr_debug("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 
 	if (state_read(&ep->com) == DEAD) {
@@ -1772,8 +1772,8 @@ int iwch_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 	if (mpa_rev == 0)
 		abort_connection(ep, NULL, GFP_KERNEL);
 	else {
-		err = send_mpa_reject(ep, pdata, pdata_len);
-		err = iwch_ep_disconnect(ep, 0, GFP_KERNEL);
+		send_mpa_reject(ep, pdata, pdata_len);
+		iwch_ep_disconnect(ep, 0, GFP_KERNEL);
 	}
 	put_ep(&ep->com);
 	return 0;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
