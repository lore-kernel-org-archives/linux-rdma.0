From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct i40e_netdev_priv
Date: Fri, 15 Feb 2019 11:10:48 -0600
Message-ID: <20190215171107.6464-2-shiraz.saleem@intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171107.6464-1-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

Expose the register/unregister function pointers in the struct
i40e_netdev_priv which is accesible via the netdev_priv() interface
in the RDMA driver. On a netdev notification in the RDMA driver,
the appropriate LAN driver register/unregister functions are invoked
from the struct i40e_netdev_priv structure,

This is done in order to support single RDMA driver to work with
multiple LAN drivers over multi-generation Intel HW supporting RDMA

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  1 +
 drivers/net/ethernet/intel/i40e/i40e_client.h | 10 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  7 +++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 8de9085..7bc6316 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -795,6 +795,7 @@ struct i40e_vsi {
 } ____cacheline_internodealigned_in_smp;
 
 struct i40e_netdev_priv {
+	struct idc_srv_provider prov_callbacks;
 	struct i40e_vsi *vsi;
 };
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.h b/drivers/net/ethernet/intel/i40e/i40e_client.h
index 72994ba..70ddb76 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.h
@@ -44,6 +44,16 @@ enum i40e_client_instance_state {
 #define I40E_QUEUE_TYPE_PE_AEQ  0x80
 #define I40E_QUEUE_INVALID_IDX	0xFFFF
 
+#define IDC_SIGNATURE 0x494e54454c494443ULL	/* INTELIDC */
+struct idc_srv_provider {
+	u64 signature;
+	u16 maj_ver;
+	u16 min_ver;
+	u8 rsvd[4];
+	int (*reg_peer_driver)(struct i40e_client *client);
+	int (*unreg_peer_driver)(struct i40e_client *client);
+};
+
 struct i40e_qv_info {
 	u32 v_idx; /* msix_vector */
 	u16 ceq_idx;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f52e2c4..114ff0e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12243,6 +12243,13 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	np = netdev_priv(netdev);
 	np->vsi = vsi;
 
+	np->prov_callbacks.signature = IDC_SIGNATURE;
+	np->prov_callbacks.maj_ver = I40E_CLIENT_VERSION_MAJOR;
+	np->prov_callbacks.min_ver = I40E_CLIENT_VERSION_MINOR;
+	memset(np->prov_callbacks.rsvd, 0, sizeof(np->prov_callbacks.rsvd));
+	np->prov_callbacks.reg_peer_driver = i40e_register_client;
+	np->prov_callbacks.unreg_peer_driver = i40e_unregister_client;
+
 	hw_enc_features = NETIF_F_SG			|
 			  NETIF_F_IP_CSUM		|
 			  NETIF_F_IPV6_CSUM		|
-- 
1.8.3.1
