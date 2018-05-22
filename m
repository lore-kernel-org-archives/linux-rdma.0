From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next] i40iw/i40e: Remove link dependency on i40e
Date: Tue, 22 May 2018 13:38:31 -0700
Message-ID: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, dledford@redhat.com, jgg@mellanox.com
Cc: Sindhu Devale <sindhu.devale@intel.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com, jogreene@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Sindhu Devale <sindhu.devale@intel.com>

Currently i40iw is dependent on i40e symbols
i40e_register_client and i40e_unregister_client due to
which i40iw cannot be loaded without i40e being loaded.

This patch allows RDMA driver to build and load without
linking to LAN driver and without LAN driver being loaded
first. Once the LAN driver is loaded, the RDMA driver
is notified through the netdevice notifiers to register
as client to the LAN driver. Add function pointers to IDC
register/unregister in the private VSI structure. This
allows a RDMA driver to build without linking to i40e.

Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/infiniband/hw/i40iw/i40iw.h           |  24 +++
 drivers/infiniband/hw/i40iw/i40iw_main.c      | 141 ++++++++++++++++--
 drivers/infiniband/hw/i40iw/i40iw_utils.c     |   5 +-
 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_client.h |   9 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   6 +
 6 files changed, 173 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index d5d8c1be345a..c6398b73a8da 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -119,6 +119,30 @@
 #define I40IW_CQP_COMPL_SQ_WQE_FLUSHED    3
 #define I40IW_CQP_COMPL_RQ_SQ_WQE_FLUSHED 4
 
