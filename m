From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 4/4] IB/mlx4: Add receive Flow Steering support
Date: Wed,  7 Aug 2013 14:02:02 +0300
Message-ID: <1375873322-19384-5-git-send-email-ogerlitz@mellanox.com>
References: <1375873322-19384-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375873322-19384-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Implement ib_create_flow and ib_destroy_flow.

Translate the verbs structures provided by the user to HW structures
and call the MLX4_QP_FLOW_STEERING_ATTACH/DETACH firmware commands.

On the ATTACH command completion, the firmware provides 64 bit registration
ID which is placed into struct mlx4_ib_flow that wraps the instance of
struct ib_flow which is retuned to caller. Later, this reg ID is used
for detaching that flow from the firmware.

Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |  235 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   12 ++
 include/linux/mlx4/device.h          |    5 -
 3 files changed, 247 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index a188d31..74e8b17 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -54,6 +54,8 @@
 #define DRV_VERSION	"1.0"
 #define DRV_RELDATE	"April 4, 2008"
 
+#define MLX4_IB_FLOW_MAX_PRIO 0xFFF
+
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
 MODULE_LICENSE("Dual BSD/GPL");
@@ -88,6 +90,25 @@ static void init_query_mad(struct ib_smp *mad)
 
 static union ib_gid zgid;
 
+static int check_flow_steering_support(struct mlx4_dev *dev)
+{
+	int ib_num_ports = 0;
+	int i;
+
+	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
+		ib_num_ports++;
+
+	if (dev->caps.steering_mode == MLX4_STEERING_MODE_DEVICE_MANAGED) {
+		if (ib_num_ports || mlx4_is_mfunc(dev)) {
+			pr_warn("Device managed flow steering is unavailable "
+				"for IB ports or in multifunction env.\n");
+			return 0;
+		}
+		return 1;
+	}
+	return 0;
+}
+
 static int mlx4_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props)
 {
@@ -144,6 +165,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2B;
 		else
 			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2A;
+	if (check_flow_steering_support(dev->dev))
+		props->device_cap_flags |= IB_DEVICE_MANAGED_FLOW_STEERING;
 	}
 
 	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
@@ -798,6 +821,209 @@ struct mlx4_ib_steering {
 	union ib_gid gid;
 };
 
