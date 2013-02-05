From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/6] opensm/osm_sa: Improve SA record response handling (osm_sa_respond)
Date: Tue,  5 Feb 2013 19:00:23 +0200
Message-ID: <1360083625-15981-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Rather than have multiple SA record item types,
unify this but keep these variable sized to
save space by allocating them based on the attribute
type.

This was motivated by Windows where the SA path record
(ib_path_rec) has some alignment (unlike Linux ib_types.h).
This change will make it easier to introduce any
needed alignment without breaking this code. A subsequent
patch may introduce that (e.g. 64 bit clean code).

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_sa.h          |  64 ++++++++++++++++++++
 opensm/osm_sa.c                  |   6 +-
 opensm/osm_sa_guidinfo_record.c  |  22 +++----
 opensm/osm_sa_informinfo.c       |  33 +++++------
 opensm/osm_sa_lft_record.c       |  17 +++---
 opensm/osm_sa_link_record.c      |  19 +++---
 opensm/osm_sa_mcmember_record.c  |  47 +++++++--------
 opensm/osm_sa_mft_record.c       |  17 +++---
 opensm/osm_sa_multipath_record.c | 122 ++++++++++++++++++++-------------------
 opensm/osm_sa_node_record.c      |  23 ++++----
 opensm/osm_sa_path_record.c      |  49 ++++++++--------
 opensm/osm_sa_pkey_record.c      |  21 +++----
 opensm/osm_sa_portinfo_record.c  |  31 +++++-----
 opensm/osm_sa_service_record.c   |  35 +++++------
 opensm/osm_sa_slvl_record.c      |  19 +++---
 opensm/osm_sa_sminfo_record.c    |  19 +++---
 opensm/osm_sa_sw_info_record.c   |  15 ++---
 opensm/osm_sa_vlarb_record.c     |  19 +++---
 18 files changed, 301 insertions(+), 277 deletions(-)

diff --git a/include/opensm/osm_sa.h b/include/opensm/osm_sa.h
index 77cb33c..19de2ab 100644
--- a/include/opensm/osm_sa.h
+++ b/include/opensm/osm_sa.h
@@ -86,6 +86,7 @@ BEGIN_C_DECLS
 *	Anil Keshavamurthy, Intel
 *
 *********/
+
 /****d* OpenSM: SA/osm_sa_state_t
 * NAME
 *	osm_sa_state_t
@@ -101,6 +102,69 @@ typedef enum _osm_sa_state {
 } osm_sa_state_t;
 /***********/
 
+/****d* OpenSM: SA/osm_mpr_rec_t
+* NAME
+*	osm_mpr_rec_t
+*
+* DESCRIPTION
+*	SA MultiPathRecord response.
+*
+* SYNOPSIS
+*/
+typedef struct osm_mpr_rec {
+	ib_path_rec_t path_rec;
+	const osm_port_t *p_src_port;
+	const osm_port_t *p_dest_port;
+	int hops;
+} osm_mpr_rec_t;
+/***********/
+
+/****d* OpenSM: SA/osm_sa_item_t
+* NAME
+*	osm_sa_item_t
+*
+* DESCRIPTION
+*	SA response item.
+*
+* SYNOPSIS
+*/
+typedef struct osm_sa_item {
+	cl_list_item_t list_item;
+	union {
+		char data[0];
+		ib_guidinfo_record_t guid_rec;
+		ib_inform_info_record_t inform_rec;
+		ib_lft_record_t lft_rec;
+		ib_link_record_t link_rec;
+		ib_member_rec_t mc_rec;
+		ib_mft_record_t mft_rec;
+		osm_mpr_rec_t mpr_rec;
+		ib_node_record_t node_rec;
+		ib_path_rec_t path_rec;
+		ib_pkey_table_record_t pkey_rec;
+		ib_portinfo_record_t port_rec;
+		ib_service_record_t service_rec;
+		ib_slvl_table_record_t slvl_rec;
+		ib_sminfo_record_t sminfo_rec;
+		ib_switch_info_record_t swinfo_rec;
+		ib_vl_arb_table_record_t vlarb_rec;
+	} resp;
+} osm_sa_item_t;
+/*
+* NOTES
+*	Actual structure allocated is based on SA attribute
+*	type. As such, it is variable sized. The allocation
+*	occurs in the SA attribute handling code.
+*	Note also that the size is specified external
+*	to this structure (It's passed as a parameter to
+*	osm_sa_respond). The SA_ITEM_RESP_SIZE macro
+*	facilitates determining the size required.
+*
+***********/
+
+#define SA_ITEM_RESP_SIZE(_m) offsetof(osm_sa_item_t, resp._m) + \
+			      sizeof(((osm_sa_item_t *)NULL)->resp._m)
+
 /****s* OpenSM: SM/osm_sa_t
 * NAME
 *	osm_sa_t
diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index 674b913..9f50bca 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -382,10 +382,6 @@ Exit:
 void osm_sa_respond(osm_sa_t *sa, osm_madw_t *madw, size_t attr_size,
 		    cl_qlist_t *list)
 {
-	struct item_data {
-		cl_list_item_t list;
-		char data[0];
-	};
 	cl_list_item_t *item;
 	osm_madw_t *resp_madw;
 	ib_sa_mad_t *sa_mad, *resp_sa_mad;
@@ -478,7 +474,7 @@ void osm_sa_respond(osm_sa_t *sa, osm_madw_t *madw, size_t attr_size,
 
 	for (i = 0; i < num_rec; i++) {
 		item = cl_qlist_remove_head(list);
-		memcpy(p, ((struct item_data *)item)->data, attr_size);
+		memcpy(p, ((osm_sa_item_t *)item)->resp.data, attr_size);
 		p += attr_size;
 		free(item);
 	}
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 92f3b1a..a00b257 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -60,6 +60,8 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
+#define SA_GIR_RESP_SIZE SA_ITEM_RESP_SIZE(guid_rec)
+
 #define MOD_GIR_COMP_MASK (IB_GIR_COMPMASK_LID | IB_GIR_COMPMASK_BLOCKNUM)
 
 typedef struct osm_gir_item {
@@ -83,12 +85,12 @@ static ib_api_status_t gir_rcv_new_gir(IN osm_sa_t * sa,
 				       IN const osm_physp_t * p_physp,
 				       IN uint8_t const block_num)
 {
-	osm_gir_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_GIR_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5102: "
 			"rec_item alloc failed\n");
@@ -100,16 +102,16 @@ static ib_api_status_t gir_rcv_new_gir(IN osm_sa_t * sa,
 		"New GUIDInfoRecord: lid %u, block num %d\n",
 		cl_ntoh16(match_lid), block_num);
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_GIR_RESP_SIZE);
 
-	p_rec_item->rec.lid = match_lid;
-	p_rec_item->rec.block_num = block_num;
+	p_rec_item->resp.guid_rec.lid = match_lid;
+	p_rec_item->resp.guid_rec.block_num = block_num;
 	if (p_physp->p_guids)
-		memcpy(&p_rec_item->rec.guid_info,
+		memcpy(&p_rec_item->resp.guid_rec.guid_info,
 		       *p_physp->p_guids + block_num * GUID_TABLE_MAX_ENTRIES,
 		       sizeof(ib_guid_info_t));
 	else if (!block_num)
-		p_rec_item->rec.guid_info.guid[0] = osm_physp_get_port_guid(p_physp);
+		p_rec_item->resp.guid_rec.guid_info.guid[0] = osm_physp_get_port_guid(p_physp);
 
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
 
@@ -322,18 +324,18 @@ static void guidinfo_respond(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 			     IN ib_guidinfo_record_t * p_guidinfo_rec)
 {
 	cl_qlist_t rec_list;
-	osm_gir_item_t *item;
+	osm_sa_item_t *item;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	item = malloc(sizeof(*item));
+	item = malloc(SA_GIR_RESP_SIZE);
 	if (!item) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5101: "
 			"rec_item alloc failed\n");
 		goto Exit;
 	}
 
-	item->rec = *p_guidinfo_rec;
+	item->resp.guid_rec = *p_guidinfo_rec;
 
 	cl_qlist_init(&rec_list);
 	cl_qlist_insert_tail(&rec_list, &item->list_item);
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index ed744a3..8f7e5d5 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -63,10 +63,7 @@
 #include <opensm/osm_inform.h>
 #include <opensm/osm_pkey.h>
 
-typedef struct osm_iir_item {
-	cl_list_item_t list_item;
-	ib_inform_info_record_t rec;
-} osm_iir_item_t;
+#define SA_IIR_RESP_SIZE SA_ITEM_RESP_SIZE(inform_rec)
 
 typedef struct osm_iir_search_ctxt {
 	const ib_inform_info_record_t *p_rcvd_rec;
@@ -209,23 +206,23 @@ Set(InformInfo) request.
 static void infr_rcv_respond(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 {
 	cl_qlist_t rec_list;
-	osm_iir_item_t *item;
+	osm_sa_item_t *item;
 
 	OSM_LOG_ENTER(sa->p_log);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Generating successful InformInfo response\n");
 
-	item = malloc(sizeof(*item));
+	item = malloc(SA_IIR_RESP_SIZE);
 	if (!item) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4303: "
 			"rec_item alloc failed\n");
 		goto Exit;
 	}
 
-	memcpy(&item->rec,
+	memcpy(&item->resp.inform_rec,
 	       ib_sa_mad_get_payload_ptr(osm_madw_get_sa_mad_ptr(p_madw)),
-	       sizeof(item->rec));
+	       sizeof(item->resp.inform_rec));
 
 	cl_qlist_init(&rec_list);
 	cl_qlist_insert_tail(&rec_list, &item->list_item);
@@ -245,7 +242,7 @@ static void sa_inform_info_rec_by_comp_mask(IN osm_sa_t * sa,
 	osm_port_t *p_subscriber_port;
 	osm_physp_t *p_subscriber_physp;
 	const osm_physp_t *p_req_physp;
-	osm_iir_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -285,14 +282,14 @@ static void sa_inform_info_rec_by_comp_mask(IN osm_sa_t * sa,
 		goto Exit;
 	}
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_IIR_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 430E: "
 			"rec_item alloc failed\n");
 		goto Exit;
 	}
 
-	memcpy(&p_rec_item->rec, &p_infr->inform_record,
+	memcpy(&p_rec_item->resp.inform_rec, &p_infr->inform_record,
 	       sizeof(ib_inform_info_record_t));
 
 	/*
@@ -302,7 +299,7 @@ static void sa_inform_info_rec_by_comp_mask(IN osm_sa_t * sa,
 	 * subscriber QPN shall be returned.
 	 */
 	if (p_ctxt->sm_key == 0)
