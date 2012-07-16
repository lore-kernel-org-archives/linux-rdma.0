From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fix part_enforce parameter parsing crash
Date: Mon, 16 Jul 2012 11:57:38 +0300
Message-ID: <20120716085738.GA3470@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The default setting should use strdup, otherwise if set to different
value, opensm will crash on parsing.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 88b68d0..7372945 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -697,6 +697,7 @@ static void subn_opt_destroy(IN osm_subn_opt_t * p_opt)
 	free(p_opt->partition_config_file);
 	free(p_opt->qos_policy_file);
 	free(p_opt->dump_files_dir);
+	free(p_opt->part_enforce);
 	free(p_opt->lid_matrix_dump_file);
 	free(p_opt->lfts_file);
 	free(p_opt->root_guid_file);
@@ -1178,7 +1179,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->log_max_size = 0;
 	p_opt->partition_config_file = strdup(OSM_DEFAULT_PARTITION_CONFIG_FILE);
 	p_opt->no_partition_enforcement = FALSE;
-	p_opt->part_enforce = OSM_PARTITION_ENFORCE_BOTH;
+	p_opt->part_enforce = strdup(OSM_PARTITION_ENFORCE_BOTH);
 	p_opt->allow_both_pkeys = FALSE;
 	p_opt->sm_assigned_guid = 0;
 	p_opt->qos = FALSE;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
