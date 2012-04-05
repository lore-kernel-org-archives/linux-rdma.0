From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] ibacm/acme.C: Fix typo in show_path output
Date: Thu, 05 Apr 2012 16:05:04 -0400
Message-ID: <4F7DFAF0.4030206@dev.mellanox.co.il>
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
index 3d7461b..768f17e 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -419,7 +419,7 @@ static void show_path(struct ibv_path_record *path)
 	printf("  flow label: 0x%x\n", fl_hop >> 8);
 	printf("  hop limit: %d\n", (uint8_t) fl_hop);
 	printf("  tclass: %d\n", path->tclass);
-	printf("  reverisible: %d\n", path->reversible_numpath >> 7);
+	printf("  reversible: %d\n", path->reversible_numpath >> 7);
 	printf("  pkey: 0x%x\n", ntohs(path->pkey));
 	printf("  sl: %d\n", ntohs(path->qosclass_sl) & 0xF);
 	printf("  mtu: %d\n", path->mtu & 0x1F);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