+static int parse_flow_attr(struct mlx4_dev *dev,
+			   struct _ib_flow_spec *ib_spec,
+			   struct _rule_hw *mlx4_spec)
+{
+	enum mlx4_net_trans_rule_id type;
+
+	switch (ib_spec->type) {
+	case IB_FLOW_SPEC_ETH:
+		type = MLX4_NET_TRANS_RULE_ID_ETH;
+		memcpy(mlx4_spec->eth.dst_mac, ib_spec->eth.val.dst_mac,
+		       ETH_ALEN);
+		memcpy(mlx4_spec->eth.dst_mac_msk, ib_spec->eth.mask.dst_mac,
+		       ETH_ALEN);
+		mlx4_spec->eth.vlan_tag = ib_spec->eth.val.vlan_tag;
+		mlx4_spec->eth.vlan_tag_msk = ib_spec->eth.mask.vlan_tag;
+		break;
+
+	case IB_FLOW_SPEC_IPV4:
+		type = MLX4_NET_TRANS_RULE_ID_IPV4;
+		mlx4_spec->ipv4.src_ip = ib_spec->ipv4.val.src_ip;
+		mlx4_spec->ipv4.src_ip_msk = ib_spec->ipv4.mask.src_ip;
+		mlx4_spec->ipv4.dst_ip = ib_spec->ipv4.val.dst_ip;
+		mlx4_spec->ipv4.dst_ip_msk = ib_spec->ipv4.mask.dst_ip;
+		break;
+
+	case IB_FLOW_SPEC_TCP:
+	case IB_FLOW_SPEC_UDP:
+		type = ib_spec->type == IB_FLOW_SPEC_TCP ?
+					MLX4_NET_TRANS_RULE_ID_TCP :
+					MLX4_NET_TRANS_RULE_ID_UDP;
+		mlx4_spec->tcp_udp.dst_port = ib_spec->tcp_udp.val.dst_port;
+		mlx4_spec->tcp_udp.dst_port_msk = ib_spec->tcp_udp.mask.dst_port;
+		mlx4_spec->tcp_udp.src_port = ib_spec->tcp_udp.val.src_port;
+		mlx4_spec->tcp_udp.src_port_msk = ib_spec->tcp_udp.mask.src_port;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	if (mlx4_map_sw_to_hw_steering_id(dev, type) < 0 ||
+	    mlx4_hw_rule_sz(dev, type) < 0)
+		return -EINVAL;
+	mlx4_spec->id = cpu_to_be16(mlx4_map_sw_to_hw_steering_id(dev, type));
+	mlx4_spec->size = mlx4_hw_rule_sz(dev, type) >> 2;
+	return mlx4_hw_rule_sz(dev, type);
+}
+
+static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_attr,
+			  int domain,
+			  enum mlx4_net_trans_promisc_mode flow_type,
+			  u64 *reg_id)
+{
+	int ret, i;
+	int size = 0;
+	void *ib_flow;
+	struct mlx4_ib_dev *mdev = to_mdev(qp->device);
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_net_trans_rule_hw_ctrl *ctrl;
+	size_t rule_size = sizeof(struct mlx4_net_trans_rule_hw_ctrl) +
+			   (sizeof(struct _rule_hw) * flow_attr->num_of_specs);
+
+	static const u16 __mlx4_domain[] = {
+		[IB_FLOW_DOMAIN_USER] = MLX4_DOMAIN_UVERBS,
+		[IB_FLOW_DOMAIN_ETHTOOL] = MLX4_DOMAIN_ETHTOOL,
+		[IB_FLOW_DOMAIN_RFS] = MLX4_DOMAIN_RFS,
+		[IB_FLOW_DOMAIN_NIC] = MLX4_DOMAIN_NIC,
+	};
+
+	if (flow_attr->priority > MLX4_IB_FLOW_MAX_PRIO) {
+		pr_err("Invalid priority value %d\n", flow_attr->priority);
+		return -EINVAL;
+	}
+
+	if (domain >= IB_FLOW_DOMAIN_NUM) {
+		pr_err("Invalid domain value %d\n", domain);
+		return -EINVAL;
+	}
+
+	if (mlx4_map_sw_to_hw_steering_mode(mdev->dev, flow_type) < 0)
+		return -EINVAL;
+
+	mailbox = mlx4_alloc_cmd_mailbox(mdev->dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	memset(mailbox->buf, 0, rule_size);
+	ctrl = mailbox->buf;
+
+	ctrl->prio = cpu_to_be16(__mlx4_domain[domain] |
+				 flow_attr->priority);
+	ctrl->type = mlx4_map_sw_to_hw_steering_mode(mdev->dev, flow_type);
+	ctrl->port = flow_attr->port;
+	ctrl->qpn = cpu_to_be32(qp->qp_num);
+
+	ib_flow = flow_attr + 1;
+	size += sizeof(struct mlx4_net_trans_rule_hw_ctrl);
+	for (i = 0; i < flow_attr->num_of_specs; i++) {
+		ret = parse_flow_attr(mdev->dev, ib_flow, mailbox->buf + size);
+		if (ret < 0) {
+			mlx4_free_cmd_mailbox(mdev->dev, mailbox);
+			return -EINVAL;
+		}
+		ib_flow += ((struct _ib_flow_spec *)ib_flow)->size;
+		size += ret;
+	}
+
+	ret = mlx4_cmd_imm(mdev->dev, mailbox->dma, reg_id, size >> 2, 0,
+			   MLX4_QP_FLOW_STEERING_ATTACH, MLX4_CMD_TIME_CLASS_A,
+			   MLX4_CMD_NATIVE);
+	if (ret == -ENOMEM)
+		pr_err("mcg table is full. Fail to register network rule.\n");
+	else if (ret == -ENXIO)
+		pr_err("Device managed flow steering is disabled. Fail to register network rule.\n");
+	else if (ret)
+		pr_err("Invalid argumant. Fail to register network rule.\n");
+
+	mlx4_free_cmd_mailbox(mdev->dev, mailbox);
+	return ret;
+}
+
+static int __mlx4_ib_destroy_flow(struct mlx4_dev *dev, u64 reg_id)
+{
+	int err;
+	err = mlx4_cmd(dev, reg_id, 0, 0,
+		       MLX4_QP_FLOW_STEERING_DETACH, MLX4_CMD_TIME_CLASS_A,
+		       MLX4_CMD_NATIVE);
+	if (err)
+		pr_err("Fail to detach network rule. registration id = 0x%llx\n",
+		       reg_id);
+	return err;
+}
+
+static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
+				    struct ib_flow_attr *flow_attr,
+				    int domain)
+{
+	int err = 0, i = 0;
+	struct mlx4_ib_flow *mflow;
+	enum mlx4_net_trans_promisc_mode type[2];
+
+	memset(type, 0, sizeof(type));
+
+	mflow = kzalloc(sizeof(*mflow), GFP_KERNEL);
+	if (!mflow) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	switch (flow_attr->type) {
+	case IB_FLOW_ATTR_NORMAL:
+		type[0] = MLX4_FS_REGULAR;
+		break;
+
+	case IB_FLOW_ATTR_ALL_DEFAULT:
+		type[0] = MLX4_FS_ALL_DEFAULT;
+		break;
+
+	case IB_FLOW_ATTR_MC_DEFAULT:
+		type[0] = MLX4_FS_MC_DEFAULT;
+		break;
+
+	case IB_FLOW_ATTR_SNIFFER:
+		type[0] = MLX4_FS_UC_SNIFFER;
+		type[1] = MLX4_FS_MC_SNIFFER;
+		break;
+
+	default:
+		err = -EINVAL;
+		goto err_free;
+	}
+
+	while (i < ARRAY_SIZE(type) && type[i]) {
+		err = __mlx4_ib_create_flow(qp, flow_attr, domain, type[i],
+					    &mflow->reg_id[i]);
+		if (err)
+			goto err_free;
+		i++;
+	}
+
+	return &mflow->ibflow;
+
+err_free:
+	kfree(mflow);
+	return ERR_PTR(err);
+}
+
+static int mlx4_ib_destroy_flow(struct ib_flow *flow_id)
+{
+	int err, ret = 0;
+	int i = 0;
+	struct mlx4_ib_dev *mdev = to_mdev(flow_id->qp->device);
+	struct mlx4_ib_flow *mflow = to_mflow(flow_id);
+
+	while (i < ARRAY_SIZE(mflow->reg_id) && mflow->reg_id[i]) {
+		err = __mlx4_ib_destroy_flow(mdev->dev, mflow->reg_id[i]);
+		if (err)
+			ret = err;
+		i++;
+	}
+
+	kfree(mflow);
+	return ret;
+}
+
 static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
 	int err;
