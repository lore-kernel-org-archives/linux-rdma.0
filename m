From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_get_port_by_lid(): use faster
 cl_ptr_vector_get()
Date: Tue, 29 Sep 2009 13:02:15 +0200
Message-ID: <20090929110215.GK26931@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use faster cl_ptr_vector_get() call instead of cl_ptr_vector_at(). In
this way eliminate 'stat' variable needs.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_subnet.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index b475031..67bc7e1 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -646,22 +646,22 @@ osm_port_t *osm_get_port_by_guid(IN osm_subn_t const *p_subn, IN ib_net64_t guid
 osm_port_t *osm_get_port_by_lid(IN osm_subn_t const * subn, IN ib_net16_t lid)
 {
 	osm_port_t *port = NULL;
-	ib_api_status_t stat;
 	uint16_t base_lid;
 	uint8_t lmc;
 
 	lid = cl_ntoh16(lid);
+	if (lid >= cl_ptr_vector_get_size(&subn->port_lid_tbl))
+		return NULL;
 
 	/* Loop on lmc from 0 up through max LMC possible */
 	for (lmc = 0; lmc <= IB_PORT_LMC_MAX; lmc++) {
 		/* Calculate a base LID assuming this is the real LMC */
 		base_lid = lid & ~((1 << lmc) - 1);
 
-		stat = cl_ptr_vector_at(&subn->port_lid_tbl, base_lid,
-					(void *)&port);
+		port = cl_ptr_vector_get(&subn->port_lid_tbl, base_lid);
 		/* Determine if base LID "tested" is the real base LID */
 		/* This is true if the LMC "tested" is the port's actual LMC */
-		if (stat == CL_SUCCESS && port && lmc == osm_port_get_lmc(port))
+		if (port && lmc == osm_port_get_lmc(port))
 			return port;
 	}
 
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
