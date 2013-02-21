From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibumad: Fix memory leak in resolve_ca_port
Date: Thu, 21 Feb 2013 12:06:53 -0500
Message-ID: <5126542D.8000007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/umad.c b/src/umad.c
index 45a9423..8f817d2 100644
--- a/src/umad.c
+++ b/src/umad.c
@@ -234,7 +234,7 @@ static int resolve_ca_port(char *ca_name, int *port)
 {
 	umad_ca_t ca;
 	int active = -1, up = -1;
-	int i;
+	int i, ret = 0;
 
 	TRACE("checking ca '%s'", ca_name);
 
@@ -243,19 +243,27 @@ static int resolve_ca_port(char *ca_name, int *port)
 
 	if (ca.node_type == 2) {
 		*port = 0;	/* switch sma port 0 */
-		return 1;
+		ret = 1;
+		goto Exit;
 	}
 
 	if (*port > 0) {	/* check only the port the user wants */
-		if (*port > ca.numports)
-			return -1;
-		if (!ca.ports[*port])
-			return -1;
-		if (ca.ports[*port]->state == 4)
-			return 1;
+		if (*port > ca.numports) {
+			ret = -1;
+			goto Exit;
+		}
+		if (!ca.ports[*port]) {
+			ret = -1;
+			goto Exit;
+		}
+		if (ca.ports[*port]->state == 4) {
+			ret = 1;
+			goto Exit;
+		}
 		if (ca.ports[*port]->phys_state != 3)
-			return 0;
-		return -1;
+			goto Exit;
+		ret = -1;
+		goto Exit;
 	}
 
 	for (i = 0; i <= ca.numports; i++) {
@@ -283,13 +291,18 @@ static int resolve_ca_port(char *ca_name, int *port)
 		}
 	}
 
+	if (active >= 0) {
+		ret = 1;
+		goto Exit;
+	}
+	if (up >= 0) {
+		ret = 0;
+		goto Exit;
+	}
+	ret = -1;
+Exit:
 	release_ca(&ca);
-
-	if (active >= 0)
-		return 1;
-	if (up >= 0)
-		return 0;
-	return -1;
+	return ret;
 }
 
 static char *resolve_ca_name(char *ca_name, int *best_port)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
