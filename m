From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa.c: enhance opensm_dump_to_file() to accept
	full path file name
Date: Thu, 08 Apr 2010 16:14:18 +0300
Message-ID: <4BBDD6AA.5050504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

Small patch that enhances opensm_dump_to_file() function
and allows it to accept full path file names as argument.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sa.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 3473e4c..8aab548 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -510,8 +510,13 @@ opensm_dump_to_file(osm_opensm_t * p_osm, const char *file_name,
 	char path[1024];
 	FILE *file;

-	snprintf(path, sizeof(path), "%s/%s",
-		 p_osm->subn.opt.dump_files_dir, file_name);
+	if (*file_name == '/')
+		/* file name was provided as an absolute path */
+		snprintf(path, sizeof(path), "%s", file_name);
+	else
+		/* file name is relative to dump_files_dir */
+		snprintf(path, sizeof(path), "%s/%s",
+			 p_osm->subn.opt.dump_files_dir, file_name);

 	file = fopen(path, "w");
 	if (!file) {
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
