From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] ibacm: Incorrect return value check in path resolution
Date: Thu, 17 Jul 2014 14:32:39 -0400
Message-ID: <1405621959-31295-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The returned variable "addr" should be checked instead of the variable "ep" in
the function acm_svr_resolve_path() when query parameters are given in a path
record (eg, slid/dlid, sgid/dgid, etc).

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index fae9d0b..11fda4c 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -946,7 +946,7 @@ acm_svr_resolve_path(struct acmc_client *client, struct acm_msg *msg)
 		msg->resolve_data[0].info.addr, sizeof *path);
 	acm_log(2, "path %s\n", log_data);
 	addr = acm_get_ep_address(&msg->resolve_data[0]);
-	if (!ep) {
+	if (!addr) {
 		acm_log(0, "notice - unknown local end point address\n");
 		return acmc_resolve_response(client->index, msg,
 					     ACM_STATUS_ESRCADDR);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
