From: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/srpt: Convert use of __constant_cpu_to_beXX to cpu_to_beXX
Date: Tue, 23 Jun 2015 10:11:53 +0530
Message-ID: <20150623044153.GA21400@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In little endian cases, the macro cpu_to_be{16,32,64} unfolds to
__swab{16,32,64} which provides special case for constants. In
big endian cases, __constant_cpu_to_be{16,32,64} and
cpu_to_be{16,32,64} expand directly to the same expression. So,
replace __constant_cpu_to_be{16,32,64} with cpu_to_be{16,32,64}
with the goal of getting rid of the definitions of
__constant_cpu_to_be{16,32,64} completely.

The Coccinelle semantic patch that performs this transformation
is as follows:

@@expression x;@@

(
- __constant_cpu_to_be16(x)
+ cpu_to_be16(x)
|
- __constant_cpu_to_be32(x)
+ cpu_to_be32(x)
|
- __constant_cpu_to_be64(x)
+ cpu_to_be64(x)
)

Signed-off-by: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 61 ++++++++++++++---------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9b84b4c..e673cc2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -303,7 +303,7 @@ static void srpt_get_iou(struct ib_dm_mad *mad)
 	int i;
 
 	ioui = (struct ib_dm_iou_info *)mad->data;
-	ioui->change_id = __constant_cpu_to_be16(1);
+	ioui->change_id = cpu_to_be16(1);
 	ioui->max_controllers = 16;
 
 	/* set present for slot 1 and empty for the rest */