-		ib_inform_info_set_qpn(&p_rec_item->rec.inform_info, 0);
+		ib_inform_info_set_qpn(&p_rec_item->resp.inform_rec.inform_info, 0);
 
 	cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list_item);
 
@@ -330,7 +327,7 @@ static void infr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	cl_qlist_t rec_list;
 	osm_iir_search_ctxt_t context;
 	osm_physp_t *p_req_physp;
-	osm_iir_item_t *item;
+	osm_sa_item_t *item;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -384,11 +381,11 @@ static void infr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	cl_plock_release(sa->p_lock);
 
 	/* clear reserved and pad fields in InformInfoRecord */
-	for (item = (osm_iir_item_t *) cl_qlist_head(&rec_list);
-	     item != (osm_iir_item_t *) cl_qlist_end(&rec_list);
-	     item = (osm_iir_item_t *) cl_qlist_next(&item->list_item)) {
-		memset(item->rec.reserved, 0, sizeof(item->rec.reserved));
-		memset(item->rec.pad, 0, sizeof(item->rec.pad));
+	for (item = (osm_sa_item_t *) cl_qlist_head(&rec_list);
+	     item != (osm_sa_item_t *) cl_qlist_end(&rec_list);
+	     item = (osm_sa_item_t *) cl_qlist_next(&item->list_item)) {
+		memset(item->resp.inform_rec.reserved, 0, sizeof(item->resp.inform_rec.reserved));
+		memset(item->resp.inform_rec.pad, 0, sizeof(item->resp.inform_rec.pad));
 	}
 
 	osm_sa_respond(sa, p_madw, sizeof(ib_inform_info_record_t), &rec_list);
diff --git a/opensm/osm_sa_lft_record.c b/opensm/osm_sa_lft_record.c
index 248d8f1..3be20f3 100644
--- a/opensm/osm_sa_lft_record.c
+++ b/opensm/osm_sa_lft_record.c
@@ -56,10 +56,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-typedef struct osm_lftr_item {
-	cl_list_item_t list_item;
-	ib_lft_record_t rec;
-} osm_lftr_item_t;
+#define SA_LFTR_RESP_SIZE SA_ITEM_RESP_SIZE(lft_rec)
 
 typedef struct osm_lftr_search_ctxt {
 	const ib_lft_record_t *p_rcvd_rec;
@@ -74,12 +71,12 @@ static ib_api_status_t lftr_rcv_new_lftr(IN osm_sa_t * sa,
 					 IN cl_qlist_t * p_list,
 					 IN ib_net16_t lid, IN uint16_t block)
 {
-	osm_lftr_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_LFTR_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4402: "
 			"rec_item alloc failed\n");
@@ -93,13 +90,13 @@ static ib_api_status_t lftr_rcv_new_lftr(IN osm_sa_t * sa,
 		cl_ntoh64(osm_node_get_node_guid(p_sw->p_node)),
 		block, cl_ntoh16(lid));
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_LFTR_RESP_SIZE);
 
-	p_rec_item->rec.lid = lid;
-	p_rec_item->rec.block_num = cl_hton16(block);
+	p_rec_item->resp.lft_rec.lid = lid;
+	p_rec_item->resp.lft_rec.block_num = cl_hton16(block);
 
 	/* copy the lft block */
-	osm_switch_get_lft_block(p_sw, block, p_rec_item->rec.lft);
+	osm_switch_get_lft_block(p_sw, block, p_rec_item->resp.lft_rec.lft);
 
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
 
diff --git a/opensm/osm_sa_link_record.c b/opensm/osm_sa_link_record.c
index f91b654..eec952d 100644
--- a/opensm/osm_sa_link_record.c
+++ b/opensm/osm_sa_link_record.c
@@ -57,18 +57,15 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-typedef struct osm_lr_item {
-	cl_list_item_t list_item;
-	ib_link_record_t link_rec;
-} osm_lr_item_t;
+#define SA_LR_RESP_SIZE SA_ITEM_RESP_SIZE(link_rec)
 
 static void lr_rcv_build_physp_link(IN osm_sa_t * sa, IN ib_net16_t from_lid,
 				    IN ib_net16_t to_lid, IN uint8_t from_port,
 				    IN uint8_t to_port, IN cl_qlist_t * p_list)
 {
-	osm_lr_item_t *p_lr_item;
+	osm_sa_item_t *p_lr_item;
 
-	p_lr_item = malloc(sizeof(*p_lr_item));
+	p_lr_item = malloc(SA_LR_RESP_SIZE);
 	if (p_lr_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1801: "
 			"Unable to acquire link record\n"
@@ -78,12 +75,12 @@ static void lr_rcv_build_physp_link(IN osm_sa_t * sa, IN ib_net16_t from_lid,
 			cl_ntoh16(from_lid), cl_ntoh16(to_lid));
 		return;
 	}
-	memset(p_lr_item, 0, sizeof(*p_lr_item));
+	memset(p_lr_item, 0, SA_LR_RESP_SIZE);
 
-	p_lr_item->link_rec.from_port_num = from_port;
-	p_lr_item->link_rec.to_port_num = to_port;
-	p_lr_item->link_rec.to_lid = to_lid;
-	p_lr_item->link_rec.from_lid = from_lid;
+	p_lr_item->resp.link_rec.from_port_num = from_port;
+	p_lr_item->resp.link_rec.to_port_num = to_port;
+	p_lr_item->resp.link_rec.to_lid = to_lid;
+	p_lr_item->resp.link_rec.from_lid = from_lid;
 
 	cl_qlist_insert_tail(p_list, &p_lr_item->list_item);
 }
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 1611b71..6df1945 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -66,6 +66,8 @@
 #include <opensm/osm_inform.h>
 #include <opensm/osm_sa.h>
 
+#define SA_MCM_RESP_SIZE SA_ITEM_RESP_SIZE(mc_rec)
+
 #define JOIN_MC_COMP_MASK (IB_MCR_COMPMASK_MGID | \
 				IB_MCR_COMPMASK_PORT_GID | \
 				IB_MCR_COMPMASK_JOIN_STATE)
