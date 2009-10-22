From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm: connect roots in fat tree - usage
Date: Thu, 22 Oct 2009 11:54:25 +0200
Message-ID: <4AE02BD1.6@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add the fact that connect_roots option is valid in ftree
in the opensm usage and in the manual.

Signed-off-by:  Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/man/opensm.8.in |    4 ++--
 opensm/opensm/main.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
index 03002c0..8ef21be 100644
--- a/opensm/man/opensm.8.in
+++ b/opensm/man/opensm.8.in
@@ -170,8 +170,8 @@ recalculations: one when the host goes down, and the other when
 the host comes back online.
 .TP
 \fB\-z\fR, \fB\-\-connect_roots\fR
-This option enforces a routing engine (currently up/down
-only) to make connectivity between root switches and in
+This option enforces routing engines (up/down and
+fat-tree) to make connectivity between root switches and in
 this way to be fully IBA complaint. In many cases this can
 violate "pure" deadlock free algorithm, so use it carefully.
 .TP
diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index 2e28c83..2bb6c43 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -189,8 +189,8 @@ static void show_usage(void)
 	printf("--sm_sl <sl number>\n"
 	       "          Sets the SL to use to communicate with the SM/SA. Defaults to 0.\n\n");
 	printf("--connect_roots, -z\n"
-	       "          This option enforces a routing engine (currently\n"
-	       "          up/down only) to make connectivity between root switches\n"
+	       "          This option enforces routing engines (up/down and \n"
+	       "          fat-tree) to make connectivity between root switches\n"
 	       "          and in this way be IBA compliant. In many cases,\n"
 	       "          this can violate \"pure\" deadlock free algorithm, so\n"
 	       "          use it carefully.\n\n");
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
