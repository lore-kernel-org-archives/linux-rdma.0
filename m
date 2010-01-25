From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_qos.c: Eliminate unneeded endport SL to VL setup
Date: Mon, 25 Jan 2010 08:29:37 -0500
Message-ID: <20100125132937.GA2053@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


when using optimized programming and it's supported by the switch

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index 6bbbfa2..afa454f 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -305,6 +305,12 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 			    (&p_node->sw->switch_info))
 				continue;
 
+			if (ib_switch_info_get_opt_sl2vlmapping(&p_node->sw->switch_info) &&
+			    p_osm->sm.p_subn->opt.use_optimized_slvl &&
+			    !memcmp(&swe_config.sl2vl, &sw0_config.sl2vl,
+				    sizeof(swe_config.sl2vl)))
+				continue;
+
 			cfg = &sw0_config;
 		} else if (osm_node_get_type(p_node) == IB_NODE_TYPE_ROUTER)
 			cfg = &rtr_config;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
