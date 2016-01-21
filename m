From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] IB/sa: Fix netlink local service GFP crash
Date: Thu, 21 Jan 2016 08:41:31 -0500
Message-ID: <1453383691-2306-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, tgraf-G/eBtMaohhA@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, chamaken-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The rdma netlink local service registers a handler to handle RESOLVE
response and another handler to handle SET_TIMEOUT request. The first
thing these handlers do is to call netlink_capable() to check the
access right of the received skb to make sure that the sender has root
access. Under normal conditions, such responses and requests will be
directly forwarded to the handlers without going through the netlink_dump
pathway (see ibnl_rcv_msg() in drivers/infiniband/core/netlink.c).
However, a user application could send a RESOLVE request (not response)
to the local service, which will fall into the netlink_dump pathway,
where a new skb will be created without initializing the control block.
This new skb will be eventually forwarded to the local service RESOLVE
response handler. Unfortunately, netlink_capable() will cause general
protection fault if the skb's control block is not initialized. This
patch will address the problem by checking the skb first.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reported-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 1f91b6e..f334090 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -717,7 +717,9 @@ static int ib_nl_handle_set_timeout(struct sk_buff *skb,
 	struct nlattr *tb[LS_NLA_TYPE_MAX];
 	int ret;
 
-	if (!netlink_capable(skb, CAP_NET_ADMIN))
+	if (!(nlh->nlmsg_flags & NLM_F_REQUEST) ||
+	    !(NETLINK_CB(skb).sk) ||
+	    !netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
 	ret = nla_parse(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
@@ -791,7 +793,9 @@ static int ib_nl_handle_resolve_resp(struct sk_buff *skb,
 	int found = 0;
 	int ret;
 
-	if (!netlink_capable(skb, CAP_NET_ADMIN))
+	if ((nlh->nlmsg_flags & NLM_F_REQUEST) ||
+	    !(NETLINK_CB(skb).sk) ||
+	    !netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
 	spin_lock_irqsave(&ib_nl_request_lock, flags);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
