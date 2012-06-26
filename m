From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/8] opensm: Add guid2mkey cache file support
Date: Mon, 25 Jun 2012 17:54:57 -0700
Message-ID: <1340672104-18039-1-git-send-email-foraker1@llnl.gov>
References: <1340672058.5218.97.camel@auk75.llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340672058.5218.97.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adds support for a guid2mkey file, and uses the database
to select which mkey to use in outgoing SMPs.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_db_pack.h |  144 ++++++++++++++++++++++++++++++++++++++++++
 include/opensm/osm_port.h    |   23 ++-----
 include/opensm/osm_subnet.h  |    2 +
 opensm/osm_db_pack.c         |   73 +++++++++++++++++++++
 opensm/osm_lid_mgr.c         |   12 +++-
 opensm/osm_link_mgr.c        |   14 +++-
 opensm/osm_opensm.c          |   10 +--
 opensm/osm_port.c            |   32 ++++++++++
 opensm/osm_port_info_rcv.c   |    6 +-
 opensm/osm_req.c             |    1 +
 opensm/osm_state_mgr.c       |    4 ++
 opensm/osm_subnet.c          |   77 ++++++++++++++++++++++
 12 files changed, 372 insertions(+), 26 deletions(-)

diff --git a/include/opensm/osm_db_pack.h b/include/opensm/osm_db_pack.h
index 3d24926..25644df 100644
--- a/include/opensm/osm_db_pack.h
+++ b/include/opensm/osm_db_pack.h
@@ -235,5 +235,149 @@ int osm_db_guid2lid_delete(IN osm_db_domain_t * p_g2l, IN uint64_t guid);
 * osm_db_guid2lid_get, osm_db_guid2lid_set
 *********/
 
