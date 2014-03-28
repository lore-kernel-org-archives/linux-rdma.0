From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 16/16] ibacm: remove processing of IP's from ibacm_addr.cfg
Date: Thu, 27 Mar 2014 22:50:10 -0700
Message-ID: <1395985810-23822-17-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Flag an error and do not process IP's which may appear in this file.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 651ccdd..c8a90ad 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -3115,12 +3115,10 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 			continue;
 
 		acm_log(2, "%s", s);
-		if (inet_pton(AF_INET, addr, &ip_addr) > 0) {
-			type = ACM_ADDRESS_IP;
-			addr_len = 4;
-		} else if (inet_pton(AF_INET6, addr, &ip_addr) > 0) {
-			type = ACM_ADDRESS_IP6;
-			addr_len = ACM_MAX_ADDRESS;
+		if (inet_pton(AF_INET, addr, &ip_addr) > 0
+		    || inet_pton(AF_INET6, addr, &ip_addr) > 0) {
+			acm_log(0, "ERROR - IP's are no longer supported in this config file : %s", s);
+			continue;
 		} else {
 			type = ACM_ADDRESS_NAME;
 			addr_len = strlen(addr);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