+enum I40IW_IDC_STATE {
+	I40IW_STATE_INVALID,
+	I40IW_STATE_VALID,
+	I40IW_STATE_REG_FAILED
+};
+
+struct i40iw_peer {
+	struct module *module;
+#define MAX_PEER_NAME_SIZE 8
+	char name[MAX_PEER_NAME_SIZE];
+	enum I40IW_IDC_STATE state;
+	atomic_t ref_count;
+	int (*idc_reg_peer_driver)(struct i40e_client *i40iw_client);
+	int (*idc_unreg_peer_driver)(struct i40e_client *i40iw_client);
+};
+
+struct i40iw_peer_drv {
+	struct i40e_client i40iw_client;
+	struct i40iw_peer peer;
+};
+
+bool i40iw_is_new_peer(struct net_device *netdev);
+void i40iw_reg_peer(void);
+
 struct i40iw_cqp_compl_info {
 	u32 op_ret_val;
 	u16 maj_err_code;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 9cd0d3ef9057..f4c5be11c1d4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -78,6 +78,7 @@ MODULE_AUTHOR("Intel Corporation, <e1000-rdma@lists.sourceforge.net>");
 MODULE_DESCRIPTION("Intel(R) Ethernet Connection X722 iWARP RDMA Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 
+static struct i40iw_peer_drv peer_drv;
 static struct i40e_client i40iw_client;
 static char i40iw_client_name[I40E_CLIENT_STR_LENGTH] = "i40iw";
 
@@ -103,6 +104,30 @@ static struct notifier_block i40iw_netdevice_notifier = {
 	.notifier_call = i40iw_netdevice_event
 };
 
+/**
+ * i40iw_open_inc_ref - Increment ref count for a open
+ */
+static void i40iw_open_inc_ref(void)
+{
+	atomic_inc(&peer_drv.peer.ref_count);
+}
+
+/**
+ * i40iw_open_dec_ref - Decrement ref count for a open
+ */
+static void i40iw_open_dec_ref(void)
+{
+	struct i40iw_peer *peer;
+
+	peer = &peer_drv.peer;
+	if (peer->state == I40IW_STATE_VALID &&
+	    atomic_dec_and_test(&peer->ref_count)) {
+		peer->state = I40IW_STATE_INVALID;
+		peer->idc_unreg_peer_driver(&peer_drv.i40iw_client);
+		module_put(peer->module);
+	}
+}
+
 /**
  * i40iw_find_i40e_handler - find a handler given a client info
  * @ldev: pointer to a client info
@@ -1710,6 +1735,7 @@ static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
 		if(iwdev->param_wq == NULL)
 			break;
 		i40iw_pr_info("i40iw_open completed\n");
+		i40iw_open_inc_ref();
 		return 0;
 	} while (0);
 
@@ -1801,6 +1827,7 @@ static void i40iw_close(struct i40e_info *ldev, struct i40e_client *client, bool
 	i40iw_cm_teardown_connections(iwdev, NULL, NULL, true);
 	destroy_workqueue(iwdev->virtchnl_wq);
 	i40iw_deinit_device(iwdev);
+	i40iw_open_dec_ref();
 }
 
 /**
@@ -2024,6 +2051,104 @@ static const struct i40e_client_ops i40e_ops = {
 	.vf_capable = i40iw_vf_capable
 };
 
+/**
+ * i40iw_is_new_peer - check netdev of the peer driver
+ * @netdev: netdev of peer driver
+ */
+bool i40iw_is_new_peer(struct net_device *netdev)
+{
+	struct idc_srv_provider *sp;
+	struct i40iw_peer *peer;
+
+	peer = &peer_drv.peer;
+	if (peer->state == I40IW_STATE_VALID)
+		return false;
+
+	if (netdev->dev.parent && netdev->dev.parent->driver &&
+	    !strncmp(netdev->dev.parent->driver->name, peer->name, sizeof(peer->name))) {
+		sp = (struct idc_srv_provider *)netdev_priv(netdev);
+		if (sp->signature != IDC_SIGNATURE || sp->version)
+			return false;
+
+		/* Found the driver */
+		peer->idc_reg_peer_driver = sp->idc_reg_peer_driver;
+		peer->idc_unreg_peer_driver = sp->idc_unreg_peer_driver;
+		peer->module = netdev->dev.parent->driver->owner;
+
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * i40iw_initialize_client - Setup client struct
+ */
+static void i40iw_initialize_client(void)
+{
+	struct i40e_client *i40iw_client = &peer_drv.i40iw_client;
+
+	i40iw_client->version.major = CLIENT_IW_INTERFACE_VERSION_MAJOR;
+	i40iw_client->version.minor = CLIENT_IW_INTERFACE_VERSION_MINOR;
+	i40iw_client->version.build = CLIENT_IW_INTERFACE_VERSION_BUILD;
+	i40iw_client->ops = &i40e_ops;
+	memcpy(i40iw_client->name, i40iw_client_name, I40E_CLIENT_STR_LENGTH);
+	i40iw_client->type = I40E_CLIENT_IWARP;
+	strncpy(peer_drv.peer.name, "i40e", sizeof(peer_drv.peer.name));
+}
+
+/**
+ * i40iw_reg_peer - Register with peer
+ */
+void i40iw_reg_peer(void)
+{
+	struct i40iw_peer *peer;
+
+	peer = &peer_drv.peer;
+
+	if (peer->state == I40IW_STATE_VALID)
+		return;
+
+	if (peer->idc_reg_peer_driver &&
+	    !peer->idc_reg_peer_driver(&peer_drv.i40iw_client)) {
+		peer->state = I40IW_STATE_VALID;
+		try_module_get(peer->module);
+	} else {
+		peer->state = I40IW_STATE_REG_FAILED;
+	}
+}
+
+/**
+ * i40iw_find_idc_peer - Search netdevs for a peer driver
+ */
+static void i40iw_find_idc_peer(void)
+{
+	struct net_device *dev;
+
+	rcu_read_lock();
+	for_each_netdev_rcu(&init_net, dev) {
+		if (i40iw_is_new_peer(dev))
+			break;
+	}
+	rcu_read_unlock();
+	i40iw_reg_peer();
+}
+
+/**
+ * i40iw_unreg_peer - Unregister with peer
+ */
+static void i40iw_unreg_peer(void)
+{
+	struct i40iw_peer *peer;
+
+	peer = &peer_drv.peer;
+	if (peer->state == I40IW_STATE_VALID) {
+		peer->state = I40IW_STATE_INVALID;
+		peer->idc_unreg_peer_driver(&peer_drv.i40iw_client);
+		module_put(peer->module);
+	}
+}
+
 /**
  * i40iw_init_module - driver initialization function
  *
@@ -2032,20 +2157,12 @@ static const struct i40e_client_ops i40e_ops = {
  */
 static int __init i40iw_init_module(void)
 {
-	int ret;
-
-	memset(&i40iw_client, 0, sizeof(i40iw_client));
-	i40iw_client.version.major = CLIENT_IW_INTERFACE_VERSION_MAJOR;
-	i40iw_client.version.minor = CLIENT_IW_INTERFACE_VERSION_MINOR;
-	i40iw_client.version.build = CLIENT_IW_INTERFACE_VERSION_BUILD;
-	i40iw_client.ops = &i40e_ops;
-	memcpy(i40iw_client.name, i40iw_client_name, I40E_CLIENT_STR_LENGTH);
-	i40iw_client.type = I40E_CLIENT_IWARP;
 	spin_lock_init(&i40iw_handler_lock);
-	ret = i40e_register_client(&i40iw_client);
+	i40iw_initialize_client();
+	i40iw_find_idc_peer();
 	i40iw_register_notifiers();
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -2057,7 +2174,7 @@ static int __init i40iw_init_module(void)
 static void __exit i40iw_exit_module(void)
 {
 	i40iw_unregister_notifiers();
-	i40e_unregister_client(&i40iw_client);
+	i40iw_unreg_peer();
 }
 
 module_init(i40iw_init_module);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index a9ea966877f2..264939942da0 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -314,8 +314,11 @@ int i40iw_netdevice_event(struct notifier_block *notifier,
 	event_netdev = netdev_notifier_info_to_dev(ptr);
 
 	hdl = i40iw_find_netdev(event_netdev);
-	if (!hdl)
+	if (!hdl) {
+		if (i40iw_is_new_peer(event_netdev))
+			i40iw_reg_peer();
 		return NOTIFY_DONE;
+	}
 
 	iwdev = &hdl->device;
 	if (iwdev->init_state < RDMA_DEV_REGISTERED || iwdev->closing)
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 7a80652e2500..e3171b696848 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -789,6 +789,7 @@ struct i40e_vsi {
 } ____cacheline_internodealigned_in_smp;
 
 struct i40e_netdev_priv {
+	struct idc_srv_provider prov_callbacks;
 	struct i40e_vsi *vsi;
 };
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.h b/drivers/net/ethernet/intel/i40e/i40e_client.h
index 72994baf4941..95a47df9c104 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.h
@@ -44,6 +44,15 @@ struct i40e_client;
 #define I40E_QUEUE_TYPE_PE_AEQ  0x80
 #define I40E_QUEUE_INVALID_IDX	0xFFFF
 
+#define IDC_SIGNATURE 0x494e54454c494443ULL	/* INTELIDC */
+struct idc_srv_provider {
+	u64 signature;
+	u8 version;
+	u8 rsvd[7];
+	int (*idc_reg_peer_driver)(struct i40e_client *client);
+	int (*idc_unreg_peer_driver)(struct i40e_client *client);
+};
+
 struct i40e_qv_info {
 	u32 v_idx; /* msix_vector */
 	u16 ceq_idx;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b5daa5c9c7de..984001ae7680 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11913,6 +11913,12 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	np = netdev_priv(netdev);
 	np->vsi = vsi;
 
+	np->prov_callbacks.signature = IDC_SIGNATURE;
+	np->prov_callbacks.version = 0;
+	memset(np->prov_callbacks.rsvd, 0, sizeof(np->prov_callbacks.rsvd));
+	np->prov_callbacks.idc_reg_peer_driver = i40e_register_client;
+	np->prov_callbacks.idc_unreg_peer_driver = i40e_unregister_client;
+
 	hw_enc_features = NETIF_F_SG			|
 			  NETIF_F_IP_CSUM		|
 			  NETIF_F_IPV6_CSUM		|
-- 
2.17.0
