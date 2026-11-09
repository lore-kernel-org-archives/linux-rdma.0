Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.83.148.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794212044;
	b=xwzUhJzVxxmchU9onP2EQUlzlkuN+B7We3ujTQTBZsrYrrsshUUXwvjprkcZ18QJGW3d
	 PvbHj8TJ7j1jZN/P45jvIw+3iLLpPLESUN4GFb51FJ/Zpg+T8mygsuW+2NHQDq4L0viOF
	 LaCDYaS8G8c2dsCWzDR2+Yqd5yR/PwLlIohvhsWG4QowQp/42PnqXHQLta9YFZleurO1i
	 goKMMz06r1lXodqZNkSajnBXrTA/Ik3eK5mwZttkPKnfsC5BzXP/eUw+uK+P2e+Cm6sSv
	 UkDNojSWJgrnIr3DAlc1+yox2uCpHW50AV5e24LSXg1p7s4MsCWdydvAPcVKoB9DDsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212044;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=hGAYq2su56GziHF6de4H5QQAOTZB3RmHYKRl0jVs0FA=;
	b=Nrny31JQU8uT8JWIAbY8VoZn5QbCUXTmnu1Dj+TDoG/CwPhiItzorqWC5imGN51S4E9l
	 2VYUe8QnGx+dDDxzj5uW0sm2dP822CgMekcgE5HuOLTfb7pjC2npH4aPEDf9egzMyn00D
	 /KDUnUfLoNGIwzjMTMfJNZDs3PBMFTtTAQxqiv62Tqj6RO//CEN5TSMlu/ot0VOaKNzIT
	 KN6NRUOyl0vsOM23nHm9IE1X84a83tygpQMEou0yM78h8fH4cYdZ7jyjjL6hvgK6qj9K0
	 hcu1v6QJT3CSR7nsAaLpZ8zOEQxlEHT/GSWeMluSw3YoJeL2AXrMPo6Zv78BtGUAM+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Yq5hACX4;
	arc=none smtp.remote-ip=35.83.148.184
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB3F606A321
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 08:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCB3F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Yq5hACX4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794212043; x=1825748043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hGAYq2su56GziHF6de4H5QQAOTZB3RmHYKRl0jVs0FA=;
  b=Yq5hACX4yz9u7syh/HWG+jh+BPbRY9z/Yj6l+kaZyO/k+tJgazljb9Hy
   099PEjeTZ5zBQEYLNKtkvrVXYiqQdDhkIU8ZhwZ7GIAVicW0VH1E9wDQo
   LNtvcHNvO0+NNDVHV50vTwUxexMX1iT+1mk3183a5Me+IBkpfVADh3i7C
   1gKzG5UxFfQeYSWpQ07FtzoQcMuwqQ4LewSoHUdTIjYPWQVMNw1zlDy89
   iouJx6fFJnaNSjTDX9SqgEZmVcFqqJRKmR0Jh2jqOLdVZmjps/RLdcGq5
   Lvf54E6RycklrZ04yQUrM5qUoFtLBdXZUGXc1PGnVFgxOxWJAUUmJ1OOx
   g==;
X-CSE-ConnectionGUID: 9U2Y4ukLTh20tuN49sKg9w==
X-CSE-MsgGUID: LxJ4rwrnRMCX7/Bs3XGShQ==
X-IronPort-AV: E=Sophos;i="6.27,203,1787011200"; 
   d="scan'208";a="33281730"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 08:14:03 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:32101]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id 2eb3d55b-11c1-453c-b8e2-5a6e6608cf89; Mon, 9 Nov 2026 08:14:03 +0000 (UTC)
X-Farcaster-Flow-ID: 2eb3d55b-11c1-453c-b8e2-5a6e6608cf89
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 9 Nov 2026 08:14:03 +0000
Received: from dev-dsk-ikolomin-1a-673563de.eu-west-1.amazon.com
 (172.19.125.167) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 9 Nov 2026
 08:14:01 +0000
