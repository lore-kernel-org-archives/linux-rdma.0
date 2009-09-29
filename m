From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_get_port_by_lid(): don't bother with lmc
Date: Tue, 29 Sep 2009 13:03:08 +0200
Message-ID: <20090929110308.GM26931@me>
References: <20090929110215.GK26931@me>
 <20090929110244.GL26931@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090929110244.GL26931@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Since subn->port_lid_tbl vector is filled for all port's LIDs in
accordance with its LMC value, so we don't need to bother with LMC
tracking and instead can just return a pointer indexed by requested lid.
Obviously it speeds this helper up significantly.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_subnet.c |   21 ++-------------------
 1 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 30f8af5..97b62c2 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -645,26 +645,9 @@ osm_port_t *osm_get_port_by_guid(IN osm_subn_t const *p_subn, IN ib_net64_t guid
  **********************************************************************/
 osm_port_t *osm_get_port_by_lid(IN osm_subn_t const * subn, IN ib_net16_t lid)
 {
-	osm_port_t *port = NULL;
-	uint16_t base_lid;
-	uint8_t lmc;
-
 	lid = cl_ntoh16(lid);
-	if (lid >= cl_ptr_vector_get_size(&subn->port_lid_tbl))
-		return NULL;
-
-	/* Loop on lmc from 0 up through max LMC possible */
-	for (lmc = 0; lmc <= IB_PORT_LMC_MAX; lmc++) {
-		/* Calculate a base LID assuming this is the real LMC */
-		base_lid = lid & ~((1 << lmc) - 1);
-
-		port = cl_ptr_vector_get(&subn->port_lid_tbl, base_lid);
-		/* Determine if base LID "tested" is the real base LID */
-		/* This is true if the LMC "tested" is the port's actual LMC */
-		if (port && lmc <= osm_port_get_lmc(port))
-			return port;
-	}
-
+	if (lid < cl_ptr_vector_get_size(&subn->port_lid_tbl))
+		return cl_ptr_vector_get(&subn->port_lid_tbl, lid);
 	return NULL;
 }
 
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
