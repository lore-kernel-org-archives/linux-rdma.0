From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: fix strtoull error handling
Date: Fri, 15 Apr 2011 15:19:22 -0700
Message-ID: <20110415151922.cd760149.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Subject: [PATCH] opensm: fix strtoull error handling

The man page states that errno _may_ be returned when the string can not be
converted.  Check that the entire string was consumed otherwise assume this is
not a guid.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 3e1575a..1cbbb71 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1419,8 +1419,9 @@ void osm_perfmgr_dump_counters(osm_perfmgr_t * pm, perfmgr_db_dump_t dump_type)
  *******************************************************************/
 void osm_perfmgr_print_counters(osm_perfmgr_t * pm, char *nodename, FILE * fp)
 {
-	uint64_t guid = strtoull(nodename, NULL, 0);
-	if (guid == 0 && errno)
+	char *end = NULL;
+	uint64_t guid = strtoull(nodename, &end, 0);
+	if (nodename + strlen(nodename) != end)
 		perfmgr_db_print_by_name(pm->db, nodename, fp);
 	else
 		perfmgr_db_print_by_guid(pm->db, guid, fp);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
