From: Sasha Khapyorsky <sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] opensm: update internal PortInfo state for any ports
Date: Mon, 22 Jul 2013 18:54:59 +0300
Message-ID: <20130722155457.GB23909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: halr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roy.Koren-mb1K0bWo544@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Should not be matter to keep internal SM's PortInfo data for ports
in any states.

Signed-off-by: Sasha Khapyorsky <sashakh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 opensm/osm_port.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index 6e73e66..d59d404 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -669,25 +669,16 @@ void osm_physp_set_port_info(IN osm_physp_t * p_physp,
 	CL_ASSERT(p_pi);
 	CL_ASSERT(osm_physp_is_valid(p_physp));
 
-	if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN) {
-		/* If PortState is down, only copy PortState */
-		/* and PortPhysicalState per C14-24-2.1 */
-		ib_port_info_set_port_state(&p_physp->port_info, IB_LINK_DOWN);
-		ib_port_info_set_port_phys_state
-		    (ib_port_info_get_port_phys_state(p_pi),
-		     &p_physp->port_info);
-	} else {
-		p_physp->port_info = *p_pi;
-
-		/* The MKey in p_pi can only be considered valid if it's
-		 * for a HCA/router or switch port 0, and it's either
-		 * non-zero or the MKeyProtect bits are also zero.
-		 */
-		if ((osm_node_get_type(p_physp->p_node) !=
-		     IB_NODE_TYPE_SWITCH || p_physp->port_num == 0) &&
-		    (p_pi->m_key != 0 || ib_port_info_get_mpb(p_pi) == 0))
-			osm_db_guid2mkey_set(p_sm->p_subn->p_g2m,
-					     cl_ntoh64(p_physp->port_guid),
-					     cl_ntoh64(p_pi->m_key));
-	}
+	p_physp->port_info = *p_pi;
+
+	/* The MKey in p_pi can only be considered valid if it's
+	 * for a HCA/router or switch port 0, and it's either
+	 * non-zero or the MKeyProtect bits are also zero.
+	 */
+	if ((osm_node_get_type(p_physp->p_node) != IB_NODE_TYPE_SWITCH ||
+	     p_physp->port_num == 0) &&
+	    (p_pi->m_key != 0 || ib_port_info_get_mpb(p_pi) == 0))
+		osm_db_guid2mkey_set(p_sm->p_subn->p_g2m,
+				     cl_ntoh64(p_physp->port_guid),
+				     cl_ntoh64(p_pi->m_key));
 }
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
