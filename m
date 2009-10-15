From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv4] opensm: Reduce heap consumption by multicast routing
	tables (MFTs)
Date: Thu, 15 Oct 2009 18:30:52 -0400
Message-ID: <20091015223052.GA6843@comcast.net>
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
Changes since v3:
Renamed mft_size to mft_depth and added description in osm_mcast_tbl.h
Removed vestigial realloc mask tbl call in osm_dump.c
Simplified max_mlid determination in alloc_mfts
Added return value to osm_mcast_tbl_realloc_mask_tbl
Added return value to alloc_mfts 
Handle alloc_mfts failure in osm_mcast_mgr_process/process_mgroups
Renamed osm_mcast_tbl_realloc_mask_tbl to osm_mcast_tbl_realloc
In osm_mcast_tbl_realloc, simplified mft_depth calculation

Changes since v2:
MFT allocation during routing preparation rather than on table access

Changes since v1:
MFT allocation based on actual MLID requests

diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/opensm/osm_mcast_tbl.h
index 710d199..0e07d95 100644
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
@@ -74,6 +74,7 @@ typedef struct osm_mcast_fwdbl {
 	int16_t max_block_in_use;
 	uint16_t num_entries;
 	uint16_t max_mlid_ho;
+	uint16_t mft_depth;
 	uint16_t(*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
 } osm_mcast_tbl_t;
 /*
@@ -97,7 +98,11 @@ typedef struct osm_mcast_fwdbl {
 *	max_mlid_ho
 *		Maximum MLID value (host order).
 *
-*	pp_mask_tbl
+*	mft_depth
+*		Number of MLIDs in the currently allocated multicast port mask
+*		table.
+*
+*	p_mask_tbl
 *		Pointer to a two dimensional array of port_masks for this switch.
 *		The first dimension is MLID, the second dimension is mask position.
 *		This pointer is null for switches that do not support multicast.
@@ -114,8 +119,8 @@ typedef struct osm_mcast_fwdbl {
 *
 * SYNOPSIS
 */
-ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
-				   IN uint8_t num_ports, IN uint16_t capacity);
+void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_ports,
+			IN uint16_t capacity);
 /*
 * PARAMETERS
 *	num_ports
@@ -126,7 +131,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
 *		by this switch.
 *
 * RETURN VALUE
-*	IB_SUCCESS on success.
+*	None.
 *
 * NOTES
 *
@@ -158,6 +163,34 @@ void osm_mcast_tbl_delete(IN osm_mcast_tbl_t ** pp_tbl);
 * SEE ALSO
 *********/
 
+/****f* OpenSM: Forwarding Table/osm_mcast_tbl_realloc
+* NAME
+*	osm_mcast_tbl_realloc
+*
+* DESCRIPTION
+*	This function reallocates the multicast port mask table if necessary.
+*
+* SYNOPSIS
+*/
+int
+osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset);
+/*
+* PARAMETERS
+*
+*	p_tbl
+*		[in] Pointer to the Multicast Forwarding Table object.
+*
+*	mlid_offset
+*		[in] Offset of MLID being accessed.
+*
+* RETURN VALUE
+*	Returns 0 on success and non-zero value otherwise.
+*
+* NOTES
+*
+* SEE ALSO
+*/
+
 /****f* OpenSM: Forwarding Table/osm_mcast_tbl_destroy
 * NAME
 *	osm_mcast_tbl_destroy
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 0ee689c..a5e9758 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -1043,6 +1043,36 @@ static int mcast_mgr_set_mftables(osm_sm_t * sm)
 	return ret;
 }
 
+static int alloc_mfts(osm_sm_t * sm)
+{
+	int i;
+	cl_map_item_t *item;
+	osm_switch_t *p_sw;
+	int max_mlid = 0;
+
+	for (i = sm->p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO; i >= 0;
+	     i--) {
+		if (sm->p_subn->mgroups[i]) {
+			max_mlid = i + IB_LID_MCAST_START_HO;
+			break;
+		}
+	}
+
+	if (max_mlid == 0)
+		return 0;
+
+	/* Now, walk switches and (re)allocate multicast tables */
+	for (item = cl_qmap_head(&sm->p_subn->sw_guid_tbl);
+	     item != cl_qmap_end(&sm->p_subn->sw_guid_tbl);
+	     item = cl_qmap_next(item)) {
+		p_sw = (osm_switch_t *)item;
+		if (osm_mcast_tbl_realloc(&p_sw->mcast_tbl,
+					  max_mlid - IB_LID_MCAST_START_HO))
+			return -1;
+	}
+	return 0;
+}
+
 /**********************************************************************
  **********************************************************************/
 int osm_mcast_mgr_process(osm_sm_t * sm)
@@ -1063,6 +1093,12 @@ int osm_mcast_mgr_process(osm_sm_t * sm)
 		goto exit;
 	}
 
+	if (alloc_mfts(sm)) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
+			"ERR 0A07: alloc_mfts failed\n");
+		goto exit;
+	}
+
 	for (i = 0; i <= sm->p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO;
 	     i++)
 		if (sm->p_subn->mgroups[i] || sm->mlids_req[i])