@@ -79,11 +81,6 @@
 					IB_MCR_COMPMASK_FLOW | \
 					IB_MCR_COMPMASK_SL)
 
-typedef struct osm_mcmr_item {
-	cl_list_item_t list_item;
-	ib_member_rec_t rec;
-} osm_mcmr_item_t;
-
 /*********************************************************************
  Copy certain fields between two mcmember records
  used during the process of join request to copy data from the mgrp
@@ -195,26 +192,26 @@ static void mcmr_rcv_respond(IN osm_sa_t * sa, IN osm_madw_t * p_madw,
 			     IN ib_member_rec_t * p_mcmember_rec)
 {
 	cl_qlist_t rec_list;
-	osm_mcmr_item_t *item;
+	osm_sa_item_t *item;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	item = malloc(sizeof(*item));
+	item = malloc(SA_MCM_RESP_SIZE);
 	if (!item) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B16: "
 			"rec_item alloc failed\n");
 		goto Exit;
 	}
 
-	item->rec = *p_mcmember_rec;
+	item->resp.mc_rec = *p_mcmember_rec;
 
 	/* Fill in the mtu, rate, and packet lifetime selectors */
-	item->rec.mtu &= 0x3f;
-	item->rec.mtu |= 2 << 6;	/* exactly */
-	item->rec.rate &= 0x3f;
-	item->rec.rate |= 2 << 6;	/* exactly */
-	item->rec.pkt_life &= 0x3f;
-	item->rec.pkt_life |= 2 << 6;	/* exactly */
+	item->resp.mc_rec.mtu &= 0x3f;
+	item->resp.mc_rec.mtu |= 2 << 6;	/* exactly */
+	item->resp.mc_rec.rate &= 0x3f;
+	item->resp.mc_rec.rate |= 2 << 6;	/* exactly */
+	item->resp.mc_rec.pkt_life &= 0x3f;
+	item->resp.mc_rec.pkt_life |= 2 << 6;	/* exactly */
 
 	cl_qlist_init(&rec_list);
 	cl_qlist_insert_tail(&rec_list, &item->list_item);
@@ -1216,12 +1213,12 @@ static ib_api_status_t mcmr_rcv_new_mcmr(IN osm_sa_t * sa,
 					 IN const ib_member_rec_t * p_rcvd_rec,
 					 IN cl_qlist_t * p_list)
 {
-	osm_mcmr_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_MCM_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B15: "
 			"rec_item alloc failed\n");
@@ -1229,11 +1226,11 @@ static ib_api_status_t mcmr_rcv_new_mcmr(IN osm_sa_t * sa,
 		goto Exit;
 	}
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_MCM_RESP_SIZE);
 
 	/* HACK: Untrusted requesters should result with 0 Join
 	   State, Port Guid, and Proxy */
-	p_rec_item->rec = *p_rcvd_rec;
+	p_rec_item->resp.mc_rec = *p_rcvd_rec;
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
 
 Exit:
@@ -1464,14 +1461,14 @@ static void mcmr_query_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	 */
 
 	if (!p_rcvd_mad->sm_key) {
-		osm_mcmr_item_t *item;
-		for (item = (osm_mcmr_item_t *) cl_qlist_head(&rec_list);
-		     item != (osm_mcmr_item_t *) cl_qlist_end(&rec_list);
+		osm_sa_item_t *item;
+		for (item = (osm_sa_item_t *) cl_qlist_head(&rec_list);
+		     item != (osm_sa_item_t *) cl_qlist_end(&rec_list);
 		     item =
-		     (osm_mcmr_item_t *) cl_qlist_next(&item->list_item)) {
-			memset(&item->rec.port_gid, 0, sizeof(ib_gid_t));
-			ib_member_set_join_state(&item->rec, 0);
-			item->rec.proxy_join = 0;
+		     (osm_sa_item_t *) cl_qlist_next(&item->list_item)) {
+			memset(&item->resp.mc_rec.port_gid, 0, sizeof(ib_gid_t));
+			ib_member_set_join_state(&item->resp.mc_rec, 0);
+			item->resp.mc_rec.proxy_join = 0;
 		}
 	}
 
diff --git a/opensm/osm_sa_mft_record.c b/opensm/osm_sa_mft_record.c
index c67c923..2eca1f0 100644
--- a/opensm/osm_sa_mft_record.c
+++ b/opensm/osm_sa_mft_record.c
@@ -56,10 +56,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-typedef struct osm_mftr_item {
-	cl_list_item_t list_item;
-	ib_mft_record_t rec;
-} osm_mftr_item_t;
+#define SA_MFTR_RESP_SIZE SA_ITEM_RESP_SIZE(mft_rec)
 
 typedef struct osm_mftr_search_ctxt {
 	const ib_mft_record_t *p_rcvd_rec;
@@ -75,13 +72,13 @@ static ib_api_status_t mftr_rcv_new_mftr(IN osm_sa_t * sa,
 					 IN ib_net16_t lid, IN uint16_t block,
 					 IN uint8_t position)
 {
-	osm_mftr_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	ib_api_status_t status = IB_SUCCESS;
 	uint16_t position_block_num;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_MFTR_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4A02: "
 			"rec_item alloc failed\n");
@@ -98,13 +95,13 @@ static ib_api_status_t mftr_rcv_new_mftr(IN osm_sa_t * sa,
 	position_block_num = ((uint16_t) position << 12) |
 	    (block & IB_MCAST_BLOCK_ID_MASK_HO);
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_MFTR_RESP_SIZE);
 
-	p_rec_item->rec.lid = lid;
-	p_rec_item->rec.position_block_num = cl_hton16(position_block_num);
+	p_rec_item->resp.mft_rec.lid = lid;
+	p_rec_item->resp.mft_rec.position_block_num = cl_hton16(position_block_num);
 
 	/* copy the mft block */
-	osm_switch_get_mft_block(p_sw, block, position, p_rec_item->rec.mft);
+	osm_switch_get_mft_block(p_sw, block, position, p_rec_item->resp.mft_rec.mft);
 
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
 
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 99628af..df1861e 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -66,13 +66,7 @@
 #define OSM_SA_MPR_MAX_NUM_PATH        127
 #define MAX_HOPS 64
 
-typedef struct osm_mpr_item {
-	cl_list_item_t list_item;
-	ib_path_rec_t path_rec;
-	const osm_port_t *p_src_port;
-	const osm_port_t *p_dest_port;
-	int hops;
-} osm_mpr_item_t;
+#define SA_MPR_RESP_SIZE SA_ITEM_RESP_SIZE(mpr_rec)
 
 typedef struct osm_path_parms {
 	ib_net16_t pkey;
@@ -889,21 +883,21 @@ static void mpr_rcv_build_pr(IN osm_sa_t * sa,
 	OSM_LOG_EXIT(sa->p_log);
 }
 
-static osm_mpr_item_t *mpr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
-						 IN const ib_multipath_rec_t *
-						 p_mpr,
-						 IN const osm_alias_guid_t *
-						 p_src_alias_guid,
-						 IN const osm_alias_guid_t *
-						 p_dest_alias_guid,
-						 IN const uint16_t src_lid_ho,
-						 IN const uint16_t dest_lid_ho,
-						 IN const ib_net64_t comp_mask,
-						 IN const uint8_t preference)
+static osm_sa_item_t *mpr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
+						IN const ib_multipath_rec_t *
+						p_mpr,
+						IN const osm_alias_guid_t *
+						p_src_alias_guid,
+						IN const osm_alias_guid_t *
+						p_dest_alias_guid,
+						IN const uint16_t src_lid_ho,
+						IN const uint16_t dest_lid_ho,
+						IN const ib_net64_t comp_mask,
+						IN const uint8_t preference)
 {
 	osm_path_parms_t path_parms;
 	osm_path_parms_t rev_path_parms;
-	osm_mpr_item_t *p_pr_item;
+	osm_sa_item_t *p_pr_item;
 	ib_api_status_t status, rev_path_status;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -911,13 +905,13 @@ static osm_mpr_item_t *mpr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Src LID %u, Dest LID %u\n",
 		src_lid_ho, dest_lid_ho);
 
-	p_pr_item = malloc(sizeof(*p_pr_item));
+	p_pr_item = malloc(SA_MPR_RESP_SIZE);
 	if (p_pr_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4501: "
 			"Unable to allocate path record\n");
 		goto Exit;
 	}
