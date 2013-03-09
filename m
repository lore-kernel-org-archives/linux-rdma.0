From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_torus.c: avoid the possibility of following
 stale ->priv pointers
Date: Sat, 09 Mar 2013 08:26:54 -0500
Message-ID: <513B389E.30506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 557b01eb8857a197a973af76d1322f76d25495ed Mon Sep 17 00:00:00 2001
From: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Date: Fri, 8 Mar 2013 08:59:01 -0700
Subject: [PATCH 1/2] opensm/osm_torus.c: avoid the possibility of following stale ->priv pointers

Torus-2QoS makes persistent use of osm_switch_t:priv and osm_port_t:priv
to speed its routing calculations.

In some situations t2q is unable to determine the location in the torus
topology of a discovered switch.  An example of this occurs when all the
inter-switch links but one connected to a switch have failed.

When this happens, at the end of a full sweep opensm will attempt to
program the VLArb tables for that switch.  Torus_update_osm_vlarb()
will follow a stale osm_switch_t:priv pointer, left over from the
previous routing cycle when switch was discovered in the torus,
ultimately resulting in a segmentation fault.

Prevent this by clearing stale values of osm_switch_t:priv as part of
the first step in torus topology discovery.  Do the same thing for
osm_port_t:priv, even though it has not yet been implicated in this
sort of issue yet.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/osm_torus.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 757a32a..bc3c0b8 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -1173,6 +1173,7 @@ bool capture_fabric(struct fabric *fabric)
 
 		osm_sw = (osm_switch_t *)item;
 		item = cl_qmap_next(item);
+		osm_sw->priv = NULL;  /* avoid stale pointer dereferencing */
 		osm_node = osm_sw->p_node;
 
 		if (osm_node_get_type(osm_node) != IB_NODE_TYPE_SWITCH)
@@ -1193,6 +1194,7 @@ bool capture_fabric(struct fabric *fabric)
 
 		lport = (osm_port_t *)item;
 		item = cl_qmap_next(item);
+		lport->priv = NULL;  /* avoid stale pointer dereferencing */
 
 		lphysp = lport->p_physp;
 		if (!(lphysp && osm_physp_is_valid(lphysp)))
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
