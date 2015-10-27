From: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/sa: replace GFP_KERNEL with GFP_ATOMIC
Date: Tue, 27 Oct 2015 21:17:40 +0530
Message-ID: <1445960860-3396-1-git-send-email-saurabh.truth@gmail.com>
References: <saurabh.truth@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

replace GFP_KERNEL with GFP_ATOMIC, as code while holding a spinlock
should be atomic
GFP_KERNEL may sleep and can cause deadlock, where as GFP_ATOMIC may
fail but certainly avoids deadlock

Signed-off-by: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 8c014b3..cd1f911 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -526,7 +526,7 @@ static int ib_nl_send_msg(struct ib_sa_query *query)
 	if (len <= 0)
 		return -EMSGSIZE;
 
-	skb = nlmsg_new(len, GFP_KERNEL);
+	skb = nlmsg_new(len, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -544,7 +544,7 @@ static int ib_nl_send_msg(struct ib_sa_query *query)
 	/* Repair the nlmsg header length */
 	nlmsg_end(skb, nlh);
 
-	ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_LS, GFP_KERNEL);
+	ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_LS, GFP_ATOMIC);
 	if (!ret)
 		ret = len;
 	else
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