-	memset(p_pr_item, 0, sizeof(*p_pr_item));
+	memset(p_pr_item, 0, SA_MPR_RESP_SIZE);
 
 	status = mpr_rcv_get_path_parms(sa, p_mpr, p_src_alias_guid,
 					p_dest_alias_guid, dest_lid_ho,
@@ -952,13 +946,13 @@ static osm_mpr_item_t *mpr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 		}
 	}
 
-	p_pr_item->p_src_port = p_src_alias_guid->p_base_port;
-	p_pr_item->p_dest_port = p_dest_alias_guid->p_base_port;
-	p_pr_item->hops = path_parms.hops;
+	p_pr_item->resp.mpr_rec.p_src_port = p_src_alias_guid->p_base_port;
+	p_pr_item->resp.mpr_rec.p_dest_port = p_dest_alias_guid->p_base_port;
+	p_pr_item->resp.mpr_rec.hops = path_parms.hops;
 
 	mpr_rcv_build_pr(sa, p_src_alias_guid, p_dest_alias_guid, src_lid_ho,
 			 dest_lid_ho, preference, &path_parms,
-			 &p_pr_item->path_rec);
+			 &p_pr_item->resp.mpr_rec.path_rec);
 
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
@@ -974,7 +968,7 @@ static uint32_t mpr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 					    IN const ib_net64_t comp_mask,
 					    IN cl_qlist_t * p_list)
 {
-	osm_mpr_item_t *p_pr_item;
+	osm_sa_item_t *p_pr_item;
 	uint16_t src_lid_min_ho;
 	uint16_t src_lid_max_ho;
 	uint16_t dest_lid_min_ho;
@@ -1156,20 +1150,20 @@ Exit:
 #undef min
 #define min(x,y)	(((x) < (y)) ? (x) : (y))
 
-static osm_mpr_item_t *mpr_rcv_get_apm_port_pair_paths(IN osm_sa_t * sa,
-						       IN const
-						       ib_multipath_rec_t *
-						       p_mpr,
-						       IN const osm_alias_guid_t *
-						       p_src_alias_guid,
-						       IN const osm_alias_guid_t *
-						       p_dest_alias_guid,
-						       IN int base_offs,
-						       IN const ib_net64_t
-						       comp_mask,
-						       IN cl_qlist_t * p_list)
+static osm_sa_item_t *mpr_rcv_get_apm_port_pair_paths(IN osm_sa_t * sa,
+						      IN const
+						      ib_multipath_rec_t *
+						      p_mpr,
+						      IN const osm_alias_guid_t *
+						      p_src_alias_guid,
+						      IN const osm_alias_guid_t *
+						      p_dest_alias_guid,
+						      IN int base_offs,
+						      IN const ib_net64_t
+						      comp_mask,
+						      IN cl_qlist_t * p_list)
 {
-	osm_mpr_item_t *p_pr_item = 0;
+	osm_sa_item_t *p_pr_item = 0;
 	uint16_t src_lid_min_ho;
 	uint16_t src_lid_max_ho;
 	uint16_t dest_lid_min_ho;
@@ -1222,7 +1216,7 @@ static osm_mpr_item_t *mpr_rcv_get_apm_port_pair_paths(IN osm_sa_t * sa,
 		if (p_pr_item) {
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 				"Found matching path from Src LID %u to Dest LID %u with %d hops\n",
-				src_lid_ho, dest_lid_ho, p_pr_item->hops);
+				src_lid_ho, dest_lid_ho, p_pr_item->resp.mpr_rec.hops);
 			break;
 		}
 
@@ -1357,7 +1351,7 @@ static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 				  IN cl_qlist_t * p_list)
 {
 	osm_alias_guid_t *pp_alias_guids[4];
-	osm_mpr_item_t *matrix[2][2];
+	osm_sa_item_t *matrix[2][2];
 	int base_offs, src_lid_ho, dest_lid_ho;
 	int sumA, sumB, minA, minB;
 
@@ -1421,20 +1415,26 @@ static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "APM matrix:\n"
 		"\t{0,0} 0x%X->0x%X (%d)\t| {0,1} 0x%X->0x%X (%d)\n"
 		"\t{1,0} 0x%X->0x%X (%d)\t| {1,1} 0x%X->0x%X (%d)\n",
-		matrix[0][0]->path_rec.slid, matrix[0][0]->path_rec.dlid,
-		matrix[0][0]->hops, matrix[0][1]->path_rec.slid,
-		matrix[0][1]->path_rec.dlid, matrix[0][1]->hops,
-		matrix[1][0]->path_rec.slid, matrix[1][0]->path_rec.dlid,
-		matrix[1][0]->hops, matrix[1][1]->path_rec.slid,
-		matrix[1][1]->path_rec.dlid, matrix[1][1]->hops);
+		matrix[0][0]->resp.mpr_rec.path_rec.slid,
+		matrix[0][0]->resp.mpr_rec.path_rec.dlid,
+		matrix[0][0]->resp.mpr_rec.hops,
+		matrix[0][1]->resp.mpr_rec.path_rec.slid,
+		matrix[0][1]->resp.mpr_rec.path_rec.dlid,
+		matrix[0][1]->resp.mpr_rec.hops,
+		matrix[1][0]->resp.mpr_rec.path_rec.slid,
+		matrix[1][0]->resp.mpr_rec.path_rec.dlid,
+		matrix[1][0]->resp.mpr_rec.hops,
+		matrix[1][1]->resp.mpr_rec.path_rec.slid,
+		matrix[1][1]->resp.mpr_rec.path_rec.dlid,
+		matrix[1][1]->resp.mpr_rec.hops);
 
 	/* check diagonal A {(0,0), (1,1)} */
-	sumA = matrix[0][0]->hops + matrix[1][1]->hops;
-	minA = min(matrix[0][0]->hops, matrix[1][1]->hops);
+	sumA = matrix[0][0]->resp.mpr_rec.hops + matrix[1][1]->resp.mpr_rec.hops;
+	minA = min(matrix[0][0]->resp.mpr_rec.hops, matrix[1][1]->resp.mpr_rec.hops);
 
 	/* check diagonal B {(0,1), (1,0)} */
