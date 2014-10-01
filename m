From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 20/21] IB/iser: Fix/add kernel-doc style description in iscsi_iser.c
Date: Wed,  1 Oct 2014 14:02:16 +0300
Message-ID: <1412161337-25285-21-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch does not change any functionality

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  169 ++++++++++++++++++++++++++++--
 1 files changed, 160 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index decf696..8c04c2d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -102,9 +102,19 @@ MODULE_PARM_DESC(pi_guard, "T10-PI guard_type, 0:CRC|1:IP_CSUM (default:CRC)");
 static struct workqueue_struct *release_wq;
 struct iser_global ig;
 
+/*
+ * iscsi_iser_recv() - Process a successfull recv completion
+ * @conn:         iscsi connection
+ * @hdr:          iscsi header
+ * @rx_data:      buffer containing receive data payload
+ * @rx_data_len:  length of rx_data
+ *
+ * Notes: In case of data length errors or iscsi PDU completion failures
+ *        this routine will signal iscsi layer of connection failure.
+ */
 void
-iscsi_iser_recv(struct iscsi_conn *conn,
-		struct iscsi_hdr *hdr, char *rx_data, int rx_data_len)
+iscsi_iser_recv(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+		char *rx_data, int rx_data_len)
 {
 	int rc = 0;
 	int datalen;
@@ -135,12 +145,22 @@ error:
 	iscsi_conn_failure(conn, rc);
 }
 
-static int iscsi_iser_pdu_alloc(struct iscsi_task *task, uint8_t opcode)
+/**
+ * iscsi_iser_pdu_alloc() - allocate an iscsi-iser PDU
+ * @task:     iscsi task
+ * @opcode:   iscsi command opcode
+ *
+ * Netes: This routine can't fail, just assign iscsi task
+ *        hdr and max hdr size.
+ */
+static int
+iscsi_iser_pdu_alloc(struct iscsi_task *task, uint8_t opcode)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 
 	task->hdr = (struct iscsi_hdr *)&iser_task->desc.iscsi_header;
 	task->hdr_max = sizeof(iser_task->desc.iscsi_header);
+
 	return 0;
 }
 
@@ -165,11 +185,15 @@ int iser_initialize_task_headers(struct iscsi_task *task,
 	iser_task->iser_conn = iser_conn;
 	return 0;
 }
+
 /**
- * iscsi_iser_task_init - Initialize task
+ * iscsi_iser_task_init() - Initialize iscsi-iser task
  * @task: iscsi task
  *
  * Initialize the task for the scsi command or mgmt command.
+ *
+ * Return: Returns zero on success or -ENOMEM when failing
+ *         to init task headers (dma mapping error).
  */
 static int
 iscsi_iser_task_init(struct iscsi_task *task)
@@ -191,7 +215,7 @@ iscsi_iser_task_init(struct iscsi_task *task)
 }
 
 /**
- * iscsi_iser_mtask_xmit - xmit management(immediate) task
+ * iscsi_iser_mtask_xmit() - xmit management (immediate) task
  * @conn: iscsi connection
  * @task: task management task
  *
@@ -249,6 +273,12 @@ iscsi_iser_task_xmit_unsol_data_exit:
 	return error;
 }
 
+/**
+ * iscsi_iser_task_xmit() - xmit iscsi-iser task
+ * @task: iscsi task
+ *
+ * Return: zero on success or escalates $error on failure.
+ */
 static int
 iscsi_iser_task_xmit(struct iscsi_task *task)
 {
@@ -286,6 +316,14 @@ iscsi_iser_task_xmit(struct iscsi_task *task)
 	return error;
 }
 
+/**
+ * iscsi_iser_cleanup_task() - cleanup an iscsi-iser task
+ * @task: iscsi task
+ *
+ * Notes: In case the RDMA device is already NULL (might have
+ *        been removed in DEVICE_REMOVAL CM event it will bail-out
+ *        without doing dma unmapping.
+ */
 static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
@@ -310,7 +348,20 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 	}
 }
 
-static u8 iscsi_iser_check_protection(struct iscsi_task *task, sector_t *sector)
+/**
+ * iscsi_iser_check_protection() - check protection information status of task.
+ * @task:     iscsi task
+ * @sector:   error sector if exsists (output)
+ *
+ * Return: zero if no data-integrity errors have occured
+ *         0x1: data-integrity error occured in the guard-block
+ *         0x2: data-integrity error occured in the reference tag
+ *         0x3: data-integrity error occured in the application tag
+ *
+ *         In addition the error sector is marked.
+ */
+static u8
+iscsi_iser_check_protection(struct iscsi_task *task, sector_t *sector)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 
@@ -322,8 +373,17 @@ static u8 iscsi_iser_check_protection(struct iscsi_task *task, sector_t *sector)
 						 sector);
 }
 
+/**
+ * iscsi_iser_conn_create() - create a new iscsi-iser connection
+ * @cls_session: iscsi class connection
+ * @conn_idx:    connection index within the session (for MCS)
+ *
+ * Return: iscsi_cls_conn when iscsi_conn_setup succeeds or NULL
+ *         otherwise.
+ */
 static struct iscsi_cls_conn *
-iscsi_iser_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
+iscsi_iser_conn_create(struct iscsi_cls_session *cls_session,
+		       uint32_t conn_idx)
 {
 	struct iscsi_conn *conn;
 	struct iscsi_cls_conn *cls_conn;
@@ -342,9 +402,21 @@ iscsi_iser_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	return cls_conn;
 }
 
