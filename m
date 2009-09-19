From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: osm_get_port_by_lid() helper
Date: Sat, 19 Sep 2009 20:00:47 +0300
Message-ID: <20090919170047.GF13667@me>
References: <20090919165817.GC13667@me>
 <20090919165924.GD13667@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090919165924.GD13667@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This new helper is similar to osm_get_port_by_base_lid(), but with
improved interface (returns port's pointer) and moved to osm_subnet.[ch]
(where others osm_get_*_by_*() helpers are located).

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_port.h       |   35 -------------------------------
 opensm/include/opensm/osm_subnet.h     |   25 ++++++++++++++++++++++
 opensm/opensm/osm_port.c               |   36 --------------------------------
 opensm/opensm/osm_sa_link_record.c     |   13 +++--------
 opensm/opensm/osm_sa_path_record.c     |    4 +-
 opensm/opensm/osm_sa_pkey_record.c     |    5 +--
 opensm/opensm/osm_sa_portinfo_record.c |    6 +---
 opensm/opensm/osm_sa_slvl_record.c     |    6 +---
 opensm/opensm/osm_sa_sminfo_record.c   |    6 +---
 opensm/opensm/osm_sa_vlarb_record.c    |    6 +---
 opensm/opensm/osm_subnet.c             |   27 ++++++++++++++++++++++++
 11 files changed, 68 insertions(+), 101 deletions(-)

diff --git a/opensm/include/opensm/osm_port.h b/opensm/include/opensm/osm_port.h
index 000e2fe..eb77ed9 100644
--- a/opensm/include/opensm/osm_port.h
+++ b/opensm/include/opensm/osm_port.h
@@ -1376,41 +1376,6 @@ osm_port_get_lid_range_ho(IN const osm_port_t * const p_port,
 *	Port
 *********/
 
-/****f* OpenSM: Port/osm_get_port_by_base_lid
-* NAME
-*	osm_get_port_by_base_lid
-*
-* DESCRIPTION
-*	Returns a status on whether a Port was able to be
-*	determined based on the LID supplied and if so, return the Port.
-*
-* SYNOPSIS
-*/
-ib_api_status_t
-osm_get_port_by_base_lid(IN const osm_subn_t * const p_subn,
-			 IN const ib_net16_t lid,
-			 IN OUT const osm_port_t ** const pp_port);
-/*
-* PARAMETERS
-*	p_subn
-*		[in] Pointer to the subnet data structure.
-*
-*	lid
-*		[in] LID requested.
-*
-*	pp_port
-*		[in][out] Pointer to pointer to Port object.
-*
-* RETURN VALUES
-*	IB_SUCCESS
-*	IB_NOT_FOUND
-*
-* NOTES
-*
-* SEE ALSO
-*       Port
-*********/
-
 /****f* OpenSM: Physical Port/osm_physp_calc_link_mtu
 * NAME
 *	osm_physp_calc_link_mtu
diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 6c20de8..a8c6b62 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -935,6 +935,31 @@ struct osm_port *osm_get_port_by_guid(IN osm_subn_t const *p_subn,
 *	osm_port_t
 *********/
 
+/****f* OpenSM: Port/osm_get_port_by_lid
+* NAME
+*	osm_get_port_by_lid
+*
+* DESCRIPTION
+*	Returns a pointer of the port object for given lid value.
+*
+* SYNOPSIS
+*/
+struct osm_port *osm_get_port_by_lid(const osm_subn_t * subn, ib_net16_t lid);
+/*
+* PARAMETERS
+*	subn
+*		[in] Pointer to the subnet data structure.
+*
+*	lid
+*		[in] LID requested.
+*
+* RETURN VALUES
+*	The port structure pointer if found. NULL otherwise.
+*
+* SEE ALSO
+*       Subnet object, osm_port_t
+*********/
+
 /****f* OpenSM: Subnet/osm_get_mgrp_by_mlid
 * NAME
 *	osm_get_mgrp_by_mlid
diff --git a/opensm/opensm/osm_port.c b/opensm/opensm/osm_port.c
index dc8a768..79a8913 100644
--- a/opensm/opensm/osm_port.c
+++ b/opensm/opensm/osm_port.c
@@ -184,42 +184,6 @@ void osm_port_get_lid_range_ho(IN const osm_port_t * p_port,
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t osm_get_port_by_base_lid(IN const osm_subn_t * p_subn,
-					 IN ib_net16_t lid,
-					 IN OUT const osm_port_t ** pp_port)
-{
-	ib_api_status_t status;
-	uint16_t base_lid;
-	uint8_t lmc;
-
-	*pp_port = NULL;
-
-	/* Loop on lmc from 0 up through max LMC possible */
-	for (lmc = 0; lmc <= IB_PORT_LMC_MAX; lmc++) {
-		/* Calculate a base LID assuming this is the real LMC */
-		base_lid = cl_ntoh16(lid) & ~((1 << lmc) - 1);
-
-		/* Look for a match */
-		status = cl_ptr_vector_at(&p_subn->port_lid_tbl,
-					  base_lid, (void **)pp_port);
-		if ((status == CL_SUCCESS) && (*pp_port != NULL)) {
-			/* Determine if base LID "tested" is the real base LID */
-			/* This is true if the LMC "tested" is the port's actual LMC */
-			if (lmc == osm_port_get_lmc(*pp_port)) {
-				status = IB_SUCCESS;
-				goto Found;
-			}
-		}
-	}
-	*pp_port = NULL;
-	status = IB_NOT_FOUND;
-
-Found:
-	return status;
-}
-
-/**********************************************************************
- **********************************************************************/
 uint8_t osm_physp_calc_link_mtu(IN osm_log_t * p_log,
 				IN const osm_physp_t * p_physp)
 {
diff --git a/opensm/opensm/osm_sa_link_record.c b/opensm/opensm/osm_sa_link_record.c
index bf0b5ee..9e55e71 100644
--- a/opensm/opensm/osm_sa_link_record.c
+++ b/opensm/opensm/osm_sa_link_record.c
@@ -363,7 +363,6 @@ static ib_net16_t lr_rcv_get_end_points(IN osm_sa_t * sa,
 	const ib_link_record_t *p_lr;
 	const ib_sa_mad_t *p_sa_mad;
 	ib_net64_t comp_mask;
-	ib_api_status_t status;
 	ib_net16_t sa_status = IB_SA_MAD_STATUS_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -380,10 +379,8 @@ static ib_net16_t lr_rcv_get_end_points(IN osm_sa_t * sa,
 	*pp_dest_port = NULL;
 
 	if (p_sa_mad->comp_mask & IB_LR_COMPMASK_FROM_LID) {
-		status = osm_get_port_by_base_lid(sa->p_subn, p_lr->from_lid,
-						  pp_src_port);
-
-		if (status != IB_SUCCESS || *pp_src_port == NULL) {
+		*pp_src_port = osm_get_port_by_lid(sa->p_subn, p_lr->from_lid);
+		if (!*pp_src_port) {
 			/*
 			   This 'error' is the client's fault (bad lid) so
 			   don't enter it as an error in our own log.
@@ -399,10 +396,8 @@ static ib_net16_t lr_rcv_get_end_points(IN osm_sa_t * sa,
 	}
 
 	if (p_sa_mad->comp_mask & IB_LR_COMPMASK_TO_LID) {
-		status = osm_get_port_by_base_lid(sa->p_subn, p_lr->to_lid,
-						  pp_dest_port);
-
-		if (status != IB_SUCCESS || *pp_dest_port == NULL) {
+		*pp_dest_port = osm_get_port_by_lid(sa->p_subn, p_lr->to_lid);
+		if (!*pp_dest_port) {
 			/*
 			   This 'error' is the client's fault (bad lid) so
 			   don't enter it as an error in our own log.
diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index 37f32ac..2247ebe 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -1496,8 +1496,8 @@ static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 	}
 
 	if (comp_mask & IB_PR_COMPMASK_SLID) {
-		if (osm_get_port_by_base_lid(sa->p_subn, p_pr->slid, &port) ||
-		    !port || !osm_mgrp_get_mcm_port(p_mgrp, port->guid))
+		port = osm_get_port_by_lid(sa->p_subn, p_pr->slid);
+		if (!port || !osm_mgrp_get_mcm_port(p_mgrp, port->guid))
 			goto Exit;
 	}
 
diff --git a/opensm/opensm/osm_sa_pkey_record.c b/opensm/opensm/osm_sa_pkey_record.c
index 8e47745..a5a3e28 100644
--- a/opensm/opensm/osm_sa_pkey_record.c
+++ b/opensm/opensm/osm_sa_pkey_record.c
@@ -300,9 +300,8 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 	   work load, since we don't have to search every port
 	 */
 	if (comp_mask & IB_PKEY_COMPMASK_LID) {
-		status = osm_get_port_by_base_lid(sa->p_subn, p_rcvd_rec->lid,
-						  &p_port);
-		if (status != IB_SUCCESS || p_port == NULL) {
+		p_port = osm_get_port_by_lid(sa->p_subn, p_rcvd_rec->lid);
+		if (!p_port) {
 			status = IB_NOT_FOUND;
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 460B: "
 				"No port found with LID %u\n",
diff --git a/opensm/opensm/osm_sa_portinfo_record.c b/opensm/opensm/osm_sa_portinfo_record.c
index b5ef101..448981c 100644
--- a/opensm/opensm/osm_sa_portinfo_record.c
+++ b/opensm/opensm/osm_sa_portinfo_record.c
@@ -521,10 +521,8 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 	   work load, since we don't have to search every port
 	 */
 	if (comp_mask & IB_PIR_COMPMASK_LID) {
-		status =
-		    osm_get_port_by_base_lid(sa->p_subn, p_rcvd_rec->lid,
-					     &p_port);
-		if ((status != IB_SUCCESS) || (p_port == NULL)) {
+		p_port = osm_get_port_by_lid(sa->p_subn, p_rcvd_rec->lid);
+		if (!p_port) {
 			status = IB_NOT_FOUND;
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2109: "
 				"No port found with LID %u\n",
diff --git a/opensm/opensm/osm_sa_slvl_record.c b/opensm/opensm/osm_sa_slvl_record.c
index 061d970..d310df0 100644
--- a/opensm/opensm/osm_sa_slvl_record.c
+++ b/opensm/opensm/osm_sa_slvl_record.c
@@ -274,10 +274,8 @@ void osm_slvl_rec_rcv_process(IN void *ctx, IN void *data)
 	   work load, since we don't have to search every port
 	 */
 	if (comp_mask & IB_SLVL_COMPMASK_LID) {
-		status =
-		    osm_get_port_by_base_lid(sa->p_subn, p_rcvd_rec->lid,
-					     &p_port);
-		if ((status != IB_SUCCESS) || (p_port == NULL)) {
+		p_port = osm_get_port_by_lid(sa->p_subn, p_rcvd_rec->lid);
+		if (!p_port) {
 			status = IB_NOT_FOUND;
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2608: "
 				"No port found with LID %u\n",
diff --git a/opensm/opensm/osm_sa_sminfo_record.c b/opensm/opensm/osm_sa_sminfo_record.c
index 4d454af..dcc8615 100644
--- a/opensm/opensm/osm_sa_sminfo_record.c
+++ b/opensm/opensm/osm_sa_sminfo_record.c
@@ -236,10 +236,8 @@ void osm_smir_rcv_process(IN void *ctx, IN void *data)
 	   work load, since we don't have to search every port
 	 */
 	if (comp_mask & IB_SMIR_COMPMASK_LID) {
-		status =
-		    osm_get_port_by_base_lid(sa->p_subn, p_rcvd_rec->lid,
-					     &p_port);
-		if ((status != IB_SUCCESS) || (p_port == NULL)) {
+		p_port = osm_get_port_by_lid(sa->p_subn, p_rcvd_rec->lid);
+		if (!p_port) {
 			status = IB_NOT_FOUND;
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2806: "
 				"No port found with LID %u\n",
diff --git a/opensm/opensm/osm_sa_vlarb_record.c b/opensm/opensm/osm_sa_vlarb_record.c
index f9f11b7..5c66049 100644
--- a/opensm/opensm/osm_sa_vlarb_record.c
+++ b/opensm/opensm/osm_sa_vlarb_record.c
@@ -288,10 +288,8 @@ void osm_vlarb_rec_rcv_process(IN void *ctx, IN void *data)
 	   work load, since we don't have to search every port
 	 */
 	if (comp_mask & IB_VLA_COMPMASK_LID) {
-		status =
-		    osm_get_port_by_base_lid(sa->p_subn, p_rcvd_rec->lid,
-					     &p_port);
-		if ((status != IB_SUCCESS) || (p_port == NULL)) {
+		p_port = osm_get_port_by_lid(sa->p_subn, p_rcvd_rec->lid);
+		if (!p_port) {
 			status = IB_NOT_FOUND;
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2A09: "
 				"No port found with LID %u\n",
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 8d63a75..b475031 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -643,6 +643,33 @@ osm_port_t *osm_get_port_by_guid(IN osm_subn_t const *p_subn, IN ib_net64_t guid
 
 /**********************************************************************
  **********************************************************************/
+osm_port_t *osm_get_port_by_lid(IN osm_subn_t const * subn, IN ib_net16_t lid)
+{
+	osm_port_t *port = NULL;
+	ib_api_status_t stat;
+	uint16_t base_lid;
+	uint8_t lmc;
+
+	lid = cl_ntoh16(lid);
+
+	/* Loop on lmc from 0 up through max LMC possible */
+	for (lmc = 0; lmc <= IB_PORT_LMC_MAX; lmc++) {
+		/* Calculate a base LID assuming this is the real LMC */
+		base_lid = lid & ~((1 << lmc) - 1);
+
+		stat = cl_ptr_vector_at(&subn->port_lid_tbl, base_lid,
+					(void *)&port);
+		/* Determine if base LID "tested" is the real base LID */
+		/* This is true if the LMC "tested" is the port's actual LMC */
+		if (stat == CL_SUCCESS && port && lmc == osm_port_get_lmc(port))
+			return port;
+	}
+
+	return NULL;
+}
+
+/**********************************************************************
+ **********************************************************************/
 static void subn_set_default_qos_options(IN osm_qos_options_t * opt)
 {
 	opt->max_vls = OSM_DEFAULT_QOS_MAX_VLS;
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
