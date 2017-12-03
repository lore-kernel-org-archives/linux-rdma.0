From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH net-next 7/8] net: hns3: Change PF to add ring-vect binding & resetQ to mailbox
Date: Sun, 3 Dec 2017 12:33:06 +0000
Message-ID: <20171203123307.19820-8-salil.mehta@huawei.com>
References: <20171203123307.19820-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171203123307.19820-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil.lnk@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

This patch is required to support ring-vector binding and reset
of TQPs requested by the VF driver to the PF driver. Mailbox
handler is added with corresponding VF commands/messages to
handle the request.

Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: lipeng <lipeng321@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 136 +++++++--------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   7 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 106 ++++++++++++++++
 3 files changed, 157 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index af9d92a3800e..7d9fa4e2b16a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3252,49 +3252,46 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 	return ret;
 }
 
-int hclge_map_vport_ring_to_vector(struct hclge_vport *vport, int vector_id,
-				   struct hnae3_ring_chain_node *ring_chain)
+int hclge_bind_ring_with_vector(struct hclge_vport *vport,
+				int vector_id, bool en,
+				struct hnae3_ring_chain_node *ring_chain)
 {
 	struct hclge_dev *hdev = vport->back;
-	struct hclge_ctrl_vector_chain_cmd *req;
 	struct hnae3_ring_chain_node *node;
 	struct hclge_desc desc;
-	int ret;
+	struct hclge_ctrl_vector_chain_cmd *req
+		= (struct hclge_ctrl_vector_chain_cmd *)desc.data;
+	enum hclge_cmd_status status;
+	enum hclge_opcode_type op;
 	int i;
 
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_ADD_RING_TO_VECTOR, false);
-
-	req = (struct hclge_ctrl_vector_chain_cmd *)desc.data;
+	op = en ? HCLGE_OPC_ADD_RING_TO_VECTOR : HCLGE_OPC_DEL_RING_TO_VECTOR;
+	hclge_cmd_setup_basic_desc(&desc, op, false);
 	req->int_vector_id = vector_id;
 
 	i = 0;
 	for (node = ring_chain; node; node = node->next) {
-		u16 type_and_id = 0;
-
-		hnae_set_field(type_and_id, HCLGE_INT_TYPE_M, HCLGE_INT_TYPE_S,
+		hnae_set_field(req->tqp_type_and_id[i], HCLGE_INT_TYPE_M,
+			       HCLGE_INT_TYPE_S,
 			       hnae_get_bit(node->flag, HNAE3_RING_TYPE_B));
-		hnae_set_field(type_and_id, HCLGE_TQP_ID_M, HCLGE_TQP_ID_S,
-			       node->tqp_index);
-		hnae_set_field(type_and_id, HCLGE_INT_GL_IDX_M,
-			       HCLGE_INT_GL_IDX_S,
-			       hnae_get_bit(node->flag, HNAE3_RING_TYPE_B));
-		req->tqp_type_and_id[i] = cpu_to_le16(type_and_id);
-		req->vfid = vport->vport_id;
-
+		hnae_set_field(req->tqp_type_and_id[i], HCLGE_TQP_ID_M,
+			       HCLGE_TQP_ID_S,	node->tqp_index);
+		req->tqp_type_and_id[i] = cpu_to_le16(req->tqp_type_and_id[i]);
 		if (++i >= HCLGE_VECTOR_ELEMENTS_PER_CMD) {
 			req->int_cause_num = HCLGE_VECTOR_ELEMENTS_PER_CMD;
+			req->vfid = vport->vport_id;
 
-			ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-			if (ret) {
+			status = hclge_cmd_send(&hdev->hw, &desc, 1);
+			if (status) {
 				dev_err(&hdev->pdev->dev,
 					"Map TQP fail, status is %d.\n",
-					ret);
-				return ret;
+					status);
+				return -EIO;
 			}
 			i = 0;
 
 			hclge_cmd_setup_basic_desc(&desc,
-						   HCLGE_OPC_ADD_RING_TO_VECTOR,
+						   op,
 						   false);
 			req->int_vector_id = vector_id;
 		}
@@ -3302,21 +3299,21 @@ int hclge_map_vport_ring_to_vector(struct hclge_vport *vport, int vector_id,
 
 	if (i > 0) {
 		req->int_cause_num = i;
-
-		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-		if (ret) {
+		req->vfid = vport->vport_id;
+		status = hclge_cmd_send(&hdev->hw, &desc, 1);
+		if (status) {
 			dev_err(&hdev->pdev->dev,
-				"Map TQP fail, status is %d.\n", ret);
-			return ret;
+				"Map TQP fail, status is %d.\n", status);
+			return -EIO;
 		}
 	}
 
 	return 0;
 }
 
-static int hclge_map_handle_ring_to_vector(
-		struct hnae3_handle *handle, int vector,
-		struct hnae3_ring_chain_node *ring_chain)
+static int hclge_map_ring_to_vector(struct hnae3_handle *handle,
+				    int vector,
+				    struct hnae3_ring_chain_node *ring_chain)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
@@ -3325,24 +3322,20 @@ static int hclge_map_handle_ring_to_vector(
 	vector_id = hclge_get_vector_index(hdev, vector);
 	if (vector_id < 0) {
 		dev_err(&hdev->pdev->dev,
-			"Get vector index fail. ret =%d\n", vector_id);
+			"Get vector index fail. vector_id =%d\n", vector_id);
 		return vector_id;
 	}
 
-	return hclge_map_vport_ring_to_vector(vport, vector_id, ring_chain);
+	return hclge_bind_ring_with_vector(vport, vector_id, true, ring_chain);
 }
 
-static int hclge_unmap_ring_from_vector(
-	struct hnae3_handle *handle, int vector,
-	struct hnae3_ring_chain_node *ring_chain)
+static int hclge_unmap_ring_frm_vector(struct hnae3_handle *handle,
+				       int vector,
+				       struct hnae3_ring_chain_node *ring_chain)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	struct hclge_ctrl_vector_chain_cmd *req;
-	struct hnae3_ring_chain_node *node;
-	struct hclge_desc desc;
-	int i, vector_id;
-	int ret;
+	int vector_id, ret;
 
 	vector_id = hclge_get_vector_index(hdev, vector);
 	if (vector_id < 0) {
@@ -3351,54 +3344,17 @@ static int hclge_unmap_ring_from_vector(
 		return vector_id;
 	}
 
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_DEL_RING_TO_VECTOR, false);
-
-	req = (struct hclge_ctrl_vector_chain_cmd *)desc.data;
-	req->int_vector_id = vector_id;
-
-	i = 0;
-	for (node = ring_chain; node; node = node->next) {
-		u16 type_and_id = 0;
-
-		hnae_set_field(type_and_id, HCLGE_INT_TYPE_M, HCLGE_INT_TYPE_S,
-			       hnae_get_bit(node->flag, HNAE3_RING_TYPE_B));
-		hnae_set_field(type_and_id, HCLGE_TQP_ID_M, HCLGE_TQP_ID_S,
-			       node->tqp_index);
-		hnae_set_field(type_and_id, HCLGE_INT_GL_IDX_M,
-			       HCLGE_INT_GL_IDX_S,
-			       hnae_get_bit(node->flag, HNAE3_RING_TYPE_B));
-
-		req->tqp_type_and_id[i] = cpu_to_le16(type_and_id);
-		req->vfid = vport->vport_id;
-
-		if (++i >= HCLGE_VECTOR_ELEMENTS_PER_CMD) {
-			req->int_cause_num = HCLGE_VECTOR_ELEMENTS_PER_CMD;
-
-			ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-			if (ret) {
-				dev_err(&hdev->pdev->dev,
-					"Unmap TQP fail, status is %d.\n",
-					ret);
-				return ret;
-			}
-			i = 0;
-			hclge_cmd_setup_basic_desc(&desc,
-						   HCLGE_OPC_DEL_RING_TO_VECTOR,
-						   false);
-			req->int_vector_id = vector_id;
-		}
+	ret = hclge_bind_ring_with_vector(vport, vector_id, false, ring_chain);
+	if (ret) {
+		dev_err(&handle->pdev->dev,
+			"Unmap ring from vector fail. vectorid=%d, ret =%d\n",
+			vector_id,
+			ret);
+		return ret;
 	}
 
-	if (i > 0) {
-		req->int_cause_num = i;
-
-		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"Unmap TQP fail, status is %d.\n", ret);
-			return ret;
-		}
-	}
+	/* Free this MSIX or MSI vector */
+	hclge_free_vector(hdev, vector_id);
 
 	return 0;
 }
