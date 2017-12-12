From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH rdma-core 1/2] srp_daemon: handle SM lid change
Date: Tue, 12 Dec 2017 15:08:19 +0100
Message-ID: <dba1097c-8ab9-7086-a976-46e6d3c4a165@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When srp_daemon was running and the master SM host changes,
 srp_daemon output these errors at every scan:
srp_daemon[25394]: No response to inform info registration
srp_daemon[25394]: Fail to register to traps, maybe there is no opensm
 running on fabric or IB port is down

This was introduced by commit 4952e5f Fix a memory leak.
A side effect of this patch was that create_ah was only called when the
 port lid changes. Which meant register_to_traps used an older, obsolete,
 version of sm_lid and failed to connect to it.

This patch fixes this behaviour by checking for both local lid changes and
 SM lid changes, and calling create_ah on any of these events.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v14, v15, v16
---
 srp_daemon/srp_daemon.c       | 10 ++++++----
 srp_daemon/srp_daemon.h       |  2 +-
 srp_daemon/srp_handle_traps.c | 14 +++++++++++---
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 2465ccd9..36df5c3b 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -1103,7 +1103,7 @@ static int get_shared_pkeys(struct resources *res,
 	int i, num_pkeys = 0;
 	uint16_t pkey;
 	uint16_t local_port_lid = get_port_lid(res->ud_res->ib_ctx,
-					       config->port_num);
+					       config->port_num, NULL);
 
 	in_mad_buf = malloc(sizeof(struct ib_user_mad) +
 			    node_table_response_size);
@@ -2092,7 +2092,7 @@ int main(int argc, char *argv[])
 {
 	int			ret;
 	struct resources       *res;
-	uint16_t 		lid;
+	uint16_t 		lid, sm_lid;
 	uint16_t 		pkey;
 	union umad_gid 		gid;
 	struct target_details  *target;
@@ -2196,8 +2196,10 @@ catas_start:
 
 			pr_debug("Starting a recalculation\n");
 			port_lid = get_port_lid(res->ud_res->ib_ctx,
-					   config->port_num);
-			if (port_lid != res->ud_res->port_attr.lid) {
+						config->port_num, &sm_lid);
+			if (port_lid != res->ud_res->port_attr.lid ||
+				sm_lid != res->ud_res->port_attr.sm_lid) {
+
 				if (res->ud_res->ah) {
 					ibv_destroy_ah(res->ud_res->ah);
 					res->ud_res->ah = NULL;
diff --git a/srp_daemon/srp_daemon.h b/srp_daemon/srp_daemon.h
index 5d268ed3..864b3d42 100644
--- a/srp_daemon/srp_daemon.h
+++ b/srp_daemon/srp_daemon.h
@@ -299,7 +299,7 @@ void *run_thread_listen_to_events(void *res_in);
 int get_node(struct umad_resources *umad_res, uint16_t dlid, uint64_t *guid);
 int create_trap_resources(struct ud_resources *ud_res);
 int register_to_traps(struct resources *res, int subscribe);
-uint16_t get_port_lid(struct ibv_context *ib_ctx, int port_num);
+uint16_t get_port_lid(struct ibv_context *ib_ctx, int port_num, uint16_t *sm_lid);
 int create_ah(struct ud_resources *ud_res);
 void push_gid_to_list(struct sync_resources *res, union umad_gid *gid,
 		      uint16_t pkey);
diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
index 6d94634e..25f2b9ab 100644
--- a/srp_daemon/srp_handle_traps.c
+++ b/srp_daemon/srp_handle_traps.c
@@ -340,12 +340,20 @@ int ud_resources_create(struct ud_resources *res)
 	return 0;
 }
 
-uint16_t get_port_lid(struct ibv_context *ib_ctx, int port_num)
+uint16_t get_port_lid(struct ibv_context *ib_ctx, int port_num, uint16_t *sm_lid)
 {
 	struct ibv_port_attr port_attr;
+	int ret;
+
+	ret = ibv_query_port(ib_ctx, port_num, &port_attr);
 
-	return ibv_query_port(ib_ctx, port_num, &port_attr) == 0 ?
-		port_attr.lid : 0;
+	if (!ret) {
+		if (sm_lid)
+			*sm_lid = port_attr.sm_lid;
+		return port_attr.lid;
+	}
+
+	return 0;
 }
 
 int create_ah(struct ud_resources *ud_res)
-- 
2.15.1.272.g8e603414b


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
