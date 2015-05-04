From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 3/5] IB/core: Convert cap_ib_mad to core_cap_flags bit mask
Date: Mon,  4 May 2015 02:14:57 -0400
Message-ID: <1430720099-32512-4-git-send-email-ira.weiny@intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430720099-32512-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the new Core Capability bits instead of inferring this support from the
protocol.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ehca/ehca_hca.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    2 +-
 drivers/infiniband/hw/mlx4/main.c            |    4 ++--
 drivers/infiniband/hw/mlx5/main.c            |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |    2 +-
 include/rdma/ib_verbs.h                      |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 75f5353..a06eadd 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -236,7 +236,7 @@ int ehca_query_port(struct ib_device *ibdev,
 		props->active_speed    = IB_SPEED_SDR;
 	}
 
-	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_IB_MAD;
 
 query_port1:
 	ehca_free_fw_ctrlblock(rblock);
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 94a03eb..bb66aa7 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1634,7 +1634,7 @@ static int ipath_query_port(struct ib_device *ibdev,
 	}
 	props->active_mtu = mtu;
 	props->subnet_timeout = dev->subnet_timeout;
-	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_IB_MAD;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index fa4e45c..9db5fdc 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -330,7 +330,7 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 	if (props->state == IB_PORT_DOWN)
 		 props->active_speed = IB_SPEED_SDR;
 
-	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_IB_MAD;
 
 out:
 	kfree(in_mad);
@@ -392,7 +392,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->state		= (netif_running(ndev) && netif_carrier_ok(ndev)) ?
 					IB_PORT_ACTIVE : IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
-	props->core_cap_flags   = RDMA_CORE_CAP_PROT_IBOE;
+	props->core_cap_flags   = RDMA_CORE_CAP_PROT_IBOE | RDMA_CORE_CAP_IB_MAD;
 out_unlock:
 	spin_unlock_bh(&iboe->lock);
 	if (is_bonded)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e3cdc17..4b8ef01 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -255,7 +255,7 @@ int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
 		}
 	}
 
-	props->core_cap_flags   = RDMA_CORE_CAP_PROT_IB;
+	props->core_cap_flags   = RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_IB_MAD;
 
 out:
 	kfree(in_mad);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index e49aece..60fcc02 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -172,7 +172,7 @@ static int mthca_query_port(struct ib_device *ibdev,
 	props->subnet_timeout    = out_mad->data[51] & 0x1f;
 	props->max_vl_num        = out_mad->data[37] >> 4;
 	props->init_type_reply   = out_mad->data[41] >> 4;
-	props->core_cap_flags    = RDMA_CORE_CAP_PROT_IB;
+	props->core_cap_flags    = RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_IB_MAD;
 
  out:
 	kfree(in_mad);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 6e52946..6975528 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1646,7 +1646,7 @@ static int qib_query_port(struct ib_device *ibdev, u8 port,
 	}
 	props->active_mtu = mtu;
 	props->subnet_timeout = ibp->subnet_timeout;
-	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_IB_MAD;
 
 	return 0;
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index dcaee4f..6c2b0e5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1807,7 +1807,7 @@ static inline int rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
  */
 static inline int cap_ib_mad(struct ib_device *device, u8 port_num)
 {
-	return rdma_ib_or_iboe(device, port_num);
+	return !!(device->core_cap_flags[port_num] & RDMA_CORE_CAP_IB_MAD);
 }
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
