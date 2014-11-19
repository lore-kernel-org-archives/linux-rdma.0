From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/3] ibacm/ibacmp: fix a crash when SM restarts
Date: Wed, 19 Nov 2014 09:46:47 -0500
Message-ID: <1416408407-6774-4-git-send-email-kaike.wan@intel.com>
References: <1416408407-6774-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416408407-6774-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Ibacm may cause segfault when the SM restarts: when the SM restarts, ibacm will
receive P_Key change event and instruct ibacmp to close all endpoints. However,
ibacmp only resets the core endpoint pointer in its ep structure and keeps the ep
in the port's ep_list. Afterwards, the ibacm core will ask ibacmp to create
an ep for each pkey enumerated from the local port. The ep will be found
from the port's ep_list if it exists. However, if an old pkey is not present
in the new SM configuration, the old ep will still be linked in the port's
ep_list with the ep->endpoint being set to NULL. When the ibacm core forwards
the client reregistration event to ibacmp, ibacmp will enumerate the ep_list and
try to join multicast group for each ep, including any one with ep->endpoint
set to NULL. In this case, it will cause segfault in acm_send_sa_mad().
Additional check should be able to avoid the crash.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 prov/acmp/src/acmp.c |    4 ++++
 src/acm.c            |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/prov/acmp/src/acmp.c b/prov/acmp/src/acmp.c
index 7568b9c..2b85958 100644
--- a/prov/acmp/src/acmp.c
+++ b/prov/acmp/src/acmp.c
@@ -1446,6 +1446,10 @@ static int acmp_port_join(void *port_context)
 	for (ep_entry = port->ep_list.Next; ep_entry != &port->ep_list;
 		 ep_entry = ep_entry->Next) {
 		ep = container_of(ep_entry, struct acmp_ep, entry);
+		if (!ep->endpoint) {
+			/* Stale endpoint */
+			continue;
+		}
 		acmp_ep_join(ep);
 	}
 	acm_log(1, "joins for device %s port %d complete\n",
diff --git a/src/acm.c b/src/acm.c
index d807c73..2d0d2e1 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -2352,6 +2352,10 @@ acm_alloc_sa_mad(const struct acm_endpoint *endpoint, void *context,
 {
 	struct acmc_sa_req *req;
 
+	if (!endpoint) {
+		acm_log(0, "Error: NULL endpoint\n");
+		return NULL;
+	}
 	req = calloc(1, sizeof (*req));
 	if (!req) {
 		acm_log(0, "Error: failed to allocate sa request\n");
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