@@ -331,13 +331,13 @@ static void srpt_get_ioc(struct srpt_port *sport, u32 slot,
 
 	if (!slot || slot > 16) {
 		mad->mad_hdr.status
-			= __constant_cpu_to_be16(DM_MAD_STATUS_INVALID_FIELD);
+			= cpu_to_be16(DM_MAD_STATUS_INVALID_FIELD);
 		return;
 	}
 
 	if (slot > 2) {
 		mad->mad_hdr.status
-			= __constant_cpu_to_be16(DM_MAD_STATUS_NO_IOC);
+			= cpu_to_be16(DM_MAD_STATUS_NO_IOC);
 		return;
 	}
 
@@ -349,10 +349,10 @@ static void srpt_get_ioc(struct srpt_port *sport, u32 slot,
 	iocp->device_version = cpu_to_be16(sdev->dev_attr.hw_ver);
 	iocp->subsys_vendor_id = cpu_to_be32(sdev->dev_attr.vendor_id);
 	iocp->subsys_device_id = 0x0;
-	iocp->io_class = __constant_cpu_to_be16(SRP_REV16A_IB_IO_CLASS);
-	iocp->io_subclass = __constant_cpu_to_be16(SRP_IO_SUBCLASS);
-	iocp->protocol = __constant_cpu_to_be16(SRP_PROTOCOL);
-	iocp->protocol_version = __constant_cpu_to_be16(SRP_PROTOCOL_VERSION);
+	iocp->io_class = cpu_to_be16(SRP_REV16A_IB_IO_CLASS);
+	iocp->io_subclass = cpu_to_be16(SRP_IO_SUBCLASS);
+	iocp->protocol = cpu_to_be16(SRP_PROTOCOL);
+	iocp->protocol_version = cpu_to_be16(SRP_PROTOCOL_VERSION);
 	iocp->send_queue_depth = cpu_to_be16(sdev->srq_size);
 	iocp->rdma_read_depth = 4;
 	iocp->send_size = cpu_to_be32(srp_max_req_size);
@@ -380,13 +380,13 @@ static void srpt_get_svc_entries(u64 ioc_guid,
 
 	if (!slot || slot > 16) {
 		mad->mad_hdr.status
-			= __constant_cpu_to_be16(DM_MAD_STATUS_INVALID_FIELD);
+			= cpu_to_be16(DM_MAD_STATUS_INVALID_FIELD);
 		return;
 	}
 
 	if (slot > 2 || lo > hi || hi > 1) {
 		mad->mad_hdr.status
-			= __constant_cpu_to_be16(DM_MAD_STATUS_NO_IOC);
+			= cpu_to_be16(DM_MAD_STATUS_NO_IOC);
 		return;
 	}
 
@@ -437,7 +437,7 @@ static void srpt_mgmt_method_get(struct srpt_port *sp, struct ib_mad *rq_mad,
 		break;
 	default:
 		rsp_mad->mad_hdr.status =
-		    __constant_cpu_to_be16(DM_MAD_STATUS_UNSUP_METHOD_ATTR);
+		    cpu_to_be16(DM_MAD_STATUS_UNSUP_METHOD_ATTR);
 		break;
 	}
 }
@@ -493,11 +493,11 @@ static void srpt_mad_recv_handler(struct ib_mad_agent *mad_agent,
 		break;
 	case IB_MGMT_METHOD_SET:
 		dm_mad->mad_hdr.status =
-		    __constant_cpu_to_be16(DM_MAD_STATUS_UNSUP_METHOD_ATTR);
+		    cpu_to_be16(DM_MAD_STATUS_UNSUP_METHOD_ATTR);
 		break;
 	default:
 		dm_mad->mad_hdr.status =
-		    __constant_cpu_to_be16(DM_MAD_STATUS_UNSUP_METHOD);
+		    cpu_to_be16(DM_MAD_STATUS_UNSUP_METHOD);
 		break;
 	}
 
@@ -1539,7 +1539,7 @@ static int srpt_build_cmd_rsp(struct srpt_rdma_ch *ch,
 	memset(srp_rsp, 0, sizeof *srp_rsp);
 	srp_rsp->opcode = SRP_RSP;
 	srp_rsp->req_lim_delta =
-		__constant_cpu_to_be32(1 + atomic_xchg(&ch->req_lim_delta, 0));
+		cpu_to_be32(1 + atomic_xchg(&ch->req_lim_delta, 0));
 	srp_rsp->tag = tag;
 	srp_rsp->status = status;
 
@@ -1589,8 +1589,7 @@ static int srpt_build_tskmgmt_rsp(struct srpt_rdma_ch *ch,
 	memset(srp_rsp, 0, sizeof *srp_rsp);
 
 	srp_rsp->opcode = SRP_RSP;
-	srp_rsp->req_lim_delta = __constant_cpu_to_be32(1
-				    + atomic_xchg(&ch->req_lim_delta, 0));
+	srp_rsp->req_lim_delta = cpu_to_be32(1 + atomic_xchg(&ch->req_lim_delta, 0));
 	srp_rsp->tag = tag;
 
 	srp_rsp->flags |= SRP_RSP_FLAG_RSPVALID;
@@ -1634,7 +1633,7 @@ static uint64_t srpt_unpack_lun(const uint8_t *lun, int len)
 	switch (len) {
 	case 8:
 		if ((*((__be64 *)lun) &
-		     __constant_cpu_to_be64(0x0000FFFFFFFFFFFFLL)) != 0)
+		     cpu_to_be64(0x0000FFFFFFFFFFFFLL)) != 0)
 			goto out_err;
 		break;
 	case 4:
@@ -2454,8 +2453,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	}
 
 	if (it_iu_len > srp_max_req_size || it_iu_len < 64) {
-		rej->reason = __constant_cpu_to_be32(
-				SRP_LOGIN_REJ_REQ_IT_IU_LENGTH_TOO_LARGE);
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_REQ_IT_IU_LENGTH_TOO_LARGE);
 		ret = -EINVAL;
 		pr_err("rejected SRP_LOGIN_REQ because its"
 		       " length (%d bytes) is out of range (%d .. %d)\n",
@@ -2464,8 +2462,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	}
 
 	if (!sport->enabled) {
-		rej->reason = __constant_cpu_to_be32(
-			     SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		ret = -EINVAL;
 		pr_err("rejected SRP_LOGIN_REQ because the target port"
 		       " has not yet been enabled\n");
@@ -2510,8 +2507,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (*(__be64 *)req->target_port_id != cpu_to_be64(srpt_service_guid)
 	    || *(__be64 *)(req->target_port_id + 8) !=
 	       cpu_to_be64(srpt_service_guid)) {
-		rej->reason = __constant_cpu_to_be32(
-				SRP_LOGIN_REJ_UNABLE_ASSOCIATE_CHANNEL);
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_UNABLE_ASSOCIATE_CHANNEL);
 		ret = -ENOMEM;
 		pr_err("rejected SRP_LOGIN_REQ because it"
 		       " has an invalid target port identifier.\n");
@@ -2520,8 +2516,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	ch = kzalloc(sizeof *ch, GFP_KERNEL);
 	if (!ch) {
-		rej->reason = __constant_cpu_to_be32(
-					SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_err("rejected SRP_LOGIN_REQ because no memory.\n");
 		ret = -ENOMEM;
 		goto reject;
@@ -2557,8 +2552,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	ret = srpt_create_ch_ib(ch);
 	if (ret) {
-		rej->reason = __constant_cpu_to_be32(
-				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_err("rejected SRP_LOGIN_REQ because creating"
 		       " a new RDMA channel failed.\n");
 		goto free_ring;
@@ -2566,8 +2560,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	ret = srpt_ch_qp_rtr(ch, ch->qp);
 	if (ret) {
-		rej->reason = __constant_cpu_to_be32(
-				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_err("rejected SRP_LOGIN_REQ because enabling"
 		       " RTR failed (error code = %d)\n", ret);
 		goto destroy_ib;
@@ -2585,15 +2578,13 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (!nacl) {
 		pr_info("Rejected login because no ACL has been"
 			" configured yet for initiator %s.\n", ch->sess_name);
-		rej->reason = __constant_cpu_to_be32(
-				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
 		goto destroy_ib;
 	}
 
 	ch->sess = transport_init_session(TARGET_PROT_NORMAL);
 	if (IS_ERR(ch->sess)) {
-		rej->reason = __constant_cpu_to_be32(
-				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_debug("Failed to create session\n");
 		goto deregister_session;
 	}
@@ -2609,8 +2600,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	rsp->max_it_iu_len = req->req_it_iu_len;
 	rsp->max_ti_iu_len = req->req_it_iu_len;
 	ch->max_ti_iu_len = it_iu_len;
-	rsp->buf_fmt = __constant_cpu_to_be16(SRP_BUF_FORMAT_DIRECT
-					      | SRP_BUF_FORMAT_INDIRECT);
+	rsp->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT | SRP_BUF_FORMAT_INDIRECT);
 	rsp->req_lim_delta = cpu_to_be32(ch->rq_size);
 	atomic_set(&ch->req_lim, ch->rq_size);
 	atomic_set(&ch->req_lim_delta, 0);
@@ -2660,8 +2650,7 @@ free_ch:
 reject:
 	rej->opcode = SRP_LOGIN_REJ;
 	rej->tag = req->tag;
-	rej->buf_fmt = __constant_cpu_to_be16(SRP_BUF_FORMAT_DIRECT
-					      | SRP_BUF_FORMAT_INDIRECT);
+	rej->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT | SRP_BUF_FORMAT_INDIRECT);
 
 	ib_send_cm_rej(cm_id, IB_CM_REJ_CONSUMER_DEFINED, NULL, 0,
 			     (void *)rej, sizeof *rej);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