-	sumB = matrix[0][1]->hops + matrix[1][0]->hops;
-	minB = min(matrix[0][1]->hops, matrix[1][0]->hops);
+	sumB = matrix[0][1]->resp.mpr_rec.hops + matrix[1][0]->resp.mpr_rec.hops;
+	minB = min(matrix[0][1]->resp.mpr_rec.hops, matrix[1][0]->resp.mpr_rec.hops);
 
 	/* and the winner is... */
 	if (minA <= minB || (minA == minB && sumA < sumB)) {
@@ -1442,10 +1442,12 @@ static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Diag {0,0} & {1,1} is the best:\n"
 			"\t{0,0} 0x%X->0x%X (%d)\t & {1,1} 0x%X->0x%X (%d)\n",
-			matrix[0][0]->path_rec.slid,
-			matrix[0][0]->path_rec.dlid, matrix[0][0]->hops,
-			matrix[1][1]->path_rec.slid,
-			matrix[1][1]->path_rec.dlid, matrix[1][1]->hops);
+			matrix[0][0]->resp.mpr_rec.path_rec.slid,
+			matrix[0][0]->resp.mpr_rec.path_rec.dlid,
+			matrix[0][0]->resp.mpr_rec.hops,
+			matrix[1][1]->resp.mpr_rec.path_rec.slid,
+			matrix[1][1]->resp.mpr_rec.path_rec.dlid,
+			matrix[1][1]->resp.mpr_rec.hops);
 		cl_qlist_insert_tail(p_list, &matrix[0][0]->list_item);
 		cl_qlist_insert_tail(p_list, &matrix[1][1]->list_item);
 		free(matrix[0][1]);
@@ -1455,10 +1457,12 @@ static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Diag {0,1} & {1,0} is the best:\n"
 			"\t{0,1} 0x%X->0x%X (%d)\t & {1,0} 0x%X->0x%X (%d)\n",
-			matrix[0][1]->path_rec.slid,
-			matrix[0][1]->path_rec.dlid, matrix[0][1]->hops,
-			matrix[1][0]->path_rec.slid,
-			matrix[1][0]->path_rec.dlid, matrix[1][0]->hops);
+			matrix[0][1]->resp.mpr_rec.path_rec.slid,
+			matrix[0][1]->resp.mpr_rec.path_rec.dlid,
+			matrix[0][1]->resp.mpr_rec.hops,
+			matrix[1][0]->resp.mpr_rec.path_rec.slid,
+			matrix[1][0]->resp.mpr_rec.path_rec.dlid,
+			matrix[1][0]->resp.mpr_rec.hops);
 		cl_qlist_insert_tail(p_list, &matrix[0][1]->list_item);
 		cl_qlist_insert_tail(p_list, &matrix[1][0]->list_item);
 		free(matrix[0][0]);
diff --git a/opensm/osm_sa_node_record.c b/opensm/osm_sa_node_record.c
index c7a079e..709d8ad 100644
--- a/opensm/osm_sa_node_record.c
+++ b/opensm/osm_sa_node_record.c
@@ -56,10 +56,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-typedef struct osm_nr_item {
-	cl_list_item_t list_item;
-	ib_node_record_t rec;
-} osm_nr_item_t;
+#define SA_NR_RESP_SIZE SA_ITEM_RESP_SIZE(node_rec)
 
 typedef struct osm_nr_search_ctxt {
 	const ib_node_record_t *p_rcvd_rec;
@@ -75,12 +72,12 @@ static ib_api_status_t nr_rcv_new_nr(osm_sa_t * sa,
 				     IN ib_net64_t port_guid, IN ib_net16_t lid,
 	                             IN unsigned int port_num)
 {
-	osm_nr_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_NR_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1D02: "
 			"rec_item alloc failed\n");
@@ -94,16 +91,16 @@ static ib_api_status_t nr_rcv_new_nr(osm_sa_t * sa,
 		cl_ntoh64(osm_node_get_node_guid(p_node)),
 		cl_ntoh64(port_guid), cl_ntoh16(lid));
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_NR_RESP_SIZE);
 
-	p_rec_item->rec.lid = lid;
+	p_rec_item->resp.node_rec.lid = lid;
 
-	p_rec_item->rec.node_info = p_node->node_info;
-	p_rec_item->rec.node_info.port_guid = port_guid;
-	p_rec_item->rec.node_info.port_num_vendor_id =
-		(p_rec_item->rec.node_info.port_num_vendor_id & IB_NODE_INFO_VEND_ID_MASK) |
+	p_rec_item->resp.node_rec.node_info = p_node->node_info;
+	p_rec_item->resp.node_rec.node_info.port_guid = port_guid;
+	p_rec_item->resp.node_rec.node_info.port_num_vendor_id =
+		(p_rec_item->resp.node_rec.node_info.port_num_vendor_id & IB_NODE_INFO_VEND_ID_MASK) |
 		((port_num << IB_NODE_INFO_PORT_NUM_SHIFT) & IB_NODE_INFO_PORT_NUM_MASK);
-	memcpy(&(p_rec_item->rec.node_desc), &(p_node->node_desc),
+	memcpy(&(p_rec_item->resp.node_rec.node_desc), &(p_node->node_desc),
 	       IB_NODE_DESCRIPTION_SIZE);
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
 
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 3ab37e3..08beb58 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -73,12 +73,9 @@
 #include <opensm/osm_prefix_route.h>
 #include <opensm/osm_ucast_lash.h>
 
-#define MAX_HOPS 64
+#define SA_PR_RESP_SIZE SA_ITEM_RESP_SIZE(path_rec)
 
-typedef struct osm_pr_item {
-	cl_list_item_t list_item;
-	ib_path_rec_t path_rec;
-} osm_pr_item_t;
+#define MAX_HOPS 64
 
 typedef struct osm_path_parms {
 	ib_net16_t pkey;
@@ -931,7 +928,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa,
 	OSM_LOG_EXIT(sa->p_log);
 }
 
-static osm_pr_item_t *pr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
+static osm_sa_item_t *pr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 					       IN const ib_path_rec_t * p_pr,
 					       IN const osm_alias_guid_t * p_src_alias_guid,
 					       IN const osm_alias_guid_t * p_dest_alias_guid,
@@ -944,7 +941,7 @@ static osm_pr_item_t *pr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 {
 	osm_path_parms_t path_parms;
 	osm_path_parms_t rev_path_parms;
-	osm_pr_item_t *p_pr_item;
+	osm_sa_item_t *p_pr_item;
 	ib_api_status_t status, rev_path_status;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -952,13 +949,13 @@ static osm_pr_item_t *pr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Src LID %u, Dest LID %u\n",
 		src_lid_ho, dest_lid_ho);
 
-	p_pr_item = malloc(sizeof(*p_pr_item));
+	p_pr_item = malloc(SA_PR_RESP_SIZE);
 	if (p_pr_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F01: "
 			"Unable to allocate path record\n");
 		goto Exit;
 	}
