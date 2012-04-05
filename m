From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ibacm/acme.c: acm/acme.c: Better error handling in resolve_gid
Date: Thu, 05 Apr 2012 16:56:01 -0400
Message-ID: <4F7E06E1.1040609@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


A return of 0 is an error for inet_pton but if 0 is returned
from resolve_gid, show_path is mistakenly called so if
0 is returned from inet_pton, return -1 instead (which is
what is done elsewhere in acme). 

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/acme.c b/src/acme.c
index 3d7461b..3e5f301 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -513,13 +513,19 @@ static int resolve_gid(struct ibv_path_record *path)
 	ret = inet_pton(AF_INET6, src_addr, &path->sgid);
 	if (ret <= 0) {
 		printf("inet_pton error on source address (%s): 0x%x\n", src_addr, ret);
-		return ret;
+		if (ret)
+			return ret;
+		else
+			return -1;
 	}
 
 	ret = inet_pton(AF_INET6, dest_addr, &path->dgid);
 	if (ret <= 0) {
 		printf("inet_pton error on dest address (%s): 0x%x\n", dest_addr, ret);
-		return ret;
+		if (ret)
+			return ret;
+		else
+			return -1;
 	}
 
 	path->reversible_numpath = IBV_PATH_RECORD_REVERSIBLE | 1;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
