From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V1 08/29] {NET,IB}/mlx4: Use port management change event instead of smp_snoop
Date: Tue, 19 Jun 2012 11:21:40 +0300
Message-ID: <1340094121-14858-9-git-send-email-jackm@dev.mellanox.co.il>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340094121-14858-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The port management change event can replace smp_snoop. If the
capability bit for this event is set in dev-caps, the event is used
(by the driver setting the PORT_MNG_CHG_EVENT bit in the async event
mask in the MAP_EQ fw command).  In this case, when the driver
passes incoming SMP PORT_INFO SET mads to the FW, the FW
generates port management change events to signal any changes
to the driver.

If the FW generates these events, smp_snoop must
not be invoked in ib_process_mad, or duplicate events will occur
(once from the FW-generated event, and once from smp_snoop).

In the case where the FW does not generate port management change
events, however, smp_snoop must be invoked to create these events.
The flow in smp_snoop has been modified to make use of the same
procedures as in the fw-generated-event event case to generate
the port management events (LID change, Client-rereg,
Pkey change, and/or GID change).

Note: Port management change event handling required changing the
mlx4_ib_event and mlx4_dispatch_event prototypes; the "param" argument
(last argument) had to be changed to unsigned long in order to
accomodate passing the EQE pointer.

We also needed to move the definition of struct mlx4_eqe from
net/mlx4.h to file device.h -- to make it available to the IB
driver, to handle port management change events.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c             |  119 ++++++++++++++++++++------
 drivers/infiniband/hw/mlx4/main.c            |   29 +++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |    9 ++
 drivers/net/ethernet/mellanox/mlx4/en_main.c |    5 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c      |   22 ++++-
 drivers/net/ethernet/mellanox/mlx4/fw.c      |    1 +
 drivers/net/ethernet/mellanox/mlx4/intf.c    |    5 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |   63 +-------------
 include/linux/mlx4/device.h                  |   99 +++++++++++++++++++++-
 include/linux/mlx4/driver.h                  |    3 +-
 10 files changed, 250 insertions(+), 105 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 84786a9..dbf315f 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -147,47 +147,50 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
 }
 
 /*
- * Snoop SM MADs for port info and P_Key table sets, so we can
- * synthesize LID change and P_Key change events.
+ * Snoop SM MADs for port info, GUID info, and  P_Key table sets, so we can
+ * synthesize LID change, Client-Rereg, GID change, and P_Key change events.
  */
+
 static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
-				u16 prev_lid)
+		      u16 prev_lid)
 {
-	struct ib_event event;
+	struct ib_port_info *pinfo;
+	u16 lid;
 
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	if ((mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED ||
 	     mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) &&
-	    mad->mad_hdr.method == IB_MGMT_METHOD_SET) {
-		if (mad->mad_hdr.attr_id == IB_SMP_ATTR_PORT_INFO) {
-			struct ib_port_info *pinfo =
-				(struct ib_port_info *) ((struct ib_smp *) mad)->data;
-			u16 lid = be16_to_cpu(pinfo->lid);
+	    mad->mad_hdr.method == IB_MGMT_METHOD_SET)
+		switch (mad->mad_hdr.attr_id) {
+		case IB_SMP_ATTR_PORT_INFO:
+			pinfo = (struct ib_port_info *) ((struct ib_smp *) mad)->data;
+			lid = be16_to_cpu(pinfo->lid);
 
-			update_sm_ah(to_mdev(ibdev), port_num,
+			update_sm_ah(dev, port_num,
 				     be16_to_cpu(pinfo->sm_lid),
 				     pinfo->neighbormtu_mastersmsl & 0xf);
 
-			event.device	       = ibdev;
-			event.element.port_num = port_num;
+			if (pinfo->clientrereg_resv_subnetto & 0x80)
+				mlx4_ib_dispatch_event(dev, port_num,
+						       IB_EVENT_CLIENT_REREGISTER);
 
-			if (pinfo->clientrereg_resv_subnetto & 0x80) {
-				event.event    = IB_EVENT_CLIENT_REREGISTER;
-				ib_dispatch_event(&event);
-			}
+			if (prev_lid != lid)
+				mlx4_ib_dispatch_event(dev, port_num,
+						       IB_EVENT_LID_CHANGE);
+			break;
 
-			if (prev_lid != lid) {
-				event.event    = IB_EVENT_LID_CHANGE;
-				ib_dispatch_event(&event);
-			}
-		}
+		case IB_SMP_ATTR_PKEY_TABLE:
+			mlx4_ib_dispatch_event(dev, port_num,
+					       IB_EVENT_PKEY_CHANGE);
+			break;
 
-		if (mad->mad_hdr.attr_id == IB_SMP_ATTR_PKEY_TABLE) {
-			event.device	       = ibdev;
-			event.event	       = IB_EVENT_PKEY_CHANGE;
-			event.element.port_num = port_num;
-			ib_dispatch_event(&event);
+		case IB_SMP_ATTR_GUID_INFO:
+			mlx4_ib_dispatch_event(dev, port_num,
+					       IB_EVENT_GID_CHANGE);
+			break;
+		default:
+			break;
 		}
-	}
 }
 
 static void node_desc_override(struct ib_device *dev,
@@ -305,7 +308,8 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		return IB_MAD_RESULT_FAILURE;
 
 	if (!out_mad->mad_hdr.status) {
-		smp_snoop(ibdev, port_num, in_mad, prev_lid);
+		if (!(to_mdev(ibdev)->dev->caps.flags & MLX4_DEV_CAP_FLAG_PORT_MNG_CHG_EV))
+			smp_snoop(ibdev, port_num, in_mad, prev_lid);
 		node_desc_override(ibdev, out_mad);
 	}
 
@@ -446,3 +450,62 @@ void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev)
 			ib_destroy_ah(dev->sm_ah[p]);
 	}
 }
