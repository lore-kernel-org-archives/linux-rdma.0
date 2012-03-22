From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/4] opensm/osm_sa_guidinfo_record.c: Check block_num
 validity in set_guidinfo() and del_guidinfo() requests
Date: Thu, 22 Mar 2012 10:38:25 +0200
Message-ID: <20120322083825.GE2613@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

block_num should be less than port's Alias GUID capability.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_guidinfo_record.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index b100da1..37451b3 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -373,6 +373,7 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 			 IN osm_port_t *p_port, IN uint8_t block_num)
 {
 	int i;
+	uint32_t max_block;
 	ib_sa_mad_t *p_sa_mad;
 	ib_guidinfo_record_t *p_rcvd_rec;
 	ib_net64_t del_alias_guid;
@@ -386,6 +387,19 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 	if (!p_port->p_physp->p_guids)
 		goto Exit;
 
+	max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
+		     GUID_TABLE_MAX_ENTRIES;
+
+	if (block_num > max_block) {
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5116: "
+			"block_num %d is higher than Max GUID Cap block %d "
+			"for port GUID 0x%" PRIx64 "\n",
+			block_num, max_block, cl_ntoh64(p_port->p_physp->port_guid));
+		osm_sa_send_error(sa, p_madw,
+				  IB_SA_MAD_STATUS_NO_RECORDS);
+		return;
+	}
+
 	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
 	p_rcvd_rec =
 		(ib_guidinfo_record_t *) ib_sa_mad_get_payload_ptr(p_sa_mad);
@@ -479,6 +493,15 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 
 	max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
 		     GUID_TABLE_MAX_ENTRIES;
+	if (block_num > max_block) {
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5118: "
+			"block_num %d is higher than Max GUID Cap block %d "
+			"for port GUID 0x%" PRIx64 "\n",
+			block_num, max_block, cl_ntoh64(p_port->p_physp->port_guid));
+		osm_sa_send_error(sa, p_madw,
+				  IB_SA_MAD_STATUS_NO_RECORDS);
+		return;
+	}
 	if (!p_port->p_physp->p_guids) {
 		p_port->p_physp->p_guids = calloc(max_block * GUID_TABLE_MAX_ENTRIES,
 						  sizeof(ib_net64_t));
-- 
1.7.7.6

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
