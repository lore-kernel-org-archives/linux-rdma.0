From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB: Convert msleep below 20ms to usleep_range
Date: Tue, 23 May 2017 11:29:42 +0300
Message-ID: <20170523082942.13314-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The msleep(1) may do not sleep 1 ms as expected
and will sleep longer. The simple conversion from
msleep to usleep_range between 1ms and 2ms can solve an
issue.

The full and comprehensive explanation can be found at [1] and [2].

[1] https://lkml.org/lkml/2007/8/3/250
[2] Documentation/timers/timers-howto.txt

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 3 ++-
 drivers/infiniband/hw/mlx4/main.c          | 2 +-
 drivers/infiniband/hw/mlx4/mcg.c           | 2 +-
 drivers/infiniband/hw/nes/nes_hw.c         | 4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    | 4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    | 2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 014c8262bfff..bb26b51b8c2d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -995,7 +995,8 @@ static void hns_roce_v1_mr_free_work_fn(struct work_struct *work)
 			goto free_work;
 		}
 		ne -= ret;
-		msleep(HNS_ROCE_V1_FREE_MR_WAIT_VALUE);
+		usleep_range(HNS_ROCE_V1_FREE_MR_WAIT_VALUE * 1000,
+			     (1 + HNS_ROCE_V1_FREE_MR_WAIT_VALUE) * 1000);
 	} while (ne && time_before_eq(jiffies, end));

 	if (ne != 0)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 521d0def2d9e..2b08739da65c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1156,7 +1156,7 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 			 * call to mlx4_ib_vma_close.
 			 */
 			put_task_struct(owning_process);
-			msleep(1);
+			usleep_range(1000, 2000);
 			owning_process = get_pid_task(ibcontext->tgid,
 						      PIDTYPE_PID);
 			if (!owning_process ||
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 3405e947dc1e..b73f89700ef9 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -1091,7 +1091,7 @@ static void _mlx4_ib_mcg_port_cleanup(struct mlx4_ib_demux_ctx *ctx, int destroy
 		if (!count)
 			break;

-		msleep(1);
+		usleep_range(1000, 2000);
 	} while (time_after(end, jiffies));

 	flush_workqueue(ctx->mcg_wq);
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 8f9d8b4ad583..b0adf65e4bdb 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -551,7 +551,7 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 			if ((0x0F000100 == (pcs_control_status0 & 0x0F000100))
 			    || (0x0F000100 == (pcs_control_status1 & 0x0F000100)))
 				int_cnt++;
-			msleep(1);
+			usleep_range(1000, 2000);
 		}
 		if (int_cnt > 1) {
 			spin_lock_irqsave(&nesadapter->phy_lock, flags);
@@ -592,7 +592,7 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 						break;
 					}
 				}
-				msleep(1);
+				usleep_range(1000, 2000);
 			}
 		}
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 7cbcfdac6529..d574d41bdf61 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -954,7 +954,7 @@ void ipoib_cm_dev_stop(struct net_device *dev)
 			break;
 		}
 		spin_unlock_irq(&priv->lock);
-		msleep(1);
+		usleep_range(1000, 2000);
 		ipoib_drain_cq(dev);
 		spin_lock_irq(&priv->lock);
 	}
@@ -1206,7 +1206,7 @@ static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
 				goto timeout;
 			}

-			msleep(1);
+			usleep_range(1000, 2000);
 		}
 	}

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 0060b2f9f659..bb5466ea6e16 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -770,7 +770,7 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)

 		ipoib_drain_cq(dev);

-		msleep(1);
+		usleep_range(1000, 2000);
 	}

 	ipoib_dbg(priv, "All sends and receives done.\n");
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
