From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH]  opensm: Reduce heap consumption by multicast routing
	tables (MFTs)
Date: Wed, 14 Oct 2009 07:14:28 -0400
Message-ID: <20091014111428.GA17501@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Heap memory consumption by the unicast and multicast routing tables can be
reduced.

This patch is analagous to the previous patch doing this for the unicast
routing tables (LFTs).

Using valgrind --tool=massif (for heap profiling), there are couple of place
->38.75% (11,206,656B) 0x43267E: osm_switch_new (osm_switch.c:134)
->12.89% (3,728,256B) 0x40F8C9: osm_mcast_tbl_init (osm_mcast_tbl.c:96)

osm_mcast_tbl_init (osm_mcast_tbl.c:96):
        p_tbl->p_mask_tbl = malloc(p_tbl->num_entries *
                                   (IB_MCAST_POSITION_MAX +
                                    1) * IB_MCAST_MASK_SIZE / 8);

num_entries above is set based on the switch's MulticastFDBCap
(indicated in it's SM class SwitchInfo attribute).

The MFT is now allocated in chunks. If there is a MLID offset that exceeds
the current MFT size, the MFT is reallocated with an increased size.

A new config option specifies the MFT allocation chunk (in units of 64 entries)
and defaults to 1K entries.

These chunks will be used as the initial minimum allocation and increased
in increments of the chunk using realloc.

MFTs are only be increased in size and are never reduced in size. If a realloc
for MFT fails, it is treated as a fatal error and OpenSM is exited.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---

diff --git a/opensm/include/opensm/osm_base.h b/opensm/include/opensm/osm_base.h
index 06223ce..524646c 100644
--- a/opensm/include/opensm/osm_base.h
+++ b/opensm/include/opensm/osm_base.h
@@ -449,6 +449,17 @@ BEGIN_C_DECLS
 */
 #define OSM_DEFAULT_SMP_MAX_ON_WIRE 4
 /***********/
+/****d* OpenSM: Base/OSM_DEFAULT_MFT_CHUNKS
+* NAME
+*	OSM_DEFAULT_MFT_CHUNKS
+*
+* DESCRIPTION
+*	Specifies the default number of 64 entry chunks in MFT related
+*	memory (re)allocation. Default is 16 (1K entries).
+*
+* SYNOPSIS
+*/
+#define OSM_DEFAULT_MFT_CHUNKS 16
 /****d* OpenSM: Base/OSM_SM_DEFAULT_QP0_RCV_SIZE
 * NAME
 *	OSM_SM_DEFAULT_QP0_RCV_SIZE
diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/opensm/osm_mcast_tbl.h
index 710d199..503a9cb 100644
--- a/opensm/include/opensm/osm_mcast_tbl.h
+++ b/opensm/include/opensm/osm_mcast_tbl.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -46,6 +46,7 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <opensm/osm_base.h>
+#include <opensm/osm_subnet.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -74,6 +75,7 @@ typedef struct osm_mcast_fwdbl {
 	int16_t max_block_in_use;
 	uint16_t num_entries;
 	uint16_t max_mlid_ho;
+	uint16_t mft_size;
 	uint16_t(*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
 } osm_mcast_tbl_t;
 /*
@@ -97,7 +99,7 @@ typedef struct osm_mcast_fwdbl {
 *	max_mlid_ho
 *		Maximum MLID value (host order).
 *
-*	pp_mask_tbl
+*	p_mask_tbl
 *		Pointer to a two dimensional array of port_masks for this switch.
 *		The first dimension is MLID, the second dimension is mask position.
 *		This pointer is null for switches that do not support multicast.
@@ -115,7 +117,8 @@ typedef struct osm_mcast_fwdbl {
 * SYNOPSIS
 */
 ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
-				   IN uint8_t num_ports, IN uint16_t capacity);
+				   IN uint8_t num_ports, IN uint16_t capacity,
+				   IN osm_subn_t * const p_subn);
 /*
 * PARAMETERS
 *	num_ports
@@ -158,6 +161,39 @@ void osm_mcast_tbl_delete(IN osm_mcast_tbl_t ** pp_tbl);
 * SEE ALSO
 *********/
 
