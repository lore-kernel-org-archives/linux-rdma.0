From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/multicast: improve function prototypes
Date: Sat, 19 Sep 2009 19:58:17 +0300
Message-ID: <20090919165817.GC13667@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Improve some function prototypes:
- osm_mgrp_new() will get MCMember record now.
- osm_mgrp_is_port_present() is replaced by cleaner
  osm_mgrp_get_mcm_port() helper.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_multicast.h  |   25 ++++++++++---------------
 opensm/opensm/osm_multicast.c          |   32 ++++++++++----------------------
 opensm/opensm/osm_sa_mcmember_record.c |   26 +++++++++++---------------
 3 files changed, 31 insertions(+), 52 deletions(-)

diff --git a/opensm/include/opensm/osm_multicast.h b/opensm/include/opensm/osm_multicast.h
index 32bcb78..15d7e78 100644
--- a/opensm/include/opensm/osm_multicast.h
+++ b/opensm/include/opensm/osm_multicast.h
@@ -142,12 +142,15 @@ typedef struct osm_mgrp {
 *
 * SYNOPSIS
 */
-osm_mgrp_t *osm_mgrp_new(IN const ib_net16_t mlid);
+osm_mgrp_t *osm_mgrp_new(IN const ib_net16_t mlid, IN ib_member_rec_t * mcmr);
 /*
 * PARAMETERS
 *	mlid
 *		[in] Multicast LID for this multicast group.
 *
+*	mcmr
+*		[in] MCMember Record for this multicast group.
+*
 * RETURN VALUES
 *	IB_SUCCESS if initialization was successful.
 *
@@ -309,20 +312,17 @@ osm_mcm_port_t *osm_mgrp_add_port(osm_subn_t *subn, osm_log_t *log,
 * SEE ALSO
 *********/
 
-/****f* OpenSM: Multicast Group/osm_mgrp_is_port_present
+/****f* OpenSM: Multicast Group/osm_mgrp_get_mcm_port
 * NAME
-*	osm_mgrp_is_port_present
+*	osm_mgrp_get_mcm_port
 *
 * DESCRIPTION
-*	checks a port from the multicast group.
+*	finds a port in the multicast group.
 *
 * SYNOPSIS
 */
-
-boolean_t
-osm_mgrp_is_port_present(IN const osm_mgrp_t * const p_mgrp,
-			 IN const ib_net64_t port_guid,
-			 OUT osm_mcm_port_t ** const pp_mcm_port);
+osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const osm_mgrp_t * const p_mgrp,
+				      IN const ib_net64_t port_guid);
 /*
 * PARAMETERS
 *	p_mgrp
@@ -331,13 +331,8 @@ osm_mgrp_is_port_present(IN const osm_mgrp_t * const p_mgrp,
 *	port_guid
 *		[in] Port guid of the departing port.
 *
-*  pp_mcm_port
-*     [out] Pointer to a pointer to osm_mcm_port_t
-*           Updated to the member on success or NULLed
-*
 * RETURN VALUES
-*	TRUE if port present
-*	FALSE if port is not present.
+*	Pointer to the mcm port object when present or NULL otherwise.
 *
 * NOTES
 *
diff --git a/opensm/opensm/osm_multicast.c b/opensm/opensm/osm_multicast.c
index 5a10003..a674514 100644
--- a/opensm/opensm/osm_multicast.c
+++ b/opensm/opensm/osm_multicast.c
@@ -75,9 +75,7 @@ void osm_mgrp_delete(IN osm_mgrp_t * p_mgrp)
 	free(p_mgrp);
 }
 
-/**********************************************************************
- **********************************************************************/
-osm_mgrp_t *osm_mgrp_new(IN const ib_net16_t mlid)
+osm_mgrp_t *osm_mgrp_new(IN const ib_net16_t mlid, IN ib_member_rec_t * mcmr)
 {
 	osm_mgrp_t *p_mgrp;
 
@@ -88,10 +86,13 @@ osm_mgrp_t *osm_mgrp_new(IN const ib_net16_t mlid)
 	memset(p_mgrp, 0, sizeof(*p_mgrp));
 	cl_qmap_init(&p_mgrp->mcm_port_tbl);
 	p_mgrp->mlid = mlid;
+	p_mgrp->mcmember_rec = *mcmr;
 
 	return p_mgrp;
 }
 
