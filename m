From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: add torus-2QoS to list of supported engine names
Date: Fri, 19 Aug 2011 14:06:38 -0700
Message-ID: <20110819140638.f8f9a5dc.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_subnet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 3ba1f81..36ec3d7 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1421,7 +1421,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Multiple routing engines can be specified separated by\n"
 		"# commas so that specific ordering of routing algorithms will\n"
 		"# be tried if earlier routing engines fail.\n"
-		"# Supported engines: minhop, updn, file, ftree, lash, dor\n"
+		"# Supported engines: minhop, updn, file, ftree, lash, dor, torus-2QoS\n"
 		"routing_engine %s\n\n", p_opts->routing_engine_names ?
 		p_opts->routing_engine_names : null_str);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