+/****f* OpenSM: Forwarding Table/osm_mcast_tbl_realloc_mask_tbl
+* NAME
+*	osm_mcast_tbl_realloc_mask_tbl
+*
+* DESCRIPTION
+*	This function reallocates the port mask table if necessary.
+*
+* SYNOPSIS
+*/
+void
+osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * const p_tbl,
+			       IN osm_subn_t * const p_subn,
+			       IN uintn_t mlid_offset);
+/*
+* PARAMETERS
+*
+*	p_tbl
+*		[in] Pointer to the Multicast Forwarding Table object.
+*
+*	p_subn
+*		[in] Pointer to the subnet object.
+*
+*	mlid_offset
+*		[in] Offset of MLID being accessed.
+*
+* RETURN VALUE
+*	None
+*
+* NOTES
+*
+* SEE ALSO
+*/
+
 /****f* OpenSM: Forwarding Table/osm_mcast_tbl_destroy
 * NAME
 *	osm_mcast_tbl_destroy
@@ -191,7 +227,7 @@ void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * p_tbl);
 * SYNOPSIS
 */
 void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
-		       IN uint8_t port_num);
+		       IN uint8_t port_num, IN osm_subn_t * const p_subn);
 /*
 * PARAMETERS
 *	p_tbl
@@ -304,6 +340,7 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 * SYNOPSIS
 */
 ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
+					IN osm_subn_t * p_subn,
 					IN const ib_net16_t * p_block,
 					IN int16_t block_num,
 					IN uint8_t position);
@@ -336,8 +373,8 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 * SYNOPSIS
 */
 boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
-				  IN int16_t block_num, IN uint8_t position,
-				  OUT ib_net16_t * p_block);
+				  IN osm_subn_t * p_subn, IN int16_t block_num,
+				  IN uint8_t position, OUT ib_net16_t * p_block);
 /*
 * PARAMETERS
 *	p_tbl
diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 9488225..2893d18 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -211,6 +211,7 @@ typedef struct osm_subn_opt {
 	osm_qos_options_t qos_rtr_options;
 	boolean_t enable_quirks;
 	boolean_t no_clients_rereg;
+	uint32_t mft_chunks;
 #ifdef ENABLE_OSM_PERF_MGR
 	boolean_t perfmgr;
 	boolean_t perfmgr_redir;
@@ -428,6 +429,9 @@ typedef struct osm_subn_opt {
 *	babbling_port_policy
 *		OpenSM will enforce its "babbling" port policy.
 *
+*	mft_chunks
+*		Number of 16 entry chunks used in MFT (re)allocation
+*
 *	perfmgr
 *		Enable or disable the performance manager
 *
diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm/osm_switch.h
index 655491d..0262d10 100644
--- a/opensm/include/opensm/osm_switch.h
+++ b/opensm/include/opensm/osm_switch.h
@@ -222,7 +222,8 @@ void osm_switch_delete(IN OUT osm_switch_t ** pp_sw);
 * SYNOPSIS
 */
 osm_switch_t *osm_switch_new(IN osm_node_t * p_node,
-			     IN const osm_madw_t * p_madw);
+			     IN const osm_madw_t * p_madw,
+			     IN osm_subn_t * p_subn);
 /*
 * PARAMETERS
 *	p_node
@@ -747,12 +748,13 @@ osm_switch_set_lft_block(IN osm_switch_t * p_sw, IN const uint8_t * p_block,
 * SYNOPSIS
 */
 static inline ib_api_status_t