+
+void handle_port_mgmt_change_event(struct work_struct *work)
+{
+	struct ib_event_work *ew = container_of(work, struct ib_event_work, work);
+	struct mlx4_ib_dev *dev = ew->ib_dev;
+	struct mlx4_eqe *eqe = &(ew->ib_eqe);
+	u8 port = eqe->event.port_mgmt_change.port;
+	u32 changed_attr;
+
+	switch (eqe->subtype) {
+	case MLX4_DEV_PMC_SUBTYPE_PORT_INFO:
+		changed_attr = be32_to_cpu(eqe->event.port_mgmt_change.params.port_info.changed_attr);
+
+		/* Update the SM ah - This should be done before handling
+		   the other changed attributes so that MADs can be sent to the SM */
+		if (changed_attr & MSTR_SM_CHANGE_MASK) {
+			u16 lid = be16_to_cpu(eqe->event.port_mgmt_change.params.port_info.mstr_sm_lid);
+			u8 sl = eqe->event.port_mgmt_change.params.port_info.mstr_sm_sl & 0xf;
+			update_sm_ah(dev, port, lid, sl);
+		}
+
+		/* Check if it is a lid change event */
+		if (changed_attr & MLX4_EQ_PORT_INFO_LID_CHANGE_MASK)
+			mlx4_ib_dispatch_event(dev, port, IB_EVENT_LID_CHANGE);
+
+		/* Generate GUID changed event */
+		if (changed_attr & MLX4_EQ_PORT_INFO_GID_PFX_CHANGE_MASK)
+			mlx4_ib_dispatch_event(dev, port, IB_EVENT_GID_CHANGE);
+
+		if (changed_attr & MLX4_EQ_PORT_INFO_CLIENT_REREG_MASK)
+			mlx4_ib_dispatch_event(dev, port,
+					       IB_EVENT_CLIENT_REREGISTER);
+		break;
+
+	case MLX4_DEV_PMC_SUBTYPE_PKEY_TABLE:
+		mlx4_ib_dispatch_event(dev, port, IB_EVENT_PKEY_CHANGE);
+		break;
+	case MLX4_DEV_PMC_SUBTYPE_GUID_INFO:
+		mlx4_ib_dispatch_event(dev, port, IB_EVENT_GID_CHANGE);
+		break;
+	default:
+		pr_warn("Unsupported subtype 0x%x for "
+			"Port Management Change event\n", eqe->subtype);
+	}
+
+	kfree(ew);
+}
+
+void mlx4_ib_dispatch_event(struct mlx4_ib_dev *dev, u8 port_num,
+			    enum ib_event_type type)
+{
+	struct ib_event event;
+
+	event.device		= &dev->ib_dev;
+	event.element.port_num	= port_num;
+	event.event		= type;
+
+	ib_dispatch_event(&event);
+}
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 5266b49..4f230c2 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -898,7 +898,6 @@ static void update_gids_task(struct work_struct *work)
 	union ib_gid *gids;
 	int err;
 	struct mlx4_dev	*dev = gw->dev->dev;