@@ -1461,6 +1687,15 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD);
 	}
 
+	if (check_flow_steering_support(dev)) {
+		ibdev->ib_dev.create_flow	= mlx4_ib_create_flow;
+		ibdev->ib_dev.destroy_flow	= mlx4_ib_destroy_flow;
+
+		ibdev->ib_dev.uverbs_cmd_mask	|=
+			(1ull << IB_USER_VERBS_CMD_CREATE_FLOW) |
+			(1ull << IB_USER_VERBS_CMD_DESTROY_FLOW);
+	}
+
 	mlx4_ib_alloc_eqs(dev, ibdev);
 
 	spin_lock_init(&iboe->lock);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index f61ec26..036b663 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -132,6 +132,12 @@ struct mlx4_ib_fmr {
 	struct mlx4_fmr         mfmr;
 };
 
+struct mlx4_ib_flow {
+	struct ib_flow ibflow;
+	/* translating DMFS verbs sniffer rule to FW API requires two reg IDs */
+	u64 reg_id[2];
+};
+
 struct mlx4_ib_wq {
 	u64		       *wrid;
 	spinlock_t		lock;
@@ -552,6 +558,12 @@ static inline struct mlx4_ib_fmr *to_mfmr(struct ib_fmr *ibfmr)
 {
 	return container_of(ibfmr, struct mlx4_ib_fmr, ibfmr);
 }
+
+static inline struct mlx4_ib_flow *to_mflow(struct ib_flow *ibflow)
+{
+	return container_of(ibflow, struct mlx4_ib_flow, ibflow);
+}
+
 static inline struct mlx4_ib_qp *to_mqp(struct ib_qp *ibqp)
 {
 	return container_of(ibqp, struct mlx4_ib_qp, ibqp);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 52c23a8..d73423c 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1052,11 +1052,6 @@ struct _rule_hw {
 	};
 };
 
-/* translating DMFS verbs sniffer rule to the FW API would need two reg IDs */
-struct mlx4_flow_handle {
-	u64 reg_id[2];
-};
-
 int mlx4_flow_steer_promisc_add(struct mlx4_dev *dev, u8 port, u32 qpn,
 				enum mlx4_net_trans_promisc_mode mode);
 int mlx4_flow_steer_promisc_remove(struct mlx4_dev *dev, u8 port,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