-osm_switch_set_mft_block(IN osm_switch_t * p_sw, IN const ib_net16_t * p_block,
+osm_switch_set_mft_block(IN osm_switch_t * p_sw, IN osm_subn_t * const p_subn,
+			 IN const ib_net16_t * p_block,
 			 IN uint16_t block_num, IN uint8_t position)
 {
 	CL_ASSERT(p_sw);
-	return osm_mcast_tbl_set_block(&p_sw->mcast_tbl, p_block, block_num,
-				       position);
+	return osm_mcast_tbl_set_block(&p_sw->mcast_tbl, p_subn, p_block,
+				       block_num, position);
 }
 /*
 * PARAMETERS
@@ -786,13 +788,14 @@ osm_switch_set_mft_block(IN osm_switch_t * p_sw, IN const ib_net16_t * p_block,
 * SYNOPSIS
 */
 static inline boolean_t osm_switch_get_mft_block(IN osm_switch_t * p_sw,
+						 IN osm_subn_t * const p_subn,
 						 IN uint16_t block_num,
 						 IN uint8_t position,
 						 OUT ib_net16_t * p_block)
 {
 	CL_ASSERT(p_sw);
-	return osm_mcast_tbl_get_block(&p_sw->mcast_tbl, block_num, position,
-				       p_block);
+	return osm_mcast_tbl_get_block(&p_sw->mcast_tbl, p_subn, block_num,
+				       position, p_block);
 }
 /*
 * PARAMETERS
diff --git a/opensm/opensm/osm_dump.c b/opensm/opensm/osm_dump.c
index 08b3156..c004b6c 100644
--- a/opensm/opensm/osm_dump.c
+++ b/opensm/opensm/osm_dump.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -232,6 +232,7 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 static void dump_mcast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 {
 	osm_switch_t *p_sw = (osm_switch_t *) item;
+	osm_opensm_t *p_osm = cxt;
 	osm_mcast_tbl_t *p_tbl;
 	int16_t mlid_ho = 0;
 	int16_t mlid_start_ho;
@@ -261,6 +262,9 @@ static void dump_mcast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 			sprintf(mlid_hdr, "0x%04X :",
 				mlid_ho + IB_LID_MCAST_START_HO);
 			while (position <= p_tbl->max_position) {
+				osm_mcast_tbl_realloc_mask_tbl(p_tbl,
+							       &p_osm->subn,
+							       mlid_ho);
 				mask_entry =
 				    cl_ntoh16((*p_tbl->
 					       p_mask_tbl)[mlid_ho][position]);
diff --git a/opensm/opensm/osm_mcast_fwd_rcv.c b/opensm/opensm/osm_mcast_fwd_rcv.c
index f3d0183..b071953 100644
--- a/opensm/opensm/osm_mcast_fwd_rcv.c
+++ b/opensm/opensm/osm_mcast_fwd_rcv.c
@@ -103,7 +103,7 @@ void osm_mft_rcv_process(IN void *context, IN void *data)
 			"MFT received for nonexistent node "
 			"0x%016" PRIx64 "\n", cl_ntoh64(node_guid));
 	} else {
-		status = osm_switch_set_mft_block(p_sw, p_block,
+		status = osm_switch_set_mft_block(p_sw, sm->p_subn, p_block,
 						  (uint16_t) block_num,
 						  position);
 		if (status != IB_SUCCESS) {
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 77e0b94..55369d0 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -322,7 +322,7 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 
 	p_tbl = osm_switch_get_mcast_tbl_ptr(p_sw);
 
-	if (osm_mcast_tbl_get_block(p_tbl, (uint16_t) block_num,
+	if (osm_mcast_tbl_get_block(p_tbl, sm->p_subn, (uint16_t) block_num,
 				    (uint8_t) position, block)) {
 
 		block_id_ho = block_num + (position << 28);
@@ -571,7 +571,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 			"Adding upstream port %u\n", upstream_port);
 
 		CL_ASSERT(upstream_port);
-		osm_mcast_tbl_set(p_tbl, mlid_ho, upstream_port);
+		osm_mcast_tbl_set(p_tbl, mlid_ho, upstream_port, sm->p_subn);
 	}
 
 	/*
@@ -610,7 +610,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 		   set the appropriate bit in the multicast forwarding
 		   table for this switch.
 		 */
-		osm_mcast_tbl_set(p_tbl, mlid_ho, i);
+		osm_mcast_tbl_set(p_tbl, mlid_ho, i, sm->p_subn);
 		if (i == 0) {
 			/* This means we are adding the switch to the MC group.
 			   We do not need to continue looking at the remote port, just
@@ -812,7 +812,7 @@ void osm_mcast_mgr_set_table(osm_sm_t * sm, IN const osm_mgrp_t * p_mgrp,
 		if (p_child_mtn == NULL)
 			continue;
 
-		osm_mcast_tbl_set(p_tbl, mlid_ho, i);
+		osm_mcast_tbl_set(p_tbl, mlid_ho, i, sm->p_subn);
 	}
 
 	OSM_LOG_EXIT(sm->p_log);
@@ -941,7 +941,8 @@ ib_api_status_t osm_mcast_mgr_process_single(osm_sm_t * sm,
 
 			p_mcast_tbl =
 			    osm_switch_get_mcast_tbl_ptr(p_remote_node->sw);
-			osm_mcast_tbl_set(p_mcast_tbl, mlid_ho, port_num);
+			osm_mcast_tbl_set(p_mcast_tbl, mlid_ho, port_num,
+					  sm->p_subn);
 		} else {
 			if (join_state & IB_JOIN_STATE_SEND_ONLY)
 				OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index d7c9529..4cc775b 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2006 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -50,11 +50,14 @@
 #include <complib/cl_math.h>
 #include <iba/ib_types.h>
 #include <opensm/osm_mcast_tbl.h>
+#include <opensm/osm_log.h>
+#include <opensm/osm_opensm.h>
 
 /**********************************************************************
  **********************************************************************/
 ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
-				   IN uint8_t num_ports, IN uint16_t capacity)
+				   IN uint8_t num_ports, IN uint16_t capacity,
+				   IN osm_subn_t * p_subn)
 {
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(num_ports);
@@ -93,7 +96,8 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
 	   since it is (and must be) defined that way the table structure
 	   in order to create a pointer to a two dimensional array.
 	 */
-	p_tbl->p_mask_tbl = calloc(p_tbl->num_entries,
+	p_tbl->mft_size = p_subn->opt.mft_chunks * IB_MCAST_BLOCK_SIZE;
+	p_tbl->p_mask_tbl = calloc(p_tbl->mft_size,
 				   (IB_MCAST_POSITION_MAX +
 				    1) * IB_MCAST_MASK_SIZE / 8);
 
@@ -113,7 +117,7 @@ void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * p_tbl)
 /**********************************************************************
  **********************************************************************/
 void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
-		       IN uint8_t port)
+		       IN uint8_t port, IN osm_subn_t * p_subn)
 {
 	uintn_t mlid_offset;
 	uintn_t mask_offset;
@@ -128,6 +132,7 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
 	mask_offset = port / IB_MCAST_MASK_SIZE;
 	bit_mask = cl_ntoh16((uint16_t) (1 << (port % IB_MCAST_MASK_SIZE)));
+	osm_mcast_tbl_realloc_mask_tbl(p_tbl, p_subn, mlid_offset);
 	(*p_tbl->p_mask_tbl)[mlid_offset][mask_offset] |= bit_mask;
 
 	block_num = (int16_t) (mlid_offset / IB_MCAST_BLOCK_SIZE);
@@ -138,6 +143,45 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 
 /**********************************************************************
  **********************************************************************/
+void
+osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * const p_tbl,
+			       IN osm_subn_t * const p_subn,
+			       IN uintn_t mlid_offset)
+{
+	size_t mft_size, size;
+	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
+
+	if (mlid_offset < p_tbl->mft_size)
+		return;
+
+	mft_size = (mlid_offset +
+		    p_subn->opt.mft_chunks * IB_MCAST_BLOCK_SIZE) /
+		    IB_MCAST_BLOCK_SIZE * IB_MCAST_BLOCK_SIZE;
+	if (mft_size == p_tbl->mft_size)
+		mft_size += p_subn->opt.mft_chunks * IB_MCAST_BLOCK_SIZE;
+	if (mft_size > p_tbl->max_block * IB_MCAST_BLOCK_SIZE)
+		mft_size = p_tbl->max_block * IB_MCAST_BLOCK_SIZE;
+	size = mft_size * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8;
+	p_mask_tbl = realloc(p_tbl->p_mask_tbl, size);
+	if (!p_mask_tbl)
+		goto error;
+	memset((uint8_t *)p_mask_tbl + p_tbl->mft_size * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8,
+	       0,
+	       size - p_tbl->mft_size * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
+	p_tbl->p_mask_tbl = p_mask_tbl;
+	p_tbl->mft_size = mft_size;
+	return;
+
+error:
+	OSM_LOG(&p_subn->p_osm->log, OSM_LOG_SYS,
+		"Reallocation of multicast mask table failed - exiting\n");
+	OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR, " ERR 6401: "
+		"Reallocation of multicast mask table failed - exiting\n");
+	exit(1);
+}
+
+/**********************************************************************
+ **********************************************************************/
 boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 				IN uint16_t mlid_ho, IN uint8_t port_num)
 {
@@ -154,6 +198,8 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_size)
+			return FALSE;
 		mask_offset = port_num / IB_MCAST_MASK_SIZE;
 		bit_mask = cl_ntoh16((uint16_t)
 				     (1 << (port_num % IB_MCAST_MASK_SIZE)));