+/**********************************************************************
+ **********************************************************************/
 void osm_mgrp_cleanup(osm_subn_t * subn, osm_mgrp_t * mgrp)
 {
 	osm_mcm_port_t *mcm_port;
@@ -207,8 +208,6 @@ osm_mcm_port_t *osm_mgrp_add_port(IN osm_subn_t * subn, osm_log_t * log,
 	return mcm_port;
 }
 
-/**********************************************************************
- **********************************************************************/
 void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 			  osm_mcm_port_t * mcm_port, ib_member_rec_t *mcmr)
 {
@@ -277,22 +276,11 @@ void osm_mgrp_delete_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 
 /**********************************************************************
  **********************************************************************/
-boolean_t osm_mgrp_is_port_present(IN const osm_mgrp_t * p_mgrp,
-				   IN const ib_net64_t port_guid,
-				   OUT osm_mcm_port_t ** const pp_mcm_port)
+osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const osm_mgrp_t * p_mgrp,
+				      IN const ib_net64_t port_guid)
 {
-	cl_map_item_t *p_map_item;
-
-	CL_ASSERT(p_mgrp);
-
-	p_map_item = cl_qmap_get(&p_mgrp->mcm_port_tbl, port_guid);
-
-	if (p_map_item != cl_qmap_end(&p_mgrp->mcm_port_tbl)) {
-		if (pp_mcm_port)
-			*pp_mcm_port = (osm_mcm_port_t *) p_map_item;
-		return TRUE;
-	}
-	if (pp_mcm_port)
-		*pp_mcm_port = NULL;
-	return FALSE;
+	cl_map_item_t *item = cl_qmap_get(&p_mgrp->mcm_port_tbl, port_guid);
+	if (item != cl_qmap_end(&p_mgrp->mcm_port_tbl))
+		return (osm_mcm_port_t *)item;
+	return NULL;
 }
diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 8f7816b..f581663 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -340,10 +340,10 @@ static boolean_t validate_modify(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 
 	portguid = p_recvd_mcmember_rec->port_gid.unicast.interface_id;
 
-	*pp_mcm_port = NULL;
+	*pp_mcm_port = osm_mgrp_get_mcm_port(p_mgrp, portguid);
 
 	/* o15-0.2.1: If this is a new port being added - nothing to check */
-	if (!osm_mgrp_is_port_present(p_mgrp, portguid, pp_mcm_port)) {
+	if (!*pp_mcm_port) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"This is a new port in the MC group\n");
 		return TRUE;
@@ -428,10 +428,10 @@ static boolean_t validate_delete(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 
 	portguid = p_recvd_mcmember_rec->port_gid.unicast.interface_id;
 
-	*pp_mcm_port = NULL;
+	*pp_mcm_port = osm_mgrp_get_mcm_port(p_mgrp, portguid);
 
 	/* 1 */
-	if (!osm_mgrp_is_port_present(p_mgrp, portguid, pp_mcm_port)) {
+	if (!*pp_mcm_port) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Failed to find the port in the MC group\n");
 		return FALSE;
@@ -812,7 +812,8 @@ ib_api_status_t osm_mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 	}
 
 	/* create a new MC Group */
-	*pp_mgrp = osm_mgrp_new(mlid);
+	mcm_rec.mlid = mlid;
+	*pp_mgrp = osm_mgrp_new(mlid, &mcm_rec);
 	if (*pp_mgrp == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B08: "
 			"osm_mgrp_new failed\n");
@@ -821,10 +822,6 @@ ib_api_status_t osm_mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 		goto Exit;
 	}
 
-	/* Initialize the mgrp */
-	(*pp_mgrp)->mcmember_rec = mcm_rec;
-	(*pp_mgrp)->mcmember_rec.mlid = mlid;
-
 	/* the mcmember_record should have mtu_sel, rate_sel, and pkt_lifetime_sel = 2 */
 	(*pp_mgrp)->mcmember_rec.mtu &= 0x3f;
 	(*pp_mgrp)->mcmember_rec.mtu |= 2 << 6;	/* exactly */
@@ -1307,13 +1304,12 @@ static void mcmr_by_comp_mask(osm_sa_t * sa, const ib_member_rec_t * p_rcvd_rec,
 	/* so did we get the PortGUID mask */
 	if (IB_MCR_COMPMASK_PORT_GID & comp_mask) {
 		/* try to find this port */
-		if (osm_mgrp_is_port_present(p_mgrp, portguid, &p_mcm_port)) {
-			scope_state = p_mcm_port->scope_state;
-			memcpy(&port_gid, &(p_mcm_port->port_gid),
-			       sizeof(ib_gid_t));
-			proxy_join = p_mcm_port->proxy_join;
-		} else /* port not in group */
+		p_mcm_port = osm_mgrp_get_mcm_port(p_mgrp, portguid);
+		if (!p_mcm_port) /* port not in group */
 			goto Exit;
+		scope_state = p_mcm_port->scope_state;
+		memcpy(&port_gid, &(p_mcm_port->port_gid), sizeof(ib_gid_t));
+		proxy_join = p_mcm_port->proxy_join;
 	} else /* point to the group information */
 		scope_state = p_mgrp->mcmember_rec.scope_state;
 
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
