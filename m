From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] IB/sa: Restrict SA Netlink to admin users
Date: Thu,  6 Aug 2015 17:08:30 -0400
Message-ID: <1438895310-6087-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The recently added SA Netlink service requires admin privileges to receive
kernel requests.  This is only partially sufficient to protect the kernel from
malicious users.  This patch fixes two issues.

	1) Path responses from user space could be spoofed if the sequence
	   number was properly guessed.
	2) The set timeout request message could be issued by any user.

Ignore these messages if not submitted by an admin user.

Fixes: 6619209af36c ("IB/sa: Route SA pathrecord query through netlink")
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Doug let me know if you would prefer that I get Kaike to squash this into the
original patch.

 drivers/infiniband/core/sa_query.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 70ceec4df02a..52be6d71b2f4 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -49,6 +49,7 @@
 #include <net/netlink.h>
 #include <uapi/rdma/ib_user_sa.h>
 #include <rdma/ib_marshall.h>
+#include <net/sock.h>
 #include "sa.h"
 
 MODULE_AUTHOR("Roland Dreier");
@@ -699,6 +700,12 @@ static int ib_nl_handle_set_timeout(struct sk_buff *skb,
 	struct nlattr *tb[LS_NLA_TYPE_MAX + 1];
 	int ret;
 
+	if (!ns_capable(sock_net(skb->sk)->user_ns, CAP_NET_ADMIN)) {
+		pr_warn_ratelimited("SA netlink: invalid perm for set timeout: `%s'.\n",
+				    current->comm);
+		return -EPERM;
+	}
+
 	ret = nla_parse(tb, LS_NLA_TYPE_MAX, nlmsg_data(nlh), nlmsg_len(nlh),
 			NULL);
 	attr = (const struct nlattr *)tb[LS_NLA_TYPE_TIMEOUT];
@@ -706,6 +713,9 @@ static int ib_nl_handle_set_timeout(struct sk_buff *skb,
 		goto settimeout_out;
 
 	timeout = *(int *) nla_data(attr);
+
+	pr_info("SA netlink: timeout: %d\n", timeout);
+
 	if (timeout < IB_SA_LOCAL_SVC_TIMEOUT_MIN)
 		timeout = IB_SA_LOCAL_SVC_TIMEOUT_MIN;
 	if (timeout > IB_SA_LOCAL_SVC_TIMEOUT_MAX)
@@ -754,6 +764,12 @@ static int ib_nl_handle_resolve_resp(struct sk_buff *skb,
 	int found = 0;
 	int ret;
 
+	if (!ns_capable(sock_net(skb->sk)->user_ns, CAP_NET_ADMIN)) {
+		pr_warn_ratelimited("SA netlink: invalid perm for response: `%s'.\n",
+				    current->comm);
+		return -EPERM;
+	}
+
 	spin_lock_irqsave(&ib_nl_request_lock, flags);
 	list_for_each_entry(query, &ib_nl_request_list, list) {
 		/*
@@ -770,6 +786,7 @@ static int ib_nl_handle_resolve_resp(struct sk_buff *skb,
 
 	if (!found) {
 		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+		pr_err_ratelimited("SA netlink: got unmatched response\n");
 		goto resp_out;
 	}
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
