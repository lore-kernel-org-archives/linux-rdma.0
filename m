From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/4] ibcm: Replace infiniband/cm_abi.h with the kernel's uapi/rdma/ib_user_cm.h
Date: Thu, 27 Oct 2016 17:06:10 -0600
Message-ID: <1477609570-8087-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1477609570-8087-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477609570-8087-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Using the system header from the kernel is now the expected way to export
definitions to user space.

Unfortunately this was exposed as a public installed header, for
now drop in a compat header with a #warning not to use it. Some
day we can delete it.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibcm/cm.c     |  70 ++++++-----
 libibcm/cm_abi.h | 351 +++++++------------------------------------------------
 2 files changed, 83 insertions(+), 338 deletions(-)

diff --git a/libibcm/cm.c b/libibcm/cm.c
index 5bc521be5e3a..433d6e88f8ac 100644
--- a/libibcm/cm.c
+++ b/libibcm/cm.c
@@ -45,7 +45,7 @@
 #include <stddef.h>
 
 #include <infiniband/cm.h>
-#include <infiniband/cm_abi.h>
+#include <rdma/ib_user_cm.h>
 #include <infiniband/driver.h>
 #include <infiniband/marshall.h>
 
@@ -53,6 +53,9 @@
 
 #define PFX "libibcm: "
 
+#define IB_USER_CM_MIN_ABI_VERSION     4
+#define IB_USER_CM_MAX_ABI_VERSION     5
+
 static int abi_ver;
 static pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
 