-	memset(p_pr_item, 0, sizeof(*p_pr_item));
+	memset(p_pr_item, 0, SA_PR_RESP_SIZE);
 
 	status = pr_rcv_get_path_parms(sa, p_pr, p_src_alias_guid, src_lid_ho,
 				       p_dest_alias_guid, dest_lid_ho,
@@ -995,7 +992,7 @@ static osm_pr_item_t *pr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 
 	pr_rcv_build_pr(sa, p_src_alias_guid, p_dest_alias_guid, p_sgid, p_dgid,
 			src_lid_ho, dest_lid_ho, preference, &path_parms,
-			&p_pr_item->path_rec);
+			&p_pr_item->resp.path_rec);
 
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
@@ -1013,7 +1010,7 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 {
 	const ib_path_rec_t *p_pr = ib_sa_mad_get_payload_ptr(sa_mad);
 	ib_net64_t comp_mask = sa_mad->comp_mask;
-	osm_pr_item_t *p_pr_item;
+	osm_sa_item_t *p_pr_item;
 	uint16_t src_lid_min_ho;
 	uint16_t src_lid_max_ho;
 	uint16_t dest_lid_min_ho;
@@ -1626,7 +1623,7 @@ static void pr_process_multicast(osm_sa_t * sa, const ib_sa_mad_t *sa_mad,
 	ib_path_rec_t *pr = ib_sa_mad_get_payload_ptr(sa_mad);
 	osm_mgrp_t *mgrp;
 	ib_api_status_t status;
-	osm_pr_item_t *pr_item;
+	osm_sa_item_t *pr_item;
 	uint32_t flow_label;
 	uint8_t sl, hop_limit;
 
@@ -1650,34 +1647,34 @@ static void pr_process_multicast(osm_sa_t * sa, const ib_sa_mad_t *sa_mad,
 		return;
 	}
 
-	pr_item = malloc(sizeof(*pr_item));
+	pr_item = malloc(SA_PR_RESP_SIZE);
 	if (pr_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F18: "
 			"Unable to allocate path record for MC group\n");
 		return;
 	}
-	memset(pr_item, 0, sizeof(*pr_item));
+	memset(pr_item, 0, SA_PR_RESP_SIZE);
 
 	/* Copy PathRecord request into response */
-	pr_item->path_rec = *pr;
+	pr_item->resp.path_rec = *pr;
 
 	/* Now, use the MC info to cruft up the PathRecord response */
-	pr_item->path_rec.dgid = mgrp->mcmember_rec.mgid;
-	pr_item->path_rec.dlid = mgrp->mcmember_rec.mlid;
-	pr_item->path_rec.tclass = mgrp->mcmember_rec.tclass;
-	pr_item->path_rec.num_path = 1;
-	pr_item->path_rec.pkey = mgrp->mcmember_rec.pkey;
+	pr_item->resp.path_rec.dgid = mgrp->mcmember_rec.mgid;
+	pr_item->resp.path_rec.dlid = mgrp->mcmember_rec.mlid;
+	pr_item->resp.path_rec.tclass = mgrp->mcmember_rec.tclass;
+	pr_item->resp.path_rec.num_path = 1;
+	pr_item->resp.path_rec.pkey = mgrp->mcmember_rec.pkey;
 
 	/* MTU, rate, and packet lifetime should be exactly */
-	pr_item->path_rec.mtu = (2 << 6) | mgrp->mcmember_rec.mtu;
-	pr_item->path_rec.rate = (2 << 6) | mgrp->mcmember_rec.rate;
-	pr_item->path_rec.pkt_life = (2 << 6) | mgrp->mcmember_rec.pkt_life;
+	pr_item->resp.path_rec.mtu = (2 << 6) | mgrp->mcmember_rec.mtu;
+	pr_item->resp.path_rec.rate = (2 << 6) | mgrp->mcmember_rec.rate;
+	pr_item->resp.path_rec.pkt_life = (2 << 6) | mgrp->mcmember_rec.pkt_life;
 
 	/* SL, Hop Limit, and Flow Label */
 	ib_member_get_sl_flow_hop(mgrp->mcmember_rec.sl_flow_hop,
 				  &sl, &flow_label, &hop_limit);
-	ib_path_rec_set_sl(&pr_item->path_rec, sl);
-	ib_path_rec_set_qos_class(&pr_item->path_rec, 0);
+	ib_path_rec_set_sl(&pr_item->resp.path_rec, sl);
+	ib_path_rec_set_qos_class(&pr_item->resp.path_rec, 0);
 
 	/* HopLimit is not yet set in non link local MC groups */
 	/* If it were, this would not be needed */
@@ -1685,7 +1682,7 @@ static void pr_process_multicast(osm_sa_t * sa, const ib_sa_mad_t *sa_mad,
 	    IB_MC_SCOPE_LINK_LOCAL)
 		hop_limit = IB_HOPLIMIT_MAX;
 
-	pr_item->path_rec.hop_flow_raw =
+	pr_item->resp.path_rec.hop_flow_raw =
 	    cl_hton32(hop_limit) | (flow_label << 8);
 
 	cl_qlist_insert_tail(list, &pr_item->list_item);
diff --git a/opensm/osm_sa_pkey_record.c b/opensm/osm_sa_pkey_record.c
index 691a716..4c4dd13 100644
--- a/opensm/osm_sa_pkey_record.c
+++ b/opensm/osm_sa_pkey_record.c
@@ -52,10 +52,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-typedef struct osm_pkey_item {
-	cl_list_item_t list_item;
-	ib_pkey_table_record_t rec;
-} osm_pkey_item_t;
+#define SA_PKEY_RESP_SIZE SA_ITEM_RESP_SIZE(pkey_rec)
 
 typedef struct osm_pkey_search_ctxt {
 	const ib_pkey_table_record_t *p_rcvd_rec;
@@ -70,13 +67,13 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
 			   IN osm_pkey_search_ctxt_t * p_ctxt,
 			   IN uint16_t block)
 {
-	osm_pkey_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	uint16_t lid;
 	ib_pkey_table_t *tbl;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_PKEY_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4602: "
 			"rec_item alloc failed\n");
@@ -94,20 +91,20 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
 		cl_ntoh64(osm_physp_get_port_guid(p_physp)),
 		cl_ntoh16(lid), osm_physp_get_port_num(p_physp), block);
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_PKEY_RESP_SIZE);
 
-	p_rec_item->rec.lid = lid;
-	p_rec_item->rec.block_num = block;
-	p_rec_item->rec.port_num = osm_physp_get_port_num(p_physp);
+	p_rec_item->resp.pkey_rec.lid = lid;
+	p_rec_item->resp.pkey_rec.block_num = block;
+	p_rec_item->resp.pkey_rec.port_num = osm_physp_get_port_num(p_physp);
 	/* FIXME: There are ninf.PartitionCap or swinf.PartitionEnforcementCap
 	   pkey entries so everything in that range is a valid block number
 	   even if opensm is not using it. Return 0. However things outside
-	   that range should return no entries.. Not sure how to figure that
+	   that range should return no entries. Not sure how to figure that
 	   here? The range of pkey_tbl can be less than the cap, so
 	   this falsely triggers. */
 	tbl = osm_pkey_tbl_block_get(osm_physp_get_pkey_tbl(p_physp), block);
 	if (tbl)
-		p_rec_item->rec.pkey_tbl = *tbl;
+		p_rec_item->resp.pkey_rec.pkey_tbl = *tbl;
 
 	cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list_item);
 
diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index b9627c9..39ea51d 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -60,10 +60,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-typedef struct osm_pir_item {
-	cl_list_item_t list_item;
-	ib_portinfo_record_t rec;
-} osm_pir_item_t;
+#define SA_PIR_RESP_SIZE SA_ITEM_RESP_SIZE(port_rec)
 
 typedef struct osm_pir_search_ctxt {
 	const ib_portinfo_record_t *p_rcvd_rec;
@@ -79,14 +76,14 @@ static ib_api_status_t pir_rcv_new_pir(IN osm_sa_t * sa,
 				       IN osm_pir_search_ctxt_t * p_ctxt,
 				       IN ib_net16_t const lid)
 {
-	osm_pir_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	ib_port_info_t *p_pi;
 	osm_physp_t *p_physp0;
 	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_PIR_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2102: "
 			"rec_item alloc failed\n");
@@ -100,12 +97,12 @@ static ib_api_status_t pir_rcv_new_pir(IN osm_sa_t * sa,
 		cl_ntoh64(osm_physp_get_port_guid(p_physp)),
 		cl_ntoh16(lid), osm_physp_get_port_num(p_physp));
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_PIR_RESP_SIZE);
 
-	p_rec_item->rec.lid = lid;
-	p_rec_item->rec.port_info = p_physp->port_info;
+	p_rec_item->resp.port_rec.lid = lid;
+	p_rec_item->resp.port_rec.port_info = p_physp->port_info;
 	if (p_ctxt->comp_mask & IB_PIR_COMPMASK_OPTIONS)