@@ -4419,7 +4375,7 @@ static int hclge_get_reset_status(struct hclge_dev *hdev, u16 queue_id)
 	return hnae_get_bit(req->ready_to_reset, HCLGE_TQP_RESET_B);
 }
 
-static void hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
+void hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
@@ -4990,8 +4946,8 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.uninit_ae_dev = hclge_uninit_ae_dev,
 	.init_client_instance = hclge_init_client_instance,
 	.uninit_client_instance = hclge_uninit_client_instance,
-	.map_ring_to_vector = hclge_map_handle_ring_to_vector,
-	.unmap_ring_from_vector = hclge_unmap_ring_from_vector,
+	.map_ring_to_vector = hclge_map_ring_to_vector,
+	.unmap_ring_from_vector = hclge_unmap_ring_frm_vector,
 	.get_vector = hclge_get_vector,
 	.set_promisc_mode = hclge_set_promisc_mode,
 	.set_loopback = hclge_set_loopback,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 028817c7d67c..c7c9a28b97ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -539,8 +539,10 @@ int hclge_cfg_func_mta_filter(struct hclge_dev *hdev,
 			      u8 func_id,
 			      bool enable);
 struct hclge_vport *hclge_get_vport(struct hnae3_handle *handle);
-int hclge_map_vport_ring_to_vector(struct hclge_vport *vport, int vector,
-				   struct hnae3_ring_chain_node *ring_chain);
+int hclge_bind_ring_with_vector(struct hclge_vport *vport,
+				int vector_id, bool en,
+				struct hnae3_ring_chain_node *ring_chain);
+
 static inline int hclge_get_queue_id(struct hnae3_queue *queue)
 {
 	struct hclge_tqp *tqp = container_of(queue, struct hclge_tqp, q);
@@ -556,4 +558,5 @@ int hclge_buffer_alloc(struct hclge_dev *hdev);
 int hclge_rss_init_hw(struct hclge_dev *hdev);
 
 void hclge_mbx_handler(struct hclge_dev *hdev);
+void hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index da8b0c9ef353..ebf7e7a47eed 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -85,6 +85,91 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 	return status;
 }
 
