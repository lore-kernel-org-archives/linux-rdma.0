From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_qos.c: merge SL2VL mapping capability check
Date: Mon, 4 Jan 2010 19:01:41 +0200
Message-ID: <20100104170141.GK26940@me>
References: <20091201194110.GA26753@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091201194110.GA26753-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The IBA 1.2.1 states (Vol.1, p.840, Table XX, explanation (b)) that
SL2VL mapping capability for switch external ports must be indicated on
its port 0 PortInfo:CapMask. So it lets us to unify this capability
check over all types of IB nodes.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_qos.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index 08f9a60..afeaa11 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -194,23 +194,15 @@ static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
 {
 	ib_api_status_t status;
 	uint8_t i, num_ports;
-	osm_physp_t *p_physp;
+	ib_port_info_t *pi = &p_port->p_physp->port_info;
+
+	if (!(pi->capability_mask & IB_PORT_CAP_HAS_SL_MAP))
+		return IB_SUCCESS;
 
-	if (osm_node_get_type(osm_physp_get_node_ptr(p)) == IB_NODE_TYPE_SWITCH) {
-		if (ib_port_info_get_vl_cap(&p->port_info) == 1) {
-			/* Check port 0's capability mask */
-			p_physp = p_port->p_physp;
-			if (!
-			    (p_physp->port_info.
-			     capability_mask & IB_PORT_CAP_HAS_SL_MAP))
-				return IB_SUCCESS;
-		}
+	if (osm_node_get_type(osm_physp_get_node_ptr(p)) == IB_NODE_TYPE_SWITCH)
 		num_ports = osm_node_get_num_physp(osm_physp_get_node_ptr(p));
-	} else {
-		if (!(p->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
-			return IB_SUCCESS;
+	else
 		num_ports = 1;
-	}
 
 	for (i = 0; i < num_ports; i++) {
 		status = sl2vl_update_table(sm, p, i, port_num, force_update,
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