-		p_rec_item->rec.options = p_ctxt->p_rcvd_rec->options;
+		p_rec_item->resp.port_rec.options = p_ctxt->p_rcvd_rec->options;
 	if ((p_ctxt->comp_mask & IB_PIR_COMPMASK_OPTIONS) == 0 ||
 	    (p_ctxt->p_rcvd_rec->options & 0x80) == 0) {
 		/* Does requested port have an extended link speed active ? */
@@ -118,7 +115,7 @@ static ib_api_status_t pir_rcv_new_pir(IN osm_sa_t * sa,
 		if ((p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) > 0) {
 			if (ib_port_info_get_link_speed_ext_active(&p_physp->port_info)) {
 				/* Add QDR bits to original link speed components */
-				p_pi = &p_rec_item->rec.port_info;
+				p_pi = &p_rec_item->resp.port_rec.port_info;
 				ib_port_info_set_link_speed_enabled(p_pi,
 								    ib_port_info_get_link_speed_enabled(p_pi) | IB_LINK_SPEED_ACTIVE_10);
 				p_pi->state_info1 =
@@ -130,7 +127,7 @@ static ib_api_status_t pir_rcv_new_pir(IN osm_sa_t * sa,
 			}
 		}
 	}
-	p_rec_item->rec.port_num = osm_physp_get_port_num(p_physp);
+	p_rec_item->resp.port_rec.port_num = osm_physp_get_port_num(p_physp);
 
 	cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list_item);
 
@@ -595,11 +592,11 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 	   sm_key.
 	 */
 	if (!p_rcvd_mad->sm_key) {
-		osm_pir_item_t *item;
-		for (item = (osm_pir_item_t *) cl_qlist_head(&rec_list);
-		     item != (osm_pir_item_t *) cl_qlist_end(&rec_list);
-		     item = (osm_pir_item_t *) cl_qlist_next(&item->list_item))
-			item->rec.port_info.m_key = 0;
+		osm_sa_item_t *item;
+		for (item = (osm_sa_item_t *) cl_qlist_head(&rec_list);
+		     item != (osm_sa_item_t *) cl_qlist_end(&rec_list);
+		     item = (osm_sa_item_t *) cl_qlist_next(&item->list_item))
+			item->resp.port_rec.port_info.m_key = 0;
 	}
 
 	osm_sa_respond(sa, p_madw, sizeof(ib_portinfo_record_t), &rec_list);
diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index fe21712..6121518 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -61,10 +61,7 @@
 #include <opensm/osm_service.h>
 #include <opensm/osm_pkey.h>
 
-typedef struct osm_sr_item {
-	cl_list_item_t list_item;
-	ib_service_record_t service_rec;
-} osm_sr_item_t;
+#define SA_SR_RESP_SIZE SA_ITEM_RESP_SIZE(service_rec)
 
 typedef struct osm_sr_match_item {
 	cl_qlist_t sr_list;
@@ -206,12 +203,12 @@ static void sr_rcv_respond(IN osm_sa_t * sa, IN osm_madw_t * p_madw,
 	   sm_key.
 	 */
 	if (!osm_madw_get_sa_mad_ptr(p_madw)->sm_key) {
-		osm_sr_item_t *item;
-		for (item = (osm_sr_item_t *) cl_qlist_head(p_list);
-		     item != (osm_sr_item_t *) cl_qlist_end(p_list);
-		     item = (osm_sr_item_t *) cl_qlist_next(&item->list_item))
-			memset(item->service_rec.service_key, 0,
-			       sizeof(item->service_rec.service_key));
+		osm_sa_item_t *item;
+		for (item = (osm_sa_item_t *) cl_qlist_head(p_list);
+		     item != (osm_sa_item_t *) cl_qlist_end(p_list);
+		     item = (osm_sa_item_t *) cl_qlist_next(&item->list_item))
+			memset(item->resp.service_rec.service_key, 0,
+			       sizeof(item->resp.service_rec.service_key));
 	}
 
 	osm_sa_respond(sa, p_madw, sizeof(ib_service_record_t), p_list);
@@ -221,7 +218,7 @@ static void get_matching_sr(IN cl_list_item_t * p_list_item, IN void *context)
 {
 	osm_sr_search_ctxt_t *p_ctxt = context;
 	osm_svcr_t *p_svcr = (osm_svcr_t *) p_list_item;
-	osm_sr_item_t *p_sr_pool_item;
+	osm_sa_item_t *p_sr_pool_item;
 	osm_sr_match_item_t *p_sr_item = p_ctxt->p_sr_item;
 	ib_net64_t comp_mask = p_sr_item->comp_mask;
 	const osm_physp_t *p_req_physp = p_ctxt->p_req_physp;
@@ -428,14 +425,14 @@ static void get_matching_sr(IN cl_list_item_t * p_list_item, IN void *context)
 		}
 	}
 
-	p_sr_pool_item = malloc(sizeof(*p_sr_pool_item));
+	p_sr_pool_item = malloc(SA_SR_RESP_SIZE);
 	if (p_sr_pool_item == NULL) {
 		OSM_LOG(p_sr_item->sa->p_log, OSM_LOG_ERROR, "ERR 2408: "
 			"Unable to acquire Service Record from pool\n");
 		goto Exit;
 	}
 
-	p_sr_pool_item->service_rec = p_svcr->service_record;
+	p_sr_pool_item->resp.service_rec = p_svcr->service_record;
 
 	cl_qlist_insert_tail(&p_sr_item->sr_list, &p_sr_pool_item->list_item);
 
@@ -513,7 +510,7 @@ static void sr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	ib_service_record_t *p_recvd_service_rec;
 	ib_net64_t comp_mask;
 	osm_svcr_t *p_svcr;
-	osm_sr_item_t *p_sr_item;
+	osm_sa_item_t *p_sr_item;
 	cl_qlist_t sr_list;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -585,7 +582,7 @@ static void sr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 		p_svcr->modified_time = cl_get_time_stamp_sec();
 	}
 
-	p_sr_item = malloc(sizeof(*p_sr_item));
+	p_sr_item = malloc(SA_SR_RESP_SIZE);
 	if (p_sr_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2412: "
 			"Unable to acquire Service record\n");
@@ -597,7 +594,7 @@ static void sr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 		/* Set the Default Service P_Key in the response */
 		p_recvd_service_rec->service_pkey = IB_DEFAULT_PKEY;
 
-	p_sr_item->service_rec = *p_recvd_service_rec;
+	p_sr_item->resp.service_rec = *p_recvd_service_rec;
 	cl_qlist_init(&sr_list);
 
 	cl_qlist_insert_tail(&sr_list, &p_sr_item->list_item);
@@ -613,7 +610,7 @@ static void sr_rcv_process_delete_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	ib_sa_mad_t *p_sa_mad;
 	ib_service_record_t *p_recvd_service_rec;
 	osm_svcr_t *p_svcr;
-	osm_sr_item_t *p_sr_item;
+	osm_sa_item_t *p_sr_item;
 	cl_qlist_t sr_list;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -646,7 +643,7 @@ static void sr_rcv_process_delete_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	osm_svcr_remove_from_db(sa->p_subn, sa->p_log, p_svcr);
 	cl_plock_release(sa->p_lock);
 
-	p_sr_item = malloc(sizeof(*p_sr_item));
+	p_sr_item = malloc(SA_SR_RESP_SIZE);
 	if (p_sr_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2413: "
 			"Unable to acquire Service record\n");
@@ -656,7 +653,7 @@ static void sr_rcv_process_delete_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	}
 
 	/* provide back the copy of the record */
-	p_sr_item->service_rec = p_svcr->service_record;
+	p_sr_item->resp.service_rec = p_svcr->service_record;
 	cl_qlist_init(&sr_list);
 
 	cl_qlist_insert_tail(&sr_list, &p_sr_item->list_item);
