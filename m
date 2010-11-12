From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 09/13] opensm/osm_subnet.c: Add torus-2QoS config file
 option to those configurable via opensm config file.
Date: Fri, 12 Nov 2010 15:11:18 -0700
Message-ID: <1289599882-15165-10-git-send-email-jaschut@sandia.gov>
References: <1289599882-15165-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289599882-15165-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_subnet.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index be406ac..f2ca36f 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -352,6 +352,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
 	{ "sa_db_file", OPT_OFFSET(sa_db_file), opts_parse_charp, NULL, 0 },
 	{ "sa_db_dump", OPT_OFFSET(sa_db_dump), opts_parse_boolean, NULL, 1 },
+	{ "torus_config", OPT_OFFSET(torus_conf_file), opts_parse_charp, NULL, 1 },
 	{ "do_mesh_analysis", OPT_OFFSET(do_mesh_analysis), opts_parse_boolean, NULL, 1 },
 	{ "exit_on_fatal", OPT_OFFSET(exit_on_fatal), opts_parse_boolean, NULL, 1 },
 	{ "honor_guid2lid_file", OPT_OFFSET(honor_guid2lid_file), opts_parse_boolean, NULL, 1 },
@@ -1447,6 +1448,10 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->sa_db_dump ? "TRUE" : "FALSE");
 
 	fprintf(out,
+		"# Torus-2QoS configuration file name\ntorus_config %s\n\n",
+		p_opts->torus_conf_file ? p_opts->torus_conf_file : null_str);
+
+	fprintf(out,
 		"#\n# HANDOVER - MULTIPLE SMs OPTIONS\n#\n"
 		"# SM priority used for deciding who is the master\n"
 		"# Range goes from 0 (lowest priority) to 15 (highest).\n"
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
