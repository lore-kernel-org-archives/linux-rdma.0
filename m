From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 10/16] ibacm: add locking around end point address arrays
Date: Thu, 27 Mar 2014 22:50:04 -0700
Message-ID: <1395985810-23822-11-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index c5da791..ebb48f4 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -92,7 +92,7 @@ enum acm_addr_preload {
 };
 
 /*
- * Nested locking order: dest -> ep, dest -> port
+ * Nested locking order: dest -> ep, dest -> port, port -> ep
  */
 struct acm_dest {
 	uint8_t                address[ACM_MAX_ADDRESS]; /* keep first */
@@ -1830,8 +1830,12 @@ acm_get_port_ep(struct acm_port *port, struct acm_ep_addr_data *data)
 		    (!data->info.path.pkey || (ntohs(data->info.path.pkey) == ep->pkey)))
 			return ep;
 
-		if (acm_addr_index(ep, data->info.addr, (uint8_t) data->type) >= 0)
+		lock_acquire(&ep->lock);
+		if (acm_addr_index(ep, data->info.addr, (uint8_t) data->type) >= 0) {
+			lock_release(&ep->lock);
 			return ep;
+		}
+		lock_release(&ep->lock);
 	}
 
 	return NULL;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
