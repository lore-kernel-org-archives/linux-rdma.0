From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Fix minhop population in fabric with duplicate lids
Date: Wed, 20 Nov 2013 19:08:00 -0500
Message-ID: <528D4EE0.9020300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Sometimes SET PortInfo from the lid_mgr can fail and a port will remain
with it previous lid. In that case we might have more than one port with
same lid. ucast_build_matrices calculate min hop tables from the lid
stored in the physp.port_info object resulting a wrong calculation.

This patch zeros the physp.port_info.base_lid field before sending lid
update to a port. In case SET fails, lid for that port will remain 0 and
won't affect min_hop calculation.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_port.h |   30 ++++++++++++++++++++++++++++++
 opensm/osm_lid_mgr.c      |    8 +++++++-
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index f4b7efd..e9e59c3 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -546,6 +546,36 @@ void osm_physp_set_port_info(IN osm_physp_t * p_physp,
 *	Port, Physical Port
 *********/
 
+/****f* OpenSM: Physical Port/osm_physp_set_base_lid
+* NAME
+*	osm_physp_set_base_lid
+*
+* DESCRIPTION
+*	Sets the base lid for this Physical Port.
+*
+* SYNOPSIS
+*/
+static inline void osm_physp_set_base_lid(IN osm_physp_t * p_physp,
+					  IN ib_net16_t base_lid)
+{
+	CL_ASSERT(p_physp);
+	CL_ASSERT(osm_physp_is_valid(p_physp));
+	p_physp->port_info.base_lid = base_lid;
+}
+
+/*
+* PARAMETERS
+*	p_physp
+*		[in] Pointer to an osm_physp_t object.
+*
+*	base_lid
+*		[in] Lid to set.
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* OpenSM: Physical Port/osm_physp_set_pkey_tbl
 * NAME
 *  osm_physp_set_pkey_tbl
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 8473514..9531a09 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -885,8 +885,14 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	p_port->lid = lid;
 	p_pi->base_lid = lid;
 	if (memcmp(&p_pi->base_lid, &p_old_pi->base_lid,
-		   sizeof(p_pi->base_lid)))
+		   sizeof(p_pi->base_lid))) {
+		/*
+		 * Reset stored base_lid.
+		 * On successful send, we'll update it when we'll get a reply.
+		 */
+		osm_physp_set_base_lid(p_physp, 0);
 		send_set = TRUE;
+	}
 
 	/* we are updating the ports with our local sm_base_lid */
 	p_pi->master_sm_base_lid = p_mgr->p_subn->sm_base_lid;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
