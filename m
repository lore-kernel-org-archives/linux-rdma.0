From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibumad/umad.c: In resolve_ca_port, skip ethernet link
 layer ports
Date: Thu, 21 Feb 2013 14:01:51 -0500
Message-ID: <51266F1F.608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/umad.c b/src/umad.c
index 8f817d2..8ab5e80 100644
--- a/src/umad.c
+++ b/src/umad.c
@@ -256,6 +256,11 @@ static int resolve_ca_port(char *ca_name, int *port)
 			ret = -1;
 			goto Exit;
 		}
+		if (strcmp(ca.ports[*port]->link_layer, "InfiniBand") &&
+		    strcmp(ca.ports[*port]->link_layer, "IB")) {
+			ret = -1;
+			goto Exit;
+		}
 		if (ca.ports[*port]->state == 4) {
 			ret = 1;
 			goto Exit;
@@ -270,6 +275,9 @@ static int resolve_ca_port(char *ca_name, int *port)
 		DEBUG("checking port %d", i);
 		if (!ca.ports[i])
 			continue;
+		if (strcmp(ca.ports[i]->link_layer, "InfiniBand") &&
+		    strcmp(ca.ports[i]->link_layer, "IB"))
+			continue;
 		if (up < 0 && ca.ports[i]->phys_state == 5)
 			up = *port = i;
 		if (ca.ports[i]->state == 4) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
