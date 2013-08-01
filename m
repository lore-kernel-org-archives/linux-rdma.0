From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm] acm.c: In acm_ep_up, fix pkey endian
Date: Thu, 01 Aug 2013 13:24:59 -0400
Message-ID: <51FA99EB.2070706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


ibv_query_pkey returns pkey in network rather than host order.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/acm.c b/src/acm.c
index 09051dc..401e367 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -3068,6 +3068,7 @@ static void acm_ep_up(struct acm_port *port, uint16_t pkey_index)
 	if (ret)
 		return;
 
+	pkey = ntohs(pkey);	/* pkey returned is in network rather than host endian */
 	if (acm_find_ep(port, pkey)) {
 		acm_log(2, "endpoint for pkey 0x%x already exists\n", pkey);
 		return;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
