From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/main.c: Handle daemon mode with guid specified as
 0 more gracefully
Date: Mon, 09 Jul 2012 13:15:10 -0400
Message-ID: <4FFB119E.2090805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


As pointed out by Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>:

Currently opensm will silently fail if you pass '-g 0 -B'. As you can't
ask for a port, exit with failure so admin can see the reason
for opensm's failure.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/main.c b/opensm/main.c
index 4218cc6..fca209a 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -1120,8 +1120,14 @@ int main(int argc, char *argv[])
 
 	block_signals();
 
-	if (opt.daemon)
+	if (opt.daemon) {
+		if (INVALID_GUID == opt.guid) {
+			fprintf(stderr,
+				"ERROR: Invalid GUID specified; exiting because of daemon mode\n");
+			return -1;
+		}
 		daemonize(&osm);
+	}
 
 	complib_init();
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
