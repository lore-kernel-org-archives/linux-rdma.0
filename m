From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/3] ibacm: close the provider endpoint when it fails to assign a name to a core endpoint
Date: Wed, 19 Nov 2014 09:46:46 -0500
Message-ID: <1416408407-6774-3-git-send-email-kaike.wan@intel.com>
References: <1416408407-6774-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416408407-6774-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In function acm_ep_up(), when it fails to assign any name to an endpoint, the
endpoint in the provider is not properly closed before the core endpoint is
freed. This may cause segfault when ibacmp tries to join multicast group with 
a stale core endpoint pointer.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 11fda4c..d807c73 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1744,12 +1744,15 @@ static void acm_ep_up(struct acmc_port *port, uint16_t pkey)
 	ret = acm_assign_ep_names(ep);
 	if (ret) {
 		acm_log(0, "ERROR - unable to assign EP name for pkey 0x%x\n", pkey);
-		goto err;
+		goto ep_close;
 	}
 
 	DListInsertHead(&ep->entry, &port->ep_list);
 	return;
 
+ep_close:
+	port->prov->close_endpoint(ep->prov_ep_context);
+
 err:
 	free(ep);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
