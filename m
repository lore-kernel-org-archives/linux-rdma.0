From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/6] opensm/osm_sa_informinfo.c: Fix infr_rcv_respond to only copy InformInfo
Date: Tue,  5 Feb 2013 19:00:24 +0200
Message-ID: <1360083625-15981-2-git-send-email-alexne@mellanox.com>
References: <1360083625-15981-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360083625-15981-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

and not InformInfoRecord which is larger when responding to
sets of InformInfo

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_sa.h    | 1 +
 opensm/osm_sa_informinfo.c | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/opensm/osm_sa.h b/include/opensm/osm_sa.h
index 19de2ab..d9016ab 100644
--- a/include/opensm/osm_sa.h
+++ b/include/opensm/osm_sa.h
@@ -133,6 +133,7 @@ typedef struct osm_sa_item {
 	union {
 		char data[0];
 		ib_guidinfo_record_t guid_rec;
+		ib_inform_info_t inform;
 		ib_inform_info_record_t inform_rec;
 		ib_lft_record_t lft_rec;
 		ib_link_record_t link_rec;
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index 8f7e5d5..0b3e1f8 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -64,6 +64,7 @@
 #include <opensm/osm_pkey.h>
 
 #define SA_IIR_RESP_SIZE SA_ITEM_RESP_SIZE(inform_rec)
+#define SA_II_RESP_SIZE SA_ITEM_RESP_SIZE(inform)
 
 typedef struct osm_iir_search_ctxt {
 	const ib_inform_info_record_t *p_rcvd_rec;
@@ -213,16 +214,16 @@ static void infr_rcv_respond(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Generating successful InformInfo response\n");
 
-	item = malloc(SA_IIR_RESP_SIZE);
+	item = malloc(SA_II_RESP_SIZE);
 	if (!item) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4303: "
 			"rec_item alloc failed\n");
 		goto Exit;
 	}
 
-	memcpy(&item->resp.inform_rec,
+	memcpy(&item->resp.inform,
 	       ib_sa_mad_get_payload_ptr(osm_madw_get_sa_mad_ptr(p_madw)),
-	       sizeof(item->resp.inform_rec));
+	       sizeof(ib_inform_info_t));
 
 	cl_qlist_init(&rec_list);
 	cl_qlist_insert_tail(&rec_list, &item->list_item);
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
