From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/perfmgr: add failed port guid to error message
Date: Sat, 23 Feb 2013 16:17:41 -0800
Message-ID: <20130223161741.268622265e0282bf7b0b705a@llnl.gov>
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
 opensm/osm_perfmgr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 9bc1154..25033bd 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -831,7 +831,9 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 			    ib_node_info_get_local_port_num(&p_node->node_info);
 		} else
 			OSM_LOG(pm->log, OSM_LOG_ERROR,
-				"ERR 5487: No PerfMgr port object\n");
+				"ERR 5487: No PerfMgr port object for "
+				"port_guid 0x%"PRIx64"\n",
+				cl_ntoh64(pm->port_guid));
 		CL_PLOCK_RELEASE(pm->sm->p_lock);
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
