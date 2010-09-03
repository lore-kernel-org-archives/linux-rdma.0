From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v4 16/18] opensm: Avoid havoc in minhop caused by
 torus-2QoS persistent use of osm_port_t:priv.
Date: Fri,  3 Sep 2010 10:43:12 -0600
Message-ID: <1283532194-27112-17-git-send-email-jaschut@sandia.gov>
References: <1283532194-27112-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283532194-27112-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Torus-2QoS makes persistent use of osm_port_t:priv to speed calculation
of path SL values.

It cannot clear osm_port_t:priv members when it tears down its persistent
data for the following reason: If a port is removed from the fabric, the
opensm core will delete the corresponding osm_port_t object, leaving
torus-2QoS holding a dangling reference.  Torus-2QoS then has a use-after-free
error when tearing down its persistent data if it tries to use its dangling
osm_port_t reference to clear the priv member.

When torus-2QoS is unable to route a fabric due to missing switches and
opensm is configured to fall back to minhop, havoc will ensue because
minhop uses a non-NULL osm_port_t:priv as a proxy for LMC > 0: it
assumes if osm_port_t:priv is non-NULL it can only be because
alloc_ports_priv() has been called.

Fix this up by always calling alloc_ports_priv(), and have it set
priv = NULL if LMC == 0.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_mgr.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index d1c485f..e6e40f0 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -315,8 +315,10 @@ static void alloc_ports_priv(osm_ucast_mgr_t * mgr)
 	     item = cl_qmap_next(item)) {
 		port = (osm_port_t *) item;
 		lmc = ib_port_info_get_lmc(&port->p_physp->port_info);
-		if (!lmc)
+		if (!lmc) {
+			port->priv = NULL;
 			continue;
+		}
 		r = malloc(sizeof(*r) + sizeof(r->guids[0]) * (1 << lmc));
 		if (!r) {
 			OSM_LOG(mgr->p_log, OSM_LOG_ERROR, "ERR 3A09: "
@@ -363,8 +365,7 @@ static void ucast_mgr_process_tbl(IN cl_map_item_t * p_map_item,
 	/* Initialize LIDs in buffer to invalid port number. */
 	memset(p_sw->new_lft, OSM_NO_PATH, p_sw->max_lid_ho + 1);
 
-	if (p_mgr->p_subn->opt.lmc)
-		alloc_ports_priv(p_mgr);
+	alloc_ports_priv(p_mgr);
 
 	/*
 	   Iterate through every port setting LID routes for each
@@ -381,8 +382,7 @@ static void ucast_mgr_process_tbl(IN cl_map_item_t * p_map_item,
 		}
 	}
 
-	if (p_mgr->p_subn->opt.lmc)
-		free_ports_priv(p_mgr);
+	free_ports_priv(p_mgr);
 
 	OSM_LOG_EXIT(p_mgr->p_log);
 }
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
