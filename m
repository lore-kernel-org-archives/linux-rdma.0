From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH 5/5] Remove duplicate initialization of
	scatter_ports
Date: Mon, 14 Nov 2011 14:53:42 -0800
Message-ID: <1321311222.5518.56.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_subnet.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 6b6bd63..f9327a6 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1009,7 +1009,6 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->lash_start_vl = 0;
 	p_opt->sm_sl = OSM_DEFAULT_SL;
 	p_opt->log_prefix = NULL;
-	p_opt->scatter_ports = OSM_DEFAULT_SCATTER_PORTS;
 	subn_init_qos_options(&p_opt->qos_options);
 	subn_init_qos_options(&p_opt->qos_ca_options);
 	subn_init_qos_options(&p_opt->qos_sw0_options);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
