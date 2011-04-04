From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Cosmetic changes
Date: Mon, 04 Apr 2011 14:46:58 -0400
Message-ID: <4D9A1222.6080809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Some commentary and formatting changes
Fix some typos

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_mcm_port.h b/include/opensm/osm_mcm_port.h
index 897f3ca..096f5f8 100644
--- a/include/opensm/osm_mcm_port.h
+++ b/include/opensm/osm_mcm_port.h
@@ -87,17 +87,19 @@ typedef struct osm_mcm_port {
 *	map_item
 *		Map Item for qmap linkage.  Must be first element!!
 *
+*	list_item
+*		Linkage structure for cl_qlist.
+*
 *	port
-*		Reference to the parent port.
+*		Reference to the parent port
 *
 *	mgrp
 *		The pointer to multicast group where this port is member of
 *
 *	port_gid
-*		GID of the member port.
+*		GID of the member port
 *
 *	scope_state
-*		???
 *
 *	proxy_join
 *		If FALSE - Join was performed by the endport identified
@@ -124,10 +126,10 @@ osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t *
port, IN struct osm_mgrp *mgrp,
 /*
 * PARAMETERS
 *	port
-*		[in] Pointer to the port object.
+*		[in] Pointer to the port object
 *
 *	mgrp
-*		[in] Pointer to multicast group where this port is joined.
+*		[in] Pointer to multicast group where this port is joined
 *
 *	mcmr
 *		[in] Pointer to MCMember record of the join request
diff --git a/include/opensm/osm_multicast.h b/include/opensm/osm_multicast.h
index df6ac6c..d8d484c 100644
--- a/include/opensm/osm_multicast.h
+++ b/include/opensm/osm_multicast.h
@@ -178,6 +178,7 @@ osm_mgrp_t *osm_mgrp_new(IN osm_subn_t * subn, IN
ib_net16_t mlid,
 * PARAMETERS
 *	subn
 *		[in] Pointer to osm_subn_t object.
+*
 *	mlid
 *		[in] Multicast LID for this multicast group.
 *
@@ -357,7 +358,7 @@ osm_mcm_port_t *osm_mgrp_add_port(osm_subn_t *subn,
osm_log_t *log,
 *	osm_mgrp_get_mcm_port
 *
 * DESCRIPTION
-*	finds a port in the multicast group.
+*	Finds a port in the multicast group.
 *
 * SYNOPSIS
 */
@@ -369,7 +370,7 @@ osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const
osm_mgrp_t * p_mgrp,
 *		[in] Pointer to an osm_mgrp_t object.
 *
 *	port_guid
-*		[in] Port guid of the departing port.
+*		[in] Port guid.
 *
 * RETURN VALUES
 *	Pointer to the mcm port object when present or NULL otherwise.
@@ -379,9 +380,9 @@ osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const
osm_mgrp_t * p_mgrp,
 * SEE ALSO
 *********/

-/****f* OpenSM: Multicast Group/osm_mgrp_remove_port
+/****f* OpenSM: Multicast Group/osm_mgrp_delete_port
 * NAME
-*	osm_mgrp_remove_port
+*	osm_mgrp_delete_port
 *
 * DESCRIPTION
 *	Removes a port from the multicast group.
diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index 8c68c99..ee9feec 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -1220,7 +1220,7 @@ osm_port_t *osm_port_new(IN const ib_node_info_t *
p_ni,
 /*
 * PARAMETERS
 *	p_ni
-*		[in] Pointer to the NodeInfo attribute relavent for this port.
+*		[in] Pointer to the NodeInfo attribute relevant for this port.
 *
 *	p_parent_node
 *		[in] Pointer to the initialized parent osm_node_t object
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 42ae416..a9499dd 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -501,7 +501,7 @@ typedef struct osm_subn_opt {
 *		hardware specific work arounds
 *
 *	no_clients_rereg
-*		When TRUE disables clients reregistration request.
+*		When TRUE disables clients reregistration request
 *
 * SEE ALSO
 *	Subnet object
@@ -929,7 +929,7 @@ struct osm_switch *osm_get_switch_by_guid(IN const
osm_subn_t * p_subn,
 *	osm_get_node_by_guid
 *
 * DESCRIPTION
-*	The looks for the given node giud in the subnet table of nodes by guid.
+*	This looks for the given node guid in the subnet table of nodes by guid.
 *  NOTE: this code is not thread safe. Need to grab the lock before
 *  calling it.
 *
@@ -958,7 +958,7 @@ struct osm_node *osm_get_node_by_guid(IN osm_subn_t
const *p_subn,
 *	osm_get_port_by_guid
 *
 * DESCRIPTION
-*	The looks for the given port guid in the subnet table of ports by guid.
+*	This looks for the given port guid in the subnet table of ports by guid.
 *  NOTE: this code is not thread safe. Need to grab the lock before
 *  calling it.
 *
@@ -1041,7 +1041,7 @@ static inline struct osm_port
*osm_get_port_by_lid(IN osm_subn_t const * subn,
 *	osm_get_mgrp_by_mgid
 *
 * DESCRIPTION
-*	The looks for the given multicast group in the subnet table by mgid.
+*	This looks for the given multicast group in the subnet table by mgid.
 *	NOTE: this code is not thread safe. Need to grab the lock before
 *	calling it.
 *
@@ -1065,7 +1065,7 @@ struct osm_mgrp *osm_get_mgrp_by_mgid(IN
osm_subn_t * subn, IN ib_gid_t * mgid);
 *	osm_get_mbox_by_mlid
 *
 * DESCRIPTION
-*	The looks for the given multicast group in the subnet table by mlid.
+*	This looks for the given multicast group in the subnet table by mlid.
 *	NOTE: this code is not thread safe. Need to grab the lock before
 *	calling it.
 *
diff --git a/include/vendor/osm_vendor_ibumad.h
b/include/vendor/osm_vendor_ibumad.h
index 0a4692d..0a25583 100644
--- a/include/vendor/osm_vendor_ibumad.h
+++ b/include/vendor/osm_vendor_ibumad.h
@@ -73,7 +73,7 @@ BEGIN_C_DECLS
 *   osm_ca_info_t
 *
 * DESCRIPTION
-* 	Structure containing information about local Channle Adapters.
+* 	Structure containing information about local Channel Adapters.
 *
 * SYNOPSIS
 */
diff --git a/opensm/osm_multicast.c b/opensm/osm_multicast.c
index 843b6ce..4ff93f2 100644
--- a/opensm/osm_multicast.c
+++ b/opensm/osm_multicast.c
@@ -72,8 +72,7 @@ void mgrp_box_delete(osm_mgrp_box_t *mbox)

 void mgrp_delete(IN osm_mgrp_t * p_mgrp)
 {
-	osm_mcm_port_t *p_mcm_port;
-	osm_mcm_port_t *p_next_mcm_port;
+	osm_mcm_port_t *p_mcm_port, *p_next_mcm_port;

 	CL_ASSERT(p_mgrp);

@@ -93,7 +92,8 @@ void mgrp_delete(IN osm_mgrp_t * p_mgrp)
 void osm_mgrp_box_delete(osm_mgrp_box_t *mbox)
 {
 	osm_mgrp_t *mgrp;
-	while(cl_qlist_count(&mbox->mgrp_list)) {
+
+	while (cl_qlist_count(&mbox->mgrp_list)) {
 		mgrp = cl_item_obj(cl_qlist_remove_head(&mbox->mgrp_list),
 				   mgrp, list_item);
 		mgrp_delete(mgrp);
@@ -140,7 +140,7 @@ void osm_mgrp_cleanup(osm_subn_t * subn, osm_mgrp_t
* mgrp)
 		return;

 	while (cl_qmap_count(&mgrp->mcm_port_tbl)) {
-		mcm_port = (osm_mcm_port_t *)cl_qmap_head(&mgrp->mcm_port_tbl);
+		mcm_port = (osm_mcm_port_t *) cl_qmap_head(&mgrp->mcm_port_tbl);
 		cl_qmap_remove_item(&mgrp->mcm_port_tbl, &mcm_port->map_item);
 		cl_qlist_remove_item(&mcm_port->port->mcm_list,
 				     &mcm_port->list_item);
@@ -320,6 +320,6 @@ osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const
osm_mgrp_t * p_mgrp,
 {
 	cl_map_item_t *item = cl_qmap_get(&p_mgrp->mcm_port_tbl, port_guid);
 	if (item != cl_qmap_end(&p_mgrp->mcm_port_tbl))
-		return (osm_mcm_port_t *)item;
+		return (osm_mcm_port_t *) item;
 	return NULL;
 }
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index 11b7158..ce51a39 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -422,14 +422,12 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t *
p_osm,
 			     p_osm->p_vendor, &p_osm->mad_pool, &p_osm->vl15,
 			     &p_osm->log, &p_osm->stats, &p_osm->disp,
 			     &p_osm->lock);
-
 	if (status != IB_SUCCESS)
 		goto Exit;

 	status = osm_sa_init(&p_osm->sm, &p_osm->sa, &p_osm->subn,
 			     p_osm->p_vendor, &p_osm->mad_pool, &p_osm->log,
 			     &p_osm->stats, &p_osm->disp, &p_osm->lock);
-
 	if (status != IB_SUCCESS)
 		goto Exit;

diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 04790fb..04ddf96 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1620,7 +1620,7 @@ void osm_pr_rcv_process(IN void *context, IN void
*data)
 		goto Exit;
 	}

-	/* update the requester physical port. */
+	/* update the requester physical port */
 	requester_port = osm_get_port_by_mad_addr(sa->p_log, sa->p_subn,
 						  osm_madw_get_mad_addr_ptr
 						  (p_madw));
diff --git a/osmtest/main.c b/osmtest/main.c
index d676de1..7b586e9 100644
--- a/osmtest/main.c
+++ b/osmtest/main.c
@@ -359,7 +359,7 @@ int main(int argc, char *argv[])

 		case 'f':
 			/*
-			 * Specifies Flow .
+			 * Specifies Flow.
 			 */
 			if (strlen(optarg) > OSMTEST_FILE_PATH_MAX)
 				printf
diff --git a/osmtest/osmt_inform.c b/osmtest/osmt_inform.c
index d3558ce..f06ec3f 100644
--- a/osmtest/osmt_inform.c
+++ b/osmtest/osmt_inform.c
@@ -596,7 +596,7 @@ osmt_init_inform_info_by_trap(IN osmtest_t * const
p_osmt,
  * - try to unregister inform info (should succeed)
  * - register an inform info
  * - send a trap - sleep
- * - check that a Report(Notice) arrived that match the sent one
+ * - check that a Report(Notice) arrived that matches the sent trap
  *
  */
 ib_api_status_t osmt_run_inform_info_flow(IN osmtest_t * const p_osmt)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
