From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 02/10] opensm/console: protect against 0 entered for the
 perfmgr sweep_time
Date: Tue, 3 Jul 2012 16:52:50 -0700
Message-ID: <20120703165250.2285498d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



The config file already has a check for 0.  This adds the same check to the
console "perfmgr sweep_time" command.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_console.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index ad3a4d7..5b602d1 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -1471,11 +1471,20 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 			p_cmd = next_token(p_last);
 			if (p_cmd) {
 				uint16_t time_s = atoi(p_cmd);
-				osm_perfmgr_set_sweep_time_s(&p_osm->perfmgr,
-							     time_s);
+				if (time_s < 1)
+					fprintf(out,
+						"sweep_time requires a "
+						"positive time period "
+						"(in seconds) to be "
+						"specified\n");
+				else
+					osm_perfmgr_set_sweep_time_s(
+							&p_osm->perfmgr,
+							time_s);
 			} else {
 				fprintf(out,
-					"sweep_time requires a time period (in seconds) to be specified\n");
+					"sweep_time requires a time period "
+					"(in seconds) to be specified\n");
 			}
 		} else {
 			fprintf(out, "\"%s\" option not found\n", p_cmd);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
