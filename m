From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] ibacm: open only prov endpoints with name/addr configured
Date: Wed,  7 Jan 2015 15:00:21 -0500
Message-ID: <1420660821-19596-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch modifies the ibacm core so that it will request the provider to
open those endpoints that have been assigned with at least one name or address.
This change will avoid unnecessary endpoint open and close for those without
any name/address configured by the administrator.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 2d0d2e1..815a916 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1517,6 +1517,17 @@ acm_ep_insert_addr(struct acmc_ep *ep, const char *name, uint8_t *addr,
 			goto out;
 		}
 
+		/* Open the provider endpoint only if at least a name or
+		   address is found */
+		if (!ep->prov_ep_context) {
+			ret = ep->port->prov->open_endpoint(&ep->endpoint,
+				ep->port->prov_port_context, 
+				&ep->prov_ep_context);
+			if (ret) {
+				acm_log(0, "Error: failed to open prov ep\n");
+				goto out;
+			}
+		}
 		ep->addr_info[i].addr.type = addr_type;
 		strncpy(ep->addr_info[i].string_buf, name, ACM_MAX_ADDRESS);
 		memcpy(ep->addr_info[i].addr.info.addr, tmp, ACM_MAX_ADDRESS);
@@ -1735,12 +1746,6 @@ static void acm_ep_up(struct acmc_port *port, uint16_t pkey)
 	if (!ep)
 		return;
 
-	if (port->prov->open_endpoint(&ep->endpoint, port->prov_port_context, 
-				      &ep->prov_ep_context)) {
-		acm_log(0, "Error -- failed to open prov endpoint\n");
-		goto err;
-	}
-
 	ret = acm_assign_ep_names(ep);
 	if (ret) {
 		acm_log(0, "ERROR - unable to assign EP name for pkey 0x%x\n", pkey);
@@ -1751,9 +1756,9 @@ static void acm_ep_up(struct acmc_port *port, uint16_t pkey)
 	return;
 
 ep_close:
-	port->prov->close_endpoint(ep->prov_ep_context);
+	if (ep->prov_ep_context) 
+		port->prov->close_endpoint(ep->prov_ep_context);
 
-err:
 	free(ep);
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
