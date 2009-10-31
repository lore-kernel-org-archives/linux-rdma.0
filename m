From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/link_mgr: verify port's lid
Date: Sat, 31 Oct 2009 14:13:12 +0200
Message-ID: <20091031121312.GB9479@me>
References: <20091030004732.GP20136@me>
 <1830724148.4221541256937456735.JavaMail.root@sz0074a.westchester.pa.mail.comcast.net>
 <f0e08f230910301631x639a6670x8fbe184580964f9a@mail.gmail.com>
 <20091031121212.GA9479@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091031121212.GA9479@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


When resolving port by lid (in link_mgr_get_smsl()) be sure that lid is
valid. This can happen that during discovery PortInfo set fails after
lid manager run and port's local PortInfo still be zeroed.

The issue was pointed out and investigated by Hal Rosenstock.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_link_mgr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_mgr.c
index c9bdfee..76325ea 100644
--- a/opensm/opensm/osm_link_mgr.c
+++ b/opensm/opensm/osm_link_mgr.c
@@ -68,7 +68,8 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 
 	OSM_LOG_ENTER(sm->p_log);
 
-	if (p_osm->routing_engine_used != OSM_ROUTING_ENGINE_TYPE_LASH) {
+	if (p_osm->routing_engine_used != OSM_ROUTING_ENGINE_TYPE_LASH
+	    || !(slid = osm_physp_get_base_lid(p_physp))) {
 		/* Use default SL if lash routing is not used */
 		OSM_LOG_EXIT(sm->p_log);
 		return (sm->p_subn->opt.sm_sl);
@@ -80,7 +81,6 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 	    cl_ptr_vector_get(&sm->p_subn->port_lid_tbl, cl_ntoh16(smlid));
 
 	/* Find osm_port of the source = p_physp */
-	slid = osm_physp_get_base_lid(p_physp);
 	p_src_port =
 	    cl_ptr_vector_get(&sm->p_subn->port_lid_tbl, cl_ntoh16(slid));
 
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
