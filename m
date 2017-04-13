From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2 rdma-core 3/3] srp_daemon: Use consistent format when
 printing LID
Date: Thu, 13 Apr 2017 11:54:30 -0400
Message-ID: <0a8e69e9-82bf-3ea7-75e4-ad25b6652004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Some LIDs are formatted in hex and others in decimal.
Be consistent (use hex LID formatting).

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
Updated commit description
Removed cast to uint16_t

 srp_daemon/srp_daemon.c       | 14 +++++++-------
 srp_daemon/srp_handle_traps.c |  4 ++--
 srp_daemon/srp_sync.c         |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 59a6137..cbaac37 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -632,8 +632,8 @@ recv:
 			ret = umad_status(in_mad);
 			if (ret) {
 				pr_err(
-					"bad MAD status (%u) from lid %d\n",
-					ret, (uint16_t) be16toh(out_mad->hdr.addr.lid));
+					"bad MAD status (%u) from lid %#x\n",
+					ret, be16toh(out_mad->hdr.addr.lid));
 				return -ret;
 			}
 
@@ -935,7 +935,7 @@ static int do_port(struct resources *res, uint16_t pkey, uint16_t dlid,
 
 	ret = get_iou_info(umad_res, dlid, &iou_info);
 	if (ret < 0) {
-		pr_err("failed to get iou info for dlid %x\n", dlid);
+		pr_err("failed to get iou info for dlid %#x\n", dlid);
 		goto out;
 	}
 
@@ -1214,7 +1214,7 @@ static int do_dm_port_list(struct resources *res)
 		num_pkeys = get_shared_pkeys(res, be16toh(port_info->endport_lid),
 					     pkeys);
 		if (num_pkeys < 0) {
-			pr_err("failed to get shared P_Keys with LID %x\n",
+			pr_err("failed to get shared P_Keys with LID %#x\n",
 			       be16toh(port_info->endport_lid));
 			free(in_mad_buf);
 			return num_pkeys;
@@ -1235,7 +1235,7 @@ void handle_port(struct resources *res, uint16_t pkey, uint16_t lid, uint64_t h_
 	uint64_t subnet_prefix;
 	int isdm;
 
- 	pr_debug("enter handle_port for lid %d\n", lid);
+	pr_debug("enter handle_port for lid %#x\n", lid);
 	if (get_port_info(umad_res, lid, &subnet_prefix, &isdm))
 		return;
 
@@ -1292,7 +1292,7 @@ static int do_full_port_list(struct resources *res)
 		num_pkeys = get_shared_pkeys(res, be16toh(node->lid),
 					     pkeys);
 		if (num_pkeys < 0) {
-			pr_err("failed to get shared P_Keys with LID %x\n",
+			pr_err("failed to get shared P_Keys with LID %#x\n",
 			       be16toh(node->lid));
 			free(in_mad_buf);
 			return num_pkeys;
@@ -2188,7 +2188,7 @@ catas_start:
 					/* unexpected error - do a full rescan */
 					schedule_rescan(res->sync_res, 0);
 				else {
-					pr_debug("lid is %d\n", lid);
+					pr_debug("lid is %#x\n", lid);
 
 					srp_sleep(0, 100);
 					handle_port(res, pkey, lid,
diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
index f219702..6d94634 100644
--- a/srp_daemon/srp_handle_traps.c
+++ b/srp_daemon/srp_handle_traps.c
@@ -561,9 +561,9 @@ static int register_to_trap(struct sync_resources *sync_res,
 	static uint64_t trans_id = 0x0000FFFF;
 
 	if (subscribe)
-		pr_debug("Registering to trap:%d (sm in %d)\n", trap_num, dest_lid);
+		pr_debug("Registering to trap:%d (sm in %#x)\n", trap_num, dest_lid);
 	else
-		pr_debug("Deregistering from trap:%d (sm in %d)\n", trap_num, dest_lid);
+		pr_debug("Deregistering from trap:%d (sm in %#x)\n", trap_num, dest_lid);
 
 	memset(res->send_buf, 0, SEND_SIZE);
 
diff --git a/srp_daemon/srp_sync.c b/srp_daemon/srp_sync.c
index 72c41f0..036fbe5 100644
--- a/srp_daemon/srp_sync.c
+++ b/srp_daemon/srp_sync.c
@@ -171,7 +171,7 @@ void push_lid_to_list(struct sync_resources *res, uint16_t lid, uint16_t pkey)
 
 	for (i=0; i < res->next_task; ++i)
 		if (res->tasks[i].lid == lid && res->tasks[i].pkey == pkey) {
-			pr_debug("lid %d is already in task list\n", lid);
+			pr_debug("lid %#x is already in task list\n", lid);
 			pthread_mutex_unlock(&res->mutex);
 			return;
 		}
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
