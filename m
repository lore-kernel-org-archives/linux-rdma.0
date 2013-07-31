From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] update man page and usage explanation for --lfts_file
Date: Wed, 31 Jul 2013 08:42:03 -0400
Message-ID: <51F9061B.4030009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add explanation that --lfts_file is relevant when using 'file' routing
engine.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 man/opensm.8.in | 3 ++-
 opensm/main.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/man/opensm.8.in b/man/opensm.8.in
index aa4a34b..d689230 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -204,7 +204,8 @@ loaded.
 .TP
 \fB\-U\fR, \fB\-\-lfts_file\fR <file name>
 This option specifies the name of the LFTs file
-from where switch forwarding tables will be loaded.
+from where switch forwarding tables will be loaded when using "file"
routing
+engine.
 .TP
 \fB\-S\fR, \fB\-\-sadb_file\fR <file name>
 This option specifies the name of the SA DB dump file
diff --git a/opensm/main.c b/opensm/main.c
index 74dd24f..1c8ce4c 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -217,7 +217,8 @@ static void show_usage(void)
 	       "          loaded.\n\n");
 	printf("--lfts_file, -U <file name>\n"
 	       "          This option specifies the name of the LFTs file\n"
-	       "          from where switch forwarding tables will be
loaded.\n\n");
+	       "          from where switch forwarding tables will be loaded
when using \"file\"\n"
+	       "          routing engine.\n\n");
 	printf("--sadb_file, -S <file name>\n"
 	       "          This option specifies the name of the SA DB dump file\n"
 	       "          from where SA database will be loaded.\n\n");
-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
