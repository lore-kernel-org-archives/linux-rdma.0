From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/8] opensm: Add routing specific update_vlarb hook routine
Date: Wed, 28 Nov 2012 14:03:01 -0500
Message-ID: <50B65FE5.1060400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_opensm.h |   12 ++++++++++++
 opensm/osm_qos.c            |    6 ++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
index 0b6e44f..b93a09a 100644
--- a/include/opensm/osm_opensm.h
+++ b/include/opensm/osm_opensm.h
@@ -136,6 +136,10 @@ struct osm_routing_engine {
 	void (*update_sl2vl)(void *context, IN osm_physp_t *port,
 			     IN uint8_t in_port_num, IN uint8_t out_port_num,
 			     IN OUT ib_slvl_table_t *t);
+	void (*update_vlarb)(void *context, IN osm_physp_t *port,
+			     IN uint8_t port_num,
+			     IN OUT ib_vl_arb_table_t *block,
+			     unsigned block_length, unsigned block_num);
 	uint8_t (*path_sl)(void *context, IN uint8_t path_sl_hint,
 			   IN const ib_net16_t slid, IN const ib_net16_t dlid);
 	ib_api_status_t (*mcast_build_stree)(void *context,
@@ -170,6 +174,14 @@ struct osm_routing_engine {
 *		which part of the SL2VL map to update.  For router/HCA ports,
 *		in_port_num/out_port_num should be ignored.
 *
+*	update_vlarb(void *context, IN osm_physp_t *port,
+*		     IN uint8_t port_num,
+*		     IN OUT ib_vl_arb_table_t *block,
+*		     unsigned block_length, unsigned block_num)
+*		The callback to allow routing engine input for VLArbitration.
+*		*port is the physical port for which the VLArb table is to be
+*		updated.
+*
 *	path_sl
 *		The callback for computing path SL.
 *
diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index ac15bcd..0bd116a 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -144,6 +144,7 @@ static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
 						unsigned block_num,
 						cl_qlist_t *mad_list)
 {
+	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
 	ib_vl_arb_table_t block;
 	uint32_t attr_mod;
 	unsigned vl_mask, i;
@@ -152,6 +153,11 @@ static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
 
 	memset(&block, 0, sizeof(block));
 	memcpy(&block, table_block, block_length * sizeof(block.vl_entry[0]));
+
+	if (re && re->update_vlarb)
+		re->update_vlarb(re->context, p, port_num, &block,
+				 block_length, block_num);
+
 	for (i = 0; i < block_length; i++)
 		block.vl_entry[i].vl &= vl_mask;
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
