From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] opensm: Reduce heap consumption by multicast routing
	tables (MFTs)
Date: Wed, 14 Oct 2009 11:52:24 -0400
Message-ID: <20091014155224.GA21566@comcast.net>
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

MFTs are only be increased in size and are never reduced in size. If a realloc
for MFT fails, it is treated as a fatal error and OpenSM is exited.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
MFT allocation based on actual MLID requests

diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/opensm/osm_mcast_tbl.h
index 710d199..dfbdc12 100644
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
@@ -114,8 +116,8 @@ typedef struct osm_mcast_fwdbl {
 *
 * SYNOPSIS
 */
-ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
-				   IN uint8_t num_ports, IN uint16_t capacity);
+void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_ports,
+			IN uint16_t capacity, IN osm_subn_t * const p_subn);
 /*
 * PARAMETERS
 *	num_ports
@@ -126,7 +128,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
 *		by this switch.
 *
 * RETURN VALUE
-*	IB_SUCCESS on success.
+*	None.
 *
 * NOTES
 *
@@ -158,6 +160,38 @@ void osm_mcast_tbl_delete(IN osm_mcast_tbl_t ** pp_tbl);
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
+osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * p_tbl,
+			       IN osm_subn_t * p_subn, IN uintn_t mlid_offset);
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
@@ -191,7 +225,7 @@ void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * p_tbl);
 * SYNOPSIS
 */
 void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
-		       IN uint8_t port_num);
+		       IN uint8_t port_num, IN osm_subn_t * const p_subn);
 /*
 * PARAMETERS
 *	p_tbl
@@ -304,6 +338,7 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 * SYNOPSIS
 */
 ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
+					IN osm_subn_t * p_subn,
 					IN const ib_net16_t * p_block,
 					IN int16_t block_num,
 					IN uint8_t position);
@@ -336,8 +371,8 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
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
index 77e0b94..36554b1 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -322,7 +322,7 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 
 	p_tbl = osm_switch_get_mcast_tbl_ptr(p_sw);
 
-	if (osm_mcast_tbl_get_block(p_tbl, (uint16_t) block_num,
+	if (osm_mcast_tbl_get_block(p_tbl, sm->p_subn, (uint16_t) block_num,
 				    (uint8_t) position, block)) {
 
 		block_id_ho = block_num + (position << 28);
@@ -351,7 +351,7 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 
 /**********************************************************************
   This is part of the recursive function to compute the paths in the
-  spanning tree that eminate from this switch.  On input, the p_list
+  spanning tree that emanate from this switch.  On input, the p_list
   contains the group members that must be routed from this switch.
 **********************************************************************/
 static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
@@ -368,7 +368,7 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 	mlid_ho = cl_ntoh16(osm_mgrp_get_mlid(p_mgrp));
 
 	/*
-	   For Multicast Groups, we want not to count on previous
+	   For Multicast Groups, we don't want to count on previous
 	   configurations - since we can easily generate a storm
 	   by loops.
 	 */
@@ -396,8 +396,8 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A03: "
 				"Error routing MLID 0x%X through switch 0x%"
 				PRIx64 "\n"
-				"\t\t\t\tNo multicast paths from this switch for port "
-				"with LID %u\n", mlid_ho, node_guid_ho,
+				"\t\t\t\tNo multicast paths from this switch "
+				"for port with LID %u\n", mlid_ho, node_guid_ho,
 				cl_ntoh16(osm_port_get_base_lid
 					  (p_wobj->p_port)));
 
@@ -411,8 +411,8 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A04: "
 				"Error routing MLID 0x%X through switch 0x%"
 				PRIx64 "\n"
-				"\t\t\t\tNo multicast paths from this switch to port "
-				"with LID %u\n", mlid_ho, node_guid_ho,
+				"\t\t\t\tNo multicast paths from this switch "
+				"to port with LID %u\n", mlid_ho, node_guid_ho,
 				cl_ntoh16(osm_port_get_base_lid
 					  (p_wobj->p_port)));
 
@@ -571,7 +571,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 			"Adding upstream port %u\n", upstream_port);
 
 		CL_ASSERT(upstream_port);
-		osm_mcast_tbl_set(p_tbl, mlid_ho, upstream_port);
+		osm_mcast_tbl_set(p_tbl, mlid_ho, upstream_port, sm->p_subn);
 	}
 
 	/*
@@ -610,11 +610,11 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 		   set the appropriate bit in the multicast forwarding
 		   table for this switch.
 		 */