@@ -181,6 +227,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_size)
+			return FALSE;
 
 		for (position = 0; position <= p_tbl->max_position; position++)
 			result |= (*p_tbl->p_mask_tbl)[mlid_offset][position];
@@ -192,6 +240,7 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 /**********************************************************************
  **********************************************************************/
 ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
+					IN osm_subn_t * p_subn,
 					IN const ib_net16_t * p_block,
 					IN int16_t block_num,
 					IN uint8_t position)
@@ -213,6 +262,9 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->max_mlid_ho)
 		return IB_INVALID_PARAMETER;
 
+	osm_mcast_tbl_realloc_mask_tbl(p_tbl, p_subn,
+				       mlid_start_ho + IB_MCAST_BLOCK_SIZE);
+
 	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
 		(*p_tbl->p_mask_tbl)[mlid_start_ho + i][position] = p_block[i];
 
@@ -234,6 +286,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 
 	if (p_tbl->p_mask_tbl && (mlid_ho <= p_tbl->max_mlid_ho)) {
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_size)
+			return;
 		for (i = 0; i <= p_tbl->max_position; i++)
 			(*p_tbl->p_mask_tbl)[mlid_offset][i] = 0;
 	}
@@ -242,6 +296,7 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 /**********************************************************************
  **********************************************************************/
 boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
