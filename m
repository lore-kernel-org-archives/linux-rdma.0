From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_guidinfo_record.c: Fix crash when receiving
 AGUID SET/DELETE with block_num equal to max_block
Date: Mon, 02 Jun 2014 06:17:42 -0400
Message-ID: <538C4F46.3070607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_guidinfo_record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 1ad8cad..d96db54 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -396,7 +396,7 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 	max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
 		     GUID_TABLE_MAX_ENTRIES;
 
-	if (block_num > max_block) {
+	if (block_num >= max_block) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5116: "
 			"block_num %d is higher than Max GUID Cap block %d "
 			"for port GUID 0x%" PRIx64 "\n",
@@ -503,7 +503,7 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 
 	max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
 		     GUID_TABLE_MAX_ENTRIES;
-	if (block_num > max_block) {
+	if (block_num >= max_block) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5118: "
 			"block_num %d is higher than Max GUID Cap block %d "
 			"for port GUID 0x%" PRIx64 "\n",
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
