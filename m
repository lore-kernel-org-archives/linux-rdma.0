From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Use smaller 512 byte messages for portmapper messages
Date: Fri, 15 Jul 2016 12:00:52 -0500
Message-ID: <1468602052-63692-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reduce memory footprint by lowering the portmapper message size
to 512 bytes.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/iwpm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index b65e06c..ade71e7 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -37,6 +37,7 @@
 #define IWPM_MAPINFO_HASH_MASK	(IWPM_MAPINFO_HASH_SIZE - 1)
 #define IWPM_REMINFO_HASH_SIZE	64
 #define IWPM_REMINFO_HASH_MASK	(IWPM_REMINFO_HASH_SIZE - 1)
+#define IWPM_MSG_SIZE		512
 
 static LIST_HEAD(iwpm_nlmsg_req_list);
 static DEFINE_SPINLOCK(iwpm_nlmsg_req_lock);
@@ -452,7 +453,7 @@ struct sk_buff *iwpm_create_nlmsg(u32 nl_op, struct nlmsghdr **nlh,
 {
 	struct sk_buff *skb = NULL;
 
-	skb = dev_alloc_skb(NLMSG_GOODSIZE);
+	skb = dev_alloc_skb(IWPM_MSG_SIZE);
 	if (!skb) {
 		pr_err("%s Unable to allocate skb\n", __func__);
 		goto create_nlmsg_exit;
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