+				  IN osm_subn_t * p_subn,
 				  IN int16_t block_num, IN uint8_t position,
 				  OUT ib_net16_t * p_block)
 {
@@ -264,6 +319,9 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
 
 	mlid_start_ho = (uint16_t) (block_num * IB_MCAST_BLOCK_SIZE);
 
+	osm_mcast_tbl_realloc_mask_tbl(p_tbl, p_subn,
+				       mlid_start_ho + IB_MCAST_BLOCK_SIZE);
+
 	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
 		p_block[i] = (*p_tbl->p_mask_tbl)[mlid_start_ho + i][position];
 
diff --git a/opensm/opensm/osm_sa_mft_record.c b/opensm/opensm/osm_sa_mft_record.c
index 841eb86..79a4f44 100644
--- a/opensm/opensm/osm_sa_mft_record.c
+++ b/opensm/opensm/osm_sa_mft_record.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -104,7 +104,8 @@ static ib_api_status_t mftr_rcv_new_mftr(IN osm_sa_t * sa,
 	p_rec_item->rec.position_block_num = cl_hton16(position_block_num);
 
 	/* copy the mft block */
-	osm_switch_get_mft_block(p_sw, block, position, p_rec_item->rec.mft);
+	osm_switch_get_mft_block(p_sw, sa->p_subn, block, position,
+				 p_rec_item->rec.mft);
 
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
 
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 647950e..bcaea8a 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -352,6 +352,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "daemon", OPT_OFFSET(daemon), opts_parse_boolean, NULL, 0 },
 	{ "sm_inactive", OPT_OFFSET(sm_inactive), opts_parse_boolean, NULL, 1 },
 	{ "babbling_port_policy", OPT_OFFSET(babbling_port_policy), opts_parse_boolean, NULL, 1 },
+	{ "mft_chunks", OPT_OFFSET(mft_chunks), opts_parse_uint32, NULL, 1 },
 #ifdef ENABLE_OSM_PERF_MGR
 	{ "perfmgr", OPT_OFFSET(perfmgr), opts_parse_boolean, NULL, 0 },
 	{ "perfmgr_redir", OPT_OFFSET(perfmgr_redir), opts_parse_boolean, NULL, 0 },
@@ -724,6 +725,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->daemon = FALSE;
 	p_opt->sm_inactive = FALSE;
 	p_opt->babbling_port_policy = FALSE;
+	p_opt->mft_chunks = OSM_DEFAULT_MFT_CHUNKS;
 #ifdef ENABLE_OSM_PERF_MGR
 	p_opt->perfmgr = FALSE;
 	p_opt->perfmgr_redir = TRUE;
@@ -1199,6 +1201,13 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
 				    NULL);
 			break;
 		}
