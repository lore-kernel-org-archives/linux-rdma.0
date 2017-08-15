From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 8/8] RDMA: Use defines instead of hard coded value for phys_state
Date: Tue, 15 Aug 2017 12:14:31 +0300
Message-ID: <20170815091431.12822-9-leon@kernel.org>
References: <20170815091431.12822-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815091431.12822-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There are new defines to express the physical state of the link, so
let's reuse them instead hard-coded values.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     |  4 ++--
 drivers/infiniband/hw/hfi1/opa_compat.h      | 30 +++++++++++++++++-----------
 drivers/infiniband/hw/hns/hns_roce_main.c    |  4 +++-
 drivers/infiniband/hw/mlx4/main.c            |  4 +++-
 drivers/infiniband/hw/mlx5/main.c            |  4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  4 ++--
 drivers/infiniband/hw/qedr/verbs.c           |  4 ++--
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  6 +++---
 drivers/infiniband/sw/rxe/rxe_param.h        |  2 +-
 9 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index d78fedc654d0..9bc28c756210 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -234,10 +234,10 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
 
 	if (netif_running(rdev->netdev) && netif_carrier_ok(rdev->netdev)) {
 		port_attr->state = IB_PORT_ACTIVE;
-		port_attr->phys_state = 5;
+		port_attr->phys_state = RDMA_LINK_PHYS_STATE_LINK_UP;
 	} else {
 		port_attr->state = IB_PORT_DOWN;
-		port_attr->phys_state = 3;
+		port_attr->phys_state = RDMA_LINK_PHYS_STATE_DISABLED;
 	}
 	port_attr->max_mtu = IB_MTU_4096;
 	port_attr->active_mtu = iboe_get_mtu(rdev->netdev->mtu);
diff --git a/drivers/infiniband/hw/hfi1/opa_compat.h b/drivers/infiniband/hw/hfi1/opa_compat.h
index 6ef3c1cbdcd7..011ea5c89e25 100644
--- a/drivers/infiniband/hw/hfi1/opa_compat.h
+++ b/drivers/infiniband/hw/hfi1/opa_compat.h
@@ -92,20 +92,26 @@ static inline u8 port_states_to_phys_state(struct opa_port_states *ps)
  * Returned by the ibphys_portstate() routine.
  */
 enum opa_port_phys_state {
-	IB_PORTPHYSSTATE_NOP = 0,
+	IB_PORTPHYSSTATE_NOP = RDMA_LINK_PHYS_STATE_NOP,
+
 	/* 1 is reserved */
-	IB_PORTPHYSSTATE_POLLING = 2,
-	IB_PORTPHYSSTATE_DISABLED = 3,
-	IB_PORTPHYSSTATE_TRAINING = 4,
-	IB_PORTPHYSSTATE_LINKUP = 5,
-	IB_PORTPHYSSTATE_LINK_ERROR_RECOVERY = 6,
-	IB_PORTPHYSSTATE_PHY_TEST = 7,
+
+	IB_PORTPHYSSTATE_POLLING = RDMA_LINK_PHYS_STATE_POLLING,
+	IB_PORTPHYSSTATE_DISABLED = RDMA_LINK_PHYS_STATE_DISABLED,
+	IB_PORTPHYSSTATE_TRAINING = RDMA_LINK_PHYS_STATE_PORT_CONFIGURATION_TRAINING,
+	IB_PORTPHYSSTATE_LINKUP = RDMA_LINK_PHYS_STATE_LINK_UP,
+	IB_PORTPHYSSTATE_LINK_ERROR_RECOVERY = RDMA_LINK_PHYS_STATE_LINK_ERROR_RECOVER,
+	IB_PORTPHYSSTATE_PHY_TEST = RDMA_LINK_PHYS_STATE_LINK_PHY_TEST,
+
 	/* 8 is reserved */
-	OPA_PORTPHYSSTATE_OFFLINE = 9,
-	OPA_PORTPHYSSTATE_GANGED = 10,
-	OPA_PORTPHYSSTATE_TEST = 11,
-	OPA_PORTPHYSSTATE_MAX = 11,
+
+	OPA_PORTPHYSSTATE_OFFLINE = RDMA_LINK_PHYS_STATE_OFFLINE,
+
+	/* 10 is reserved */
+
+	OPA_PORTPHYSSTATE_TEST = RDMA_LINK_PHYS_STATE_TEST,
+	OPA_PORTPHYSSTATE_MAX = OPA_PORTPHYSSTATE_TEST,
+
 	/* values 12-15 are reserved/ignored */
 };
