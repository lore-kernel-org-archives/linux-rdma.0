From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/3] ibacmp: missing '%' in acm_log format
Date: Wed, 19 Nov 2014 09:46:45 -0500
Message-ID: <1416408407-6774-2-git-send-email-kaike.wan@intel.com>
References: <1416408407-6774-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416408407-6774-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This debugging print is in function acmp_get_ep().

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 prov/acmp/src/acmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/prov/acmp/src/acmp.c b/prov/acmp/src/acmp.c
index 2dd356d..7568b9c 100644
--- a/prov/acmp/src/acmp.c
+++ b/prov/acmp/src/acmp.c
@@ -2374,7 +2374,7 @@ acmp_get_ep(struct acmp_port *port, struct acm_endpoint *endpoint)
 	struct acmp_ep *ep;
 	DLIST_ENTRY *entry;
 
-	acm_log(1, "dev 0xllx port %d pkey 0x%x\n",
+	acm_log(1, "dev 0x%llx port %d pkey 0x%x\n",
 		endpoint->port->dev->dev_guid, endpoint->port->port_num, endpoint->pkey);
 	for (entry = port->ep_list.Next; entry != &port->ep_list;
 	     entry = entry->Next) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