-	struct ib_event event;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
@@ -916,10 +915,7 @@ static void update_gids_task(struct work_struct *work)
 		pr_warn("set port command failed\n");
 	else {
 		memcpy(gw->dev->iboe.gid_table[gw->port - 1], gw->gids, sizeof gw->gids);
-		event.device = &gw->dev->ib_dev;
-		event.element.port_num = gw->port;
-		event.event    = IB_EVENT_GID_CHANGE;
-		ib_dispatch_event(&event);
+		mlx4_ib_dispatch_event(gw->dev, gw->port, IB_EVENT_GID_CHANGE);
 	}
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
@@ -1383,10 +1379,18 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 }
 
 static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
-			  enum mlx4_dev_event event, int port)
+			  enum mlx4_dev_event event, unsigned long param)
 {
 	struct ib_event ibev;
 	struct mlx4_ib_dev *ibdev = to_mdev((struct ib_device *) ibdev_ptr);
+	struct mlx4_eqe *eqe = NULL;
+	struct ib_event_work *ew;
+	int port = 0;
+
+	if (event == MLX4_DEV_EVENT_PORT_MGMT_CHANGE)
+		eqe = (struct mlx4_eqe *)param;
+	else
+		port = (u8)param;
 
 	if (port > ibdev->num_ports)
 		return;
@@ -1405,6 +1409,19 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 		ibev.event = IB_EVENT_DEVICE_FATAL;
 		break;
 
+	case MLX4_DEV_EVENT_PORT_MGMT_CHANGE:
+		ew = kmalloc(sizeof *ew, GFP_ATOMIC);
+		if (!ew) {
+			pr_err("failed to allocate memory for events work\n");
+			break;
+		}
+
+		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
+		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);
+		ew->ib_dev = ibdev;
+		handle_port_mgmt_change_event(&ew->work);
+		return;
+
 	default:
 		return;
 	}
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 5f298af..23bfbf9 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -224,6 +224,12 @@ struct mlx4_ib_dev {
 	int			eq_added;
 };
 
+struct ib_event_work {
+	struct work_struct	work;
+	struct mlx4_ib_dev	*ib_dev;
+	struct mlx4_eqe		ib_eqe;
+};
+
 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
 {
 	return container_of(ibdev, struct mlx4_ib_dev, ib_dev);
@@ -381,4 +387,7 @@ static inline int mlx4_ib_ah_grh_present(struct mlx4_ib_ah *ah)
 int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 		   union ib_gid *gid);
 
