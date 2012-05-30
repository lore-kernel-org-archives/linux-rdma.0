From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ibacm/acm.c: Make sure shift for subnet timeout is not negative
Date: Wed, 30 May 2012 17:31:02 -0400
Message-ID: <4FC69196.9070200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


in acm_port_up

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/acm.c b/src/acm.c
index b47ee8a..c40f079 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -2794,7 +2794,8 @@ static void acm_port_up(struct acm_port *port)
 
 	port->mtu = attr.active_mtu;
 	port->rate = acm_get_rate(attr.active_width, attr.active_speed);
-	port->subnet_timeout = 1 << (attr.subnet_timeout - 8);
+	if (attr.subnet_timeout >= 8)
+		port->subnet_timeout = 1 << (attr.subnet_timeout - 8);
 	for (port->gid_cnt = 0;; port->gid_cnt++) {
 		ret = ibv_query_gid(port->dev->verbs, port->port_num, port->gid_cnt, &gid);
 		if (ret || !gid.global.interface_id)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
