From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ibacm/acme.c: Eliminate seg fault when source not supplied
Date: Wed, 30 May 2012 17:31:10 -0400
Message-ID: <4FC6919E.9090805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/acme.c b/src/acme.c
index d3f8174..533588c 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -618,12 +618,18 @@ static void resolve(char *svc)
 				ret = resolve_name(&path);
 				break;
 			case 'l':
-				memset(&path, 0, sizeof path);
-				ret = resolve_lid(&path);
+				if (src_addr) {
+					memset(&path, 0, sizeof path);
+					ret = resolve_lid(&path);
+				} else
+					ret = -1;
 				break;
 			case 'g':
-				memset(&path, 0, sizeof path);
-				ret = resolve_gid(&path);
+				if (src_addr) {
+					memset(&path, 0, sizeof path);
+					ret = resolve_gid(&path);
+				} else
+					ret = -1;
 				break;
 			default:
 				break;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
