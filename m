From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCHv2 libibcm] Return errors from the library consistently
Date: Tue, 20 Oct 2009 11:50:44 -0600
Message-ID: <20091020175044.GC14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove the return of -errno and always return codes via errno.
As documented in librdmacm, these libraries are already documented
to return -1 to indicate the code is in errno.

Also fix an errant return of 0 if the read/write syscalls return 0.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 src/cm.c |   89 +++++++++++++++++++++++++++++++++----------------------------
 1 files changed, 48 insertions(+), 41 deletions(-)

Same deal as before.. this is now aligned with POSIX conventions.

diff --git a/src/cm.c b/src/cm.c
index 7370abe..abc0863 100644
--- a/src/cm.c
+++ b/src/cm.c
@@ -67,6 +67,13 @@
 static int abi_ver;
 static pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
 
+static inline int ERR(int err)
+{
+	errno = err;
+	return -1;
+}
+
+
 #define CM_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size) \
 do {                                        \
 	struct cm_abi_cmd_hdr *hdr;         \
@@ -74,7 +81,7 @@ do {                                        \
 	size = sizeof(*hdr) + sizeof(*cmd); \
 	msg = alloca(size);                 \
 	if (!msg)                           \
-		return -ENOMEM;             \
+		return ERR(ENOMEM);         \
 	hdr = msg;                          \
 	cmd = msg + sizeof(*hdr);           \
 	hdr->cmd = type;                    \
@@ -83,7 +90,7 @@ do {                                        \
 	memset(cmd, 0, sizeof(*cmd));       \
 	resp = alloca(sizeof(*resp));       \
 	if (!resp)                          \
-		return -ENOMEM;             \
+		return ERR(ENOMEM);         \
 	cmd->response = (uintptr_t)resp;\
 } while (0)
 
@@ -94,7 +101,7 @@ do {                                        \
 	size = sizeof(*hdr) + sizeof(*cmd); \
 	msg = alloca(size);                 \
 	if (!msg)                           \
-		return -ENOMEM;             \
+		return ERR(ENOMEM);         \
 	hdr = msg;                          \
 	cmd = msg + sizeof(*hdr);           \
 	hdr->cmd = type;                    \
@@ -228,7 +235,7 @@ int ib_cm_create_id(struct ib_cm_device *device,
 
 	cm_id_priv = ib_cm_alloc_id(device, context);
 	if (!cm_id_priv)
-		return -ENOMEM;
+		return ERR(ENOMEM);
 
 	CM_CREATE_MSG_CMD_RESP(msg, cmd, resp, IB_USER_CM_CMD_CREATE_ID, size);
 	cmd->uid = (uintptr_t) cm_id_priv;
@@ -261,7 +268,7 @@ int ib_cm_destroy_id(struct ib_cm_id *cm_id)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
@@ -285,14 +292,14 @@ int ib_cm_attr_id(struct ib_cm_id *cm_id, struct ib_cm_attr_param *param)
 	int size;
 
 	if (!param)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	CM_CREATE_MSG_CMD_RESP(msg, cmd, resp, IB_USER_CM_CMD_ATTR_ID, size);
 	cmd->id = cm_id->handle;
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
@@ -314,7 +321,7 @@ int ib_cm_init_qp_attr(struct ib_cm_id *cm_id,
 	int size;
 
 	if (!qp_attr || !qp_attr_mask)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	CM_CREATE_MSG_CMD_RESP(msg, cmd, resp, IB_USER_CM_CMD_INIT_QP_ATTR, size);
 	cmd->id = cm_id->handle;
@@ -322,7 +329,7 @@ int ib_cm_init_qp_attr(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
@@ -348,7 +355,7 @@ int ib_cm_listen(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -363,7 +370,7 @@ int ib_cm_send_req(struct ib_cm_id *cm_id, struct ib_cm_req_param *param)
 	int size;
 
 	if (!param)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	CM_CREATE_MSG_CMD(msg, cmd, IB_USER_CM_CMD_SEND_REQ, size);
 	cmd->id				= cm_id->handle;
@@ -385,7 +392,7 @@ int ib_cm_send_req(struct ib_cm_id *cm_id, struct ib_cm_req_param *param)
 	if (param->primary_path) {
 		p_path = alloca(sizeof(*p_path));
 		if (!p_path)
-			return -ENOMEM;
+			return ERR(ENOMEM);
 
 		ibv_copy_path_rec_to_kern(p_path, param->primary_path);
 		cmd->primary_path = (uintptr_t) p_path;
@@ -394,7 +401,7 @@ int ib_cm_send_req(struct ib_cm_id *cm_id, struct ib_cm_req_param *param)
 	if (param->alternate_path) {
 		a_path = alloca(sizeof(*a_path));
 		if (!a_path)
-			return -ENOMEM;
+			return ERR(ENOMEM);
 
 		ibv_copy_path_rec_to_kern(a_path, param->alternate_path);
 		cmd->alternate_path = (uintptr_t) a_path;
@@ -407,7 +414,7 @@ int ib_cm_send_req(struct ib_cm_id *cm_id, struct ib_cm_req_param *param)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -420,7 +427,7 @@ int ib_cm_send_rep(struct ib_cm_id *cm_id, struct ib_cm_rep_param *param)
 	int size;
 
 	if (!param)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	CM_CREATE_MSG_CMD(msg, cmd, IB_USER_CM_CMD_SEND_REP, size);
 	cmd->uid = (uintptr_t) container_of(cm_id, struct cm_id_private, id);
@@ -442,7 +449,7 @@ int ib_cm_send_rep(struct ib_cm_id *cm_id, struct ib_cm_rep_param *param)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -467,7 +474,7 @@ static inline int cm_send_private_data(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -508,7 +515,7 @@ static int cm_establish(struct ib_cm_id *cm_id)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -524,7 +531,7 @@ int ib_cm_notify(struct ib_cm_id *cm_id, enum ibv_event_type event)
 		if (event == IBV_EVENT_COMM_EST)
 			return cm_establish(cm_id);
 		else
-			return -EINVAL;
+			return ERR(EINVAL);
 	}
 
 	CM_CREATE_MSG_CMD(msg, cmd, IB_USER_CM_CMD_NOTIFY, size);
@@ -533,7 +540,7 @@ int ib_cm_notify(struct ib_cm_id *cm_id, enum ibv_event_type event)
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -567,7 +574,7 @@ static inline int cm_send_status(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -617,7 +624,7 @@ int ib_cm_send_mra(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -639,7 +646,7 @@ int ib_cm_send_lap(struct ib_cm_id *cm_id,
 	if (alternate_path) {
 		abi_path = alloca(sizeof(*abi_path));
 		if (!abi_path)
-			return -ENOMEM;
+			return ERR(ENOMEM);
 
 		ibv_copy_path_rec_to_kern(abi_path, alternate_path);
 		cmd->path = (uintptr_t) abi_path;
@@ -652,7 +659,7 @@ int ib_cm_send_lap(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -667,7 +674,7 @@ int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 	int size;
 
 	if (!param)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	CM_CREATE_MSG_CMD(msg, cmd, IB_USER_CM_CMD_SEND_SIDR_REQ, size);
 	cmd->id             = cm_id->handle;
@@ -679,7 +686,7 @@ int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 	if (param->path) {
 		abi_path = alloca(sizeof(*abi_path));
 		if (!abi_path)
-			return -ENOMEM;
+			return ERR(ENOMEM);
 
 		ibv_copy_path_rec_to_kern(abi_path, param->path);
 		cmd->path = (uintptr_t) abi_path;
@@ -692,7 +699,7 @@ int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -706,7 +713,7 @@ int ib_cm_send_sidr_rep(struct ib_cm_id *cm_id,
 	int size;
 
 	if (!param)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	CM_CREATE_MSG_CMD(msg, cmd, IB_USER_CM_CMD_SEND_SIDR_REP, size);
 	cmd->id     = cm_id->handle;
@@ -726,7 +733,7 @@ int ib_cm_send_sidr_rep(struct ib_cm_id *cm_id,
 
 	result = write(cm_id->device->fd, msg, size);
 	if (result != size)
-		return (result > 0) ? -ENODATA : result;
+		return (result >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -795,12 +802,12 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 	int size;
 	
 	if (!event)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	size = sizeof(*hdr) + sizeof(*cmd);
 	msg = alloca(size);
 	if (!msg)
-		return -ENOMEM;
+		return ERR(ENOMEM);
 
 	hdr = msg;
 	cmd = msg + sizeof(*hdr);
@@ -813,7 +820,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 
 	resp = alloca(sizeof(*resp));
 	if (!resp)
-		return -ENOMEM;
+		return ERR(ENOMEM);
 	
 	cmd->response = (uintptr_t) resp;
 	cmd->data_len = (uint8_t)(~0U);
@@ -821,13 +828,13 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 
 	data = malloc(cmd->data_len);
 	if (!data) {
-		result = -ENOMEM;
+		result = ERR(ENOMEM);
 		goto done;
 	}
 
 	info = malloc(cmd->info_len);
 	if (!info) {
-		result = -ENOMEM;
+		result = ERR(ENOMEM);
 		goto done;
 	}
 
@@ -836,7 +843,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 
 	result = write(device->fd, msg, size);
 	if (result != size) {
-		result = (result > 0) ? -ENODATA : result;
+		result = (result >= 0) ? ERR(ENODATA) : -1;
 		goto done;
 	}
 
@@ -847,7 +854,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 	 */
 	evt = malloc(sizeof(*evt));
 	if (!evt) {
-		result = -ENOMEM;
+		result = ERR(ENOMEM);
 		goto done;
 	}
 	memset(evt, 0, sizeof(*evt));
@@ -857,7 +864,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 	if (resp->present & CM_ABI_PRES_PRIMARY) {
 		path_a = malloc(sizeof(*path_a));
 		if (!path_a) {
-			result = -ENOMEM;
+			result = ERR(ENOMEM);
 			goto done;
 		}
 	}
@@ -865,7 +872,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 	if (resp->present & CM_ABI_PRES_ALTERNATE) {
 		path_b = malloc(sizeof(*path_b));
 		if (!path_b) {
-			result = -ENOMEM;
+			result = ERR(ENOMEM);
 			goto done;
 		}
 	}
@@ -876,7 +883,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 		cm_id_priv = ib_cm_alloc_id(evt->cm_id->device,
 					    evt->cm_id->context);
 		if (!cm_id_priv) {
-			result = -ENOMEM;
+			result = ERR(ENOMEM);
 			goto done;
 		}
 		cm_id_priv->id.handle = resp->id;
@@ -914,7 +921,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 		cm_id_priv = ib_cm_alloc_id(evt->cm_id->device,
 					    evt->cm_id->context);
 		if (!cm_id_priv) {
-			result = -ENOMEM;
+			result = ERR(ENOMEM);
 			goto done;
 		}
 		cm_id_priv->id.handle = resp->id;
@@ -961,7 +968,7 @@ int ib_cm_ack_event(struct ib_cm_event *event)
 	struct cm_id_private *cm_id_priv;
 
 	if (!event)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	if (event->private_data)
 		free(event->private_data);
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
