From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] opensm/osm_mcast_tbl.(h c): Make max_mlid_ho be maximum
	MLID configured
Date: Fri, 16 Oct 2009 14:28:34 -0400
Message-ID: <20091016182834.GA26292@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


rather than max table size

Now, the determination of subnet max MLID in si_rcv_process_new
in osm_sw_info_rcv.c needs to be based on num_entries rather than max_mlid_ho

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Update determination of subnet max MLID in si_rcv_process_new

diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/opensm/osm_mcast_tbl.h
index 710d199..276b7f7 100644
--- a/opensm/include/opensm/osm_mcast_tbl.h
+++ b/opensm/include/opensm/osm_mcast_tbl.h
@@ -2,6 +2,7 @@
  * Copyright (c) 2004, 2005 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -95,7 +96,8 @@ typedef struct osm_mcast_fwdbl {
 *		Number of entries in the table (aka number of MLIDs supported).
 *
 *	max_mlid_ho
-*		Maximum MLID value (host order).
+*		Maximum MLID (host order) configured in the multicast port mask
+*		table.
 *
 *	pp_mask_tbl
 *		Pointer to a two dimensional array of port_masks for this switch.
diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index d7c9529..bdea416 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -81,8 +81,6 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
 						IB_MCAST_BLOCK_SIZE) /
 					IB_MCAST_BLOCK_SIZE) - 1);
 
-	p_tbl->max_mlid_ho = (uint16_t) (IB_LID_MCAST_START_HO + capacity - 1);
-
 	/*
 	   The number of bytes needed in the mask table is:
 	   The (maximum bit mask 'position' + 1) times the
@@ -122,7 +120,8 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
-	CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
+	CL_ASSERT(mlid_ho <= (uint16_t) (IB_LID_MCAST_START_HO +
+					 p_tbl->num_entries - 1));
 	CL_ASSERT(p_tbl->p_mask_tbl);
 
 	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
@@ -134,6 +133,8 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 
 	if (block_num > p_tbl->max_block_in_use)
 		p_tbl->max_block_in_use = (uint16_t) block_num;
+	if (mlid_ho > p_tbl->max_mlid_ho)
+		p_tbl->max_mlid_ho = mlid_ho;
 }
 
 /**********************************************************************
@@ -151,7 +152,8 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(port_num <=
 			  (p_tbl->max_position + 1) * IB_MCAST_MASK_SIZE);
 		CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
-		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
+		CL_ASSERT(mlid_ho <= (uint16_t) (IB_LID_MCAST_START_HO +
+						 p_tbl->num_entries - 1));
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
 		mask_offset = port_num / IB_MCAST_MASK_SIZE;
@@ -178,7 +180,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 
 	if (p_tbl->p_mask_tbl) {
 		CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
-		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
+		CL_ASSERT(mlid_ho <= (uint16_t) (IB_LID_MCAST_START_HO +
+						 p_tbl->num_entries - 1));
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
 
@@ -210,7 +213,8 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 
 	mlid_start_ho = (uint16_t) (block_num * IB_MCAST_BLOCK_SIZE);
 
-	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->max_mlid_ho)
+	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 >
+	    p_tbl->num_entries + IB_LID_MCAST_START_HO - 1)
 		return IB_INVALID_PARAMETER;
 
 	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
@@ -219,6 +223,9 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 	if (block_num > p_tbl->max_block_in_use)
 		p_tbl->max_block_in_use = (uint16_t) block_num;
 
+	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->max_mlid_ho)
+		p_tbl->max_mlid_ho = mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1;
+
 	return IB_SUCCESS;
 }
 
diff --git a/opensm/opensm/osm_sw_info_rcv.c b/opensm/opensm/osm_sw_info_rcv.c
index c335263..ad75fd4 100644
--- a/opensm/opensm/osm_sw_info_rcv.c
+++ b/opensm/opensm/osm_sw_info_rcv.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -219,8 +220,10 @@ static void si_rcv_process_new(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	}
 
 	/* set subnet max mlid to the minimum MulticastFDBCap of all switches */
-	if (p_sw->mcast_tbl.max_mlid_ho < sm->p_subn->max_mcast_lid_ho) {
-		sm->p_subn->max_mcast_lid_ho = p_sw->mcast_tbl.max_mlid_ho;
+	if (p_sw->mcast_tbl.num_entries < sm->p_subn->max_mcast_lid_ho -
+					  IB_LID_MCAST_START_HO + 1) {
+		sm->p_subn->max_mcast_lid_ho = p_sw->mcast_tbl.num_entries +
+					       IB_LID_MCAST_START_HO - 1;
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Subnet max multicast lid is 0x%X\n",
 			sm->p_subn->max_mcast_lid_ho);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