+/**
+ * iscsi_iser_conn_bind() - bind iscsi and iser connection structures
+ * @cls_session:     iscsi class session
+ * @cls_conn:        iscsi class connection
+ * @transport_eph:   transport end-point handle
+ * @is_leading:      indicate if this is the session leading connection (MCS)
+ *
+ * Return: zero on success, $error if iscsi_conn_bind fails and
+ *         -EINVAL in case end-point doesn't exsits anymore or iser connection
+ *         state is not UP (teardown already started).
+ */
 static int
 iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
-		     struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
+		     struct iscsi_cls_conn *cls_conn,
+		     uint64_t transport_eph,
 		     int is_leading)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
@@ -391,6 +463,14 @@ out:
 	return error;
 }
 
+/**
+ * iscsi_iser_conn_start() - start iscsi-iser connection
+ * @cls_conn: iscsi class connection
+ *
+ * Notes: Here iser intialize (or re-initialize) stop_completion as
+ *        from this point iscsi must call conn_stop in session/connection
+ *        teardown so iser transport must wait for it.
+ */
 static int
 iscsi_iser_conn_start(struct iscsi_cls_conn *cls_conn)
 {
@@ -404,6 +484,16 @@ iscsi_iser_conn_start(struct iscsi_cls_conn *cls_conn)
 	return iscsi_conn_start(cls_conn);
 }
 
+/**
+ * iscsi_iser_conn_stop() - stop iscsi-iser connection
+ * @cls_conn:  iscsi class connection
+ * @flag:      indicate if recover or terminate (passed as is)
+ *
+ * Notes: Calling iscsi_conn_stop might theoretically race with
+ *        DEVICE_REMOVAL event and dereference a previously freed RDMA device
+ *        handle, so we call it under iser the state lock to protect against
+ *        this kind of race.
+ */
 static void
 iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
@@ -432,7 +522,14 @@ iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	}
 }
 
-static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
+/**
+ * iscsi_iser_session_destroy() - destroy iscsi-iser session
+ * @cls_session: iscsi class session
+ *
+ * Removes and free iscsi host.
+ */
+static void
+iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 
@@ -452,6 +549,16 @@ iser_dif_prot_caps(int prot_caps)
 						      SHOST_DIX_TYPE3_PROTECTION : 0);
 }
 
+/**
+ * iscsi_iser_session_create() - create an iscsi-iser session
+ * @ep:             iscsi end-point handle
+ * @cmds_max:       maximum commands in this session
+ * @qdepth:         session command queue depth
+ * @initial_cmdsn:  initiator command sequnce number
+ *
+ * Allocates and adds a scsi host, expose DIF supprot if
+ * exists, and sets up an iscsi session.
+ */
 static struct iscsi_cls_session *
 iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			  uint16_t cmds_max, uint16_t qdepth,
@@ -564,6 +671,13 @@ iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
 	return 0;
 }
 
+/**
+ * iscsi_iser_set_param() - set class connection parameter
+ * @cls_conn:    iscsi class connection
+ * @stats:       iscsi stats to output
+ *
+ * Output connection statistics.
+ */
 static void
 iscsi_iser_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
 {
@@ -612,6 +726,21 @@ static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
 	return len;
 }
 
+/**
+ * iscsi_iser_ep_connect() - Initiate iSER connection establishment
+ * @shost:          scsi_host
+ * @dst_addr:       destination address
+ * @non-blocking:   indicate if routine can block
+ *
+ * Allocate an iscsi endpoint, an iser_conn structure and bind them.
+ * After that start RDMA connection establishment via rdma_cm. We
+ * don't allocate iser_conn embedded in iscsi_endpoint since in teardown
+ * the endpoint will be destroyed at ep_disconnect while iser_conn will
+ * cleanup its resources asynchronuously.
+ *
+ * Return: iscsi_endpoint created by iscsi layer or ERR_PTR(error)
+ *         if fails.
+ */
 static struct iscsi_endpoint *
 iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		      int non_blocking)
@@ -644,6 +773,19 @@ failure:
 	return ERR_PTR(err);
 }
 
+/**
+ * iscsi_iser_ep_poll() - poll for iser connection establishment to complete
+ * @ep:            iscsi endpoint (created at ep_connect)
+ * @timeout_ms:    polling timeout allowed in ms.
+ *
+ * This routine boils down to waiting for up_completion signaling
+ * that cma_id got CONNECTED event.
+ *
+ * Return: 1 if succeeded in connection establishment, 0 if timeout expired
+ *         (libiscsi will retry will kick in) or -1 if interrupted by signal
+ *         or more likely iser connection state transitioned to TEMINATING or
+ *         DOWN during the wait period.
+ */
 static int
 iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 {
@@ -672,6 +814,15 @@ iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 		return rc; /* signal */
 }
 
+/**
+ * iscsi_iser_ep_disconnect() - Initiate connection teardown process
+ * @ep:    iscsi endpoint handle
+ *
+ * This routine is not blocked by iser and RDMA termination process
+ * completion as we queue a deffered work for iser/RDMA destruction
+ * and cleanup or actually call it immediately in case we didn't pass
+ * iscsi conn bind/start stage, thus it is safe.
+ */
 static void
 iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
