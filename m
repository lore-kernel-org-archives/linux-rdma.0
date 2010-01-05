From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv7 3/4] libibverbs: Add API to retrieve eth MAC
Date: Tue, 5 Jan 2010 12:34:10 +0200
Message-ID: <20100105103410.GN31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a command to retrieve the MAC address of a port's GID. This is required by
libraries to build work requests when the port's link layer is Ethernet.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/infiniband/driver.h   |    1 +
 include/infiniband/kern-abi.h |   20 +++++++++++++++++++-
 src/cmd.c                     |   19 +++++++++++++++++++
 src/libibverbs.map            |    1 +
 4 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 9a81416..8d7c2c6 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -131,6 +131,7 @@ int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
 int ibv_cmd_destroy_ah(struct ibv_ah *ah);
 int ibv_cmd_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
 int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
+int ibv_cmd_get_mac(struct ibv_pd *pd, uint8_t port, uint8_t *gid, uint8_t *mac);
 
 int ibv_dontfork_range(void *base, size_t size);
 int ibv_dofork_range(void *base, size_t size);
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 619ea7e..345d70f 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -85,7 +85,8 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_GET_MAC
 };
 
 /*
@@ -804,6 +805,7 @@ enum {
 	 * trick opcodes in IBV_INIT_CMD() doesn't break.
 	 */
 	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL_V2 = -1,
+	IB_USER_VERBS_CMD_GET_MAC_V2 = -1,
 };
 
 struct ibv_destroy_cq_v1 {
@@ -879,4 +881,20 @@ struct ibv_create_srq_resp_v5 {
 	__u32 srq_handle;
 };
 
+struct ibv_get_mac {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u64 response;
+	__u32 pd_handle;
+	__u8  port;
+	__u8  reserved[3];
+	__u8  dgid[16];
+};
+
+struct ibv_get_mac_resp {
+	__u8	mac[6];
+	__u16	reserved;
+};
+
 #endif /* KERN_ABI_H */
diff --git a/src/cmd.c b/src/cmd.c
index 39af833..c8aa7ee 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1123,3 +1123,22 @@ int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t l
 
 	return 0;
 }
+
+int ibv_cmd_get_mac(struct ibv_pd *pd, uint8_t port, uint8_t *gid, uint8_t *mac)
+{
+	struct ibv_get_mac cmd;
+	struct ibv_get_mac_resp resp;
+
+	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, GET_MAC, &resp, sizeof resp);
+	memcpy(cmd.dgid, gid, sizeof cmd.dgid);
+	cmd.pd_handle = pd->handle;
+	cmd.port = port;
+
+	if (write(pd->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
+		return errno;
+
+	memcpy(mac, resp.mac, 6);
+
+	return 0;
+}
+
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 1827da0..1688e73 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -64,6 +64,7 @@ IBVERBS_1.0 {
 		ibv_cmd_destroy_ah;
 		ibv_cmd_attach_mcast;
 		ibv_cmd_detach_mcast;
+		ibv_cmd_get_mac;
 		ibv_copy_qp_attr_from_kern;
 		ibv_copy_path_rec_from_kern;
 		ibv_copy_path_rec_to_kern;
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
