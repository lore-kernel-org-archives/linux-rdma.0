From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/perfmgr: skip data counters when only printing
 errors
Date: Wed, 13 Feb 2013 13:52:03 -0800
Message-ID: <20130213135203.5a782dd09233a37a2bcb3ab2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr_db.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index ab6c978..116bb07 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -869,6 +869,9 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port, int err_only)
 			fprintf(fp, "     vl15_dropped         : %" PRIu64 "\n",
 				err->vl15_dropped);
 
+		if (err_only)
+			continue;
+
 		fprintf(fp, "     Last Data Update     : %s\n",
 			last_data_update);
 		fprintf(fp, "     xmit_data            : %" PRIu64,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
