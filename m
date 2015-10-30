From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 1/1] IB/sa: Put netlink request into the request list before sending
Date: Fri, 30 Oct 2015 08:23:45 -0400
Message-ID: <1446207825-17664-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It was found by Saurabh Sengar that the netlink code tried to allocate
memory with GFP_KERNEL while holding a spinlock. While it is possible
to fix the issue by replacing GFP_KERNEL with GFP_ATOMIC, it is better
to get rid of the spinlock while sending the packet. However, in order
to protect against a race condition that a quick response may be received
before the request is put on the request list, we need to put the request
on the list first.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This patch is based on Doug's k.o/for-4.4 branch

Changes since v1:
-- Pass gfp_mask to ib_nl_send_msg for internal memory allocation, as suggested
   by Ira Weiny;
-- Queue the netlink timeout work before the request is sent to avoid potential
   race condition where the query is freed by the response handler.

 drivers/infiniband/core/sa_query.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index dcdaa79..1495c00 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -512,7 +512,7 @@ static int ib_nl_get_path_rec_attrs_len(ib_sa_comp_mask comp_mask)
 	return len;
 }
 
-static int ib_nl_send_msg(struct ib_sa_query *query)
+static int ib_nl_send_msg(struct ib_sa_query *query, gfp_t gfp_mask)
 {
 	struct sk_buff *skb = NULL;
 	struct nlmsghdr *nlh;
@@ -526,7 +526,7 @@ static int ib_nl_send_msg(struct ib_sa_query *query)
 	if (len <= 0)
 		return -EMSGSIZE;
 
-	skb = nlmsg_new(len, GFP_KERNEL);
+	skb = nlmsg_new(len, gfp_mask);
 	if (!skb)
 		return -ENOMEM;
 
@@ -544,7 +544,7 @@ static int ib_nl_send_msg(struct ib_sa_query *query)
 	/* Repair the nlmsg header length */
 	nlmsg_end(skb, nlh);
 
-	ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_LS, GFP_KERNEL);
+	ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_LS, gfp_mask);
 	if (!ret)
 		ret = len;
 	else
@@ -553,7 +553,7 @@ static int ib_nl_send_msg(struct ib_sa_query *query)
 	return ret;
 }
 
-static int ib_nl_make_request(struct ib_sa_query *query)
+static int ib_nl_make_request(struct ib_sa_query *query, gfp_t gfp_mask)
 {
 	unsigned long flags;
 	unsigned long delay;
@@ -562,25 +562,27 @@ static int ib_nl_make_request(struct ib_sa_query *query)
 	INIT_LIST_HEAD(&query->list);
 	query->seq = (u32)atomic_inc_return(&ib_nl_sa_request_seq);
 
+	/* Put the request on the list first.*/
 	spin_lock_irqsave(&ib_nl_request_lock, flags);
-	ret = ib_nl_send_msg(query);
-	if (ret <= 0) {
-		ret = -EIO;
-		goto request_out;
-	} else {
-		ret = 0;
-	}
-
 	delay = msecs_to_jiffies(sa_local_svc_timeout_ms);
 	query->timeout = delay + jiffies;
 	list_add_tail(&query->list, &ib_nl_request_list);
 	/* Start the timeout if this is the only request */
 	if (ib_nl_request_list.next == &query->list)
 		queue_delayed_work(ib_nl_wq, &ib_nl_timed_work, delay);
-
-request_out:
 	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
 
+	ret = ib_nl_send_msg(query, gfp_mask);
+	if (ret <= 0) {
+		ret = -EIO;
+		/* Remove the request */
+		spin_lock_irqsave(&ib_nl_request_lock, flags);
+		list_del(&query->list);
+		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+	} else {
+		ret = 0;
+	}
+
 	return ret;
 }
 
@@ -1108,7 +1110,7 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 
 	if (query->flags & IB_SA_ENABLE_LOCAL_SERVICE) {
 		if (!ibnl_chk_listeners(RDMA_NL_GROUP_LS)) {
-			if (!ib_nl_make_request(query))
+			if (!ib_nl_make_request(query, gfp_mask))
 				return id;
 		}
 		ib_sa_disable_local_svc(query);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