+static void hclge_free_vector_ring_chain(struct hnae3_ring_chain_node *head)
+{
+	struct hnae3_ring_chain_node *chain_tmp, *chain;
+
+	chain = head->next;
+
+	while (chain) {
+		chain_tmp = chain->next;
+		kzfree(chain);
+		chain = chain_tmp;
+	}
+}
+
+/* hclge_get_ring_chain_from_mbx: get ring type & tqpid from mailbox message
+ * msg[0]: opcode
+ * msg[1]: <not relevant to this function>
+ * msg[2]: ring_num
+ * msg[3]: first ring type (TX|RX)
+ * msg[4]: first tqp id
+ * msg[5] ~ msg[14]: other ring type and tqp id
+ */
+static int hclge_get_ring_chain_from_mbx(
+			struct hclge_mbx_vf_to_pf_cmd *req,
+			struct hnae3_ring_chain_node *ring_chain,
+			struct hclge_vport *vport)
+{
+#define HCLGE_RING_NODE_VARIABLE_NUM		3
+#define HCLGE_RING_MAP_MBX_BASIC_MSG_NUM	3
+	struct hnae3_ring_chain_node *cur_chain, *new_chain;
+	int ring_num;
+	int i;
+
+	ring_num = req->msg[2];
+
+	hnae_set_bit(ring_chain->flag, HNAE3_RING_TYPE_B, req->msg[3]);
+	ring_chain->tqp_index =
+			hclge_get_queue_id(vport->nic.kinfo.tqp[req->msg[4]]);
+
+	cur_chain = ring_chain;
+
+	for (i = 1; i < ring_num; i++) {
+		new_chain = kzalloc(sizeof(*new_chain), GFP_KERNEL);
+		if (!new_chain)
+			goto err;
+
+		hnae_set_bit(new_chain->flag, HNAE3_RING_TYPE_B,
+			     req->msg[HCLGE_RING_NODE_VARIABLE_NUM * i +
+			     HCLGE_RING_MAP_MBX_BASIC_MSG_NUM]);
+
+		new_chain->tqp_index =
+		hclge_get_queue_id(vport->nic.kinfo.tqp
+			[req->msg[HCLGE_RING_NODE_VARIABLE_NUM * i +
+			HCLGE_RING_MAP_MBX_BASIC_MSG_NUM + 1]]);
+
+		cur_chain->next = new_chain;
+		cur_chain = new_chain;
+	}
+
+	return 0;
+err:
+	hclge_free_vector_ring_chain(ring_chain);
+	return -ENOMEM;
+}
+
+static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
+					     struct hclge_mbx_vf_to_pf_cmd *req)
+{
+	struct hnae3_ring_chain_node ring_chain;
+	int vector_id = req->msg[1];
+	int ret;
+
+	memset(&ring_chain, 0, sizeof(ring_chain));
+	ret = hclge_get_ring_chain_from_mbx(req, &ring_chain, vport);
+	if (ret)
+		return ret;
+
+	ret = hclge_bind_ring_with_vector(vport, vector_id, en, &ring_chain);
+	if (ret)
+		return ret;
+
+	hclge_free_vector_ring_chain(&ring_chain);
+
+	return 0;
+}
+
 static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 				     struct hclge_mbx_vf_to_pf_cmd *req)
 {
@@ -229,6 +314,16 @@ static int hclge_get_link_info(struct hclge_vport *vport,
 				  HCLGE_MBX_LINK_STAT_CHANGE, dest_vfid);
 }
 