-
 #endif /* _LINUX_H */
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index d9777b662eba..48e88357d1c4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -272,7 +272,9 @@ static int hns_roce_query_port(struct ib_device *ib_dev, u8 port_num,
 	props->active_mtu = mtu ? min(props->max_mtu, mtu) : IB_MTU_256;
 	props->state = (netif_running(net_dev) && netif_carrier_ok(net_dev)) ?
 			IB_PORT_ACTIVE : IB_PORT_DOWN;
-	props->phys_state = (props->state == IB_PORT_ACTIVE) ? 5 : 3;
+	props->phys_state = (props->state == IB_PORT_ACTIVE) ?
+			    RDMA_LINK_PHYS_STATE_LINK_UP :
+			    RDMA_LINK_PHYS_STATE_DISABLED;
 
 	spin_unlock_irqrestore(&hr_dev->iboe.lock, flags);
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c636842c5be0..d1598ef15406 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -694,7 +694,9 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 
 static u8 state_to_phys_state(enum ib_port_state state)
 {
-	return state == IB_PORT_ACTIVE ? 5 : 3;
+	return state == IB_PORT_ACTIVE ?
+		RDMA_LINK_PHYS_STATE_LINK_UP :
+		RDMA_LINK_PHYS_STATE_DISABLED;
 }
 
 static int eth_link_query_port(struct ib_device *ibdev, u8 port,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 894aec4a7c9d..8b3f19060a67 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -282,7 +282,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	props->max_msg_sz       = 1 << MLX5_CAP_GEN(dev->mdev, log_max_msg);
 	props->pkey_tbl_len     = 1;
 	props->state            = IB_PORT_DOWN;
-	props->phys_state       = 3;
+	props->phys_state       = RDMA_LINK_PHYS_STATE_DISABLED;
 
 	mlx5_query_nic_vport_qkey_viol_cntr(dev->mdev, &qkey_viol_cntr);
 	props->qkey_viol_cntr = qkey_viol_cntr;
@@ -304,7 +304,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 
 	if (netif_running(ndev) && netif_carrier_ok(ndev)) {
 		props->state      = IB_PORT_ACTIVE;
-		props->phys_state = 5;
+		props->phys_state = RDMA_LINK_PHYS_STATE_LINK_UP;
 	}
 
 	ndev_ib_mtu = iboe_get_mtu(ndev->mtu);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 27d5e8d9f08d..32e7a04b027f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -220,10 +220,10 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	netdev = dev->nic_info.netdev;
 	if (netif_running(netdev) && netif_oper_up(netdev)) {
 		port_state = IB_PORT_ACTIVE;
-		props->phys_state = 5;
+		props->phys_state = RDMA_LINK_PHYS_STATE_LINK_UP;
 	} else {
 		port_state = IB_PORT_DOWN;
-		props->phys_state = 3;
+		props->phys_state = RDMA_LINK_PHYS_STATE_DISABLED;
 	}
 	props->max_mtu = IB_MTU_4096;
 	props->active_mtu = iboe_get_mtu(netdev->mtu);
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 9ee2dce3e5bb..724921aad51b 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -251,10 +251,10 @@ int qedr_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr *attr)
 	/* *attr being zeroed by the caller, avoid zeroing it here */
 	if (rdma_port->port_state == QED_RDMA_PORT_UP) {
 		attr->state = IB_PORT_ACTIVE;
-		attr->phys_state = 5;
+		attr->phys_state = RDMA_LINK_PHYS_STATE_LINK_UP;
 	} else {
 		attr->state = IB_PORT_DOWN;
-		attr->phys_state = 3;
+		attr->phys_state = RDMA_LINK_PHYS_STATE_DISABLED;
 	}
 	attr->max_mtu = IB_MTU_4096;
 	attr->active_mtu = iboe_get_mtu(dev->ndev->mtu);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index e5f57dd49980..8889b549a6bc 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -324,13 +324,13 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 
 	if (!us_ibdev->ufdev->link_up) {
 		props->state = IB_PORT_DOWN;
-		props->phys_state = 3;
+		props->phys_state = RDMA_LINK_PHYS_STATE_DISABLED;
 	} else if (!us_ibdev->ufdev->inaddr) {
 		props->state = IB_PORT_INIT;
-		props->phys_state = 4;
+		props->phys_state = RDMA_LINK_PHYS_STATE_PORT_CONFIGURATION_TRAINING;
 	} else {
 		props->state = IB_PORT_ACTIVE;
-		props->phys_state = 5;
+		props->phys_state = RDMA_LINK_PHYS_STATE_LINK_UP;
 	}
 
 	props->port_cap_flags = 0;
diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
index 1b596fbbe251..475767262102 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -157,7 +157,7 @@ enum rxe_port_param {
 	RXE_PORT_ACTIVE_WIDTH		= IB_WIDTH_1X,
 	RXE_PORT_ACTIVE_SPEED		= 1,
 	RXE_PORT_PKEY_TBL_LEN		= 64,
-	RXE_PORT_PHYS_STATE		= 2,
+	RXE_PORT_PHYS_STATE		= RDMA_LINK_PHYS_STATE_POLLING,
 	RXE_PORT_SUBNET_PREFIX		= 0xfe80000000000000ULL,
 };
 
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
