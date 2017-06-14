From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] IB/opa_vnic: Use spinlock instead of mutex for stats_lock
Date: Wed, 14 Jun 2017 12:34:42 -0700
Message-ID: <1497468882-19161-3-git-send-email-niranjana.vishwanathapura@intel.com>
References: <1497468882-19161-1-git-send-email-niranjana.vishwanathapura@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497468882-19161-1-git-send-email-niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Stats can be read from atomic context, hence make stats_lock as
a spinlock.

Fix the following trace with debug kernel.

BUG: sleeping function called from invalid context at
kernel/locking/mutex.c:238
in_atomic(): 1, irqs_disabled(): 0, pid: 6487, name: sadc
Call Trace:
 dump_stack+0x63/0x90
 ___might_sleep+0xda/0x130
 __might_sleep+0x4a/0x90
 mutex_lock+0x20/0x50
 opa_vnic_get_stats64+0x56/0x140 [opa_vnic]
 dev_get_stats+0x74/0x130
 dev_seq_printf_stats+0x37/0x120
 dev_seq_show+0x14/0x30
 seq_read+0x26d/0x3d0

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c    | 4 ++--
 drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h   | 2 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c     | 8 +++-----
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c | 8 ++++----
 4 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
index d66540e..62390e9 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_ethtool.c
@@ -146,15 +146,15 @@ static void vnic_get_ethtool_stats(struct net_device *netdev,
 	int i;
 
 	memset(&vstats, 0, sizeof(vstats));
-	mutex_lock(&adapter->stats_lock);
+	spin_lock(&adapter->stats_lock);
 	adapter->rn_ops->ndo_get_stats64(netdev, &vstats.netstats);
+	spin_unlock(&adapter->stats_lock);
 	for (i = 0; i < VNIC_STATS_LEN; i++) {
 		char *p = (char *)&vstats + vnic_gstrings_stats[i].stat_offset;
 
 		data[i] = (vnic_gstrings_stats[i].sizeof_stat ==
 			   sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
 	}
-	mutex_unlock(&adapter->stats_lock);
 }
 
 /* vnic_get_strings - get strings */
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
index 6bba886..ca29e6d 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
@@ -214,7 +214,7 @@ struct opa_vnic_adapter {
 	struct mutex mactbl_lock;
 
 	/* Lock used to protect access to vnic counters */
-	struct mutex stats_lock;
+	spinlock_t stats_lock;
 
 	u8 flow_tbl[OPA_VNIC_FLOW_TBL_SIZE];
 
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
index 905f39d..78d9007 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
@@ -69,9 +69,9 @@ static void opa_vnic_get_stats64(struct net_device *netdev,
 	struct opa_vnic_stats vstats;
 
 	memset(&vstats, 0, sizeof(vstats));
-	mutex_lock(&adapter->stats_lock);
+	spin_lock(&adapter->stats_lock);
 	adapter->rn_ops->ndo_get_stats64(netdev, &vstats.netstats);
-	mutex_unlock(&adapter->stats_lock);
+	spin_unlock(&adapter->stats_lock);
 	memcpy(stats, &vstats.netstats, sizeof(*stats));
 }
 
@@ -344,7 +344,7 @@ struct opa_vnic_adapter *opa_vnic_add_netdev(struct ib_device *ibdev,
 	netdev->hard_header_len += OPA_VNIC_SKB_HEADROOM;
 	mutex_init(&adapter->lock);
 	mutex_init(&adapter->mactbl_lock);
-	mutex_init(&adapter->stats_lock);
+	spin_lock_init(&adapter->stats_lock);
 
 	SET_NETDEV_DEV(netdev, ibdev->dev.parent);
 
@@ -364,7 +364,6 @@ struct opa_vnic_adapter *opa_vnic_add_netdev(struct ib_device *ibdev,
 netdev_err:
 	mutex_destroy(&adapter->lock);
 	mutex_destroy(&adapter->mactbl_lock);
-	mutex_destroy(&adapter->stats_lock);
 	kfree(adapter);
 adapter_err:
 	ibdev->free_rdma_netdev(netdev);
@@ -383,7 +382,6 @@ void opa_vnic_rem_netdev(struct opa_vnic_adapter *adapter)
 	opa_vnic_release_mac_tbl(adapter);
 	mutex_destroy(&adapter->lock);
 	mutex_destroy(&adapter->mactbl_lock);
-	mutex_destroy(&adapter->stats_lock);
 	kfree(adapter);
 	ibdev->free_rdma_netdev(netdev);
 }
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
index a51bf97..c273396 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
@@ -89,9 +89,9 @@ void opa_vnic_get_summary_counters(struct opa_vnic_adapter *adapter,
 	u64 *src;
 
 	memset(&vstats, 0, sizeof(vstats));
-	mutex_lock(&adapter->stats_lock);
+	spin_lock(&adapter->stats_lock);
 	adapter->rn_ops->ndo_get_stats64(adapter->netdev, &vstats.netstats);
-	mutex_unlock(&adapter->stats_lock);
+	spin_unlock(&adapter->stats_lock);
 
 	cntrs->vp_instance = cpu_to_be16(adapter->vport_num);
 	cntrs->vesw_id = cpu_to_be16(adapter->info.vesw.vesw_id);
@@ -128,9 +128,9 @@ void opa_vnic_get_error_counters(struct opa_vnic_adapter *adapter,
 	struct opa_vnic_stats vstats;
 
 	memset(&vstats, 0, sizeof(vstats));
-	mutex_lock(&adapter->stats_lock);
+	spin_lock(&adapter->stats_lock);
 	adapter->rn_ops->ndo_get_stats64(adapter->netdev, &vstats.netstats);
-	mutex_unlock(&adapter->stats_lock);
+	spin_unlock(&adapter->stats_lock);
 
 	cntrs->vp_instance = cpu_to_be16(adapter->vport_num);
 	cntrs->vesw_id = cpu_to_be16(adapter->info.vesw.vesw_id);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