diff --git a/opensm/osm_sa_slvl_record.c b/opensm/osm_sa_slvl_record.c
index 1049a1f..d3b48af 100644
--- a/opensm/osm_sa_slvl_record.c
+++ b/opensm/osm_sa_slvl_record.c
@@ -59,10 +59,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-typedef struct osm_slvl_item {
-	cl_list_item_t list_item;
-	ib_slvl_table_record_t rec;
-} osm_slvl_item_t;
+#define SA_SLVL_RESP_SIZE SA_ITEM_RESP_SIZE(slvl_rec)
 
 typedef struct osm_slvl_search_ctxt {
 	const ib_slvl_table_record_t *p_rcvd_rec;
@@ -77,12 +74,12 @@ static void sa_slvl_create(IN osm_sa_t * sa, IN const osm_physp_t * p_physp,
 			   IN osm_slvl_search_ctxt_t * p_ctxt,
 			   IN uint8_t in_port_idx)
 {
-	osm_slvl_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	uint16_t lid;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_SLVL_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2602: "
 			"rec_item alloc failed\n");
@@ -100,14 +97,14 @@ static void sa_slvl_create(IN osm_sa_t * sa, IN const osm_physp_t * p_physp,
 		cl_ntoh64(osm_physp_get_port_guid(p_physp)),
 		cl_ntoh16(lid), osm_physp_get_port_num(p_physp), in_port_idx);
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_SLVL_RESP_SIZE);
 
-	p_rec_item->rec.lid = lid;
+	p_rec_item->resp.slvl_rec.lid = lid;
 	if (p_physp->p_node->node_info.node_type == IB_NODE_TYPE_SWITCH) {
-		p_rec_item->rec.out_port_num = osm_physp_get_port_num(p_physp);
-		p_rec_item->rec.in_port_num = in_port_idx;
+		p_rec_item->resp.slvl_rec.out_port_num = osm_physp_get_port_num(p_physp);
+		p_rec_item->resp.slvl_rec.in_port_num = in_port_idx;
 	}
-	p_rec_item->rec.slvl_tbl =
+	p_rec_item->resp.slvl_rec.slvl_tbl =
 	    *(osm_physp_get_slvl_tbl(p_physp, in_port_idx));
 
 	cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list_item);
diff --git a/opensm/osm_sa_sminfo_record.c b/opensm/osm_sa_sminfo_record.c
index c60316d..99bb5ab 100644
--- a/opensm/osm_sa_sminfo_record.c
+++ b/opensm/osm_sa_sminfo_record.c
@@ -65,10 +65,7 @@
 #include <opensm/osm_sa.h>
 #include <opensm/osm_opensm.h>
 
-typedef struct osm_smir_item {
-	cl_list_item_t list_item;
-	ib_sminfo_record_t rec;
-} osm_smir_item_t;
+#define SA_SMIR_RESP_SIZE SA_ITEM_RESP_SIZE(sminfo_rec)
 
 typedef struct osm_smir_search_ctxt {
 	const ib_sminfo_record_t *p_rcvd_rec;
@@ -86,12 +83,12 @@ static ib_api_status_t smir_rcv_new_smir(IN osm_sa_t * sa,
 					 IN uint8_t const pri_state,
 					 IN const osm_physp_t * p_req_physp)
 {
-	osm_smir_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_SMIR_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2801: "
 			"rec_item alloc failed\n");
@@ -102,12 +99,12 @@ static ib_api_status_t smir_rcv_new_smir(IN osm_sa_t * sa,
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"New SMInfo: GUID 0x%016" PRIx64 "\n", cl_ntoh64(guid));
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_SMIR_RESP_SIZE);
 
-	p_rec_item->rec.lid = osm_port_get_base_lid(p_port);
-	p_rec_item->rec.sm_info.guid = guid;
-	p_rec_item->rec.sm_info.act_count = act_count;
-	p_rec_item->rec.sm_info.pri_state = pri_state;
+	p_rec_item->resp.sminfo_rec.lid = osm_port_get_base_lid(p_port);
+	p_rec_item->resp.sminfo_rec.sm_info.guid = guid;
+	p_rec_item->resp.sminfo_rec.sm_info.act_count = act_count;
+	p_rec_item->resp.sminfo_rec.sm_info.pri_state = pri_state;
 
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
 
diff --git a/opensm/osm_sa_sw_info_record.c b/opensm/osm_sa_sw_info_record.c
index d83e621..1ce1230 100644
--- a/opensm/osm_sa_sw_info_record.c
+++ b/opensm/osm_sa_sw_info_record.c
@@ -56,10 +56,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-typedef struct osm_sir_item {
-	cl_list_item_t list_item;
-	ib_switch_info_record_t rec;
-} osm_sir_item_t;
+#define SA_SIR_RESP_SIZE SA_ITEM_RESP_SIZE(swinfo_rec)
 
 typedef struct osm_sir_search_ctxt {
 	const ib_switch_info_record_t *p_rcvd_rec;
@@ -74,12 +71,12 @@ static ib_api_status_t sir_rcv_new_sir(IN osm_sa_t * sa,
 				       IN cl_qlist_t * p_list,
 				       IN ib_net16_t lid)
 {
-	osm_sir_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_SIR_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5308: "
 			"rec_item alloc failed\n");
@@ -90,10 +87,10 @@ static ib_api_status_t sir_rcv_new_sir(IN osm_sa_t * sa,
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"New SwitchInfoRecord: lid %u\n", cl_ntoh16(lid));
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_SIR_RESP_SIZE);
 
-	p_rec_item->rec.lid = lid;
-	p_rec_item->rec.switch_info = p_sw->switch_info;
+	p_rec_item->resp.swinfo_rec.lid = lid;
+	p_rec_item->resp.swinfo_rec.switch_info = p_sw->switch_info;
 
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
 
diff --git a/opensm/osm_sa_vlarb_record.c b/opensm/osm_sa_vlarb_record.c
index 2ada36b..24652a0 100644
--- a/opensm/osm_sa_vlarb_record.c
+++ b/opensm/osm_sa_vlarb_record.c
@@ -59,10 +59,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-typedef struct osm_vl_arb_item {
-	cl_list_item_t list_item;
-	ib_vl_arb_table_record_t rec;
-} osm_vl_arb_item_t;
+#define SA_VLA_RESP_SIZE SA_ITEM_RESP_SIZE(vlarb_rec)
 
 typedef struct osm_vl_arb_search_ctxt {
 	const ib_vl_arb_table_record_t *p_rcvd_rec;
@@ -77,12 +74,12 @@ static void sa_vl_arb_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
 			     IN osm_vl_arb_search_ctxt_t * p_ctxt,
 			     IN uint8_t block)
 {
-	osm_vl_arb_item_t *p_rec_item;
+	osm_sa_item_t *p_rec_item;
 	uint16_t lid;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rec_item = malloc(sizeof(*p_rec_item));
+	p_rec_item = malloc(SA_VLA_RESP_SIZE);
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2A02: "
 			"rec_item alloc failed\n");
@@ -100,12 +97,12 @@ static void sa_vl_arb_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
 		cl_ntoh64(osm_physp_get_port_guid(p_physp)),
 		cl_ntoh16(lid), osm_physp_get_port_num(p_physp), block);
 
-	memset(p_rec_item, 0, sizeof(*p_rec_item));
+	memset(p_rec_item, 0, SA_VLA_RESP_SIZE);
 
-	p_rec_item->rec.lid = lid;
-	p_rec_item->rec.port_num = osm_physp_get_port_num(p_physp);
-	p_rec_item->rec.block_num = block;
-	p_rec_item->rec.vl_arb_tbl = *(osm_physp_get_vla_tbl(p_physp, block));
+	p_rec_item->resp.vlarb_rec.lid = lid;
+	p_rec_item->resp.vlarb_rec.port_num = osm_physp_get_port_num(p_physp);
+	p_rec_item->resp.vlarb_rec.block_num = block;
+	p_rec_item->resp.vlarb_rec.vl_arb_tbl = *(osm_physp_get_vla_tbl(p_physp, block));
 
 	cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list_item);
 
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
