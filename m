From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] RDMA: Remove useless MODULE_VERSION
Date: Mon, 26 Jun 2017 08:58:22 +0300
Message-ID: <20170626055822.18946-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

All modules in drivers/infiniband defined and used MODULE_VERSION, which
was pointless because the kernel version describes their state more accurate
then those arbitrary numbers.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Followup of the following discussion:
https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-June/004421.html
---
 drivers/infiniband/hw/bnxt_re/main.c            | 1 -
 drivers/infiniband/hw/cxgb3/iwch.c              | 1 -
 drivers/infiniband/hw/cxgb4/device.c            | 1 -
 drivers/infiniband/hw/hfi1/driver.c             | 1 -
 drivers/infiniband/hw/i40iw/i40iw_main.c        | 1 -
 drivers/infiniband/hw/mlx4/main.c               | 1 -
 drivers/infiniband/hw/mlx5/main.c               | 1 -
 drivers/infiniband/hw/mthca/mthca_main.c        | 1 -
 drivers/infiniband/hw/nes/nes.c                 | 1 -
 drivers/infiniband/hw/ocrdma/ocrdma_main.c      | 1 -
 drivers/infiniband/hw/qedr/main.c               | 1 -
 drivers/infiniband/hw/qedr/qedr.h               | 1 -
 drivers/infiniband/hw/qib/qib_driver.c          | 1 -
 drivers/infiniband/hw/usnic/usnic_ib_main.c     | 1 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c  | 1 -
 drivers/infiniband/sw/rxe/rxe.c                 | 1 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c       | 1 -
 drivers/infiniband/ulp/iser/iscsi_iser.c        | 1 -
 drivers/infiniband/ulp/isert/ib_isert.c         | 1 -
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c | 1 -
 drivers/infiniband/ulp/srp/ib_srp.c             | 1 -
 21 files changed, 21 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 5d355401179b..239b51685884 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -70,7 +70,6 @@ static char version[] =
 MODULE_AUTHOR("Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>");
 MODULE_DESCRIPTION(BNXT_RE_DESC " Driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(ROCE_DRV_MODULE_VERSION);

 /* globals */
 static struct list_head bnxt_re_dev_list = LIST_HEAD_INIT(bnxt_re_dev_list);
diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index 47b2ce2ef203..591de319c178 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -45,7 +45,6 @@
 MODULE_AUTHOR("Boyd Faulkner, Steve Wise");
 MODULE_DESCRIPTION("Chelsio T3 RDMA Driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);

 static void open_rnic_dev(struct t3cdev *);
 static void close_rnic_dev(struct t3cdev *);
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index f96a96dbcf1f..cef48d1d83b9 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -44,7 +44,6 @@
 MODULE_AUTHOR("Steve Wise");
 MODULE_DESCRIPTION("Chelsio T4/T5 RDMA Driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);

 static int allow_db_fc_on_t5;
 module_param(allow_db_fc_on_t5, int, 0644);
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index a50870e455a3..79a8b05855ac 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -96,7 +96,6 @@ MODULE_PARM_DESC(cap_mask, "Bit mask of enabled/disabled HW features");

 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("Intel Omni-Path Architecture driver");
-MODULE_VERSION(HFI1_DRIVER_VERSION);

 /*
  * MAX_PKT_RCV is the max # if packets processed per receive interrupt.
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index a3f18a22f5ed..3b22d925baa5 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -77,7 +77,6 @@ MODULE_PARM_DESC(mpa_version, "MPA version to be used in MPA Req/Resp 1 or 2");
 MODULE_AUTHOR("Intel Corporation, <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>");
 MODULE_DESCRIPTION("Intel(R) Ethernet Connection X722 iWARP RDMA Driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);

 static struct i40e_client i40iw_client;
 static char i40iw_client_name[I40E_CLIENT_STR_LENGTH] = "i40iw";
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 521d0def2d9e..93601cdb6532 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -71,7 +71,6 @@
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);

 int mlx4_ib_sm_guid_assign = 0;
 module_param_named(sm_guid_assign, mlx4_ib_sm_guid_assign, int, 0444);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0c79983c8b1a..a7a0756a6996 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -66,7 +66,6 @@
 MODULE_AUTHOR("Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>");
 MODULE_DESCRIPTION("Mellanox Connect-IB HCA IB driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRIVER_VERSION);

 static char mlx5_version[] =
 	DRIVER_NAME ": Mellanox Connect-IB Infiniband driver v"
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index c309e5c96383..1b10d21c8026 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -49,7 +49,6 @@
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("Mellanox InfiniBand HCA low-level driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);

 #ifdef CONFIG_INFINIBAND_MTHCA_DEBUG

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 5b9601014f0c..ab6232ab136b 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -63,7 +63,6 @@
 MODULE_AUTHOR("NetEffect");
 MODULE_DESCRIPTION("NetEffect RNIC Low-level iWARP Driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);

 int interrupt_mod_interval = 0;

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 57c9a2ad0260..757c65816295 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -58,7 +58,6 @@
 #include "ocrdma_stats.h"
 #include <rdma/ocrdma-abi.h>

-MODULE_VERSION(OCRDMA_ROCE_DRV_VERSION);
 MODULE_DESCRIPTION(OCRDMA_ROCE_DRV_DESC " " OCRDMA_ROCE_DRV_VERSION);
 MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 6a72095d6c7a..6c5639caab20 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -47,7 +47,6 @@
 MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(QEDR_MODULE_VERSION);

 #define QEDR_WQ_MULTIPLIER_DFT	(3)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index aa08c76a4245..0e95ffd6c14a 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -41,7 +41,6 @@
 #include <linux/qed/roce_common.h>
 #include "qedr_hsi_rdma.h"

-#define QEDR_MODULE_VERSION	"8.10.10.0"
 #define QEDR_NODE_DESC "QLogic 579xx RoCE HCA"
 #define DP_NAME(dev) ((dev)->ibdev.name)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 2b5982f743ef..719906a9fd51 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -66,7 +66,6 @@ MODULE_PARM_DESC(compat_ddr_negotiate,
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel <ibsupport-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>");
 MODULE_DESCRIPTION("Intel IB driver");
-MODULE_VERSION(QIB_DRIVER_VERSION);

 /*
  * QIB_PIO_MAXIBHDR is the max IB header size allowed for in our
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index c0c1e8b027b1..08cbbe224e11 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -720,7 +720,6 @@ static void __exit usnic_ib_destroy(void)
 MODULE_DESCRIPTION("Cisco VIC (usNIC) Verbs Driver");
 MODULE_AUTHOR("Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);
 module_param(usnic_log_lvl, uint, S_IRUGO | S_IWUSR);
 module_param(usnic_ib_share_vf, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(usnic_log_lvl, " Off=0, Err=1, Info=2, Debug=3");
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 34ebc7615411..e76565280afa 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -1119,5 +1119,4 @@ module_exit(pvrdma_cleanup);

 MODULE_AUTHOR("VMware, Inc");
 MODULE_DESCRIPTION("VMware Paravirtual RDMA driver");
-MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index c21c913f911a..8c3d30b3092d 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -38,7 +38,6 @@
 MODULE_AUTHOR("Bob Pearson, Frank Zago, John Groves, Kamal Heib");
 MODULE_DESCRIPTION("Soft RDMA transport");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION("0.2");

 /* free resources for all ports on a device */
 static void rxe_cleanup_ports(struct rxe_dev *rxe)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index a115c0b7a310..b11c46db7cc9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -60,7 +60,6 @@ const char ipoib_driver_version[] = DRV_VERSION;
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("IP-over-InfiniBand net driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);

 int ipoib_sendq_size __read_mostly = IPOIB_TX_RING_SIZE;
 int ipoib_recvq_size __read_mostly = IPOIB_RX_RING_SIZE;
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5a887efb4bdf..8ef3c1bd78bf 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -77,7 +77,6 @@
 MODULE_DESCRIPTION("iSER (iSCSI Extensions for RDMA) Datamover");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Alex Nezhinsky, Dan Bar Dov, Or Gerlitz");
-MODULE_VERSION(DRV_VER);

 static struct scsi_host_template iscsi_iser_sht;
 static struct iscsi_transport iscsi_iser_transport;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index fcbed35e95a8..d7cc7c6190ba 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2710,7 +2710,6 @@ static void __exit isert_exit(void)
 }

 MODULE_DESCRIPTION("iSER-Target for mainline target infrastructure");
-MODULE_VERSION("1.0");
 MODULE_AUTHOR("nab-mGRCEbBOV6Ml+7RC/bbRzw@public.gmane.org");
 MODULE_LICENSE("GPL");

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 875694f9a7f9..f9910a6c3291 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -1053,4 +1053,3 @@ module_exit(opa_vnic_deinit);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Intel OPA Virtual Network driver");
-MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2354c742caa1..fa5ccdb3bb2a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -62,7 +62,6 @@
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRV_VERSION);
 MODULE_INFO(release_date, DRV_RELDATE);

 #if !defined(CONFIG_DYNAMIC_DEBUG)
--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