+/****f* OpenSM: DB-Pack/osm_db_guid2mkey_init
+* NAME
+*	osm_db_guid2mkey_init
+*
+* DESCRIPTION
+*	Initialize a domain for the guid2mkey table
+*
+* SYNOPSIS
+*/
+static inline osm_db_domain_t *osm_db_guid2mkey_init(IN osm_db_t * p_db)
+{
+	return (osm_db_domain_init(p_db, "guid2mkey"));
+}
+
+/*
+* PARAMETERS
+*	p_db
+*		[in] Pointer to the database object to construct
+*
+* RETURN VALUES
+*	The pointer to the new allocated domain object or NULL.
+*
+* NOTE: DB domains are destroyed by the osm_db_destroy
+*
+* SEE ALSO
+*	Database, osm_db_init, osm_db_destroy
+*********/
+
+/****f* OpenSM: DB-Pack/osm_db_guid2mkey_guids
+* NAME
+*	osm_db_guid2mkey_guids
+*
+* DESCRIPTION
+*	Provides back a list of guid elements.
+*
+* SYNOPSIS
+*/
+int osm_db_guid2mkey_guids(IN osm_db_domain_t * p_g2m,
+			  OUT cl_qlist_t * p_guid_list);
+/*
+* PARAMETERS
+*	p_g2l
+*		[in] Pointer to the guid2mkey domain
+*
+*  p_guid_list
+*     [out] A quick list of guid elements of type osm_db_guid_elem_t
+*
+* RETURN VALUES
+*	0 if successful
+*
+* NOTE: the output qlist should be initialized and each item freed
+*       by the caller, then destroyed.
+*
+* SEE ALSO
+* osm_db_guid2mkey_init, osm_db_guid2mkey_guids, osm_db_guid2mkey_get
+* osm_db_guid2mkey_set, osm_db_guid2mkey_delete
+*********/
+
+/****f* OpenSM: DB-Pack/osm_db_guid2mkey_get
+* NAME
+*	osm_db_guid2mkey_get
+*
+* DESCRIPTION
+*	Get the mkey for the given guid.
+*
+* SYNOPSIS
+*/
+int osm_db_guid2mkey_get(IN osm_db_domain_t * p_g2m, IN uint64_t guid,
+			 OUT uint64_t * p_mkey);
+/*
+* PARAMETERS
+*	p_g2m
+*		[in] Pointer to the guid2mkey domain
+*
+*  guid
+*     [in] The guid to look for
+*
+*  p_mkey
+*     [out] Pointer to the resulting mkey in host order.
+*
+* RETURN VALUES
+*	0 if successful. The lid will be set to 0 if not found.
+*
+* SEE ALSO
+* osm_db_guid2mkey_init, osm_db_guid2mkey_guids
+* osm_db_guid2mkey_set, osm_db_guid2mkey_delete
+*********/
+
+/****f* OpenSM: DB-Pack/osm_db_guid2mkey_set
+* NAME
+*	osm_db_guid2mkey_set
+*
+* DESCRIPTION
+*	Set the mkey for the given guid.
+*
+* SYNOPSIS
+*/
+int osm_db_guid2mkey_set(IN osm_db_domain_t * p_g2m, IN uint64_t guid,
+			 IN uint64_t mkey);
+/*
+* PARAMETERS
+*	p_g2m
+*		[in] Pointer to the guid2mkey domain
+*
+*  guid
+*     [in] The guid to look for
+*
+*  mkey
+*     [in] The mkey value to set, in host order
+*
+* RETURN VALUES
+*	0 if successful
+*
+* SEE ALSO
+* osm_db_guid2mkey_init, osm_db_guid2mkey_guids
+* osm_db_guid2mkey_get, osm_db_guid2mkey_delete
+*********/
+
+/****f* OpenSM: DB-Pack/osm_db_guid2mkey_delete
+* NAME
+*	osm_db_guid2mkey_delete
+*
+* DESCRIPTION
+*	Delete the entry by the given guid
+*
+* SYNOPSIS
+*/
+int osm_db_guid2mkey_delete(IN osm_db_domain_t * p_g2m, IN uint64_t guid);
+/*
+* PARAMETERS
+*	p_g2m
+*		[in] Pointer to the guid2mkey domain
+*
+*  guid
+*     [in] The guid to look for
+*
+* RETURN VALUES
+*	0 if successful otherwise 1
+*
+* SEE ALSO
+* osm_db_guid2mkey_init, osm_db_guid2mkey_guids
+* osm_db_guid2mkey_get, osm_db_guid2mkey_set
+*********/
+
 END_C_DECLS
 #endif				/* _OSM_DB_PACK_H_ */
diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index 473b269..3575039 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -66,6 +66,7 @@ BEGIN_C_DECLS
 struct osm_port;
 struct osm_node;
 struct osm_mgrp;
+struct osm_sm;
 
 /****h* OpenSM/Physical Port
 * NAME
@@ -431,22 +432,9 @@ static inline void osm_physp_set_health(IN osm_physp_t * p_physp,
 *
 * SYNOPSIS
 */
