From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] ibacm/acme.c: Change format for LIDs
Date: Thu, 05 Apr 2012 16:05:14 -0400
Message-ID: <4F7DFAFA.7020908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


"Standard" format for unicast LIDs is decimal rather than hex

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/acme.c b/src/acme.c
index 3d7461b..def8942 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -413,8 +413,8 @@ static void show_path(struct ibv_path_record *path)
 	printf("  dgid: %s\n", gid);
 	inet_ntop(AF_INET6, path->sgid.raw, gid, sizeof gid);
 	printf("  sgid: %s\n", gid);
-	printf("  dlid: 0x%x\n", ntohs(path->dlid));
-	printf("  slid: 0x%x\n", ntohs(path->slid));
+	printf("  dlid: %u\n", ntohs(path->dlid));
+	printf("  slid: %u\n", ntohs(path->slid));
 	fl_hop = ntohl(path->flowlabel_hoplimit);
 	printf("  flow label: 0x%x\n", fl_hop >> 8);
 	printf("  hop limit: %d\n", (uint8_t) fl_hop);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
