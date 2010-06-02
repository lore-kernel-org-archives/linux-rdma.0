From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: MFT distribution improvement
Date: Wed, 02 Jun 2010 15:56:28 +0300
Message-ID: <4C0654FC.3020608@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The patch reduces the number of MFT set MADs beeing send,
by sending only blocks that have been changed since the
last time same block was issued.

Signed-off-by: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_mcast_tbl.h |   49 ++++++++++++++-
 opensm/opensm/osm_dump.c              |    2 +-
 opensm/opensm/osm_mcast_mgr.c         |   15 +++++-
 opensm/opensm/osm_mcast_tbl.c         |  104 ++++++++++++++++++++-------------
 4 files changed, 124 insertions(+), 46 deletions(-)

diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/opensm/osm_mcast_tbl.h
index 37e2c26..f1f12ad 100644
--- a/opensm/include/opensm/osm_mcast_tbl.h
+++ b/opensm/include/opensm/osm_mcast_tbl.h
@@ -76,7 +76,9 @@ typedef struct osm_mcast_fwdbl {
 	uint16_t num_entries;
 	uint16_t max_mlid_ho;
 	uint16_t mft_depth;
-	uint16_t(*p_mask_tbl)[][IB_MCAST_POSITION_MAX + 1];
+	uint16_t(*p_new_mask_tbl)[][IB_MCAST_BLOCK_SIZE*(IB_MCAST_POSITION_MAX + 1)];
+	uint16_t(*p_mask_tbl)[][IB_MCAST_BLOCK_SIZE*(IB_MCAST_POSITION_MAX + 1)];
+	uint16_t is_first_block[IB_MCAST_MAX_BLOCK_ID];
 } osm_mcast_tbl_t;
 /*
 * FIELDS
@@ -104,11 +106,20 @@ typedef struct osm_mcast_fwdbl {
 *		Number of MLIDs in the currently allocated multicast port mask
 *		table.
 *
-*	p_mask_tbl
-*		Pointer to a two dimensional array of port_masks for this switch.
-*		The first dimension is MLID offset, second dimension is mask position.
+*	p_new_mask_tbl
+*		Pointer to a two dimensional array of (IB_MCAST_POSITION_MAX + 1)
+*		MFT blocks. The first dimensional is MFT block offset, second dimension
+*		is (IB_MCAST_POSITION_MAX + 1) MFT blocks of the same mlid offset.
 *		This pointer is null for switches that do not support multicast.
 *
+*	p_mask_tbl
+*		Pointer to a table, that is being filled when MFT table is recieved
+*		after applying the tables to the switches.
+*
+*	is_first_block
+*		Table that for each block indicates whether it's being issued for
+*		the first time.
+*
 * SEE ALSO
 *********/
 
@@ -482,5 +493,35 @@ osm_mcast_tbl_get_max_position(IN osm_mcast_tbl_t * p_tbl)
 * SEE ALSO
 *********/
 
+/****f* OpenSM: Forwarding Table/osm_mcast_tbl_diff
+* NAME
+*	osm_mcast_cmpr_tbl_block
+*
+* DESCRIPTION
+*	Compares between two multicast forwarding table blocks.
+*
+* SYNOPSIS
+*/
+boolean_t osm_mcast_tbl_diff(IN osm_mcast_tbl_t * p_tbl,
+				   IN int16_t block_num, IN uint8_t position);
+/*
+* PARAMETERS
+*	p_tbl
+*		[in] Pointer to an osm_mcast_tbl_t object.
+*
+*	p_block
+*		[in] Pointer to the Forwarding Table block.
+*
+*	block_num
+*		[in] Block number of this block.
+*
+* RETURN VALUES
+*	Returns TRUE if block is not idnetical in p_new_mask_tbl
+*	and p_mask_tbl. FALSE otherwise.
+*
+* NOTES
+*
+* SEE ALSO
+*********/
 END_C_DECLS
 #endif				/* _OSM_MCAST_TBL_H_ */