-static inline void osm_physp_set_port_info(IN osm_physp_t * p_physp,
-					   IN const ib_port_info_t * p_pi)
-{
-	CL_ASSERT(p_pi);
-	CL_ASSERT(osm_physp_is_valid(p_physp));
-
-	if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN) {
-		/* If PortState is down, only copy PortState */
-		/* and PortPhysicalState per C14-24-2.1 */
-		ib_port_info_set_port_state(&p_physp->port_info, IB_LINK_DOWN);
-		ib_port_info_set_port_phys_state
-		    (ib_port_info_get_port_phys_state(p_pi),
-		     &p_physp->port_info);
-	} else
-		p_physp->port_info = *p_pi;
-}
+void osm_physp_set_port_info(IN osm_physp_t * p_physp,
+					   IN const ib_port_info_t * p_pi,
+					   IN const struct osm_sm * p_sm);
 
 /*
 * PARAMETERS
@@ -456,6 +444,9 @@ static inline void osm_physp_set_port_info(IN osm_physp_t * p_physp,
 *	p_pi
 *		[in] Pointer to the IBA defined PortInfo at this port number.
 *
+* 	p_sm
+* 		[in] Pointer to an osm_sm_t object.
+*
 * RETURN VALUES
 *	This function does not return a value.
 *
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index d88f9c7..f8a1f3f 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -54,6 +54,7 @@
 #include <complib/cl_list.h>
 #include <opensm/osm_base.h>
 #include <opensm/osm_prefix_route.h>
+#include <opensm/osm_db.h>
 #include <stdio.h>
 
 #ifdef __cplusplus
@@ -586,6 +587,7 @@ typedef struct osm_subn {
 	boolean_t sweeping_enabled;
 	unsigned need_update;
 	cl_fmap_t mgrp_mgid_tbl;
+	osm_db_domain_t *p_g2m;
 	void *mboxes[IB_LID_MCAST_END_HO - IB_LID_MCAST_START_HO + 1];
 } osm_subn_t;
 /*
diff --git a/opensm/osm_db_pack.c b/opensm/osm_db_pack.c
index 9122ac4..3fea4a2 100644
--- a/opensm/osm_db_pack.c
+++ b/opensm/osm_db_pack.c
@@ -83,6 +83,17 @@ static inline int unpack_lids(IN char *p_lid_str, OUT uint16_t * p_min_lid,
 	return 0;
 }
 
+static inline void pack_mkey(uint64_t mkey, char *p_mkey_str)
+{
+	sprintf(p_mkey_str, "0x%016" PRIx64, mkey);
+}
+
+static inline uint64_t unpack_mkey(char *p_mkey_str)
+{
+	return strtoull(p_mkey_str, NULL, 0);
+}
+
+
 int osm_db_guid2lid_guids(IN osm_db_domain_t * p_g2l,
 			  OUT cl_qlist_t * p_guid_list)
 {
@@ -149,3 +160,65 @@ int osm_db_guid2lid_delete(IN osm_db_domain_t * p_g2l, IN uint64_t guid)
 	pack_guid(guid, guid_str);
 	return osm_db_delete(p_g2l, guid_str);
 }
+
+int osm_db_guid2mkey_guids(IN osm_db_domain_t * p_g2m,
+			   OUT cl_qlist_t * p_guid_list)
+{
+	char *p_key;
+	cl_list_t keys;
+	osm_db_guid_elem_t *p_guid_elem;
+
+	cl_list_construct(&keys);
+	cl_list_init(&keys, 10);
+
+	if (osm_db_keys(p_g2m, &keys))
+		return 1;
+
+	while ((p_key = cl_list_remove_head(&keys)) != NULL) {
+		p_guid_elem =
+		    (osm_db_guid_elem_t *) malloc(sizeof(osm_db_guid_elem_t));
+		CL_ASSERT(p_guid_elem != NULL);
+
+		p_guid_elem->guid = unpack_guid(p_key);
+		cl_qlist_insert_head(p_guid_list, &p_guid_elem->item);
+	}
+
+	cl_list_destroy(&keys);
+	return 0;
+}
+
+int osm_db_guid2mkey_get(IN osm_db_domain_t * p_g2m, IN uint64_t guid,
+			 OUT uint64_t * p_mkey)
+{
+	char guid_str[20];
+	char *p_mkey_str;
+
+	pack_guid(guid, guid_str);
+	p_mkey_str = osm_db_lookup(p_g2m, guid_str);
+	if (!p_mkey_str)
+		return 1;
+
+	if (p_mkey)
+		*p_mkey = unpack_mkey(p_mkey_str);
+
+	return 0;
+}
+
+int osm_db_guid2mkey_set(IN osm_db_domain_t * p_g2m, IN uint64_t guid,
+			 IN uint64_t mkey)
+{
+	char guid_str[20];
+	char mkey_str[20];
+
+	pack_guid(guid, guid_str);
+	pack_mkey(mkey, mkey_str);
+
+	return osm_db_update(p_g2m, guid_str, mkey_str);
+}
+
+int osm_db_guid2mkey_delete(IN osm_db_domain_t * p_g2m, IN uint64_t guid)
+{
+	char guid_str[20];
+	pack_guid(guid, guid_str);
+	return osm_db_delete(p_g2m, guid_str);
+}
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index a7613e2..b169f6b 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -798,6 +798,7 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	uint8_t op_vls;
 	uint8_t port_num;
 	boolean_t send_set = FALSE;
+	boolean_t update_mkey = FALSE;
 	int ret = 0;
 
 	OSM_LOG_ENTER(p_mgr->p_log);
@@ -860,8 +861,10 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 		send_set = TRUE;
 
 	p_pi->m_key = p_mgr->p_subn->opt.m_key;
-	if (memcmp(&p_pi->m_key, &p_old_pi->m_key, sizeof(p_pi->m_key)))
+	if (memcmp(&p_pi->m_key, &p_old_pi->m_key, sizeof(p_pi->m_key))) {
+		update_mkey = TRUE;
 		send_set = TRUE;
+	}
 
 	p_pi->subnet_prefix = p_mgr->p_subn->opt.subnet_prefix;
 	if (memcmp(&p_pi->subnet_prefix, &p_old_pi->subnet_prefix,
@@ -1051,6 +1054,13 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 			     CL_DISP_MSGID_NONE, &context);
 	if (status != IB_SUCCESS)
 		ret = -1;
+	/* If we sent a new mkey above, update our guid2mkey map
+	   now, on the assumption that the SubnSet succeeds
+	*/
+	if (update_mkey)
+		osm_db_guid2mkey_set(p_mgr->p_subn->p_g2m,
+				     cl_ntoh64(p_physp->port_guid),
+				     cl_ntoh64(p_pi->m_key));
 
 Exit:
 	OSM_LOG_EXIT(p_mgr->p_log);
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 8fcd0da..98eceaf 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -54,6 +54,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_opensm.h>
+#include <opensm/osm_db_pack.h>
 
 static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 {
@@ -102,6 +103,7 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	int qdr_change = 0, fdr10_change = 0;
 	int ret = 0;
 	ib_net32_t attr_mod, cap_mask;
+	boolean_t update_mkey = FALSE;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -192,8 +194,10 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 		    port_num == 0) {
 			p_pi->m_key = sm->p_subn->opt.m_key;
 			if (memcmp(&p_pi->m_key, &p_old_pi->m_key,
-				   sizeof(p_pi->m_key)))
+				   sizeof(p_pi->m_key))) {
+				update_mkey = TRUE;
 				send_set = TRUE;
+			}
 
 			p_pi->subnet_prefix = sm->p_subn->opt.subnet_prefix;
 			if (memcmp(&p_pi->subnet_prefix,
@@ -464,6 +468,14 @@ Send:
 	if (status)
 		ret = -1;
 
+	/* If we sent a new mkey above, update our guid2mkey map
+ 	   now, on the assumption that the SubnSet succeeds
+	 */
+	if (update_mkey)
+		osm_db_guid2mkey_set(sm->p_subn->p_g2m,
+				     cl_ntoh64(p_physp->port_guid),
+				     cl_ntoh64(p_pi->m_key));
+
 	if (send_set2) {
 		status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_physp),
 				     payload2, sizeof(payload2),
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index 379e269..f518591 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -410,6 +410,11 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 	if (status != IB_SUCCESS)
 		goto Exit;
 
+	/* the DB is in use by subn so init before */
+	status = osm_db_init(&p_osm->db, &p_osm->log);
+	if (status != IB_SUCCESS)
+		goto Exit;
+
 	status = osm_subn_init(&p_osm->subn, p_osm, p_opt);
 	if (status != IB_SUCCESS)
 		goto Exit;
@@ -432,11 +437,6 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 	if (status != IB_SUCCESS)
 		goto Exit;
 
-	/* the DB is in use by the SM and SA so init before */
-	status = osm_db_init(&p_osm->db, &p_osm->log);
-	if (status != IB_SUCCESS)
-		goto Exit;
-
 	status = osm_sm_init(&p_osm->sm, &p_osm->subn, &p_osm->db,
 			     p_osm->p_vendor, &p_osm->mad_pool, &p_osm->vl15,
 			     &p_osm->log, &p_osm->stats, &p_osm->disp,
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index 5438c2c..91ed3a3 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -52,6 +52,8 @@
 #include <opensm/osm_node.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_switch.h>
+#include <opensm/osm_db_pack.h>
+#include <opensm/osm_sm.h>
 
 void osm_physp_construct(IN osm_physp_t * p_physp)
 {
@@ -657,3 +659,33 @@ void osm_alias_guid_delete(IN OUT osm_alias_guid_t ** pp_alias_guid)
 	free(*pp_alias_guid);
 	*pp_alias_guid = NULL;
 }
+
+void osm_physp_set_port_info(IN osm_physp_t * p_physp,
+					   IN const ib_port_info_t * p_pi,
+					   IN const struct osm_sm * p_sm)
+{
+	CL_ASSERT(p_pi);
+	CL_ASSERT(osm_physp_is_valid(p_physp));
+
+	if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN) {
+		/* If PortState is down, only copy PortState */
+		/* and PortPhysicalState per C14-24-2.1 */
+		ib_port_info_set_port_state(&p_physp->port_info, IB_LINK_DOWN);
+		ib_port_info_set_port_phys_state
+		    (ib_port_info_get_port_phys_state(p_pi),
+		     &p_physp->port_info);
+	} else {
+		p_physp->port_info = *p_pi;
+
+		/* The MKey in p_pi can only be considered valid if it's
+		 * for a HCA/router or switch port 0, and it's either
+		 * non-zero or the MKeyProtect bits are also zero.
+		 */
+		if ((osm_node_get_type(p_physp->p_node) != IB_NODE_TYPE_SWITCH ||
+		     p_physp->port_num == 0) &&
+		    (p_pi->m_key != 0 || ib_port_info_get_mpb(p_pi) == 0)) 
+			osm_db_guid2mkey_set(p_sm->p_subn->p_g2m,
+				     	     cl_ntoh64(p_physp->port_guid),
+					     cl_ntoh64(p_pi->m_key));
+	}
+}
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index a4f81a8..7afa26b 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -310,7 +310,7 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	/*
 	   Update the PortInfo attribute.
 	 */
-	osm_physp_set_port_info(p_physp, p_pi);
+	osm_physp_set_port_info(p_physp, p_pi, sm);
 
 	if (port_num == 0) {
 		/* Determine if base switch port 0 */
@@ -335,7 +335,7 @@ static void pi_rcv_process_ca_or_router_port(IN osm_sm_t * sm,
 
 	pi_rcv_check_and_fix_lid(sm->p_log, p_pi, p_physp);
 
-	osm_physp_set_port_info(p_physp, p_pi);
+	osm_physp_set_port_info(p_physp, p_pi, sm);
 
 	pi_rcv_process_endport(sm, p_physp, p_pi);
 
@@ -473,7 +473,7 @@ static void pi_rcv_process_set(IN osm_sm_t * sm, IN osm_node_t * p_node,
 		cl_ntoh64(osm_node_get_node_guid(p_node)),
 		cl_ntoh64(p_smp->trans_id));
 
-	osm_physp_set_port_info(p_physp, p_pi);
+	osm_physp_set_port_info(p_physp, p_pi, sm);
 
 	OSM_LOG_EXIT(sm->p_log);
 }
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 7e9e664..640334a 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -56,6 +56,7 @@
 #include <opensm/osm_vl15intf.h>
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_opensm.h>
+#include <opensm/osm_db_pack.h>
 
 /**********************************************************************
   The plock MAY or MAY NOT be held before calling this function.
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 2629fc5..39fb15a 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -64,6 +64,7 @@
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_inform.h>
 #include <opensm/osm_opensm.h>
+#include <opensm/osm_db.h>
 
 extern void osm_drop_mgr_process(IN osm_sm_t * sm);
 extern int osm_qos_setup(IN osm_opensm_t * p_osm);
@@ -1444,6 +1445,9 @@ repeat_discovery:
 	if (sm->p_subn->force_heavy_sweep
 	    || sm->p_subn->subnet_initialization_error)
 		osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
+
+	/* Write a new copy of our persistent guid2mkey database */
+	osm_db_store(sm->p_subn->p_g2m);
 }
 
 static void do_process_mgrp_queue(osm_sm_t * sm)
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 04c7b18..200287a 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -73,6 +73,8 @@
 #include <opensm/osm_event_plugin.h>
 #include <opensm/osm_qos_policy.h>
 #include <opensm/osm_service.h>
+#include <opensm/osm_db.h>
+#include <opensm/osm_db_pack.h>
 
 static const char null_str[] = "(null)";
 
@@ -422,6 +424,52 @@ static int compar_mgids(const void *m1, const void *m2)
 	return memcmp(m1, m2, sizeof(ib_gid_t));
 }
 
+static void subn_validate_g2m(osm_subn_t *p_subn)
+{
+	cl_qlist_t guids;
+	osm_db_guid_elem_t *p_item;
+	uint64_t mkey;
+	boolean_t valid_entry;
+
+	OSM_LOG_ENTER(&(p_subn->p_osm->log));
+	cl_qlist_init(&guids);
+
+	if (osm_db_guid2mkey_guids(p_subn->p_g2m, &guids)) {
+		OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR, "ERR 7506: "
+			"could not get mkey guid list\n");
+		goto Exit;
+	}
+
+	while ((p_item = (osm_db_guid_elem_t *) cl_qlist_remove_head(&guids))
+	       != (osm_db_guid_elem_t *) cl_qlist_end(&guids)) {
+		valid_entry = TRUE;
+
+		if (p_item->guid == 0) {
+			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+				"ERR 7507: found invalid zero guid");
+			valid_entry = FALSE;
+		} else if (osm_db_guid2mkey_get(p_subn->p_g2m, p_item->guid,
+						&mkey)) {
+			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+				"ERR 7508: could not get mkey for guid:0x%016"
+				PRIx64 "\n", p_item->guid);
+			valid_entry = FALSE;
+		}
+
+		if (valid_entry == FALSE) {
+			if (osm_db_guid2mkey_delete(p_subn->p_g2m,
+                                                        p_item->guid))
+                                OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+                                        "ERR 7509: failed to delete entry for "
+                                        "guid:0x%016" PRIx64 "\n",
+                                        p_item->guid);
+		}
+	}
+
+Exit:
+	OSM_LOG_EXIT(&(p_subn->p_osm->log));
+}
+
 void osm_subn_construct(IN osm_subn_t * p_subn)
 {
 	memset(p_subn, 0, sizeof(*p_subn));
@@ -628,6 +676,35 @@ ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn, IN osm_opensm_t * p_osm,
 	p_subn->sweeping_enabled = TRUE;
 	p_subn->last_sm_port_state = 1;
 
+	/* Initialize the guid2mkey database */
+	p_subn->p_g2m = osm_db_domain_init(&(p_osm->db), "guid2mkey");
+	if (!p_subn->p_g2m) {
+		OSM_LOG(&(p_osm->log), OSM_LOG_ERROR, "ERR 7510: "
+			"Error initializing Guid-to-MKey persistent database\n");
+		return IB_ERROR;
+	}
+
+	if (osm_db_restore(p_subn->p_g2m)) {
+#ifndef __WIN__
+		/*
+		 * When Windows is BSODing, it might corrupt files that
+		 * were previously opened for writing, even if the files
+		 * are closed, so we might see corrupted guid2mkey file.
+		 */
+		if (p_subn->opt.exit_on_fatal) {
+			osm_log(&(p_osm->log), OSM_LOG_SYS, 
+				"FATAL: Error restoring Guid-to-Mkey "
+				"persistent database\n");
+			return IB_ERROR;
+		} else
+#endif
+			OSM_LOG(&(p_osm->log), OSM_LOG_ERROR,
+				"ERR 7511: Error restoring Guid-to-Mkey "
+				"persistent database\n");
+	}
+
+	subn_validate_g2m(p_subn);
+
 	return IB_SUCCESS;
 }
 
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