+void mlx4_ib_dispatch_event(struct mlx4_ib_dev *dev, u8 port_num,
+			    enum ib_event_type type);
+
 #endif /* MLX4_IB_H */
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index 69ba572..a52922e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -131,7 +131,7 @@ static void *mlx4_en_get_netdev(struct mlx4_dev *dev, void *ctx, u8 port)
 }
 
 static void mlx4_en_event(struct mlx4_dev *dev, void *endev_ptr,
-			  enum mlx4_dev_event event, int port)
+			  enum mlx4_dev_event event, unsigned long port)
 {
 	struct mlx4_en_dev *mdev = (struct mlx4_en_dev *) endev_ptr;
 	struct mlx4_en_priv *priv;
@@ -156,7 +156,8 @@ static void mlx4_en_event(struct mlx4_dev *dev, void *endev_ptr,
 		if (port < 1 || port > dev->caps.num_ports ||
 		    !mdev->pndev[port])
 			return;
-		mlx4_warn(mdev, "Unhandled event %d for port %d\n", event, port);
+		mlx4_warn(mdev, "Unhandled event %d for port %d\n", event,
+			  (int) port);
 	}
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index bce98d9..9b15d02 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -82,6 +82,15 @@ enum {
 			       (1ull << MLX4_EVENT_TYPE_FLR_EVENT)	    | \
 			       (1ull << MLX4_EVENT_TYPE_FATAL_WARNING))
 
+static u64 get_async_ev_mask(struct mlx4_dev *dev)
+{
+	u64 async_ev_mask = MLX4_ASYNC_EVENT_MASK;
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_PORT_MNG_CHG_EV)
+		async_ev_mask |= (1ull << MLX4_EVENT_TYPE_PORT_MNG_CHG_EVENT);
+
+	return async_ev_mask;
+}
+
 static void eq_set_ci(struct mlx4_eq *eq, int req_not)
 {
 	__raw_writel((__force u32) cpu_to_be32((eq->cons_index & 0xffffff) |
@@ -473,6 +482,11 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 
 			break;
 
+		case MLX4_EVENT_TYPE_PORT_MNG_CHG_EVENT:
+			mlx4_dispatch_event(dev, MLX4_DEV_EVENT_PORT_MGMT_CHANGE,
+					    (unsigned long) eqe);
+			break;
+
 		case MLX4_EVENT_TYPE_EEC_CATAS_ERROR:
 		case MLX4_EVENT_TYPE_ECC_DETECT:
 		default:
@@ -956,7 +970,7 @@ int mlx4_init_eq_table(struct mlx4_dev *dev)
 		priv->eq_table.have_irq = 1;
 	}
 
-	err = mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 0,
+	err = mlx4_MAP_EQ(dev, get_async_ev_mask(dev), 0,
 			  priv->eq_table.eq[dev->caps.num_comp_vectors].eqn);
 	if (err)
 		mlx4_warn(dev, "MAP_EQ for async EQ %d failed (%d)\n",
@@ -996,7 +1010,7 @@ void mlx4_cleanup_eq_table(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int i;
 
-	mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 1,
+	mlx4_MAP_EQ(dev, get_async_ev_mask(dev), 1,
 		    priv->eq_table.eq[dev->caps.num_comp_vectors].eqn);
 
 	mlx4_free_irqs(dev);
@@ -1040,7 +1054,7 @@ int mlx4_test_interrupts(struct mlx4_dev *dev)
 		mlx4_cmd_use_polling(dev);
 
 		/* Map the new eq to handle all asyncronous events */
-		err = mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 0,
+		err = mlx4_MAP_EQ(dev, get_async_ev_mask(dev), 0,
 				  priv->eq_table.eq[i].eqn);
 		if (err) {
 			mlx4_warn(dev, "Failed mapping eq for interrupt test\n");
@@ -1054,7 +1068,7 @@ int mlx4_test_interrupts(struct mlx4_dev *dev)
 	}
 
 	/* Return to default */
-	mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 0,
+	mlx4_MAP_EQ(dev, get_async_ev_mask(dev), 0,
 		    priv->eq_table.eq[dev->caps.num_comp_vectors].eqn);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 7c579cf..1e5a10e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -109,6 +109,7 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
 		[41] = "Unicast VEP steering support",
 		[42] = "Multicast VEP steering support",
 		[48] = "Counters support",
+		[59] = "Port management change event support",
 	};
 	int i;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c b/drivers/net/ethernet/mellanox/mlx4/intf.c
index b4e9f6f..116895a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ -115,7 +115,8 @@ void mlx4_unregister_interface(struct mlx4_interface *intf)
 }
 EXPORT_SYMBOL_GPL(mlx4_unregister_interface);
 
-void mlx4_dispatch_event(struct mlx4_dev *dev, enum mlx4_dev_event type, int port)
+void mlx4_dispatch_event(struct mlx4_dev *dev, enum mlx4_dev_event type,
+			 unsigned long param)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_device_context *dev_ctx;
@@ -125,7 +126,7 @@ void mlx4_dispatch_event(struct mlx4_dev *dev, enum mlx4_dev_event type, int por
 
 	list_for_each_entry(dev_ctx, &priv->ctx_list, list)
 		if (dev_ctx->intf->event)
-			dev_ctx->intf->event(dev, dev_ctx->context, type, port);
+			dev_ctx->intf->event(dev, dev_ctx->context, type, param);
 
 	spin_unlock_irqrestore(&priv->ctx_lock, flags);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index e5d2022..4d11d12 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -338,66 +338,6 @@ struct mlx4_srq_context {
 	__be64			db_rec_addr;
 };
 
-struct mlx4_eqe {
-	u8			reserved1;
-	u8			type;
-	u8			reserved2;
-	u8			subtype;
-	union {
-		u32		raw[6];
-		struct {
-			__be32	cqn;
-		} __packed comp;
-		struct {
-			u16	reserved1;
-			__be16	token;
-			u32	reserved2;
-			u8	reserved3[3];
-			u8	status;
-			__be64	out_param;
-		} __packed cmd;
-		struct {
-			__be32	qpn;
-		} __packed qp;
-		struct {
-			__be32	srqn;
-		} __packed srq;
-		struct {
-			__be32	cqn;
-			u32	reserved1;
-			u8	reserved2[3];
-			u8	syndrome;
-		} __packed cq_err;
-		struct {
-			u32	reserved1[2];
-			__be32	port;
-		} __packed port_change;
-		struct {
-			#define COMM_CHANNEL_BIT_ARRAY_SIZE	4
-			u32 reserved;
-			u32 bit_vec[COMM_CHANNEL_BIT_ARRAY_SIZE];
-		} __packed comm_channel_arm;
-		struct {
-			u8	port;
-			u8	reserved[3];
-			__be64	mac;
-		} __packed mac_update;
-		struct {
-			u8	port;
-		} __packed sw_event;
-		struct {
-			__be32	slave_id;
-		} __packed flr_event;
-		struct {
-			__be16  current_temperature;
-			__be16  warning_threshold;
-		} __packed warming;
-	}			event;
-	u8			slave_id;
-	u8			reserved3[2];
-	u8			owner;
-} __packed;
-
 struct mlx4_eq {
 	struct mlx4_dev	       *dev;
 	void __iomem	       *doorbell;
@@ -887,7 +827,8 @@ void mlx4_catas_init(void);
 int mlx4_restart_one(struct pci_dev *pdev);
 int mlx4_register_device(struct mlx4_dev *dev);
 void mlx4_unregister_device(struct mlx4_dev *dev);
-void mlx4_dispatch_event(struct mlx4_dev *dev, enum mlx4_dev_event type, int port);
+void mlx4_dispatch_event(struct mlx4_dev *dev, enum mlx4_dev_event type,
+			 unsigned long param);
 
 struct mlx4_dev_cap;
 struct mlx4_init_hca_param;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 8eadf0f..560b220 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -96,7 +96,8 @@ enum {
 	MLX4_DEV_CAP_FLAG_VEP_UC_STEER	= 1LL << 41,
 	MLX4_DEV_CAP_FLAG_VEP_MC_STEER	= 1LL << 42,
 	MLX4_DEV_CAP_FLAG_COUNTERS	= 1LL << 48,
-	MLX4_DEV_CAP_FLAG_SENSE_SUPPORT	= 1LL << 55
+	MLX4_DEV_CAP_FLAG_SENSE_SUPPORT	= 1LL << 55,
+	MLX4_DEV_CAP_FLAG_PORT_MNG_CHG_EV = 1LL << 59,
 };
 
 enum {
@@ -138,6 +139,7 @@ enum mlx4_event {
 	MLX4_EVENT_TYPE_COMM_CHANNEL	   = 0x18,
 	MLX4_EVENT_TYPE_FATAL_WARNING	   = 0x1b,
 	MLX4_EVENT_TYPE_FLR_EVENT	   = 0x1c,
+	MLX4_EVENT_TYPE_PORT_MNG_CHG_EVENT = 0x1d,
 	MLX4_EVENT_TYPE_NONE		   = 0xff,
 };
 
@@ -235,6 +237,24 @@ enum {
 	MLX4_MAX_FAST_REG_PAGES = 511,
 };
 
+enum {
+	MLX4_DEV_PMC_SUBTYPE_GUID_INFO	 = 0x14,
+	MLX4_DEV_PMC_SUBTYPE_PORT_INFO	 = 0x15,
+	MLX4_DEV_PMC_SUBTYPE_PKEY_TABLE	 = 0x16,
+};
+
+/* Port mgmt change event handling */
+enum {
+	MLX4_EQ_PORT_INFO_MSTR_SM_LID_CHANGE_MASK	= 1 << 0,
+	MLX4_EQ_PORT_INFO_GID_PFX_CHANGE_MASK		= 1 << 1,
+	MLX4_EQ_PORT_INFO_LID_CHANGE_MASK		= 1 << 2,
+	MLX4_EQ_PORT_INFO_CLIENT_REREG_MASK		= 1 << 3,
+	MLX4_EQ_PORT_INFO_MSTR_SM_SL_CHANGE_MASK	= 1 << 4,
+};
+
+#define MSTR_SM_CHANGE_MASK (MLX4_EQ_PORT_INFO_MSTR_SM_SL_CHANGE_MASK | \
+			     MLX4_EQ_PORT_INFO_MSTR_SM_LID_CHANGE_MASK)
+
 static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 {
 	return (major << 32) | (minor << 16) | subminor;
@@ -511,6 +531,81 @@ struct mlx4_dev {
 	int			num_vfs;
 };
 
+struct mlx4_eqe {
+	u8			reserved1;
+	u8			type;
+	u8			reserved2;
+	u8			subtype;
+	union {
+		u32		raw[6];
+		struct {
+			__be32	cqn;
+		} __packed comp;
+		struct {
+			u16	reserved1;
+			__be16	token;
+			u32	reserved2;
+			u8	reserved3[3];
+			u8	status;
+			__be64	out_param;
+		} __packed cmd;
+		struct {
+			__be32	qpn;
+		} __packed qp;
+		struct {
+			__be32	srqn;
+		} __packed srq;
+		struct {
+			__be32	cqn;
+			u32	reserved1;
+			u8	reserved2[3];
+			u8	syndrome;
+		} __packed cq_err;
+		struct {
+			u32	reserved1[2];
+			__be32	port;
+		} __packed port_change;
+		struct {
+			#define COMM_CHANNEL_BIT_ARRAY_SIZE	4
+			u32 reserved;
+			u32 bit_vec[COMM_CHANNEL_BIT_ARRAY_SIZE];
+		} __packed comm_channel_arm;
+		struct {
+			u8	port;
+			u8	reserved[3];
+			__be64	mac;
+		} __packed mac_update;
+		struct {
+			__be32	slave_id;
+		} __packed flr_event;
+		struct {
+			__be16  current_temperature;
+			__be16  warning_threshold;
+		} __packed warming;
+		struct {
+			u8 reserved[3];
+			u8 port;
+			union {
+				struct {
+					__be16 mstr_sm_lid;
+					__be16 port_lid;
+					__be32 changed_attr;
+					u8 reserved[3];
+					u8 mstr_sm_sl;
+					__be64 gid_prefix;
+				} __packed port_info;
+				struct {
+					__be32 block_ptr;
+					__be32 tbl_entries_mask;
+				} __packed tbl_change_info;
+			} params;
+		} __packed port_mgmt_change;
+	}			event;
+	u8			slave_id;
+	u8			reserved3[2];
+	u8			owner;
+} __packed;
+
 struct mlx4_init_port_param {
 	int			set_guid0;
 	int			set_node_guid;
@@ -536,6 +631,8 @@ struct mlx4_init_port_param {
 
 #define MLX4_INVALID_SLAVE_ID	0xFF
 
+void handle_port_mgmt_change_event(struct work_struct *work);
+
 static inline int mlx4_is_master(struct mlx4_dev *dev)
 {
 	return dev->flags & MLX4_FLAG_MASTER;
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index 5f1298b..0f50922 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -42,13 +42,14 @@ enum mlx4_dev_event {
 	MLX4_DEV_EVENT_PORT_UP,
 	MLX4_DEV_EVENT_PORT_DOWN,
 	MLX4_DEV_EVENT_PORT_REINIT,
+	MLX4_DEV_EVENT_PORT_MGMT_CHANGE,
 };
 
 struct mlx4_interface {
 	void *			(*add)	 (struct mlx4_dev *dev);
 	void			(*remove)(struct mlx4_dev *dev, void *context);
 	void			(*event) (struct mlx4_dev *dev, void *context,
-					  enum mlx4_dev_event event, int port);
+					  enum mlx4_dev_event event, unsigned long param);
 	void *			(*get_dev)(struct mlx4_dev *dev, void *context, u8 port);
 	struct list_head	list;
 	enum mlx4_protocol	protocol;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