diff --git a/opensm/opensm/osm_dump.c b/opensm/opensm/osm_dump.c
index fe2c3bc..adad23c 100644
--- a/opensm/opensm/osm_dump.c
+++ b/opensm/opensm/osm_dump.c
@@ -263,7 +263,7 @@ static void dump_mcast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 			while (position <= p_tbl->max_position) {
 				mask_entry =
 				    cl_ntoh16((*p_tbl->
-					       p_mask_tbl)[mlid_ho][position]);
+					       p_new_mask_tbl)[mlid_ho][position]);
 				if (mask_entry == 0) {
 					position++;
 					continue;
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 322635d..d5a49bf 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -380,8 +380,20 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 
 	p_tbl = osm_switch_get_mcast_tbl_ptr(p_sw);
 
+	/*
+	  Send MFT block only if one of the following persists:
+	  1) There is a connectiviry change in the switch.
+	  2) This is the first time, the block is sent.
+	  3) New block is different than the previous time the
+	     block was sent.
+	 */
+
 	if (osm_mcast_tbl_get_block(p_tbl, (uint16_t) block_num,
-				    (uint8_t) position, block)) {
+				    (uint8_t) position, block) &&
+				    p_sw->need_update != 0 ||
+				    p_tbl->is_first_block[block_num] ||
+				    osm_mcast_tbl_diff(p_tbl,
+						       uint16_t) block_num,(uint8_t) position))) {
 		block_id_ho = block_num + (position << 28);
 
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
@@ -1045,6 +1057,7 @@ static int mcast_mgr_set_mftables(osm_sm_t * sm)
 					p_tbl = osm_switch_get_mcast_tbl_ptr(p_sw);
 					if (++p_sw->mft_position > p_tbl->max_position) {
 						p_sw->mft_position = 0;
+						p_tbl->is_first_block[block_num] = 0;
 						p_sw->mft_block_num++;
 					}
 				}
diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index ee59275..565e8ef 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -78,29 +78,30 @@ void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_ports,
 	p_tbl->max_block = (uint16_t) ((ROUNDUP(p_tbl->num_entries,
 						IB_MCAST_BLOCK_SIZE) /
 					IB_MCAST_BLOCK_SIZE) - 1);
+
+	memset(p_tbl->is_first_block,1,sizeof(p_tbl->is_first_block));
 }
 
 void osm_mcast_tbl_destroy(IN osm_mcast_tbl_t * p_tbl)
 {
-	free(p_tbl->p_mask_tbl);
+	free(p_tbl->p_new_mask_tbl);
 }
 
 void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 		       IN uint8_t port)
 {
 	unsigned mlid_offset, mask_offset, bit_mask;
-	int16_t block_num;
+	uint16_t block_num;
 
-	CL_ASSERT(p_tbl && p_tbl->p_mask_tbl);
+	CL_ASSERT(p_tbl && p_tbl->p_new_mask_tbl);
 	CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
 	CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
-	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
-	mask_offset = port / IB_MCAST_MASK_SIZE;
+	mlid_offset = (mlid_ho - IB_LID_MCAST_START_HO) % IB_MCAST_BLOCK_SIZE;
+	mask_offset = mlid_offset + ( port / IB_MCAST_MASK_SIZE ) * IB_MCAST_BLOCK_SIZE;
+	block_num = (uint16_t) ((mlid_ho - IB_LID_MCAST_START_HO) / IB_MCAST_BLOCK_SIZE);
 	bit_mask = cl_ntoh16((uint16_t) (1 << (port % IB_MCAST_MASK_SIZE)));
-	(*p_tbl->p_mask_tbl)[mlid_offset][mask_offset] |= bit_mask;
-
-	block_num = (int16_t) (mlid_offset / IB_MCAST_BLOCK_SIZE);
+	(*p_tbl->p_new_mask_tbl)[block_num][mask_offset] |= bit_mask;
 
 	if (block_num > p_tbl->max_block_in_use)
 		p_tbl->max_block_in_use = (uint16_t) block_num;
@@ -108,8 +109,8 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 
 int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN unsigned mlid_offset)
 {
-	size_t mft_depth, size;
-	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX + 1];
+	size_t mft_depth, size, old_size;
+	uint16_t (*p_new_mask_tbl)[][IB_MCAST_BLOCK_SIZE*(IB_MCAST_POSITION_MAX + 1)];
 
 	if (mlid_offset < p_tbl->mft_depth)
 		goto done;
