From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 14/17] RDMA/iw_cxgb4: atomic find and reference for listening endpoints
Date: Fri,  6 May 2016 22:18:07 +0530
Message-ID: <1462553290-16422-15-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add get_ep_from_stid() which will atomically find and reference the
endpoint struct if found. This avoids touch-after-free races between
threads destroying listening endpoints and the CPL processing thread
processing an incoming PASS_ACCEPT_REQ CPL.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e8edfeea84f9..4ee10547a4e4 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -342,6 +342,23 @@ static struct c4iw_ep *get_ep_from_tid(struct c4iw_dev *dev, unsigned int tid)
 	return ep;
 }
 
+/*
+ * Atomically lookup the ep ptr given the stid and grab a reference on the ep.
+ */
+static struct c4iw_listen_ep *get_ep_from_stid(struct c4iw_dev *dev,
+					       unsigned int stid)
+{
+	struct c4iw_listen_ep *ep;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	ep = idr_find(&dev->stid_idr, stid);
+	if (ep)
+		c4iw_get_ep(&ep->com);
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return ep;
+}
+
 void _c4iw_free_ep(struct kref *kref)
 {
 	struct c4iw_ep *ep;
@@ -2306,9 +2323,8 @@ fail:
 static int pass_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 {
 	struct cpl_pass_open_rpl *rpl = cplhdr(skb);
-	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int stid = GET_TID(rpl);
-	struct c4iw_listen_ep *ep = lookup_stid(t, stid);
+	struct c4iw_listen_ep *ep = get_ep_from_stid(dev, stid);
 
 	if (!ep) {
 		PDBG("%s stid %d lookup failure!\n", __func__, stid);
@@ -2317,7 +2333,7 @@ static int pass_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	PDBG("%s ep %p status %d error %d\n", __func__, ep,
 	     rpl->status, status2errno(rpl->status));
 	c4iw_wake_up(&ep->com.wr_wait, status2errno(rpl->status));
-
+	c4iw_put_ep(&ep->com);
 out:
 	return 0;
 }
@@ -2325,12 +2341,12 @@ out:
 static int close_listsrv_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 {
 	struct cpl_close_listsvr_rpl *rpl = cplhdr(skb);
-	struct tid_info *t = dev->rdev.lldi.tids;
 	unsigned int stid = GET_TID(rpl);
-	struct c4iw_listen_ep *ep = lookup_stid(t, stid);
+	struct c4iw_listen_ep *ep = get_ep_from_stid(dev, stid);
 
 	PDBG("%s ep %p\n", __func__, ep);
 	c4iw_wake_up(&ep->com.wr_wait, status2errno(rpl->status));
+	c4iw_put_ep(&ep->com);
 	return 0;
 }
 
@@ -2490,7 +2506,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	unsigned short hdrs;
 	u8 tos = PASS_OPEN_TOS_G(ntohl(req->tos_stid));
 
-	parent_ep = lookup_stid(t, stid);
+	parent_ep = (struct c4iw_ep *)get_ep_from_stid(dev, stid);
 	if (!parent_ep) {
 		PDBG("%s connect request on invalid stid %d\n", __func__, stid);
 		goto reject;
@@ -2618,6 +2634,8 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	goto out;
 reject:
 	reject_cr(dev, hwtid, skb);
+	if (parent_ep)
+		c4iw_put_ep(&parent_ep->com);
 out:
 	return 0;
 }
@@ -3868,7 +3886,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct cpl_pass_accept_req *req = (void *)(rss + 1);
 	struct l2t_entry *e;
 	struct dst_entry *dst;
-	struct c4iw_ep *lep;
+	struct c4iw_ep *lep = NULL;
 	u16 window;
 	struct port_info *pi;
 	struct net_device *pdev;
@@ -3893,7 +3911,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 	 */
 	stid = (__force int) cpu_to_be32((__force u32) rss->hash_val);
 
-	lep = (struct c4iw_ep *)lookup_stid(dev->rdev.lldi.tids, stid);
+	lep = (struct c4iw_ep *)get_ep_from_stid(dev, stid);
 	if (!lep) {
 		PDBG("%s connect request on invalid stid %d\n", __func__, stid);
 		goto reject;
@@ -3994,6 +4012,8 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 free_dst:
 	dst_release(dst);
 reject:
+	if (lep)
+		c4iw_put_ep(&lep->com);
 	return 0;
 }
 
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