+static void hclge_reset_vf_queue(struct hclge_vport *vport,
+				 struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+{
+	u16 queue_id;
+
+	memcpy(&queue_id, &mbx_req->msg[0], sizeof(queue_id));
+
+	hclge_reset_tqp(&vport->nic, queue_id);
+}
+
 void hclge_mbx_handler(struct hclge_dev *hdev)
 {
 	struct hclge_cmq_ring *crq = &hdev->hw.cmq.crq;
@@ -246,6 +341,14 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		vport = &hdev->vport[req->mbx_src_vfid];
 
 		switch (req->msg[0]) {
+		case HCLGE_MBX_MAP_RING_TO_VECTOR:
+			ret = hclge_map_unmap_ring_to_vf_vector(vport, true,
+								req);
+			break;
+		case HCLGE_MBX_UNMAP_RING_TO_VECTOR:
+			ret = hclge_map_unmap_ring_to_vf_vector(vport, false,
+								req);
+			break;
 		case HCLGE_MBX_SET_PROMISC_MODE:
 			ret = hclge_set_vf_promisc_mode(vport, req);
 			if (ret)
@@ -295,6 +398,9 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 					"PF fail(%d) to get link stat for VF\n",
 					ret);
 			break;
+		case HCLGE_MBX_QUEUE_RESET:
+			hclge_reset_vf_queue(vport, req);
+			break;
 		default:
 			dev_err(&hdev->pdev->dev,
 				"un-supported mailbox message, code = %d\n",
-- 
2.11.0