@@ -125,14 +126,22 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN unsigned mlid_offset)
 	   in order to create a pointer to a two dimensional array.
 	 */
 	mft_depth = (mlid_offset / IB_MCAST_BLOCK_SIZE + 1) * IB_MCAST_BLOCK_SIZE;
-	size = mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8;
-	p_mask_tbl = realloc(p_tbl->p_mask_tbl, size);
-	if (!p_mask_tbl)
+	size = mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_BLOCK_SIZE * IB_MCAST_MASK_SIZE / 8;
+	old_size =  p_tbl->mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_BLOCK_SIZE * IB_MCAST_MASK_SIZE / 8;
+	p_new_mask_tbl = realloc(p_tbl->p_new_mask_tbl, size);
+	if (!p_new_mask_tbl)
+		return -1;
+	memset((uint8_t *)p_new_mask_tbl + old_size,
+	       0, size - old_size);
+	p_tbl->p_new_mask_tbl = p_new_mask_tbl;
+
+	p_new_mask_tbl = realloc(p_tbl->p_mask_tbl, size);
+	if (!p_new_mask_tbl)
 		return -1;
-	memset((uint8_t *)p_mask_tbl + p_tbl->mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8,
-	       0,
-	       size - p_tbl->mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
-	p_tbl->p_mask_tbl = p_mask_tbl;
+	memset((uint8_t *)p_new_mask_tbl + old_size,
+		0, size - old_size);
+	p_tbl->p_mask_tbl = p_new_mask_tbl;
+
 	p_tbl->mft_depth = mft_depth;
 done:
 	p_tbl->max_mlid_ho = mlid_offset + IB_LID_MCAST_START_HO;
@@ -143,21 +152,23 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 				IN uint16_t mlid_ho, IN uint8_t port_num)
 {
 	unsigned mlid_offset, mask_offset, bit_mask;
+	uint16_t block_num;
 
 	CL_ASSERT(p_tbl);
 
-	if (p_tbl->p_mask_tbl) {
+	if (p_tbl->p_new_mask_tbl) {
 		CL_ASSERT(port_num <=
 			  (p_tbl->max_position + 1) * IB_MCAST_MASK_SIZE);
 		CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
-		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
-		mask_offset = port_num / IB_MCAST_MASK_SIZE;
+		mlid_offset = (mlid_ho - IB_LID_MCAST_START_HO) % IB_MCAST_BLOCK_SIZE;
+		mask_offset = mlid_offset + ( port_num / IB_MCAST_MASK_SIZE ) * IB_MCAST_BLOCK_SIZE;
+		block_num = (uint16_t) ((mlid_ho - IB_LID_MCAST_START_HO) / IB_MCAST_BLOCK_SIZE);
 		bit_mask = cl_ntoh16((uint16_t)
 				     (1 << (port_num % IB_MCAST_MASK_SIZE)));
 		return (((*p_tbl->
-			  p_mask_tbl)[mlid_offset][mask_offset] & bit_mask) ==
+			  p_new_mask_tbl)[block_num][mask_offset] & bit_mask) ==
 			bit_mask);
 	}
 
@@ -170,17 +181,19 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 	unsigned mlid_offset;
 	uint8_t position;
 	uint16_t result = 0;
+	uint16_t block_num;
 
 	CL_ASSERT(p_tbl);
 
