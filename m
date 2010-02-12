From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/02] RDMA/nes: atomic counters for cm listener create and destroy
Date: Fri, 12 Feb 2010 13:55:03 -0600
Message-ID: <20100212195503.GA66180@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, -c@vger.kernel.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Running long hour iterative MPI tests, sometimes ethtool statistics
"CM Destroy Listener" count is more than "CM Create Listener".
This inconsistency is fixed by making counter variable atomic.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.h     |    4 ++--
 drivers/infiniband/hw/nes/nes_cm.c  |    8 ++++----
 drivers/infiniband/hw/nes/nes_nic.c |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index 9884056..cffdac4 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -193,8 +193,8 @@ extern u32 cm_packets_created;
 extern u32 cm_packets_received;
 extern u32 cm_packets_dropped;
 extern u32 cm_packets_retrans;
-extern u32 cm_listens_created;
-extern u32 cm_listens_destroyed;
+extern atomic_t cm_listens_created;
+extern atomic_t cm_listens_destroyed;
 extern u32 cm_backlog_drops;
 extern atomic_t cm_loopbacks;
 extern atomic_t cm_nodes_created;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 39468c2..debd92c 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -67,8 +67,8 @@ u32 cm_packets_dropped;
 u32 cm_packets_retrans;
 u32 cm_packets_created;
 u32 cm_packets_received;
-u32 cm_listens_created;
-u32 cm_listens_destroyed;
+atomic_t cm_listens_created;
+atomic_t cm_listens_destroyed;
 u32 cm_backlog_drops;
 atomic_t cm_loopbacks;
 atomic_t cm_nodes_created;
@@ -1042,7 +1042,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 		kfree(listener);
 		listener = NULL;
 		ret = 0;
-		cm_listens_destroyed++;
+		atomic_inc(&cm_listens_destroyed);
 	} else {
 		spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 	}
@@ -3172,7 +3172,7 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 			g_cm_core->api->stop_listener(g_cm_core, (void *)cm_node);
 			return err;
 		}
-		cm_listens_created++;
+		atomic_inc(&cm_listens_created);
 	}
 
 	cm_id->add_ref(cm_id);
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index ab11027..3d550dc 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1230,8 +1230,8 @@ static void nes_netdev_get_ethtool_stats(struct net_device *netdev,
 	target_stat_values[++index] = cm_packets_received;
 	target_stat_values[++index] = cm_packets_dropped;
 	target_stat_values[++index] = cm_packets_retrans;
-	target_stat_values[++index] = cm_listens_created;
-	target_stat_values[++index] = cm_listens_destroyed;
+	target_stat_values[++index] = atomic_read(&cm_listens_created);
+	target_stat_values[++index] = atomic_read(&cm_listens_destroyed);
 	target_stat_values[++index] = cm_backlog_drops;
 	target_stat_values[++index] = atomic_read(&cm_loopbacks);
 	target_stat_values[++index] = atomic_read(&cm_nodes_created);
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