From: Ilia Kolominsky <ikolomin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Michael Margolin" <mrgolin@amazon.com>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next 3/3] RDMA/efa: Add Completion Actions support
Date: Mon, 9 Nov 2026 08:13:49 +0000
Message-ID: <20261109081349.27316-4-ikolomin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109081349.27316-1-ikolomin@amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Completion actions are device-side effects triggered by work requests:
when a work request completes, locally or at the remote side, the device
performs the action, so completions can be observed without polling a
completion queue.

Implement the control path. A memory completion action object pins a
user buffer (VA or dmabuf) on a protection domain and yields the action
id that work requests carry; on each completion the device modifies
mem_modify_size bytes (1, 2 or 4) of that buffer with the operand the
work request supplies. The buffer must be physically contiguous. The
device also returns an action handle, which the driver keeps for the
destroy command.

The object is an EFA ioctl object, exposed only when the device reports
the actions capability. It holds a reference on its protection domain,
so deallocating the PD while the action exists fails with EBUSY. QP
creation accepts a WQE feature block configuration - an enablement
bitmap and the offset of the action descriptor within the WQE -
determined by the user space provider, which owns the WQE layout, and
passed through to the device. The device capability, the maximum number
of memory completion actions and the supported work request types are
reported through query device.

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Ilia Kolominsky <ikolomin@amazon.com>
---
 drivers/infiniband/hw/efa/efa.h         |   7 +
 drivers/infiniband/hw/efa/efa_com.c     |   8 +
 drivers/infiniband/hw/efa/efa_com_cmd.c |  73 ++++++++
 drivers/infiniband/hw/efa/efa_com_cmd.h |  31 ++++
 drivers/infiniband/hw/efa/efa_verbs.c   | 235 +++++++++++++++++++++++-
 include/uapi/rdma/efa-abi.h             |  56 +++++-
 6 files changed, 408 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa.h b/drivers/infiniband/hw/efa/efa.h
index 6f6686eef..c61dd0014 100644
--- a/drivers/infiniband/hw/efa/efa.h
+++ b/drivers/infiniband/hw/efa/efa.h
@@ -118,6 +118,13 @@ struct efa_comp_cntr {
 	u32 err_handle;
 };
 