-		osm_mcast_tbl_set(p_tbl, mlid_ho, i);
+		osm_mcast_tbl_set(p_tbl, mlid_ho, i, sm->p_subn);
 		if (i == 0) {
 			/* This means we are adding the switch to the MC group.
-			   We do not need to continue looking at the remote port, just
-			   needed to add the port to the table */
+			   We do not need to continue looking at the remote
+			   port, just needed to add the port to the table */
 			CL_ASSERT(count == 1);
 
 			p_wobj = (osm_mcast_work_obj_t *)
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
index d7c9529..5a46c84 100644
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
@@ -50,11 +50,13 @@
 #include <complib/cl_math.h>
 #include <iba/ib_types.h>
 #include <opensm/osm_mcast_tbl.h>
+#include <opensm/osm_log.h>
+#include <opensm/osm_opensm.h>
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
-				   IN uint8_t num_ports, IN uint16_t capacity)
+void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_ports,
+			IN uint16_t capacity, IN osm_subn_t * p_subn)
 {
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(num_ports);
@@ -68,7 +70,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
 		   This switch apparently doesn't support multicast.
 		   Everything is initialized to zero already, so return.
 		 */
-		return IB_SUCCESS;
+		return;
 	}
 
 	p_tbl->num_entries = capacity;
@@ -82,25 +84,6 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
 					IB_MCAST_BLOCK_SIZE) - 1);
 
 	p_tbl->max_mlid_ho = (uint16_t) (IB_LID_MCAST_START_HO + capacity - 1);
-
-	/*
-	   The number of bytes needed in the mask table is:
-	   The (maximum bit mask 'position' + 1) times the
-	   number of bytes in each bit mask times the
-	   number of MLIDs supported by the table.
-
-	   We must always allocate the array with the maximum position
-	   since it is (and must be) defined that way the table structure
-	   in order to create a pointer to a two dimensional array.
-	 */
-	p_tbl->p_mask_tbl = calloc(p_tbl->num_entries,
-				   (IB_MCAST_POSITION_MAX +
-				    1) * IB_MCAST_MASK_SIZE / 8);
-
-	if (p_tbl->p_mask_tbl == NULL)
-		return IB_INSUFFICIENT_MEMORY;
-
-	return IB_SUCCESS;
 }
 
 /**********************************************************************
@@ -113,7 +96,7 @@ void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * p_tbl)
 /**********************************************************************
  **********************************************************************/
 void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
-		       IN uint8_t port)
+		       IN uint8_t port, IN osm_subn_t * p_subn)
 {
 	uintn_t mlid_offset;
 	uintn_t mask_offset;
@@ -128,6 +111,7 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
 	mask_offset = port / IB_MCAST_MASK_SIZE;
 	bit_mask = cl_ntoh16((uint16_t) (1 << (port % IB_MCAST_MASK_SIZE)));
+	osm_mcast_tbl_realloc_mask_tbl(p_tbl, p_subn, mlid_offset);
 	(*p_tbl->p_mask_tbl)[mlid_offset][mask_offset] |= bit_mask;
 
 	block_num = (int16_t) (mlid_offset / IB_MCAST_BLOCK_SIZE);
@@ -138,6 +122,51 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 
 /**********************************************************************
  **********************************************************************/
+void
+osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * p_tbl,
+			       IN osm_subn_t * p_subn, IN uintn_t mlid_offset)
+{
+	size_t mft_size, size;
+	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
+
+	if (mlid_offset < p_tbl->mft_size)
+		return;
+
+	/*
+	   The number of bytes needed in the mask table is:
+	   The (maximum bit mask 'position' + 1) times the
+	   number of bytes in each bit mask times the
+	   number of MLIDs supported by the table.
+
+	   We must always allocate the array with the maximum position
+	   since it is (and must be) defined that way the table structure
+	   in order to create a pointer to a two dimensional array.
+	 */
+	mft_size = (mlid_offset + IB_MCAST_BLOCK_SIZE) /
+		    IB_MCAST_BLOCK_SIZE * IB_MCAST_BLOCK_SIZE;
+	if (mft_size > (p_tbl->max_block + 1) * IB_MCAST_BLOCK_SIZE)
+		mft_size = (p_tbl->max_block + 1) * IB_MCAST_BLOCK_SIZE;
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
@@ -154,6 +183,8 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_size)
+			return FALSE;
 		mask_offset = port_num / IB_MCAST_MASK_SIZE;
 		bit_mask = cl_ntoh16((uint16_t)
 				     (1 << (port_num % IB_MCAST_MASK_SIZE)));