@@ -69,7 +72,7 @@ static inline int ERR(int err)
 
 #define CM_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size) \
 do {                                        \
-	struct cm_abi_cmd_hdr *hdr;         \
+	struct ib_ucm_cmd_hdr *hdr;         \
                                             \
 	size = sizeof(*hdr) + sizeof(*cmd); \
 	msg = alloca(size);                 \
@@ -89,7 +92,7 @@ do {                                        \
 
 #define CM_CREATE_MSG_CMD(msg, cmd, type, size) \
 do {                                        \
-	struct cm_abi_cmd_hdr *hdr;         \
+	struct ib_ucm_cmd_hdr *hdr;         \
                                             \
 	size = sizeof(*hdr) + sizeof(*cmd); \
 	msg = alloca(size);                 \
@@ -244,8 +247,8 @@ err:	ib_cm_free_id(cm_id_priv);
 int ib_cm_create_id(struct ib_cm_device *device,
 		    struct ib_cm_id **cm_id, void *context)
 {
-	struct cm_abi_create_id_resp *resp;
-	struct cm_abi_create_id *cmd;
+	struct ib_ucm_create_id_resp *resp;
+	struct ib_ucm_create_id *cmd;
 	struct cm_id_private *cm_id_priv;
 	void *msg;
 	int result;
@@ -274,8 +277,8 @@ err:	ib_cm_free_id(cm_id_priv);
 
 int ib_cm_destroy_id(struct ib_cm_id *cm_id)
 {
-	struct cm_abi_destroy_id_resp *resp;
-	struct cm_abi_destroy_id *cmd;
+	struct ib_ucm_destroy_id_resp *resp;
+	struct ib_ucm_destroy_id *cmd;
 	struct cm_id_private *cm_id_priv;
 	void *msg;
 	int result;
@@ -303,8 +306,8 @@ int ib_cm_destroy_id(struct ib_cm_id *cm_id)
 
 int ib_cm_attr_id(struct ib_cm_id *cm_id, struct ib_cm_attr_param *param)
 {
-	struct cm_abi_attr_id_resp *resp;
-	struct cm_abi_attr_id *cmd;
+	struct ib_ucm_attr_id_resp *resp;
+	struct ib_ucm_attr_id *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -333,7 +336,7 @@ int ib_cm_init_qp_attr(struct ib_cm_id *cm_id,
 		       int *qp_attr_mask)
 {
 	struct ibv_kern_qp_attr *resp;
-	struct cm_abi_init_qp_attr *cmd;
+	struct ib_ucm_init_qp_attr *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -361,7 +364,7 @@ int ib_cm_listen(struct ib_cm_id *cm_id,
 		 uint64_t service_id,
 		 uint64_t service_mask)
 {
-	struct cm_abi_listen *cmd;
+	struct ib_ucm_listen *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -382,7 +385,7 @@ int ib_cm_send_req(struct ib_cm_id *cm_id, struct ib_cm_req_param *param)
 {
 	struct ib_user_path_rec p_path;
 	struct ib_user_path_rec *a_path;
-	struct cm_abi_req *cmd;
+	struct ib_ucm_req *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -433,7 +436,7 @@ int ib_cm_send_req(struct ib_cm_id *cm_id, struct ib_cm_req_param *param)
 
 int ib_cm_send_rep(struct ib_cm_id *cm_id, struct ib_cm_rep_param *param)
 {
-	struct cm_abi_rep *cmd;
+	struct ib_ucm_rep *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -471,7 +474,7 @@ static inline int cm_send_private_data(struct ib_cm_id *cm_id,
 				       void *private_data,
 				       uint8_t private_data_len)
 {
-	struct cm_abi_private_data *cmd;
+	struct ib_ucm_private_data *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -517,6 +520,14 @@ int ib_cm_send_drep(struct ib_cm_id *cm_id,
 
 static int cm_establish(struct ib_cm_id *cm_id)
 {
+	/* In kernel ABI 4 ESTABLISH was repurposed as NOTIFY and gained an
+	   extra field. For some reason the compat definitions were deleted
+	   from the uapi headers :( */
+#define IB_USER_CM_CMD_ESTABLISH IB_USER_CM_CMD_NOTIFY
+	struct cm_abi_establish { /* ABI 4 support */
+		__u32 id;
+	};
+
 	struct cm_abi_establish *cmd;
 	void *msg;
 	int result;
@@ -534,7 +545,7 @@ static int cm_establish(struct ib_cm_id *cm_id)
 
 int ib_cm_notify(struct ib_cm_id *cm_id, enum ibv_event_type event)
 {
-	struct cm_abi_notify *cmd;
+	struct ib_ucm_notify *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -565,7 +576,7 @@ static inline int cm_send_status(struct ib_cm_id *cm_id,
 				 void *private_data,
 				 uint8_t private_data_len)
 {
-	struct cm_abi_info *cmd;
+	struct ib_ucm_info *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -620,7 +631,7 @@ int ib_cm_send_mra(struct ib_cm_id *cm_id,
 		   void *private_data,
 		   uint8_t private_data_len)
 {
-	struct cm_abi_mra *cmd;
+	struct ib_ucm_mra *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -647,7 +658,7 @@ int ib_cm_send_lap(struct ib_cm_id *cm_id,
 		   uint8_t private_data_len)
 {
 	struct ib_user_path_rec abi_path;
-	struct cm_abi_lap *cmd;
+	struct ib_ucm_lap *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -674,7 +685,7 @@ int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 			struct ib_cm_sidr_req_param *param)
 {
 	struct ib_user_path_rec abi_path;
-	struct cm_abi_sidr_req *cmd;
+	struct ib_ucm_sidr_req *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -686,7 +697,6 @@ int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 	cmd->id             = cm_id->handle;
 	cmd->sid            = param->service_id;
 	cmd->timeout        = param->timeout_ms;
-	cmd->pkey           = param->path->pkey;
 	cmd->max_cm_retries = param->max_cm_retries;
 
 	ibv_copy_path_rec_to_kern(&abi_path, param->path);
@@ -707,7 +717,7 @@ int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 int ib_cm_send_sidr_rep(struct ib_cm_id *cm_id,
 			struct ib_cm_sidr_rep_param *param)
 {
-	struct cm_abi_sidr_rep *cmd;
+	struct ib_ucm_sidr_rep *cmd;
 	void *msg;
 	int result;
 	int size;
@@ -739,7 +749,7 @@ int ib_cm_send_sidr_rep(struct ib_cm_id *cm_id,
 }
 
 static void cm_event_req_get(struct ib_cm_req_event_param *ureq,
-			     struct cm_abi_req_event_resp *kreq)
+			     struct ib_ucm_req_event_resp *kreq)
 {
 	ureq->remote_ca_guid             = kreq->remote_ca_guid;
 	ureq->remote_qkey                = kreq->remote_qkey;
@@ -763,7 +773,7 @@ static void cm_event_req_get(struct ib_cm_req_event_param *ureq,
 }
 
 static void cm_event_rep_get(struct ib_cm_rep_event_param *urep,
-			     struct cm_abi_rep_event_resp *krep)
+			     struct ib_ucm_rep_event_resp *krep)
 {
 	urep->remote_ca_guid      = krep->remote_ca_guid;
 	urep->remote_qkey         = krep->remote_qkey;
@@ -779,7 +789,7 @@ static void cm_event_rep_get(struct ib_cm_rep_event_param *urep,
 }
 
 static void cm_event_sidr_rep_get(struct ib_cm_sidr_rep_event_param *urep,
-				  struct cm_abi_sidr_rep_event_resp *krep)
+				  struct ib_ucm_sidr_rep_event_resp *krep)
 {
 	urep->status = krep->status;
 	urep->qkey   = krep->qkey;
@@ -789,9 +799,9 @@ static void cm_event_sidr_rep_get(struct ib_cm_sidr_rep_event_param *urep,
 int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 {
 	struct cm_id_private *cm_id_priv;
-	struct cm_abi_cmd_hdr *hdr;
-	struct cm_abi_event_get *cmd;
-	struct cm_abi_event_resp *resp;
+	struct ib_ucm_cmd_hdr *hdr;
+	struct ib_ucm_event_get *cmd;
+	struct ib_ucm_event_resp *resp;
 	struct ib_cm_event *evt = NULL;
 	struct ibv_sa_path_rec *path_a = NULL;
 	struct ibv_sa_path_rec *path_b = NULL;
@@ -861,7 +871,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 	evt->cm_id = (void *) (uintptr_t) resp->uid;
 	evt->event = resp->event;
 
-	if (resp->present & CM_ABI_PRES_PRIMARY) {
+	if (resp->present & IB_UCM_PRES_PRIMARY) {
 		path_a = malloc(sizeof(*path_a));
 		if (!path_a) {
 			result = ERR(ENOMEM);
@@ -869,7 +879,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 		}
 	}
 
-	if (resp->present & CM_ABI_PRES_ALTERNATE) {
+	if (resp->present & IB_UCM_PRES_ALTERNATE) {
 		path_b = malloc(sizeof(*path_b));
 		if (!path_b) {
 			result = ERR(ENOMEM);
@@ -940,7 +950,7 @@ int ib_cm_get_event(struct ib_cm_device *device, struct ib_cm_event **event)
 		break;
 	}
 
-	if (resp->present & CM_ABI_PRES_DATA) {
+	if (resp->present & IB_UCM_PRES_DATA) {
 		evt->private_data = data;
 		data = NULL;
 	}
diff --git a/libibcm/cm_abi.h b/libibcm/cm_abi.h
index 8fd10dd56150..8b76dc1fba78 100644
--- a/libibcm/cm_abi.h
+++ b/libibcm/cm_abi.h
@@ -1,7 +1,4 @@
 /*
- * Copyright (c) 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Intel Corporation.  All rights reserved.
- *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
  * General Public License (GPL) Version 2, available from the file
@@ -29,310 +26,48 @@
  * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
- *
- * $Id$
- */
-
-#ifndef CM_ABI_H
-#define CM_ABI_H
-
-#include <linux/types.h>
-#include <infiniband/sa.h>
-#include <infiniband/marshall.h>
-
-/*
- * This file must be kept in sync with the kernel's version of ib_user_cm.h
  */
 
-#define IB_USER_CM_MIN_ABI_VERSION	4
-#define IB_USER_CM_MAX_ABI_VERSION	5
-
-enum {
-	IB_USER_CM_CMD_CREATE_ID,
-	IB_USER_CM_CMD_DESTROY_ID,
-	IB_USER_CM_CMD_ATTR_ID,
-
-	IB_USER_CM_CMD_LISTEN,
-	IB_USER_CM_CMD_NOTIFY,
-	IB_USER_CM_CMD_ESTABLISH = IB_USER_CM_CMD_NOTIFY, /* ABI 4 support */
-	
-	IB_USER_CM_CMD_SEND_REQ,
-	IB_USER_CM_CMD_SEND_REP,
-	IB_USER_CM_CMD_SEND_RTU,
-	IB_USER_CM_CMD_SEND_DREQ,
-	IB_USER_CM_CMD_SEND_DREP,
-	IB_USER_CM_CMD_SEND_REJ,
-	IB_USER_CM_CMD_SEND_MRA,
-	IB_USER_CM_CMD_SEND_LAP,
-	IB_USER_CM_CMD_SEND_APR,
-	IB_USER_CM_CMD_SEND_SIDR_REQ,
-	IB_USER_CM_CMD_SEND_SIDR_REP,
-
-	IB_USER_CM_CMD_EVENT,
-	IB_USER_CM_CMD_INIT_QP_ATTR,
-};
-/*
- * command ABI structures.
- */
-struct cm_abi_cmd_hdr {
-	__u32 cmd;
-	__u16 in;
-	__u16 out;
-};
-
-struct cm_abi_create_id {
-	__u64 uid;
-	__u64 response;
-};
-
-struct cm_abi_create_id_resp {
-	__u32 id;
-};
-
-struct cm_abi_destroy_id {
-	__u64 response;
-	__u32 id;
-	__u32 reserved;
-};
-
-struct cm_abi_destroy_id_resp {
-	__u32 events_reported;
-};
-
-struct cm_abi_attr_id {
-	__u64 response;
-	__u32 id;
-	__u32 reserved;
-};
-
-struct cm_abi_attr_id_resp {
-	__u64 service_id;
-	__u64 service_mask;
-	__u32 local_id;
-	__u32 remote_id;
-};
-
-struct cm_abi_init_qp_attr {
-	__u64 response;
-	__u32 id;
-	__u32 qp_state;
-};
-
-struct cm_abi_listen {
-	__u64 service_id;
-	__u64 service_mask;
-	__u32 id;
-	__u32 reserved;
-};
-
-struct cm_abi_establish {	/* ABI 4 support */
-	__u32 id;
-};
-
-struct cm_abi_notify {
-	__u32 id;
-	__u32 event;
-};
-
-struct cm_abi_private_data {
-	__u64 data;
-	__u32 id;
-	__u8  len;
-	__u8  reserved[3];
-};
-
-struct cm_abi_req {
-	__u32 id;
-	__u32 qpn;
-	__u32 qp_type;
-	__u32 psn;
-	__u64 sid;
-	__u64 data;
-	__u64 primary_path;
-	__u64 alternate_path;
-	__u8  len;
-	__u8  peer_to_peer;
-	__u8  responder_resources;
-	__u8  initiator_depth;
-	__u8  remote_cm_response_timeout;
-	__u8  flow_control;
-	__u8  local_cm_response_timeout;
-	__u8  retry_count;
-	__u8  rnr_retry_count;
-	__u8  max_cm_retries;
-	__u8  srq;
-	__u8  reserved[5];
-};
-
-struct cm_abi_rep {
-	__u64 uid;
-	__u64 data;
-	__u32 id;
-	__u32 qpn;
-	__u32 psn;
-	__u8  len;
-	__u8  responder_resources;
-	__u8  initiator_depth;
-	__u8  target_ack_delay;
-	__u8  failover_accepted;
-	__u8  flow_control;
-	__u8  rnr_retry_count;
-	__u8  srq;
-	__u8  reserved[4];
-};
-
-struct cm_abi_info {
-	__u32 id;
-	__u32 status;
-	__u64 info;
-	__u64 data;
-	__u8  info_len;
-	__u8  data_len;
-	__u8  reserved[6];
-};
-
-struct cm_abi_mra {
-	__u64 data;
-	__u32 id;
-	__u8  len;
-	__u8  timeout;
-	__u8  reserved[2];
-};
-
-struct cm_abi_lap {
-	__u64 path;
-	__u64 data;
-	__u32 id;
-	__u8  len;
-	__u8  reserved[3];
-};
-
-struct cm_abi_sidr_req {
-	__u32 id;
-	__u32 timeout;
-	__u64 sid;
-	__u64 data;
-	__u64 path;
-	__u16 pkey;
-	__u8  len;
-	__u8  max_cm_retries;
-	__u8  reserved[4];
-};
-
-struct cm_abi_sidr_rep {
-	__u32 id;
-	__u32 qpn;
-	__u32 qkey;
-	__u32 status;
-	__u64 info;
-	__u64 data;
-	__u8  info_len;
-	__u8  data_len;
-	__u8  reserved[6];
-};
-/*
- * event notification ABI structures.
- */
-struct cm_abi_event_get {
-	__u64 response;
-	__u64 data;
-	__u64 info;
-	__u8  data_len;
-	__u8  info_len;
-	__u8  reserved[6];
-};
-
-struct cm_abi_req_event_resp {
-	struct ibv_kern_path_rec primary_path;
-	struct ibv_kern_path_rec alternate_path;
-	__u64                  remote_ca_guid;
-	__u32                  remote_qkey;
-	__u32                  remote_qpn;
-	__u32                  qp_type;
-	__u32                  starting_psn;
-	__u8  responder_resources;
-	__u8  initiator_depth;
-	__u8  local_cm_response_timeout;
-	__u8  flow_control;
-	__u8  remote_cm_response_timeout;
-	__u8  retry_count;
-	__u8  rnr_retry_count;
-	__u8  srq;
-	__u8  port;
-	__u8  reserved[7];
-};
-
-struct cm_abi_rep_event_resp {
-	__u64 remote_ca_guid;
-	__u32 remote_qkey;
-	__u32 remote_qpn;
-	__u32 starting_psn;
-	__u8  responder_resources;
-	__u8  initiator_depth;
-	__u8  target_ack_delay;
-	__u8  failover_accepted;
-	__u8  flow_control;
-	__u8  rnr_retry_count;
-	__u8  srq;
-	__u8  reserved[5];
-};
-
-struct cm_abi_rej_event_resp {
-	__u32 reason;
-	/* ari in cm_abi_event_get info field. */
-};
-
-struct cm_abi_mra_event_resp {
-	__u8  timeout;
-	__u8  reserved[3];
-};
-
-struct cm_abi_lap_event_resp {
-	struct ibv_kern_path_rec path;
-};
-
-struct cm_abi_apr_event_resp {
-	__u32 status;
-	/* apr info in cm_abi_event_get info field. */
-};
-
-struct cm_abi_sidr_req_event_resp {
-	__u16 pkey;
-	__u8  port;
-	__u8  reserved;
-};
-
-struct cm_abi_sidr_rep_event_resp {
-	__u32 status;
-	__u32 qkey;
-	__u32 qpn;
-	/* info in cm_abi_event_get info field. */
-};
-
-#define CM_ABI_PRES_DATA      0x01
-#define CM_ABI_PRES_INFO      0x02
-#define CM_ABI_PRES_PRIMARY   0x04
-#define CM_ABI_PRES_ALTERNATE 0x08
-
-struct cm_abi_event_resp {
-	__u64 uid;
-	__u32 id;
-	__u32 event;
-	__u32 present;
-	__u32 reserved;
-	union {
-		struct cm_abi_req_event_resp req_resp;
-		struct cm_abi_rep_event_resp rep_resp;
-		struct cm_abi_rej_event_resp rej_resp;
-		struct cm_abi_mra_event_resp mra_resp;
-		struct cm_abi_lap_event_resp lap_resp;
-		struct cm_abi_apr_event_resp apr_resp;
-
-		struct cm_abi_sidr_req_event_resp sidr_req_resp;
-		struct cm_abi_sidr_rep_event_resp sidr_rep_resp;
-
-		__u32                             send_status;
-	} u;
-};
-
-#endif /* CM_ABI_H */
+#ifndef INFINIBAND_CM_ABI_H
+#define INFINIBAND_CM_ABI_H
+
+#warning "This header is obsolete, use rdma/ib_user_cm.h instead"
+
+#include <rdma/ib_user_cm.h>
+
+#define cm_abi_cmd_hdr ib_ucm_cmd_hdr
+#define cm_abi_create_id ib_ucm_create_id
+#define cm_abi_create_id_resp ib_ucm_create_id_resp
+#define cm_abi_destroy_id ib_ucm_destroy_id
+#define cm_abi_destroy_id_resp ib_ucm_destroy_id_resp
+#define cm_abi_attr_id ib_ucm_attr_id
+#define cm_abi_attr_id_resp ib_ucm_attr_id_resp
+#define cm_abi_init_qp_attr ib_ucm_init_qp_attr
+#define cm_abi_listen ib_ucm_listen
+#define cm_abi_establish ib_ucm_establish
+#define cm_abi_notify ib_ucm_notify
+#define cm_abi_private_data ib_ucm_private_data
+#define cm_abi_req ib_ucm_req
+#define cm_abi_rep ib_ucm_rep
+#define cm_abi_info ib_ucm_info
+#define cm_abi_mra ib_ucm_mra
+#define cm_abi_lap ib_ucm_lap
+#define cm_abi_sidr_req ib_ucm_sidr_req
+#define cm_abi_sidr_rep ib_ucm_sidr_rep
+#define cm_abi_event_get ib_ucm_event_get
+#define cm_abi_req_event_resp ib_ucm_req_event_resp
+#define cm_abi_rep_event_resp ib_ucm_rep_event_resp
+#define cm_abi_rej_event_resp ib_ucm_rej_event_resp
+#define cm_abi_mra_event_resp ib_ucm_mra_event_resp
+#define cm_abi_lap_event_resp ib_ucm_lap_event_resp
+#define cm_abi_apr_event_resp ib_ucm_apr_event_resp
+#define cm_abi_sidr_req_event_resp ib_ucm_sidr_req_event_resp
+#define cm_abi_sidr_rep_event_resp ib_ucm_sidr_rep_event_resp
+#define cm_abi_event_resp ib_ucm_event_resp
+
+#define CM_ABI_PRES_DATA IB_UCM_PRES_DATA
+#define CM_ABI_PRES_INFO IB_UCM_PRES_INFO
+#define CM_ABI_PRES_PRIMARY IB_UCM_PRES_PRIMARY
+#define CM_ABI_PRES_ALTERNATE IB_UCM_PRES_ALTERNATE
+
+#endif
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