@@ -1101,6 +1137,12 @@ int osm_mcast_mgr_process_mgroups(osm_sm_t * sm)
 		goto exit;
 	}
 
+	if (alloc_mfts(sm)) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
+			"ERR 0A09: alloc_mfts failed\n");
+		goto exit;
+	}
+
 	for (i = 0; i <= sm->mlids_req_max; i++) {
 		if (!sm->mlids_req[i])
 			continue;
diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index d7c9529..bb719f2 100644
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
@@ -53,8 +53,8 @@
 
 /**********************************************************************
  **********************************************************************/
-ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
-				   IN uint8_t num_ports, IN uint16_t capacity)
+void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_ports,
+			IN uint16_t capacity)
 {
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(num_ports);
@@ -68,7 +68,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
 		   This switch apparently doesn't support multicast.
 		   Everything is initialized to zero already, so return.
 		 */
-		return IB_SUCCESS;
+		return;
 	}
 
 	p_tbl->num_entries = capacity;
@@ -82,25 +82,6 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
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
@@ -123,6 +104,7 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
 	CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
+	CL_ASSERT(mlid_ho - IB_LID_MCAST_START_HO < p_tbl->mft_depth);
 	CL_ASSERT(p_tbl->p_mask_tbl);
 
 	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
@@ -138,6 +120,42 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 
 /**********************************************************************
  **********************************************************************/
+int
+osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
+{
+	size_t mft_depth, size;
+	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
+
+	if (mlid_offset < p_tbl->mft_depth)
+		return 0;
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
+	mft_depth = (mlid_offset / IB_MCAST_BLOCK_SIZE + 1) * IB_MCAST_BLOCK_SIZE;
+	if (mft_depth > (p_tbl->max_block + 1) * IB_MCAST_BLOCK_SIZE)
+		mft_depth = (p_tbl->max_block + 1) * IB_MCAST_BLOCK_SIZE;
+	size = mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8;
+	p_mask_tbl = realloc(p_tbl->p_mask_tbl, size);
+	if (!p_mask_tbl)
+		return -1;
+	memset((uint8_t *)p_mask_tbl + p_tbl->mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8,
+	       0,
+	       size - p_tbl->mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
+	p_tbl->p_mask_tbl = p_mask_tbl;
+	p_tbl->mft_depth = mft_depth;
+	return 0;
+}
+
+/**********************************************************************
+ **********************************************************************/
 boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 				IN uint16_t mlid_ho, IN uint8_t port_num)
 {
@@ -154,6 +172,8 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_depth)
+			return FALSE;
 		mask_offset = port_num / IB_MCAST_MASK_SIZE;
 		bit_mask = cl_ntoh16((uint16_t)
 				     (1 << (port_num % IB_MCAST_MASK_SIZE)));
@@ -181,6 +201,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_depth)
+			return FALSE;
 
 		for (position = 0; position <= p_tbl->max_position; position++)
 			result |= (*p_tbl->p_mask_tbl)[mlid_offset][position];
@@ -210,7 +232,7 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 
 	mlid_start_ho = (uint16_t) (block_num * IB_MCAST_BLOCK_SIZE);
 
-	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->max_mlid_ho)
+	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->mft_depth)
 		return IB_INVALID_PARAMETER;
 
 	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
@@ -234,6 +256,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 
 	if (p_tbl->p_mask_tbl && (mlid_ho <= p_tbl->max_mlid_ho)) {
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_depth)
+			return;
 		for (i = 0; i <= p_tbl->max_position; i++)
 			(*p_tbl->p_mask_tbl)[mlid_offset][i] = 0;
 	}
@@ -250,6 +274,7 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
 
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(p_block);
+	CL_ASSERT(block_num * IB_MCAST_BLOCK_SIZE <= p_tbl->mft_depth);
 
 	if (block_num > p_tbl->max_block_in_use)
 		return FALSE;
diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
index ed0bc66..223791c 100644
--- a/opensm/opensm/osm_switch.c
+++ b/opensm/opensm/osm_switch.c
@@ -136,9 +136,8 @@ osm_switch_t *osm_switch_new(IN osm_node_t * p_node,
 
 	memset(p_sw->p_prof, 0, sizeof(*p_sw->p_prof) * num_ports);
 
-	if (osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_get_num_physp(p_node),
-			       cl_ntoh16(p_si->mcast_cap)))
-		goto err;
+	osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_get_num_physp(p_node),
+			   cl_ntoh16(p_si->mcast_cap));
 
 	for (port_num = 0; port_num < num_ports; port_num++)
 		osm_port_prof_construct(&p_sw->p_prof[port_num]);
@@ -508,7 +507,6 @@ static int alloc_lft(IN osm_switch_t * p_sw, uint16_t lids)
 		p_sw->lft = new_lft;
 		p_sw->lft_size = lft_size;
 	}
-
 	return 0;
 }
 
@@ -549,7 +547,6 @@ int osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids
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
