From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa.{c,h}: osm_sa_db_file_dump() return values
Date: Thu, 21 Jan 2010 17:54:13 +0200
Message-ID: <4B5878A5.1080800@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since osm_sa_db_file_dump() doesn't have to actually dump
SA DB, reflecting this in the function return values.

Function returns 0 if the SA DB was actually dumped,
>0 if there was no need to dump the SA DB and <0 if
some error occurred.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_sa.h |    4 +++-
 opensm/opensm/osm_sa.c         |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/opensm/include/opensm/osm_sa.h b/opensm/include/opensm/osm_sa.h
index 9229d1a..d516310 100644
--- a/opensm/include/opensm/osm_sa.h
+++ b/opensm/include/opensm/osm_sa.h
@@ -436,7 +436,9 @@ int osm_sa_db_file_dump(struct osm_opensm *p_osm);
 *		[in] Pointer to an osm_opensm_t object.
 *
 * RETURN VALUES
-*	None
+*	 0 if the SA DB was actually dumped
+*	>0 if there was no need to dump the SA DB
+*	<0 if some error occurred.
 *
 *********/

diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 0d203ad..3473e4c 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -704,7 +704,7 @@ static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)

 int osm_sa_db_file_dump(osm_opensm_t * p_osm)
 {
-	int res = 0;
+	int res = 1;
 	if (p_osm->sa.dirty) {
 		res = opensm_dump_to_file(
 			p_osm, "opensm-sa.dump", sa_dump_all_sa);
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