+		if (p_opts->mft_chunks < 1 || p_opts->mft_chunks > 256) {
+			log_report(" Invalid Cached Option Value:"
+				   "mft_chunks = %u"
+				   " Using Default:%u\n",
+				   p_opts->mft_chunks, OSM_DEFAULT_MFT_CHUNKS);
+			p_opts->mft_chunks = OSM_DEFAULT_MFT_CHUNKS;
+		}
 	}
 	fclose(opts_file);
 
@@ -1524,6 +1533,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->sm_inactive ? "TRUE" : "FALSE",
 		p_opts->babbling_port_policy ? "TRUE" : "FALSE");
 
+	fprintf(out,
+		"# Number of 16 entry chunks used when (re)allocating "
+		"MFTs\nmft_chunks %d\n\n",
+		p_opts->mft_chunks);
+
 #ifdef ENABLE_OSM_PERF_MGR
 	fprintf(out,
 		"#\n# Performance Manager Options\n#\n"
diff --git a/opensm/opensm/osm_sw_info_rcv.c b/opensm/opensm/osm_sw_info_rcv.c
index c335263..9861525 100644
--- a/opensm/opensm/osm_sw_info_rcv.c
+++ b/opensm/opensm/osm_sw_info_rcv.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -211,7 +211,7 @@ static void si_rcv_process_new(IN osm_sm_t * sm, IN osm_node_t * p_node,
 
 	osm_dump_switch_info(sm->p_log, p_si, OSM_LOG_DEBUG);
 
-	p_sw = osm_switch_new(p_node, p_madw);
+	p_sw = osm_switch_new(p_node, p_madw, sm->p_subn);
 	if (p_sw == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3608: "
 			"Unable to allocate new switch object\n");
diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
index ed0bc66..7ad1af4 100644
--- a/opensm/opensm/osm_switch.c
+++ b/opensm/opensm/osm_switch.c
@@ -99,7 +99,8 @@ void osm_switch_delete(IN OUT osm_switch_t ** pp_sw)
 /**********************************************************************
  **********************************************************************/
 osm_switch_t *osm_switch_new(IN osm_node_t * p_node,
-			     IN const osm_madw_t * p_madw)
+			     IN const osm_madw_t * p_madw,
+			     IN osm_subn_t * p_subn)
 {
 	osm_switch_t *p_sw;
 	ib_switch_info_t *p_si;
@@ -137,7 +138,7 @@ osm_switch_t *osm_switch_new(IN osm_node_t * p_node,
 	memset(p_sw->p_prof, 0, sizeof(*p_sw->p_prof) * num_ports);
 
 	if (osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_get_num_physp(p_node),
-			       cl_ntoh16(p_si->mcast_cap)))
+			       cl_ntoh16(p_si->mcast_cap), p_subn))
 		goto err;
 
 	for (port_num = 0; port_num < num_ports; port_num++)
@@ -508,7 +509,6 @@ static int alloc_lft(IN osm_switch_t * p_sw, uint16_t lids)
 		p_sw->lft = new_lft;
 		p_sw->lft_size = lft_size;
 	}
-
 	return 0;
 }
 
@@ -549,7 +549,6 @@ int osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids
 		p_sw->num_hops = max_lids + 1;
 	}
 	p_sw->max_lid_ho = max_lids;
-
 	return 0;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