+struct efa_comp_action {
+	struct efa_dev *dev;
+	struct ib_pd *pd;
+	struct ib_umem *umem;
+	u32 action_handle;
+};
+
 struct efa_qp {
 	struct ib_qp ibqp;
 	dma_addr_t rq_dma_addr;
diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index e8045b43f..6491932e7 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -77,6 +77,14 @@ static const char *efa_com_cmd_str(u8 cmd)
 	EFA_CMD_STR_CASE(DEALLOC_UAR);
 	EFA_CMD_STR_CASE(CREATE_EQ);
 	EFA_CMD_STR_CASE(DESTROY_EQ);
+	EFA_CMD_STR_CASE(SERVICE);
+	EFA_CMD_STR_CASE(CREATE_ACTION);
+	EFA_CMD_STR_CASE(DESTROY_ACTION);
+	EFA_CMD_STR_CASE(CREATE_EVENT_COUNTER);
+	EFA_CMD_STR_CASE(DESTROY_EVENT_COUNTER);
+	EFA_CMD_STR_CASE(ATTACH_EVENT_COUNTER);
+	EFA_CMD_STR_CASE(MODIFY_EVENT_COUNTER);
+	EFA_CMD_STR_CASE(DETACH_EVENT_COUNTER);
 	default: return "unknown command opcode";
 	}
 #undef EFA_CMD_STR_CASE
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
index 07bfcb093..a613cdc63 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.c
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
@@ -39,6 +39,13 @@ int efa_com_create_qp(struct efa_com_dev *edev,
 	if (params->sq_64_bit_req_id)
 		EFA_SET(&create_qp_cmd.flags, EFA_ADMIN_CREATE_QP_CMD_SQ_64_BIT_REQ_ID, 1);
 
+	if (params->wqe_blocks_en.action_with_data) {
+		EFA_SET(&create_qp_cmd.wqe_blocks_enablement,
+			EFA_ADMIN_CREATE_QP_CMD_ACTION_WITH_DATA, 1);
+		create_qp_cmd.action_with_data_wqe_offset =
+			params->wqe_blocks_offsets.action_with_data;
+	}
+
 	err = efa_com_cmd_exec(aq, EFA_ADMIN_CREATE_QP, 0,
 			       &create_qp_cmd, sizeof(create_qp_cmd),
 			       (struct efa_admin_acq_entry *)&cmd_completion,
@@ -542,6 +549,8 @@ int efa_com_get_device_attr(struct efa_com_dev *edev,
 		result->event_counter_max_val = resp.u.queue_attr_2.event_counter_max_val;
 		result->supported_event_counter_qp_events =
 			resp.u.queue_attr_2.supported_event_counter_qp_events;
+		result->max_actions = resp.u.queue_attr_2.max_actions;
+		result->supported_action_events = resp.u.queue_attr_2.supported_action_events;
 	} else {
 		result->inline_buf_size_ex = result->inline_buf_size;
 	}
@@ -983,3 +992,67 @@ int efa_com_modify_event_counter(struct efa_com_dev *edev,
 
 	return 0;
 }
+
+int efa_com_create_action(struct efa_com_dev *edev,
+			  struct efa_com_create_action_params *params,
+			  struct efa_com_create_action_result *result)
+{
+	struct efa_admin_create_action_cmd cmd = {};
+	struct efa_com_admin_queue *aq = &edev->aq;
+	struct efa_admin_create_action_resp resp;
+	int err;
+
+	/*
+	 * The command carries the length of the target buffer in 32 bits and
+	 * the write size in a byte
+	 */
+	if (params->length > U32_MAX || params->write_size > U8_MAX) {
+		ibdev_dbg(edev->efa_dev,
+			  "Action length[%llu] or write size[%u] out of range\n",
+			  params->length, params->write_size);
+		return -EINVAL;
+	}
+
+	cmd.type = EFA_ADMIN_ACTION_TYPE_MEMSET;
+	cmd.pd = params->pdn;
+	cmd.action_data.memset.paddr = params->dma_addr;
+	cmd.action_data.memset.length = params->length;
+	cmd.action_data.memset.write_size = params->write_size;
+
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_CREATE_ACTION, 0,
+			       &cmd, sizeof(cmd),
+			       (struct efa_admin_acq_entry *)&resp,
+			       sizeof(resp));
+	if (err) {
+		ibdev_err_ratelimited(edev->efa_dev,
+				      "Failed to create action [%d]\n", err);
+		return err;
+	}
+
+	result->action_handle = resp.action_handle;
+	result->action_id = resp.action_id;
+	return 0;
+}
+
+int efa_com_destroy_action(struct efa_com_dev *edev,
+			   struct efa_com_destroy_action_params *params)
+{
+	struct efa_admin_destroy_action_cmd cmd = {};
+	struct efa_com_admin_queue *aq = &edev->aq;
+	struct efa_admin_destroy_action_resp resp;
+	int err;
+
+	cmd.action_handle = params->action_handle;
+
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_DESTROY_ACTION, 0,
+			       &cmd, sizeof(cmd),
+			       (struct efa_admin_acq_entry *)&resp,
+			       sizeof(resp));
+	if (err) {
+		ibdev_err_ratelimited(edev->efa_dev,
+				      "Failed to destroy action [%d]\n", err);
+		return err;
+	}
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.h b/drivers/infiniband/hw/efa/efa_com_cmd.h
index 524407f36..a75ffeb37 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.h
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.h
@@ -30,6 +30,14 @@ struct efa_com_create_qp_params {
 	u8 sl;
 	u8 unsolicited_write_recv : 1;
 	u8 sq_64_bit_req_id : 1;
+	/* Enablement of WQE feature blocks */
+	struct {
+		u8 action_with_data:1;
+	} wqe_blocks_en;
+	/* Offsets in SQ WQE of the enabled WQE feature blocks */
+	struct {
+		u8 action_with_data;
+	} wqe_blocks_offsets;
 };
 
 struct efa_com_create_qp_result {
@@ -151,6 +159,8 @@ struct efa_com_get_device_attr_result {
 	u32 max_event_counters;
 	u64 event_counter_max_val;
 	u32 supported_event_counter_qp_events;
+	u32 max_actions;
+	u32 supported_action_events;
 };
 
 struct efa_com_get_hw_hints_result {
@@ -341,6 +351,22 @@ struct efa_com_modify_event_counter_params {
 	u64 value;
 };
 
+struct efa_com_create_action_params {
+	dma_addr_t dma_addr;
+	u64 length;
+	u32 write_size;
+	u16 pdn;
+};
+
+struct efa_com_create_action_result {
+	u32 action_handle;
+	u32 action_id;
+};
+
+struct efa_com_destroy_action_params {
+	u32 action_handle;
+};
+
 int efa_com_create_qp(struct efa_com_dev *edev,
 		      struct efa_com_create_qp_params *params,
 		      struct efa_com_create_qp_result *res);
@@ -402,5 +428,10 @@ int efa_com_detach_event_counter(struct efa_com_dev *edev,
 				 struct efa_com_detach_event_counter_params *params);
 int efa_com_modify_event_counter(struct efa_com_dev *edev,
 				 struct efa_com_modify_event_counter_params *params);
+int efa_com_create_action(struct efa_com_dev *edev,
+			  struct efa_com_create_action_params *params,
+			  struct efa_com_create_action_result *result);
+int efa_com_destroy_action(struct efa_com_dev *edev,
+			   struct efa_com_destroy_action_params *params);
 
 #endif /* _EFA_COM_CMD_H_ */
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index d56eb1325..e8099f52d 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -212,6 +212,29 @@ static void efa_free_mapped(struct efa_dev *dev, void *cpu_addr,
 	free_pages_exact(cpu_addr, size);
 }
 
+static u32 efa_comp_action_supp_ops(u32 action_events)
+{
+	u32 supp_ops = 0;
+
+	if (EFA_GET(&action_events, EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_SEND_COMP))
+		supp_ops |= EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_SEND;
+	if (EFA_GET(&action_events, EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_RECV_COMP))
+		supp_ops |= EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_RECV;
+	if (EFA_GET(&action_events, EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_READ_COMP))
+		supp_ops |= EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_RDMA_READ;
+	if (EFA_GET(&action_events, EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_REMOTE_READ_COMP))
+		supp_ops |= EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_REMOTE_RDMA_READ;
+	if (EFA_GET(&action_events, EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_WRITE_COMP))
+		supp_ops |= EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_RDMA_WRITE;
+	if (EFA_GET(&action_events, EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_REMOTE_WRITE_COMP))
+		supp_ops |= EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_REMOTE_RDMA_WRITE;
+	if (EFA_GET(&action_events,
+		    EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_REMOTE_WRITE_IMM_COMP))
+		supp_ops |= EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_REMOTE_RDMA_WRITE_IMM;
+
+	return supp_ops;
+}
+
 int efa_query_device(struct ib_device *ibdev,
 		     struct ib_device_attr *props,
 		     struct ib_udata *udata)
@@ -272,6 +295,13 @@ int efa_query_device(struct ib_device *ibdev,
 		if (EFA_DEV_CAP(dev, EVENT_COUNTERS))
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_COMP_CNTR;
 
+		if (EFA_DEV_CAP(dev, ACTIONS)) {
+			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_COMP_ACTION;
+			resp.max_comp_actions = dev_attr->max_actions;
+			resp.comp_action_supp_ops =
+				efa_comp_action_supp_ops(dev_attr->supported_action_events);
+		}
+
 		if (EFA_DEV_CAP(dev, SQ_64_BIT_REQ_ID))
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID;
 
@@ -692,6 +722,30 @@ static int efa_qp_validate_attr(struct efa_dev *dev,
 	return 0;
 }
 
+static int efa_qp_validate_wqe_blocks(struct efa_dev *dev,
+				      struct efa_ibv_create_qp *cmd)
+{
+	u32 supported_wqe_blocks = 0;
+
+	if (EFA_DEV_CAP(dev, ACTIONS))
+		supported_wqe_blocks |= EFA_CREATE_QP_WQE_BLOCK_ACTION_WITH_DATA;
+
+	if (cmd->wqe_blocks_enablement & ~supported_wqe_blocks) {
+		ibdev_dbg(&dev->ibdev, "Unsupported WQE blocks[%#x], supported[%#x]\n",
+			  cmd->wqe_blocks_enablement, supported_wqe_blocks);
+		return -EOPNOTSUPP;
+	}
+
+	if ((cmd->wqe_blocks_enablement & EFA_CREATE_QP_WQE_BLOCK_ACTION_WITH_DATA) &&
+	    cmd->action_with_data_wqe_offset > U8_MAX) {
+		ibdev_dbg(&dev->ibdev, "Invalid action with data WQE offset[%u]\n",
+			  cmd->action_with_data_wqe_offset);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int efa_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 		  struct ib_udata *udata)
 {
@@ -712,7 +766,8 @@ int efa_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 	if (err)
 		goto err_out;
 
-	if (!is_reserved_cleared(cmd.reserved_98)) {
+	if (!is_reserved_cleared(cmd.reserved_98) ||
+	    !is_reserved_cleared(cmd.reserved_d0)) {
 		ibdev_dbg(&dev->ibdev,
 			  "Incompatible ABI params, unknown fields in udata\n");
 		err = -EINVAL;
@@ -732,6 +787,10 @@ int efa_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 		goto err_out;
 	}
 
+	err = efa_qp_validate_wqe_blocks(dev, &cmd);
+	if (err)
+		goto err_out;
+
 	err = efa_qp_validate_cap(dev, init_attr, cmd.sq_ring_size);
 	if (err)
 		goto err_out;
@@ -787,6 +846,12 @@ int efa_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 	if (cmd.flags & EFA_CREATE_QP_WITH_SQ_64_BIT_REQ_ID)
 		create_qp_params.sq_64_bit_req_id = true;
 
+	if (cmd.wqe_blocks_enablement & EFA_CREATE_QP_WQE_BLOCK_ACTION_WITH_DATA) {
+		create_qp_params.wqe_blocks_en.action_with_data = true;
+		create_qp_params.wqe_blocks_offsets.action_with_data =
+			cmd.action_with_data_wqe_offset;
+	}
+
 	err = efa_com_create_qp(&dev->edev, &create_qp_params,
 				&create_qp_resp);
 	if (err)
@@ -2500,6 +2565,132 @@ int efa_qp_attach_comp_cntr(struct ib_qp *ibqp, struct ib_comp_cntr *ibcc,
 	return 0;
 }
 
+static int efa_free_comp_action(struct ib_uobject *uobject, enum rdma_remove_reason why,
+				struct uverbs_attr_bundle *attrs)
+{
+	struct efa_com_destroy_action_params params = {};
+	struct efa_comp_action *action = uobject->object;
+	int err;
+
+	params.action_handle = action->action_handle;
+	err = efa_com_destroy_action(&action->dev->edev, &params);
+	if (err)
+		return err;
+
+	atomic_dec(&action->pd->usecnt);
+	ib_umem_release(action->umem);
+	kfree(action);
+	return 0;
+}
+
+static int UVERBS_HANDLER(EFA_IB_METHOD_COMP_ACTION_CREATE)(struct uverbs_attr_bundle *attrs)
+{
+	struct efa_com_destroy_action_params destroy_params = {};
+	enum efa_mem_comp_action_modify_type mem_modify_type;
+	struct efa_com_create_action_params params = {};
+	struct efa_com_create_action_result result;
+	enum efa_comp_action_type type;
+	struct efa_comp_action *action;
+	struct ib_uobject *uobj;
+	struct ib_umem *umem;
+	struct efa_dev *dev;
+	u32 mem_modify_size;
+	struct ib_pd *ibpd;
+	u64 mem_size;
+	int err;
+
+	uobj = uverbs_attr_get_uobject(attrs, EFA_IB_ATTR_COMP_ACTION_CREATE_HANDLE);
+	ibpd = uverbs_attr_get_obj(attrs, EFA_IB_ATTR_COMP_ACTION_CREATE_PD_HANDLE);
+	dev = to_edev(ibpd->device);
+
+	err = uverbs_get_const(&type, attrs, EFA_IB_ATTR_COMP_ACTION_CREATE_TYPE);
+	if (err)
+		return err;
+
+	if (type != EFA_COMP_ACTION_TYPE_MEM)
+		return -EOPNOTSUPP;
+
+	err = uverbs_get_const(&mem_modify_type, attrs,
+			       EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_MODIFY_TYPE);
+	if (err)
+		return err;
+
+	if (mem_modify_type != EFA_MEM_COMP_ACTION_SET_INITIATOR_VAL)
+		return -EOPNOTSUPP;
+
+	err = uverbs_copy_from(&mem_modify_size, attrs,
+			       EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_MODIFY_SIZE);
+	if (err)
+		return err;
+
+	err = uverbs_copy_from(&mem_size, attrs, EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_SIZE);
+	if (err)
+		return err;
+
+	if (!mem_size || !mem_modify_size) {
+		ibdev_dbg(&dev->ibdev, "Invalid action memory size[%llu] or modify size[%u]\n",
+			  mem_size, mem_modify_size);
+		return -EINVAL;
+	}
+
+	umem = ib_umem_get_attr(ibpd->device, attrs,
+				EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_BUFFER, mem_size,
+				IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE);
+	if (IS_ERR(umem))
+		return PTR_ERR(umem);
+
+	if (!ib_umem_is_contiguous(umem)) {
+		ibdev_dbg(&dev->ibdev, "Non contiguous action memory unsupported\n");
+		err = -EINVAL;
+		goto err_umem;
+	}
+
+	action = kzalloc_obj(*action);
+	if (!action) {
+		err = -ENOMEM;
+		goto err_umem;
+	}
+
+	params.pdn = to_epd(ibpd)->pdn;
+	params.dma_addr = ib_umem_start_dma_addr(umem);
+	params.length = mem_size;
+	params.write_size = mem_modify_size;
+
+	err = efa_com_create_action(&dev->edev, &params, &result);
+	if (err)
+		goto err_free;
+
+	/* Work requests carry the action id; the handle is kept for the destroy command */
+	err = uverbs_copy_to(attrs, EFA_IB_ATTR_COMP_ACTION_CREATE_RESP_ACTION_ID,
+			     &result.action_id, sizeof(result.action_id));
+	if (IS_UVERBS_COPY_ERR(err))
+		goto err_destroy;
+
+	action->dev = dev;
+	action->pd = ibpd;
+	action->umem = umem;
+	action->action_handle = result.action_handle;
+	atomic_inc(&ibpd->usecnt);
+
+	uobj->object = action;
+	uverbs_finalize_uobj_create(attrs, EFA_IB_ATTR_COMP_ACTION_CREATE_HANDLE);
+	return 0;
+
+err_destroy:
+	destroy_params.action_handle = result.action_handle;
+	efa_com_destroy_action(&dev->edev, &destroy_params);
+err_free:
+	kfree(action);
+err_umem:
+	ib_umem_release(umem);
+	return err;
+}
+
+static bool efa_comp_actions_supported(struct ib_device *ibdev)
+{
+	return EFA_DEV_CAP(to_edev(ibdev), ACTIONS);
+}
+
 DECLARE_UVERBS_NAMED_METHOD(EFA_IB_METHOD_MR_QUERY,
 			    UVERBS_ATTR_IDR(EFA_IB_ATTR_QUERY_MR_HANDLE,
 					    UVERBS_OBJECT_MR,
@@ -2535,10 +2726,52 @@ ADD_UVERBS_ATTRIBUTES_SIMPLE(
 		UVERBS_ATTR_STRUCT(struct ib_uverbs_buffer_desc, length),
 		UA_MANDATORY));
 
+DECLARE_UVERBS_NAMED_METHOD(EFA_IB_METHOD_COMP_ACTION_CREATE,
+			    UVERBS_ATTR_IDR(EFA_IB_ATTR_COMP_ACTION_CREATE_HANDLE,
+					    EFA_IB_OBJECT_COMP_ACTION,
+					    UVERBS_ACCESS_NEW,
+					    UA_MANDATORY),
+			    UVERBS_ATTR_IDR(EFA_IB_ATTR_COMP_ACTION_CREATE_PD_HANDLE,
+					    UVERBS_OBJECT_PD,
+					    UVERBS_ACCESS_READ,
+					    UA_MANDATORY),
+			    UVERBS_ATTR_CONST_IN(EFA_IB_ATTR_COMP_ACTION_CREATE_TYPE,
+						 enum efa_comp_action_type,
+						 UA_MANDATORY),
+			    UVERBS_ATTR_CONST_IN(EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_MODIFY_TYPE,
+						 enum efa_mem_comp_action_modify_type,
+						 UA_MANDATORY),
+			    UVERBS_ATTR_PTR_IN(EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_MODIFY_SIZE,
+					       UVERBS_ATTR_TYPE(u32),
+					       UA_MANDATORY),
+			    UVERBS_ATTR_PTR_IN(EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_SIZE,
+					       UVERBS_ATTR_TYPE(u64),
+					       UA_MANDATORY),
+			    UVERBS_ATTR_PTR_IN(EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_BUFFER,
+					       UVERBS_ATTR_STRUCT(struct ib_uverbs_buffer_desc,
+								  length),
+					       UA_MANDATORY),
+			    UVERBS_ATTR_PTR_OUT(EFA_IB_ATTR_COMP_ACTION_CREATE_RESP_ACTION_ID,
+						UVERBS_ATTR_TYPE(u32),
+						UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(EFA_IB_METHOD_COMP_ACTION_DESTROY,
+				    UVERBS_ATTR_IDR(EFA_IB_ATTR_COMP_ACTION_DESTROY_HANDLE,
+						    EFA_IB_OBJECT_COMP_ACTION,
+						    UVERBS_ACCESS_DESTROY,
+						    UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(EFA_IB_OBJECT_COMP_ACTION,
+			    UVERBS_TYPE_ALLOC_IDR(efa_free_comp_action),
+			    &UVERBS_METHOD(EFA_IB_METHOD_COMP_ACTION_CREATE),
+			    &UVERBS_METHOD(EFA_IB_METHOD_COMP_ACTION_DESTROY));
+
 const struct uapi_definition efa_uapi_defs[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_MR,
 				&efa_mr),
 	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_COMP_CNTR,
 				&efa_comp_cntr_create),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(EFA_IB_OBJECT_COMP_ACTION,
+				      UAPI_DEF_IS_OBJ_SUPPORTED(efa_comp_actions_supported)),
 	{},
 };
diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
index 2094b4bcc..c907d966b 100644
--- a/include/uapi/rdma/efa-abi.h
+++ b/include/uapi/rdma/efa-abi.h
@@ -92,6 +92,10 @@ enum {
 	EFA_CREATE_QP_WITH_SQ_64_BIT_REQ_ID = 1 << 1,
 };
 
+enum {
+	EFA_CREATE_QP_WQE_BLOCK_ACTION_WITH_DATA = 1 << 0,
+};
+
 struct efa_ibv_create_qp {
 	__u32 comp_mask;
 	__u32 rq_ring_size; /* bytes */
@@ -99,7 +103,12 @@ struct efa_ibv_create_qp {
 	__u32 driver_qp_type;
 	__u16 flags;
 	__u8 sl;
-	__u8 reserved_98[5];
+	__u8 reserved_98[1];
+	/* enablement bitmap for WQE configurable feature blocks */
+	__u32 wqe_blocks_enablement;
+	/* offset in SQ WQE to the action with data descriptor */
+	__u16 action_with_data_wqe_offset;
+	__u8 reserved_d0[6];
 };
 
 struct efa_ibv_create_qp_resp {
@@ -137,6 +146,17 @@ enum {
 	EFA_QUERY_DEVICE_CAPS_CQ_WITH_EXT_MEM = 1 << 7,
 	EFA_QUERY_DEVICE_CAPS_COMP_CNTR = 1 << 8,
 	EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID = 1 << 9,
+	EFA_QUERY_DEVICE_CAPS_COMP_ACTION = 1 << 10,
+};
+
+enum efa_query_device_comp_action_supp_ops {
+	EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_SEND = 1 << 0,
+	EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_RECV = 1 << 1,
+	EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_RDMA_READ = 1 << 2,
+	EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_REMOTE_RDMA_READ = 1 << 3,
+	EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_RDMA_WRITE = 1 << 4,
+	EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_REMOTE_RDMA_WRITE = 1 << 5,
+	EFA_QUERY_DEVICE_COMP_ACTION_SUPP_OP_REMOTE_RDMA_WRITE_IMM = 1 << 6,
 };
 
 struct efa_ibv_ex_query_device_resp {
@@ -147,6 +167,8 @@ struct efa_ibv_ex_query_device_resp {
 	__u16 max_rq_sge;
 	__u32 max_rdma_size;
 	__u32 device_caps;
+	__u32 max_comp_actions;
+	__u32 comp_action_supp_ops;
 };
 
 enum {
@@ -172,4 +194,36 @@ enum efa_comp_cntr_create_attrs {
 	EFA_IB_ATTR_CREATE_COMP_CNTR_ERR_BUFFER,
 };
 
+enum efa_objects {
+	EFA_IB_OBJECT_COMP_ACTION = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum efa_comp_action_type {
+	EFA_COMP_ACTION_TYPE_MEM,
+};
+
+enum efa_mem_comp_action_modify_type {
+	EFA_MEM_COMP_ACTION_SET_INITIATOR_VAL,
+};
+
+enum efa_comp_action_methods {
+	EFA_IB_METHOD_COMP_ACTION_CREATE = (1U << UVERBS_ID_NS_SHIFT),
+	EFA_IB_METHOD_COMP_ACTION_DESTROY,
+};
+
+enum efa_comp_action_create_attrs {
+	EFA_IB_ATTR_COMP_ACTION_CREATE_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	EFA_IB_ATTR_COMP_ACTION_CREATE_PD_HANDLE,
+	EFA_IB_ATTR_COMP_ACTION_CREATE_TYPE,
+	EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_MODIFY_TYPE,
+	EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_MODIFY_SIZE,
+	EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_SIZE,
+	EFA_IB_ATTR_COMP_ACTION_CREATE_MEM_BUFFER,
+	EFA_IB_ATTR_COMP_ACTION_CREATE_RESP_ACTION_ID,
+};
+
+enum efa_comp_action_destroy_attrs {
+	EFA_IB_ATTR_COMP_ACTION_DESTROY_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+};
+
 #endif /* EFA_ABI_USER_H */
-- 
2.47.3