@@ -181,6 +212,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_size)
+			return FALSE;
 
 		for (position = 0; position <= p_tbl->max_position; position++)
 			result |= (*p_tbl->p_mask_tbl)[mlid_offset][position];
@@ -192,6 +225,7 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 /**********************************************************************
  **********************************************************************/
 ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
+					IN osm_subn_t * p_subn,
 					IN const ib_net16_t * p_block,
 					IN int16_t block_num,
 					IN uint8_t position)
@@ -213,6 +247,9 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->max_mlid_ho)
 		return IB_INVALID_PARAMETER;
 
+	osm_mcast_tbl_realloc_mask_tbl(p_tbl, p_subn,
+				       mlid_start_ho + IB_MCAST_BLOCK_SIZE);
+
 	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
 		(*p_tbl->p_mask_tbl)[mlid_start_ho + i][position] = p_block[i];
 
@@ -234,6 +271,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 
 	if (p_tbl->p_mask_tbl && (mlid_ho <= p_tbl->max_mlid_ho)) {
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_size)
+			return;
 		for (i = 0; i <= p_tbl->max_position; i++)
 			(*p_tbl->p_mask_tbl)[mlid_offset][i] = 0;
 	}
@@ -242,6 +281,7 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 /**********************************************************************
  **********************************************************************/
 boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
+				  IN osm_subn_t * p_subn,
 				  IN int16_t block_num, IN uint8_t position,
 				  OUT ib_net16_t * p_block)
 {
@@ -264,6 +304,9 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
 
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
index ed0bc66..ceec54c 100644
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
@@ -136,9 +137,8 @@ osm_switch_t *osm_switch_new(IN osm_node_t * p_node,
 
 	memset(p_sw->p_prof, 0, sizeof(*p_sw->p_prof) * num_ports);
 
-	if (osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_get_num_physp(p_node),
-			       cl_ntoh16(p_si->mcast_cap)))
-		goto err;
+	osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_get_num_physp(p_node),
+			   cl_ntoh16(p_si->mcast_cap), p_subn);
 
 	for (port_num = 0; port_num < num_ports; port_num++)
 		osm_port_prof_construct(&p_sw->p_prof[port_num]);
@@ -508,7 +508,6 @@ static int alloc_lft(IN osm_switch_t * p_sw, uint16_t lids)
 		p_sw->lft = new_lft;
 		p_sw->lft_size = lft_size;
 	}
-
 	return 0;
 }
 
@@ -549,7 +548,6 @@ int osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids
 		p_sw->num_hops = max_lids + 1;
 	}
 	p_sw->max_lid_ho = max_lids;
-
 	return 0;
 }
 
diff --git a/opensm/opensm/osm_ucast_updn.c b/opensm/opensm/osm_ucast_updn.c
index bb9ccda..ced076a 100644
--- a/opensm/opensm/osm_ucast_updn.c
+++ b/opensm/opensm/osm_ucast_updn.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -431,13 +432,13 @@ static void updn_find_root_nodes_by_min_hop(OUT updn_t * p_updn)
 		"Current number of ports in the subnet is %d\n",
 		cl_qmap_count(&p_osm->subn.port_guid_tbl));
 
-	cas_per_sw = malloc((IB_LID_UCAST_END_HO + 1) * sizeof(*cas_per_sw));
+	cas_per_sw = malloc(p_osm->subn.max_ucast_lid_ho * sizeof(*cas_per_sw));
 	if (!cas_per_sw) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR AA14: "
 			"cannot alloc mem for CAs per switch counter array\n");
 		goto _exit;
 	}
-	memset(cas_per_sw, 0, (IB_LID_UCAST_END_HO + 1) * sizeof(*cas_per_sw));
+	memset(cas_per_sw, 0, p_osm->subn.max_ucast_lid_ho * sizeof(*cas_per_sw));
 
 	/* Find the Maximum number of CAs (and routers) for histogram normalization */
 	OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