-	if (p_tbl->p_mask_tbl) {
+	if (p_tbl->p_new_mask_tbl) {
 		CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
-		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		mlid_offset = (mlid_ho - IB_LID_MCAST_START_HO) % IB_MCAST_BLOCK_SIZE;
+		block_num = (uint16_t) (mlid_offset / IB_MCAST_BLOCK_SIZE);
 
 		for (position = 0; position <= p_tbl->max_position; position++)
-			result |= (*p_tbl->p_mask_tbl)[mlid_offset][position];
+			result |= (*p_tbl->p_new_mask_tbl)[block_num][mlid_offset + position * IB_MCAST_BLOCK_SIZE];
 	}
 
 	return (result != 0);
@@ -191,7 +204,6 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 					IN int16_t block_num,
 					IN uint8_t position)
 {
-	uint32_t i;
 	uint16_t mlid_start_ho;
 
 	CL_ASSERT(p_tbl);
@@ -208,9 +220,7 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->mft_depth)
 		return IB_INVALID_PARAMETER;
 
-	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
-		(*p_tbl->p_mask_tbl)[mlid_start_ho + i][position] = p_block[i];
-
+	memcpy(&(*p_tbl->p_mask_tbl)[block_num][position * IB_MCAST_BLOCK_SIZE],p_block,IB_MCAST_BLOCK_SIZE * IB_MCAST_MASK_SIZE / 8);
 	if (block_num > p_tbl->max_block_in_use)
 		p_tbl->max_block_in_use = (uint16_t) block_num;
 
@@ -220,24 +230,41 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 {
 	unsigned mlid_offset;
+	uint16_t block_num;
+	uint32_t i;
 
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
 
-	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
-	if (p_tbl->p_mask_tbl && mlid_offset < p_tbl->mft_depth)
-		memset((uint8_t *)p_tbl->p_mask_tbl + mlid_offset * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8,
-		       0,
-		       (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
+	mlid_offset = (mlid_ho - IB_LID_MCAST_START_HO) % IB_MCAST_BLOCK_SIZE;
+	block_num = (uint16_t) ((mlid_ho - IB_LID_MCAST_START_HO) / IB_MCAST_BLOCK_SIZE);
+
+	if (p_tbl->p_new_mask_tbl && mlid_offset < p_tbl->mft_depth)
+		for (i=0;i<IB_MCAST_POSITION_MAX + 1; i++)
+			memset(&(*p_tbl->p_new_mask_tbl)[block_num][i * IB_MCAST_BLOCK_SIZE + mlid_offset],
+			       0, IB_MCAST_MASK_SIZE / 8);
+}
+
+boolean_t osm_mcast_tbl_diff(IN osm_mcast_tbl_t * p_tbl,
+				   IN int16_t block_num, IN uint8_t position)
+{
+	CL_ASSERT(p_tbl);
+	CL_ASSERT(p_block);
+	CL_ASSERT(block_num * IB_MCAST_BLOCK_SIZE <= p_tbl->mft_depth);
+	if (position > p_tbl->max_position)
+		return TRUE;
+
+	if (memcmp(&(*p_tbl->p_new_mask_tbl)[block_num][position * IB_MCAST_BLOCK_SIZE],
+		   &(*p_tbl->p_mask_tbl)[block_num][position * IB_MCAST_BLOCK_SIZE],IB_MCAST_BLOCK_SIZE * IB_MCAST_MASK_SIZE / 8))
+		return TRUE;
+
+	return FALSE;
 }
 
 boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
 				  IN int16_t block_num, IN uint8_t position,
 				  OUT ib_net16_t * p_block)
 {
-	uint32_t i;
-	uint16_t mlid_start_ho;
-
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(p_block);
 	CL_ASSERT(block_num * IB_MCAST_BLOCK_SIZE <= p_tbl->mft_depth);
@@ -253,10 +280,7 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
 		return TRUE;
 	}
 
-	mlid_start_ho = (uint16_t) (block_num * IB_MCAST_BLOCK_SIZE);
-
-	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
-		p_block[i] = (*p_tbl->p_mask_tbl)[mlid_start_ho + i][position];
+	memcpy(p_block,&(*p_tbl->p_new_mask_tbl)[block_num][position*IB_MCAST_BLOCK_SIZE],IB_MCAST_BLOCK_SIZE * IB_MCAST_MASK_SIZE / 8);
 
 	return TRUE;
 }
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
