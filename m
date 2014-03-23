From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/9] ibacm: Eliminate strict aliasing compiler warnings
Date: Sun, 23 Mar 2014 13:18:15 -0700
Message-ID: <1395605901-9080-4-git-send-email-sean.hefty@intel.com>
References: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395605901-9080-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use local variables and memcpy to defeat the
compiler warning: dereferencing type-punned
pointer will break strict-aliasing rules

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 57d34dc..c9e1b3c 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1598,13 +1598,15 @@ static void acm_process_timeouts(void)
 	DLIST_ENTRY *entry;
 	struct acm_send_msg *msg;
 	struct acm_resolve_rec *rec;
+	struct acm_mad *mad;
 	
 	while (!DListEmpty(&timeout_list)) {
 		entry = timeout_list.Next;
 		DListRemove(entry);
 
 		msg = container_of(entry, struct acm_send_msg, entry);
-		rec = (struct acm_resolve_rec *) ((struct acm_mad *) msg->data)->data;
+		mad = (struct acm_mad *) &msg->data[0];
+		rec = (struct acm_resolve_rec *) mad->data;
 
 		acm_format_name(0, log_data, sizeof log_data,
 				rec->dest_type, rec->dest, sizeof rec->dest);
@@ -2647,7 +2649,7 @@ static int acm_parse_osm_fullv1_paths(FILE *f, uint64_t *lid2guid, struct acm_ep
 	char s[128];
 	char *p, *ptr, *p_guid, *p_lid;
 	uint64_t guid;
-	uint16_t lid, dlid;
+	uint16_t lid, dlid, net_dlid;
 	int sl, mtu, rate;
 	int ret = 1, i;
 	uint8_t addr[ACM_MAX_ADDRESS];
@@ -2710,6 +2712,7 @@ static int acm_parse_osm_fullv1_paths(FILE *f, uint64_t *lid2guid, struct acm_ep
 			break;
 
 		dlid = strtoul(p, NULL, 0);
+		net_dlid = htons(dlid);
 
 		p = strtok_r(NULL, ":", &ptr);
 		if (!p)
@@ -2740,7 +2743,7 @@ static int acm_parse_osm_fullv1_paths(FILE *f, uint64_t *lid2guid, struct acm_ep
 			memset(addr, 0, ACM_MAX_ADDRESS);
 			if (i == 0) {
 				addr_type = ACM_ADDRESS_LID;
-				*((uint16_t *) addr) = htons(dlid);
+				memcpy(addr, &net_dlid, sizeof net_dlid);
 			} else {
 				addr_type = ACM_ADDRESS_GID;
 				memcpy(addr, &dgid, sizeof(dgid));
@@ -2754,7 +2757,7 @@ static int acm_parse_osm_fullv1_paths(FILE *f, uint64_t *lid2guid, struct acm_ep
 			dest->path.sgid = sgid;
 			dest->path.slid = htons(ep->port->lid);
 			dest->path.dgid = dgid;
-			dest->path.dlid = htons(dlid);
+			dest->path.dlid = net_dlid;
 			dest->path.reversible_numpath = IBV_PATH_RECORD_REVERSIBLE;
 			dest->path.pkey = htons(ep->pkey);
 			dest->path.mtu = (uint8_t) mtu;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
