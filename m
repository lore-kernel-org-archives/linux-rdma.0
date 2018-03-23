From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/4] ethernet: Use octal not symbolic permissions
Date: Fri, 23 Mar 2018 15:54:36 -0700
Message-ID: <31c47a8bb2af3f01178d83e890d2600f049ad709.1521845235.git.joe@perches.com>
References: <cover.1521845235.git.joe@perches.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <cover.1521845235.git.joe@perches.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Vince Bridgers <vbridger@opensource.altera.com>, Tom Lendacky <thomas.lendacky@amd.com>, Rasesh Mody <rasesh.mody@cavium.com>, Harish Patil <harish.patil@cavium.com>, Dept-GELinuxNICDev@cavium.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, Siva Reddy Kallam <siva.kallam@broadcom.com>, Prashant Sreedharan <prashant@broadcom.com>, Michael Chan <mchan@broadcom.com>, Sudarsana Kalluru <sudarsana.kalluru@cavium.com>, Sunil Goutham <sgoutham@cavium.com>, Robert Richter <rric@kernel.org>, Santosh Raspatur <santosh@chelsio.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Casey Leedom <leedom@chelsio.com>, Dariusz Marcinkiewicz <reksio@newterm.pl>, Sathya Perla <sathya.perla@broadcom.com>, Ajit Khaparde <ajit.khaparde@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Douglas Miller <dougm>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, oss-drivers@netronome.com, intel-wired-lan@lists.osuosl.org, nios2-dev@lists.rocketboards.org, linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

Prefer the direct use of octal for permissions.

Done with checkpatch -f --types=SYMBOLIC_PERMS --fix-inplace
and some typing.

Miscellanea:

o Whitespace neatening around these conversions.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/8390/apne.c                   |   2 +-
 drivers/net/ethernet/8390/lib8390.c                |   2 +-
 drivers/net/ethernet/8390/ne.c                     |   2 +-
 drivers/net/ethernet/8390/ne2k-pci.c               |   2 +-
 drivers/net/ethernet/8390/smc-ultra.c              |   2 +-
 drivers/net/ethernet/8390/stnic.c                  |   2 +-
 drivers/net/ethernet/8390/wd.c                     |   2 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |   6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  10 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c          |   2 +-
 drivers/net/ethernet/broadcom/bnx2.c               |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  12 +--
 drivers/net/ethernet/broadcom/sb1250-mac.c         |  10 +-
 drivers/net/ethernet/broadcom/tg3.c                |   6 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |   2 +-
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c    |  10 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 112 ++++++++++-----------
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  10 +-
 drivers/net/ethernet/ec_bhf.c                      |   2 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   6 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   7 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   2 +-
 drivers/net/ethernet/intel/igb/igb_hwmon.c         |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c     |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   8 +-
 drivers/net/ethernet/marvell/skge.c                |   2 +-
 drivers/net/ethernet/marvell/sky2.c                |   2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  16 +--
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |  10 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  32 +++---
 .../net/ethernet/netronome/nfp/nfp_net_debugfs.c   |   6 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  14 +--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c  |  30 +++---
 drivers/net/ethernet/qualcomm/qca_debug.c          |   2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   4 +-
 drivers/net/ethernet/sfc/mcdi_mon.c                |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  26 ++---
 drivers/net/ethernet/sun/niu.c                     |  10 +-
 40 files changed, 194 insertions(+), 195 deletions(-)

diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index c56ac9ebc08f..fe6c834c422e 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -117,7 +117,7 @@ static const char version[] =
 static int apne_owned;	/* signal if card already owned */
 
 static u32 apne_msg_enable;
-module_param_named(msg_enable, apne_msg_enable, uint, (S_IRUSR|S_IRGRP|S_IROTH));
+module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
 struct net_device * __init apne_probe(int unit)
diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
index 5d9bbde9fe68..c9c55c9eab9f 100644
--- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -113,7 +113,7 @@ static void __NS8390_init(struct net_device *dev, int startp);
 
 static unsigned version_printed;
 static u32 msg_enable;
-module_param(msg_enable, uint, (S_IRUSR|S_IRGRP|S_IROTH));
+module_param(msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
 /*
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index 44a084b41bf0..ac99d089ac72 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -77,7 +77,7 @@ static u32 ne_msg_enable;
 module_param_hw_array(io, int, ioport, NULL, 0);
 module_param_hw_array(irq, int, irq, NULL, 0);
 module_param_array(bad, int, NULL, 0);
-module_param_named(msg_enable, ne_msg_enable, uint, (S_IRUSR|S_IRGRP|S_IROTH));
+module_param_named(msg_enable, ne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(io, "I/O base address(es),required");
 MODULE_PARM_DESC(irq, "IRQ number(s)");
 MODULE_PARM_DESC(bad, "Accept card(s) with bad signatures");
diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8390/ne2k-pci.c
index 1bdea746926c..42985a82321a 100644
--- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -76,7 +76,7 @@ MODULE_AUTHOR("Donald Becker / Paul Gortmaker");
 MODULE_DESCRIPTION("PCI NE2000 clone driver");
 MODULE_LICENSE("GPL");
 
-module_param_named(msg_enable, ne2k_msg_enable, uint, (S_IRUSR|S_IRGRP|S_IROTH));
+module_param_named(msg_enable, ne2k_msg_enable, uint, 0444);
 module_param_array(options, int, NULL, 0);
 module_param_array(full_duplex, int, NULL, 0);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
diff --git a/drivers/net/ethernet/8390/smc-ultra.c b/drivers/net/ethernet/8390/smc-ultra.c
index 4e02f6a23575..3fe3b4dfa7c5 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -563,7 +563,7 @@ static int irq[MAX_ULTRA_CARDS];
 
 module_param_hw_array(io, int, ioport, NULL, 0);
 module_param_hw_array(irq, int, irq, NULL, 0);
-module_param_named(msg_enable, ultra_msg_enable, uint, (S_IRUSR|S_IRGRP|S_IROTH));
+module_param_named(msg_enable, ultra_msg_enable, uint, 0444);
 MODULE_PARM_DESC(io, "I/O base address(es)");
 MODULE_PARM_DESC(irq, "IRQ number(s) (assigned)");
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
diff --git a/drivers/net/ethernet/8390/stnic.c b/drivers/net/ethernet/8390/stnic.c
index aca957d4e121..1f0670cd3ea3 100644
--- a/drivers/net/ethernet/8390/stnic.c
+++ b/drivers/net/ethernet/8390/stnic.c
@@ -71,7 +71,7 @@ static void stnic_init (struct net_device *dev);
 
 static u32 stnic_msg_enable;
 
-module_param_named(msg_enable, stnic_msg_enable, uint, (S_IRUSR|S_IRGRP|S_IROTH));
+module_param_named(msg_enable, stnic_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
 /* SH7750 specific read/write io. */
diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index fb17c2c7e1dd..c834123560f1 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -507,7 +507,7 @@ module_param_hw_array(io, int, ioport, NULL, 0);
 module_param_hw_array(irq, int, irq, NULL, 0);
 module_param_hw_array(mem, int, iomem, NULL, 0);
 module_param_hw_array(mem_end, int, iomem, NULL, 0);
-module_param_named(msg_enable, wd_msg_enable, uint, (S_IRUSR|S_IRGRP|S_IROTH));
+module_param_named(msg_enable, wd_msg_enable, uint, 0444);
 MODULE_PARM_DESC(io, "I/O base address(es)");
 MODULE_PARM_DESC(irq, "IRQ number(s) (ignored for PureData boards)");
 MODULE_PARM_DESC(mem, "memory base address(es)(ignored for PureData boards)");
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 527908c7e384..baca8f704a45 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -56,7 +56,7 @@
 static atomic_t instance_count = ATOMIC_INIT(~0);
 /* Module parameters */
 static int debug = -1;
-module_param(debug, int, S_IRUGO | S_IWUSR);
+module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Message Level (-1: default, 0: no output, 16: all)");
 
 static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
@@ -65,12 +65,12 @@ static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 
 #define RX_DESCRIPTORS 64
 static int dma_rx_num = RX_DESCRIPTORS;
-module_param(dma_rx_num, int, S_IRUGO | S_IWUSR);
+module_param(dma_rx_num, int, 0644);
 MODULE_PARM_DESC(dma_rx_num, "Number of descriptors in the RX list");
 
 #define TX_DESCRIPTORS 64
 static int dma_tx_num = TX_DESCRIPTORS;
-module_param(dma_tx_num, int, S_IRUGO | S_IWUSR);
+module_param(dma_tx_num, int, 0644);
 MODULE_PARM_DESC(dma_tx_num, "Number of descriptors in the TX list");
 
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 100adee778df..7c204f05b418 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -137,21 +137,21 @@ static unsigned int ecc_ded_period = 600;
 
 #ifdef CONFIG_AMD_XGBE_HAVE_ECC
 /* Only expose the ECC parameters if supported */
-module_param(ecc_sec_info_threshold, uint, S_IWUSR | S_IRUGO);
+module_param(ecc_sec_info_threshold, uint, 0644);
 MODULE_PARM_DESC(ecc_sec_info_threshold,
 		 " ECC corrected error informational threshold setting");
 
-module_param(ecc_sec_warn_threshold, uint, S_IWUSR | S_IRUGO);
+module_param(ecc_sec_warn_threshold, uint, 0644);
 MODULE_PARM_DESC(ecc_sec_warn_threshold,
 		 " ECC corrected error warning threshold setting");
 
-module_param(ecc_sec_period, uint, S_IWUSR | S_IRUGO);
+module_param(ecc_sec_period, uint, 0644);
 MODULE_PARM_DESC(ecc_sec_period, " ECC corrected error period (in seconds)");
 
-module_param(ecc_ded_threshold, uint, S_IWUSR | S_IRUGO);
+module_param(ecc_ded_threshold, uint, 0644);
 MODULE_PARM_DESC(ecc_ded_threshold, " ECC detected error threshold setting");
 
-module_param(ecc_ded_period, uint, S_IWUSR | S_IRUGO);
+module_param(ecc_ded_period, uint, 0644);
 MODULE_PARM_DESC(ecc_ded_period, " ECC detected error period (in seconds)");
 #endif
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index d91fa595be98..795e556d4a3f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -131,7 +131,7 @@ MODULE_VERSION(XGBE_DRV_VERSION);
 MODULE_DESCRIPTION(XGBE_DRV_DESC);
 
 static int debug = -1;
-module_param(debug, int, S_IWUSR | S_IRUGO);
+module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, " Network interface message level setting");
 
 static const u32 default_msg_level = (NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 5e34b34f7740..9ffc4a8c5fc7 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -87,7 +87,7 @@ MODULE_FIRMWARE(FW_RV2P_FILE_09_Ax);
 
 static int disable_msi = 0;
 
-module_param(disable_msi, int, S_IRUGO);
+module_param(disable_msi, int, 0444);
 MODULE_PARM_DESC(disable_msi, "Disable Message Signaled Interrupt (MSI)");
 
 typedef enum {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index b8388e93520a..fd97250d6371 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -97,29 +97,29 @@ MODULE_FIRMWARE(FW_FILE_NAME_E1H);
 MODULE_FIRMWARE(FW_FILE_NAME_E2);
 
 int bnx2x_num_queues;
-module_param_named(num_queues, bnx2x_num_queues, int, S_IRUGO);
+module_param_named(num_queues, bnx2x_num_queues, int, 0444);
 MODULE_PARM_DESC(num_queues,
 		 " Set number of queues (default is as a number of CPUs)");
 
 static int disable_tpa;
-module_param(disable_tpa, int, S_IRUGO);
+module_param(disable_tpa, int, 0444);
 MODULE_PARM_DESC(disable_tpa, " Disable the TPA (LRO) feature");
 
 static int int_mode;
-module_param(int_mode, int, S_IRUGO);
+module_param(int_mode, int, 0444);
 MODULE_PARM_DESC(int_mode, " Force interrupt mode other than MSI-X "
 				"(1 INT#x; 2 MSI)");
 
 static int dropless_fc;
-module_param(dropless_fc, int, S_IRUGO);
+module_param(dropless_fc, int, 0444);
 MODULE_PARM_DESC(dropless_fc, " Pause on exhausted host ring");
 
 static int mrrs = -1;
-module_param(mrrs, int, S_IRUGO);
+module_param(mrrs, int, 0444);
 MODULE_PARM_DESC(mrrs, " Force Max Read Req Size (0..3) (for debug)");
 
 static int debug;
-module_param(debug, int, S_IRUGO);
+module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, " Default debug msglevel");
 
 static struct workqueue_struct *bnx2x_wq;
diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
index ecdef42f0ae6..ef4a0c326736 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -63,24 +63,24 @@ MODULE_DESCRIPTION("Broadcom SiByte SOC GB Ethernet driver");
 
 /* 1 normal messages, 0 quiet .. 7 verbose. */
 static int debug = 1;
-module_param(debug, int, S_IRUGO);
+module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "Debug messages");
 
 #ifdef CONFIG_SBMAC_COALESCE
 static int int_pktcnt_tx = 255;
-module_param(int_pktcnt_tx, int, S_IRUGO);
+module_param(int_pktcnt_tx, int, 0444);
 MODULE_PARM_DESC(int_pktcnt_tx, "TX packet count");
 
 static int int_timeout_tx = 255;
-module_param(int_timeout_tx, int, S_IRUGO);
+module_param(int_timeout_tx, int, 0444);
 MODULE_PARM_DESC(int_timeout_tx, "TX timeout value");
 
 static int int_pktcnt_rx = 64;
-module_param(int_pktcnt_rx, int, S_IRUGO);
+module_param(int_pktcnt_rx, int, 0444);
 MODULE_PARM_DESC(int_pktcnt_rx, "RX packet count");
 
 static int int_timeout_rx = 64;
-module_param(int_timeout_rx, int, S_IRUGO);
+module_param(int_timeout_rx, int, 0444);
 MODULE_PARM_DESC(int_timeout_rx, "RX timeout value");
 #endif
 
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index f2593978ae75..08bbb639be1a 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -10799,11 +10799,11 @@ static ssize_t tg3_show_temp(struct device *dev,
 }
 
 
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, tg3_show_temp, NULL,
+static SENSOR_DEVICE_ATTR(temp1_input, 0444, tg3_show_temp, NULL,
 			  TG3_TEMP_SENSOR_OFFSET);
-static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, tg3_show_temp, NULL,
+static SENSOR_DEVICE_ATTR(temp1_crit, 0444, tg3_show_temp, NULL,
 			  TG3_TEMP_CAUTION_OFFSET);
-static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO, tg3_show_temp, NULL,
+static SENSOR_DEVICE_ATTR(temp1_max, 0444, tg3_show_temp, NULL,
 			  TG3_TEMP_MAX_OFFSET);
 
 static struct attribute *tg3_attrs[] = {
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index a843076597ec..69cc3e0119d6 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -46,7 +46,7 @@ module_param(bnad_ioc_auto_recover, uint, 0444);
 MODULE_PARM_DESC(bnad_ioc_auto_recover, "Enable / Disable auto recovery");
 
 static uint bna_debugfs_enable = 1;
-module_param(bna_debugfs_enable, uint, S_IRUGO | S_IWUSR);
+module_param(bna_debugfs_enable, uint, 0644);
 MODULE_PARM_DESC(bna_debugfs_enable, "Enables debugfs feature, default=1,"
 		 " Range[false:0|true:1]");
 
diff --git a/drivers/net/ethernet/brocade/bna/bnad_debugfs.c b/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
index cebfe3bd086e..933799be0471 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
@@ -486,11 +486,11 @@ struct bnad_debugfs_entry {
 };
 
 static const struct bnad_debugfs_entry bnad_debugfs_files[] = {
-	{ "fwtrc",  S_IFREG|S_IRUGO, &bnad_debugfs_op_fwtrc, },
-	{ "fwsave", S_IFREG|S_IRUGO, &bnad_debugfs_op_fwsave, },
-	{ "regrd",  S_IFREG|S_IRUGO|S_IWUSR, &bnad_debugfs_op_regrd, },
-	{ "regwr",  S_IFREG|S_IWUSR, &bnad_debugfs_op_regwr, },
-	{ "drvinfo", S_IFREG|S_IRUGO, &bnad_debugfs_op_drvinfo, },
+	{ "fwtrc",  S_IFREG | 0444, &bnad_debugfs_op_fwtrc, },
+	{ "fwsave", S_IFREG | 0444, &bnad_debugfs_op_fwsave, },
+	{ "regrd",  S_IFREG | 0644, &bnad_debugfs_op_regrd, },
+	{ "regwr",  S_IFREG | 0200, &bnad_debugfs_op_regwr, },
+	{ "drvinfo", S_IFREG | 0444, &bnad_debugfs_op_drvinfo, },
 };
 
 static struct dentry *bna_debugfs_root;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 7d9c5ffbd041..73fe3881414b 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -63,7 +63,7 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug message level bitmap");
 
 static int cpi_alg = CPI_ALG_NONE;
-module_param(cpi_alg, int, S_IRUGO);
+module_param(cpi_alg, int, 0444);
 MODULE_PARM_DESC(cpi_alg,
 		 "PFC algorithm (0=none, 1=VLAN, 2=VLAN16, 3=IP Diffserv)");
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 185fe8df7628..2edfdbdaae48 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -776,11 +776,11 @@ static ssize_t store_nservers(struct device *d, struct device_attribute *attr,
 
 #define CXGB3_ATTR_R(name, val_expr) \
 CXGB3_SHOW(name, val_expr) \
-static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)
+static DEVICE_ATTR(name, 0444, show_##name, NULL)
 
 #define CXGB3_ATTR_RW(name, val_expr, store_method) \
 CXGB3_SHOW(name, val_expr) \
-static DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show_##name, store_method)
+static DEVICE_ATTR(name, 0644, show_##name, store_method)
 
 CXGB3_ATTR_R(cam_size, t3_mc5_size(&adap->mc5));
 CXGB3_ATTR_RW(nfilters, adap->params.mc5.nfilters, store_nfilters);
@@ -859,7 +859,7 @@ static ssize_t store_##name(struct device *d, struct device_attribute *attr, \
 { \
 	return tm_attr_store(d, buf, len, sched); \
 } \
-static DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show_##name, store_##name)
+static DEVICE_ATTR(name, 0644, show_##name, store_##name)
 
 TM_ATTR(sched0, 0);
 TM_ATTR(sched1, 1);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index de2ba86eccfd..251d5bdc972f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2752,7 +2752,7 @@ DEFINE_SIMPLE_DEBUGFS_FILE(tid_info);
 static void add_debugfs_mem(struct adapter *adap, const char *name,
 			    unsigned int idx, unsigned int size_mb)
 {
-	debugfs_create_file_size(name, S_IRUSR, adap->debugfs_root,
+	debugfs_create_file_size(name, 0400, adap->debugfs_root,
 				 (void *)adap + idx, &mem_debugfs_fops,
 				 size_mb << 20);
 }
@@ -2947,65 +2947,65 @@ int t4_setup_debugfs(struct adapter *adap)
 	struct dentry *de;
 
 	static struct t4_debugfs_entry t4_debugfs_files[] = {
-		{ "cim_la", &cim_la_fops, S_IRUSR, 0 },
-		{ "cim_pif_la", &cim_pif_la_fops, S_IRUSR, 0 },
-		{ "cim_ma_la", &cim_ma_la_fops, S_IRUSR, 0 },
-		{ "cim_qcfg", &cim_qcfg_fops, S_IRUSR, 0 },
-		{ "clk", &clk_debugfs_fops, S_IRUSR, 0 },
-		{ "devlog", &devlog_fops, S_IRUSR, 0 },
-		{ "mboxlog", &mboxlog_fops, S_IRUSR, 0 },
-		{ "mbox0", &mbox_debugfs_fops, S_IRUSR | S_IWUSR, 0 },
-		{ "mbox1", &mbox_debugfs_fops, S_IRUSR | S_IWUSR, 1 },
-		{ "mbox2", &mbox_debugfs_fops, S_IRUSR | S_IWUSR, 2 },
-		{ "mbox3", &mbox_debugfs_fops, S_IRUSR | S_IWUSR, 3 },
-		{ "mbox4", &mbox_debugfs_fops, S_IRUSR | S_IWUSR, 4 },
-		{ "mbox5", &mbox_debugfs_fops, S_IRUSR | S_IWUSR, 5 },
-		{ "mbox6", &mbox_debugfs_fops, S_IRUSR | S_IWUSR, 6 },
-		{ "mbox7", &mbox_debugfs_fops, S_IRUSR | S_IWUSR, 7 },
-		{ "trace0", &mps_trc_debugfs_fops, S_IRUSR | S_IWUSR, 0 },
-		{ "trace1", &mps_trc_debugfs_fops, S_IRUSR | S_IWUSR, 1 },
-		{ "trace2", &mps_trc_debugfs_fops, S_IRUSR | S_IWUSR, 2 },
-		{ "trace3", &mps_trc_debugfs_fops, S_IRUSR | S_IWUSR, 3 },
-		{ "l2t", &t4_l2t_fops, S_IRUSR, 0},
-		{ "mps_tcam", &mps_tcam_debugfs_fops, S_IRUSR, 0 },
-		{ "rss", &rss_debugfs_fops, S_IRUSR, 0 },
-		{ "rss_config", &rss_config_debugfs_fops, S_IRUSR, 0 },
-		{ "rss_key", &rss_key_debugfs_fops, S_IRUSR, 0 },
-		{ "rss_pf_config", &rss_pf_config_debugfs_fops, S_IRUSR, 0 },
-		{ "rss_vf_config", &rss_vf_config_debugfs_fops, S_IRUSR, 0 },
-		{ "sge_qinfo", &sge_qinfo_debugfs_fops, S_IRUSR, 0 },
-		{ "ibq_tp0",  &cim_ibq_fops, S_IRUSR, 0 },
-		{ "ibq_tp1",  &cim_ibq_fops, S_IRUSR, 1 },
-		{ "ibq_ulp",  &cim_ibq_fops, S_IRUSR, 2 },
-		{ "ibq_sge0", &cim_ibq_fops, S_IRUSR, 3 },
-		{ "ibq_sge1", &cim_ibq_fops, S_IRUSR, 4 },
-		{ "ibq_ncsi", &cim_ibq_fops, S_IRUSR, 5 },
-		{ "obq_ulp0", &cim_obq_fops, S_IRUSR, 0 },
-		{ "obq_ulp1", &cim_obq_fops, S_IRUSR, 1 },
-		{ "obq_ulp2", &cim_obq_fops, S_IRUSR, 2 },
-		{ "obq_ulp3", &cim_obq_fops, S_IRUSR, 3 },
-		{ "obq_sge",  &cim_obq_fops, S_IRUSR, 4 },
-		{ "obq_ncsi", &cim_obq_fops, S_IRUSR, 5 },
-		{ "tp_la", &tp_la_fops, S_IRUSR, 0 },
-		{ "ulprx_la", &ulprx_la_fops, S_IRUSR, 0 },
-		{ "sensors", &sensors_debugfs_fops, S_IRUSR, 0 },
-		{ "pm_stats", &pm_stats_debugfs_fops, S_IRUSR, 0 },
-		{ "tx_rate", &tx_rate_debugfs_fops, S_IRUSR, 0 },
-		{ "cctrl", &cctrl_tbl_debugfs_fops, S_IRUSR, 0 },
+		{ "cim_la", &cim_la_fops, 0400, 0 },
+		{ "cim_pif_la", &cim_pif_la_fops, 0400, 0 },
+		{ "cim_ma_la", &cim_ma_la_fops, 0400, 0 },
+		{ "cim_qcfg", &cim_qcfg_fops, 0400, 0 },
+		{ "clk", &clk_debugfs_fops, 0400, 0 },
+		{ "devlog", &devlog_fops, 0400, 0 },
+		{ "mboxlog", &mboxlog_fops, 0400, 0 },
+		{ "mbox0", &mbox_debugfs_fops, 0600, 0 },
+		{ "mbox1", &mbox_debugfs_fops, 0600, 1 },
+		{ "mbox2", &mbox_debugfs_fops, 0600, 2 },
+		{ "mbox3", &mbox_debugfs_fops, 0600, 3 },
+		{ "mbox4", &mbox_debugfs_fops, 0600, 4 },
+		{ "mbox5", &mbox_debugfs_fops, 0600, 5 },
+		{ "mbox6", &mbox_debugfs_fops, 0600, 6 },
+		{ "mbox7", &mbox_debugfs_fops, 0600, 7 },
+		{ "trace0", &mps_trc_debugfs_fops, 0600, 0 },
+		{ "trace1", &mps_trc_debugfs_fops, 0600, 1 },
+		{ "trace2", &mps_trc_debugfs_fops, 0600, 2 },
+		{ "trace3", &mps_trc_debugfs_fops, 0600, 3 },
+		{ "l2t", &t4_l2t_fops, 0400, 0},
+		{ "mps_tcam", &mps_tcam_debugfs_fops, 0400, 0 },
+		{ "rss", &rss_debugfs_fops, 0400, 0 },
+		{ "rss_config", &rss_config_debugfs_fops, 0400, 0 },
+		{ "rss_key", &rss_key_debugfs_fops, 0400, 0 },
+		{ "rss_pf_config", &rss_pf_config_debugfs_fops, 0400, 0 },
+		{ "rss_vf_config", &rss_vf_config_debugfs_fops, 0400, 0 },
+		{ "sge_qinfo", &sge_qinfo_debugfs_fops, 0400, 0 },
+		{ "ibq_tp0",  &cim_ibq_fops, 0400, 0 },
+		{ "ibq_tp1",  &cim_ibq_fops, 0400, 1 },
+		{ "ibq_ulp",  &cim_ibq_fops, 0400, 2 },
+		{ "ibq_sge0", &cim_ibq_fops, 0400, 3 },
+		{ "ibq_sge1", &cim_ibq_fops, 0400, 4 },
+		{ "ibq_ncsi", &cim_ibq_fops, 0400, 5 },
+		{ "obq_ulp0", &cim_obq_fops, 0400, 0 },
+		{ "obq_ulp1", &cim_obq_fops, 0400, 1 },
+		{ "obq_ulp2", &cim_obq_fops, 0400, 2 },
+		{ "obq_ulp3", &cim_obq_fops, 0400, 3 },
+		{ "obq_sge",  &cim_obq_fops, 0400, 4 },
+		{ "obq_ncsi", &cim_obq_fops, 0400, 5 },
+		{ "tp_la", &tp_la_fops, 0400, 0 },
+		{ "ulprx_la", &ulprx_la_fops, 0400, 0 },
+		{ "sensors", &sensors_debugfs_fops, 0400, 0 },
+		{ "pm_stats", &pm_stats_debugfs_fops, 0400, 0 },
+		{ "tx_rate", &tx_rate_debugfs_fops, 0400, 0 },
+		{ "cctrl", &cctrl_tbl_debugfs_fops, 0400, 0 },
 #if IS_ENABLED(CONFIG_IPV6)
-		{ "clip_tbl", &clip_tbl_debugfs_fops, S_IRUSR, 0 },
+		{ "clip_tbl", &clip_tbl_debugfs_fops, 0400, 0 },
 #endif
-		{ "tids", &tid_info_debugfs_fops, S_IRUSR, 0},
-		{ "blocked_fl", &blocked_fl_fops, S_IRUSR | S_IWUSR, 0 },
-		{ "meminfo", &meminfo_fops, S_IRUSR, 0 },
-		{ "crypto", &chcr_stats_debugfs_fops, S_IRUSR, 0 },
+		{ "tids", &tid_info_debugfs_fops, 0400, 0},
+		{ "blocked_fl", &blocked_fl_fops, 0600, 0 },
+		{ "meminfo", &meminfo_fops, 0400, 0 },
+		{ "crypto", &chcr_stats_debugfs_fops, 0400, 0 },
 	};
 
 	/* Debug FS nodes common to all T5 and later adapters.
 	 */
 	static struct t4_debugfs_entry t5_debugfs_files[] = {
-		{ "obq_sge_rx_q0", &cim_obq_fops, S_IRUSR, 6 },
-		{ "obq_sge_rx_q1", &cim_obq_fops, S_IRUSR, 7 },
+		{ "obq_sge_rx_q0", &cim_obq_fops, 0400, 6 },
+		{ "obq_sge_rx_q1", &cim_obq_fops, 0400, 7 },
 	};
 
 	add_debugfs_files(adap,
@@ -3050,11 +3050,11 @@ int t4_setup_debugfs(struct adapter *adap)
 		}
 	}
 
-	de = debugfs_create_file_size("flash", S_IRUSR, adap->debugfs_root, adap,
+	de = debugfs_create_file_size("flash", 0400, adap->debugfs_root, adap,
 				      &flash_debugfs_fops, adap->params.sf_size);
-	debugfs_create_bool("use_backdoor", S_IWUSR | S_IRUSR,
+	debugfs_create_bool("use_backdoor", 0600,
 			    adap->debugfs_root, &adap->use_bd);
-	debugfs_create_bool("trace_rss", S_IWUSR | S_IRUSR,
+	debugfs_create_bool("trace_rss", 0600,
 			    adap->debugfs_root, &adap->trace_rss);
 
 	return 0;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 7bd8497fd9be..9a81b52307a9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2402,11 +2402,11 @@ struct cxgb4vf_debugfs_entry {
 };
 
 static struct cxgb4vf_debugfs_entry debugfs_files[] = {
-	{ "mboxlog",    S_IRUGO, &mboxlog_fops },
-	{ "sge_qinfo",  S_IRUGO, &sge_qinfo_debugfs_fops },
-	{ "sge_qstats", S_IRUGO, &sge_qstats_proc_fops },
-	{ "resources",  S_IRUGO, &resources_proc_fops },
-	{ "interfaces", S_IRUGO, &interfaces_proc_fops },
+	{ "mboxlog",    0444, &mboxlog_fops },
+	{ "sge_qinfo",  0444, &sge_qinfo_debugfs_fops },
+	{ "sge_qstats", 0444, &sge_qstats_proc_fops },
+	{ "resources",  0444, &resources_proc_fops },
+	{ "interfaces", 0444, &interfaces_proc_fops },
 };
 
 /*
diff --git a/drivers/net/ethernet/ec_bhf.c b/drivers/net/ethernet/ec_bhf.c
index 1b79a6defd56..d71cba0842c5 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -602,7 +602,7 @@ static struct pci_driver pci_driver = {
 };
 module_pci_driver(pci_driver);
 
-module_param(polling_frequency, long, S_IRUGO);
+module_param(polling_frequency, long, 0444);
 MODULE_PARM_DESC(polling_frequency, "Polling timer frequency in ns");
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 5774fb6f8aa0..c697e79e491e 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -34,11 +34,11 @@ MODULE_LICENSE("GPL");
  * Use sysfs method to enable/disable VFs.
  */
 static unsigned int num_vfs;
-module_param(num_vfs, uint, S_IRUGO);
+module_param(num_vfs, uint, 0444);
 MODULE_PARM_DESC(num_vfs, "Number of PCI VFs to initialize");
 
 static ushort rx_frag_size = 2048;
-module_param(rx_frag_size, ushort, S_IRUGO);
+module_param(rx_frag_size, ushort, 0444);
 MODULE_PARM_DESC(rx_frag_size, "Size of a fragment that holds rcvd data.");
 
 /* Per-module error detection/recovery workq shared across all functions.
@@ -5788,7 +5788,7 @@ static ssize_t be_hwmon_show_temp(struct device *dev,
 			       adapter->hwmon_info.be_on_die_temp * 1000);
 }
 
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp1_input, 0444,
 			  be_hwmon_show_temp, NULL, 1);
 
 static struct attribute *be_hwmon_attrs[] = {
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 4878b7169e0f..ba580bfae512 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2903,8 +2903,7 @@ static ssize_t ehea_show_port_id(struct device *dev,
 	return sprintf(buf, "%d", port->logical_port_id);
 }
 
-static DEVICE_ATTR(log_port_id, S_IRUSR | S_IRGRP | S_IROTH, ehea_show_port_id,
-		   NULL);
+static DEVICE_ATTR(log_port_id, 0444, ehea_show_port_id, NULL);
 
 static void logical_port_release(struct device *dev)
 {
@@ -3235,8 +3234,8 @@ static ssize_t ehea_remove_port(struct device *dev,
 	return (ssize_t) count;
 }
 
-static DEVICE_ATTR(probe_port, S_IWUSR, NULL, ehea_probe_port);
-static DEVICE_ATTR(remove_port, S_IWUSR, NULL, ehea_remove_port);
+static DEVICE_ATTR(probe_port, 0200, NULL, ehea_probe_port);
+static DEVICE_ATTR(remove_port, 0200, NULL, ehea_remove_port);
 
 static int ehea_create_device_sysfs(struct platform_device *dev)
 {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index f210398200ec..c1b51edaaf62 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -82,7 +82,7 @@ module_param(rx_flush, uint, 0644);
 MODULE_PARM_DESC(rx_flush, "Flush receive buffers before use");
 
 static bool old_large_send __read_mostly;
-module_param(old_large_send, bool, S_IRUGO);
+module_param(old_large_send, bool, 0444);
 MODULE_PARM_DESC(old_large_send,
 	"Use old large send method on firmware that supports the new method");
 
diff --git a/drivers/net/ethernet/intel/igb/igb_hwmon.c b/drivers/net/ethernet/intel/igb/igb_hwmon.c
index 44b6a68f1af7..d87d27fb9e6e 100644
--- a/drivers/net/ethernet/intel/igb/igb_hwmon.c
+++ b/drivers/net/ethernet/intel/igb/igb_hwmon.c
@@ -147,7 +147,7 @@ static int igb_add_hwmon_attr(struct igb_adapter *adapter,
 		&adapter->hw.mac.thermal_sensor_data.sensor[offset];
 	igb_attr->hw = &adapter->hw;
 	igb_attr->dev_attr.store = NULL;
-	igb_attr->dev_attr.attr.mode = S_IRUGO;
+	igb_attr->dev_attr.attr.mode = 0444;
 	igb_attr->dev_attr.attr.name = igb_attr->name;
 	sysfs_attr_init(&igb_attr->dev_attr.attr);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c
index ef6df3d6437e..24766e125592 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c
@@ -146,7 +146,7 @@ static int ixgbe_add_hwmon_attr(struct ixgbe_adapter *adapter,
 		&adapter->hw.mac.thermal_sensor_data.sensor[offset];
 	ixgbe_attr->hw = &adapter->hw;
 	ixgbe_attr->dev_attr.store = NULL;
-	ixgbe_attr->dev_attr.attr.mode = S_IRUGO;
+	ixgbe_attr->dev_attr.attr.mode = 0444;
 	ixgbe_attr->dev_attr.attr.name = ixgbe_attr->name;
 	sysfs_attr_init(&ixgbe_attr->dev_attr.attr);
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 25e9a551cc8c..eaa4bb80f1c9 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4655,8 +4655,8 @@ MODULE_DESCRIPTION("Marvell NETA Ethernet Driver - www.marvell.com");
 MODULE_AUTHOR("Rami Rosen <rosenr@marvell.com>, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>");
 MODULE_LICENSE("GPL");
 
-module_param(rxq_number, int, S_IRUGO);
-module_param(txq_number, int, S_IRUGO);
+module_param(rxq_number, int, 0444);
+module_param(txq_number, int, 0444);
 
-module_param(rxq_def, int, S_IRUGO);
-module_param(rx_copybreak, int, S_IRUGO | S_IWUSR);
+module_param(rxq_def, int, 0444);
+module_param(rx_copybreak, int, 0644);
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 31efc47c847e..9c08c3650c02 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3783,7 +3783,7 @@ static int skge_device_event(struct notifier_block *unused,
 		break;
 
 	case NETDEV_UP:
-		d = debugfs_create_file(dev->name, S_IRUGO,
+		d = debugfs_create_file(dev->name, 0444,
 					skge_debug, dev,
 					&skge_debug_fops);
 		if (!d || IS_ERR(d))
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 9fe85300e7b6..9b77db7c13d0 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4667,7 +4667,7 @@ static int sky2_device_event(struct notifier_block *unused,
 		break;
 
 	case NETDEV_UP:
-		sky2->debugfs = debugfs_create_file(dev->name, S_IRUGO,
+		sky2->debugfs = debugfs_create_file(dev->name, 0444,
 						    sky2_debug, dev,
 						    &sky2_debug_fops);
 		if (IS_ERR(sky2->debugfs))
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 958619ff24ae..5af50191c181 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2994,10 +2994,10 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 
 	sprintf(info->dev_name, "mlx4_port%d", port);
 	info->port_attr.attr.name = info->dev_name;
-	if (mlx4_is_mfunc(dev))
-		info->port_attr.attr.mode = S_IRUGO;
-	else {
-		info->port_attr.attr.mode = S_IRUGO | S_IWUSR;
+	if (mlx4_is_mfunc(dev)) {
+		info->port_attr.attr.mode = 0444;
+	} else {
+		info->port_attr.attr.mode = 0644;
 		info->port_attr.store     = set_port_type;
 	}
 	info->port_attr.show      = show_port_type;
@@ -3012,10 +3012,10 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 
 	sprintf(info->dev_mtu_name, "mlx4_port%d_mtu", port);
 	info->port_mtu_attr.attr.name = info->dev_mtu_name;
-	if (mlx4_is_mfunc(dev))
-		info->port_mtu_attr.attr.mode = S_IRUGO;
-	else {
-		info->port_mtu_attr.attr.mode = S_IRUGO | S_IWUSR;
+	if (mlx4_is_mfunc(dev)) {
+		info->port_mtu_attr.attr.mode = 0444;
+	} else {
+		info->port_mtu_attr.attr.mode = 0644;
 		info->port_mtu_attr.store     = set_port_ib_mtu;
 	}
 	info->port_mtu_attr.show      = show_port_ib_mtu;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index ab710e37af99..84185f8dfbae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -218,32 +218,32 @@ static void mlxsw_hwmon_attr_add(struct mlxsw_hwmon *mlxsw_hwmon,
 	switch (attr_type) {
 	case MLXSW_HWMON_ATTR_TYPE_TEMP:
 		mlxsw_hwmon_attr->dev_attr.show = mlxsw_hwmon_temp_show;
-		mlxsw_hwmon_attr->dev_attr.attr.mode = S_IRUGO;
+		mlxsw_hwmon_attr->dev_attr.attr.mode = 0444;
 		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
 			 "temp%u_input", num + 1);
 		break;
 	case MLXSW_HWMON_ATTR_TYPE_TEMP_MAX:
 		mlxsw_hwmon_attr->dev_attr.show = mlxsw_hwmon_temp_max_show;
-		mlxsw_hwmon_attr->dev_attr.attr.mode = S_IRUGO;
+		mlxsw_hwmon_attr->dev_attr.attr.mode = 0444;
 		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
 			 "temp%u_highest", num + 1);
 		break;
 	case MLXSW_HWMON_ATTR_TYPE_TEMP_RST:
 		mlxsw_hwmon_attr->dev_attr.store = mlxsw_hwmon_temp_rst_store;
-		mlxsw_hwmon_attr->dev_attr.attr.mode = S_IWUSR;
+		mlxsw_hwmon_attr->dev_attr.attr.mode = 0200;
 		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
 			 "temp%u_reset_history", num + 1);
 		break;
 	case MLXSW_HWMON_ATTR_TYPE_FAN_RPM:
 		mlxsw_hwmon_attr->dev_attr.show = mlxsw_hwmon_fan_rpm_show;
-		mlxsw_hwmon_attr->dev_attr.attr.mode = S_IRUGO;
+		mlxsw_hwmon_attr->dev_attr.attr.mode = 0444;
 		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
 			 "fan%u_input", num + 1);
 		break;
 	case MLXSW_HWMON_ATTR_TYPE_PWM:
 		mlxsw_hwmon_attr->dev_attr.show = mlxsw_hwmon_pwm_show;
 		mlxsw_hwmon_attr->dev_attr.store = mlxsw_hwmon_pwm_store;
-		mlxsw_hwmon_attr->dev_attr.attr.mode = S_IWUSR | S_IRUGO;
+		mlxsw_hwmon_attr->dev_attr.attr.mode = 0644;
 		snprintf(mlxsw_hwmon_attr->name, sizeof(mlxsw_hwmon_attr->name),
 			 "pwm%u", num + 1);
 		break;
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 2521c8c40015..b2d2ec8c11e2 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -266,7 +266,7 @@ MODULE_FIRMWARE("myri10ge_rss_eth_z8e.dat");
 
 /* Careful: must be accessed under kernel_param_lock() */
 static char *myri10ge_fw_name = NULL;
-module_param(myri10ge_fw_name, charp, S_IRUGO | S_IWUSR);
+module_param(myri10ge_fw_name, charp, 0644);
 MODULE_PARM_DESC(myri10ge_fw_name, "Firmware image name");
 
 #define MYRI10GE_MAX_BOARDS 8
@@ -277,49 +277,49 @@ module_param_array_named(myri10ge_fw_names, myri10ge_fw_names, charp, NULL,
 MODULE_PARM_DESC(myri10ge_fw_names, "Firmware image names per board");
 
 static int myri10ge_ecrc_enable = 1;
-module_param(myri10ge_ecrc_enable, int, S_IRUGO);
+module_param(myri10ge_ecrc_enable, int, 0444);
 MODULE_PARM_DESC(myri10ge_ecrc_enable, "Enable Extended CRC on PCI-E");
 
 static int myri10ge_small_bytes = -1;	/* -1 == auto */
-module_param(myri10ge_small_bytes, int, S_IRUGO | S_IWUSR);
+module_param(myri10ge_small_bytes, int, 0644);
 MODULE_PARM_DESC(myri10ge_small_bytes, "Threshold of small packets");
 
 static int myri10ge_msi = 1;	/* enable msi by default */
-module_param(myri10ge_msi, int, S_IRUGO | S_IWUSR);
+module_param(myri10ge_msi, int, 0644);
 MODULE_PARM_DESC(myri10ge_msi, "Enable Message Signalled Interrupts");
 
 static int myri10ge_intr_coal_delay = 75;
-module_param(myri10ge_intr_coal_delay, int, S_IRUGO);
+module_param(myri10ge_intr_coal_delay, int, 0444);
 MODULE_PARM_DESC(myri10ge_intr_coal_delay, "Interrupt coalescing delay");
 
 static int myri10ge_flow_control = 1;
-module_param(myri10ge_flow_control, int, S_IRUGO);
+module_param(myri10ge_flow_control, int, 0444);
 MODULE_PARM_DESC(myri10ge_flow_control, "Pause parameter");
 
 static int myri10ge_deassert_wait = 1;
-module_param(myri10ge_deassert_wait, int, S_IRUGO | S_IWUSR);
+module_param(myri10ge_deassert_wait, int, 0644);
 MODULE_PARM_DESC(myri10ge_deassert_wait,
 		 "Wait when deasserting legacy interrupts");
 
 static int myri10ge_force_firmware = 0;
-module_param(myri10ge_force_firmware, int, S_IRUGO);
+module_param(myri10ge_force_firmware, int, 0444);
 MODULE_PARM_DESC(myri10ge_force_firmware,
 		 "Force firmware to assume aligned completions");
 
 static int myri10ge_initial_mtu = MYRI10GE_MAX_ETHER_MTU - ETH_HLEN;
-module_param(myri10ge_initial_mtu, int, S_IRUGO);
+module_param(myri10ge_initial_mtu, int, 0444);
 MODULE_PARM_DESC(myri10ge_initial_mtu, "Initial MTU");
 
 static int myri10ge_napi_weight = 64;
-module_param(myri10ge_napi_weight, int, S_IRUGO);
+module_param(myri10ge_napi_weight, int, 0444);
 MODULE_PARM_DESC(myri10ge_napi_weight, "Set NAPI weight");
 
 static int myri10ge_watchdog_timeout = 1;
-module_param(myri10ge_watchdog_timeout, int, S_IRUGO);
+module_param(myri10ge_watchdog_timeout, int, 0444);
 MODULE_PARM_DESC(myri10ge_watchdog_timeout, "Set watchdog timeout");
 
 static int myri10ge_max_irq_loops = 1048576;
-module_param(myri10ge_max_irq_loops, int, S_IRUGO);
+module_param(myri10ge_max_irq_loops, int, 0444);
 MODULE_PARM_DESC(myri10ge_max_irq_loops,
 		 "Set stuck legacy IRQ detection threshold");
 
@@ -330,21 +330,21 @@ module_param(myri10ge_debug, int, 0);
 MODULE_PARM_DESC(myri10ge_debug, "Debug level (0=none,...,16=all)");
 
 static int myri10ge_fill_thresh = 256;
-module_param(myri10ge_fill_thresh, int, S_IRUGO | S_IWUSR);
+module_param(myri10ge_fill_thresh, int, 0644);
 MODULE_PARM_DESC(myri10ge_fill_thresh, "Number of empty rx slots allowed");
 
 static int myri10ge_reset_recover = 1;
 
 static int myri10ge_max_slices = 1;
-module_param(myri10ge_max_slices, int, S_IRUGO);
+module_param(myri10ge_max_slices, int, 0444);
 MODULE_PARM_DESC(myri10ge_max_slices, "Max tx/rx queues");
 
 static int myri10ge_rss_hash = MXGEFW_RSS_HASH_TYPE_SRC_DST_PORT;
-module_param(myri10ge_rss_hash, int, S_IRUGO);
+module_param(myri10ge_rss_hash, int, 0444);
 MODULE_PARM_DESC(myri10ge_rss_hash, "Type of RSS hashing to do");
 
 static int myri10ge_dca = 1;
-module_param(myri10ge_dca, int, S_IRUGO);
+module_param(myri10ge_dca, int, 0444);
 MODULE_PARM_DESC(myri10ge_dca, "Enable DCA if possible");
 
 #define MYRI10GE_FW_OFFSET 1024*1024
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
index cf81cf95d1d8..67cdd8330c59 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
@@ -231,15 +231,15 @@ void nfp_net_debugfs_vnic_add(struct nfp_net *nn, struct dentry *ddir, int id)
 
 	for (i = 0; i < min(nn->max_rx_rings, nn->max_r_vecs); i++) {
 		sprintf(name, "%d", i);
-		debugfs_create_file(name, S_IRUSR, rx,
+		debugfs_create_file(name, 0400, rx,
 				    &nn->r_vecs[i], &nfp_rx_q_fops);
-		debugfs_create_file(name, S_IRUSR, xdp,
+		debugfs_create_file(name, 0400, xdp,
 				    &nn->r_vecs[i], &nfp_xdp_q_fops);
 	}
 
 	for (i = 0; i < min(nn->max_tx_rings, nn->max_r_vecs); i++) {
 		sprintf(name, "%d", i);
-		debugfs_create_file(name, S_IRUSR, tx,
+		debugfs_create_file(name, 0400, tx,
 				    &nn->r_vecs[i], &nfp_tx_q_fops);
 	}
 }
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index f2e8de607119..8259e8309320 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -2829,9 +2829,9 @@ netxen_show_bridged_mode(struct device *dev,
 }
 
 static const struct device_attribute dev_attr_bridged_mode = {
-       .attr = {.name = "bridged_mode", .mode = (S_IRUGO | S_IWUSR)},
-       .show = netxen_show_bridged_mode,
-       .store = netxen_store_bridged_mode,
+	.attr = { .name = "bridged_mode", .mode = 0644 },
+	.show = netxen_show_bridged_mode,
+	.store = netxen_store_bridged_mode,
 };
 
 static ssize_t
@@ -2861,7 +2861,7 @@ netxen_show_diag_mode(struct device *dev,
 }
 
 static const struct device_attribute dev_attr_diag_mode = {
-	.attr = {.name = "diag_mode", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "diag_mode", .mode = 0644 },
 	.show = netxen_show_diag_mode,
 	.store = netxen_store_diag_mode,
 };
@@ -3006,14 +3006,14 @@ static ssize_t netxen_sysfs_write_mem(struct file *filp, struct kobject *kobj,
 
 
 static const struct bin_attribute bin_attr_crb = {
-	.attr = {.name = "crb", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "crb", .mode = 0644 },
 	.size = 0,
 	.read = netxen_sysfs_read_crb,
 	.write = netxen_sysfs_write_crb,
 };
 
 static const struct bin_attribute bin_attr_mem = {
-	.attr = {.name = "mem", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "mem", .mode = 0644 },
 	.size = 0,
 	.read = netxen_sysfs_read_mem,
 	.write = netxen_sysfs_write_mem,
@@ -3142,7 +3142,7 @@ netxen_sysfs_read_dimm(struct file *filp, struct kobject *kobj,
 }
 
 static const struct bin_attribute bin_attr_dimm = {
-	.attr = { .name = "dimm", .mode = (S_IRUGO | S_IWUSR) },
+	.attr = { .name = "dimm", .mode = 0644 },
 	.size = sizeof(struct netxen_dimm_cfg),
 	.read = netxen_sysfs_read_dimm,
 };
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
index 287d89dd086f..891f03a7a33d 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
@@ -1175,81 +1175,81 @@ static ssize_t qlcnic_83xx_sysfs_flash_write_handler(struct file *filp,
 }
 
 static const struct device_attribute dev_attr_bridged_mode = {
-       .attr = {.name = "bridged_mode", .mode = (S_IRUGO | S_IWUSR)},
-       .show = qlcnic_show_bridged_mode,
-       .store = qlcnic_store_bridged_mode,
+	.attr = { .name = "bridged_mode", .mode = 0644 },
+	.show = qlcnic_show_bridged_mode,
+	.store = qlcnic_store_bridged_mode,
 };
 
 static const struct device_attribute dev_attr_diag_mode = {
-	.attr = {.name = "diag_mode", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "diag_mode", .mode = 0644 },
 	.show = qlcnic_show_diag_mode,
 	.store = qlcnic_store_diag_mode,
 };
 
 static const struct device_attribute dev_attr_beacon = {
-	.attr = {.name = "beacon", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "beacon", .mode = 0644 },
 	.show = qlcnic_show_beacon,
 	.store = qlcnic_store_beacon,
 };
 
 static const struct bin_attribute bin_attr_crb = {
-	.attr = {.name = "crb", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "crb", .mode = 0644 },
 	.size = 0,
 	.read = qlcnic_sysfs_read_crb,
 	.write = qlcnic_sysfs_write_crb,
 };
 
 static const struct bin_attribute bin_attr_mem = {
-	.attr = {.name = "mem", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "mem", .mode = 0644 },
 	.size = 0,
 	.read = qlcnic_sysfs_read_mem,
 	.write = qlcnic_sysfs_write_mem,
 };
 
 static const struct bin_attribute bin_attr_npar_config = {
-	.attr = {.name = "npar_config", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "npar_config", .mode = 0644 },
 	.size = 0,
 	.read = qlcnic_sysfs_read_npar_config,
 	.write = qlcnic_sysfs_write_npar_config,
 };
 
 static const struct bin_attribute bin_attr_pci_config = {
-	.attr = {.name = "pci_config", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "pci_config", .mode = 0644 },
 	.size = 0,
 	.read = qlcnic_sysfs_read_pci_config,
 	.write = NULL,
 };
 
 static const struct bin_attribute bin_attr_port_stats = {
-	.attr = {.name = "port_stats", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "port_stats", .mode = 0644 },
 	.size = 0,
 	.read = qlcnic_sysfs_get_port_stats,
 	.write = qlcnic_sysfs_clear_port_stats,
 };
 
 static const struct bin_attribute bin_attr_esw_stats = {
-	.attr = {.name = "esw_stats", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "esw_stats", .mode = 0644 },
 	.size = 0,
 	.read = qlcnic_sysfs_get_esw_stats,
 	.write = qlcnic_sysfs_clear_esw_stats,
 };
 
 static const struct bin_attribute bin_attr_esw_config = {
-	.attr = {.name = "esw_config", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "esw_config", .mode = 0644 },
 	.size = 0,
 	.read = qlcnic_sysfs_read_esw_config,
 	.write = qlcnic_sysfs_write_esw_config,
 };
 
 static const struct bin_attribute bin_attr_pm_config = {
-	.attr = {.name = "pm_config", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "pm_config", .mode = 0644 },
 	.size = 0,
 	.read = qlcnic_sysfs_read_pm_config,
 	.write = qlcnic_sysfs_write_pm_config,
 };
 
 static const struct bin_attribute bin_attr_flash = {
-	.attr = {.name = "flash", .mode = (S_IRUGO | S_IWUSR)},
+	.attr = { .name = "flash", .mode = 0644 },
 	.size = 0,
 	.read = qlcnic_83xx_sysfs_flash_read_handler,
 	.write = qlcnic_83xx_sysfs_flash_write_handler,
@@ -1276,7 +1276,7 @@ static ssize_t qlcnic_hwmon_show_temp(struct device *dev,
 }
 
 /* hwmon-sysfs attributes */
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp1_input, 0444,
 			  qlcnic_hwmon_show_temp, NULL, 1);
 
 static struct attribute *qlcnic_hwmon_attrs[] = {
diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index 92b6be9c4429..51d89c86e60f 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -151,7 +151,7 @@ qcaspi_init_device_debugfs(struct qcaspi *qca)
 			dev_name(&qca->net_dev->dev));
 		return;
 	}
-	debugfs_create_file("info", S_IFREG | S_IRUGO, device_root, qca,
+	debugfs_create_file("info", S_IFREG | 0444, device_root, qca,
 			    &qcaspi_info_ops);
 }
 
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index fd35d8004a78..a9da1ad4b4f2 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -57,9 +57,9 @@
 static int debug = -1;
 static int eee_timer = SXGBE_DEFAULT_LPI_TIMER;
 
-module_param(eee_timer, int, S_IRUGO | S_IWUSR);
+module_param(eee_timer, int, 0644);
 
-module_param(debug, int, S_IRUGO | S_IWUSR);
+module_param(debug, int, 0644);
 static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 				      NETIF_MSG_LINK | NETIF_MSG_IFUP |
 				      NETIF_MSG_IFDOWN | NETIF_MSG_TIMER);
diff --git a/drivers/net/ethernet/sfc/mcdi_mon.c b/drivers/net/ethernet/sfc/mcdi_mon.c
index f97da05952c7..f17751559ccc 100644
--- a/drivers/net/ethernet/sfc/mcdi_mon.c
+++ b/drivers/net/ethernet/sfc/mcdi_mon.c
@@ -298,7 +298,7 @@ efx_mcdi_mon_add_attr(struct efx_nic *efx, const char *name,
 	attr->limit_value = limit_value;
 	sysfs_attr_init(&attr->dev_attr.attr);
 	attr->dev_attr.attr.name = attr->name;
-	attr->dev_attr.attr.mode = S_IRUGO;
+	attr->dev_attr.attr.mode = 0444;
 	attr->dev_attr.show = reader;
 	hwmon->group.attrs[hwmon->n_attrs++] = &attr->dev_attr.attr;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a9856a8bf8ad..9f983dd069d5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -57,36 +57,36 @@
 /* Module parameters */
 #define TX_TIMEO	5000
 static int watchdog = TX_TIMEO;
-module_param(watchdog, int, S_IRUGO | S_IWUSR);
+module_param(watchdog, int, 0644);
 MODULE_PARM_DESC(watchdog, "Transmit timeout in milliseconds (default 5s)");
 
 static int debug = -1;
-module_param(debug, int, S_IRUGO | S_IWUSR);
+module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Message Level (-1: default, 0: no output, 16: all)");
 
 static int phyaddr = -1;
-module_param(phyaddr, int, S_IRUGO);
+module_param(phyaddr, int, 0444);
 MODULE_PARM_DESC(phyaddr, "Physical device address");
 
 #define STMMAC_TX_THRESH	(DMA_TX_SIZE / 4)
 #define STMMAC_RX_THRESH	(DMA_RX_SIZE / 4)
 
 static int flow_ctrl = FLOW_OFF;
-module_param(flow_ctrl, int, S_IRUGO | S_IWUSR);
+module_param(flow_ctrl, int, 0644);
 MODULE_PARM_DESC(flow_ctrl, "Flow control ability [on/off]");
 
 static int pause = PAUSE_TIME;
-module_param(pause, int, S_IRUGO | S_IWUSR);
+module_param(pause, int, 0644);
 MODULE_PARM_DESC(pause, "Flow Control Pause Time");
 
 #define TC_DEFAULT 64
 static int tc = TC_DEFAULT;
-module_param(tc, int, S_IRUGO | S_IWUSR);
+module_param(tc, int, 0644);
 MODULE_PARM_DESC(tc, "DMA threshold control value");
 
 #define	DEFAULT_BUFSIZE	1536
 static int buf_sz = DEFAULT_BUFSIZE;
-module_param(buf_sz, int, S_IRUGO | S_IWUSR);
+module_param(buf_sz, int, 0644);
 MODULE_PARM_DESC(buf_sz, "DMA buffer size");
 
 #define	STMMAC_RX_COPYBREAK	256
@@ -97,7 +97,7 @@ static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 
 #define STMMAC_DEFAULT_LPI_TIMER	1000
 static int eee_timer = STMMAC_DEFAULT_LPI_TIMER;
-module_param(eee_timer, int, S_IRUGO | S_IWUSR);
+module_param(eee_timer, int, 0644);
 MODULE_PARM_DESC(eee_timer, "LPI tx expiration time in msec");
 #define STMMAC_LPI_T(x) (jiffies + msecs_to_jiffies(x))
 
@@ -105,7 +105,7 @@ MODULE_PARM_DESC(eee_timer, "LPI tx expiration time in msec");
  * but allow user to force to use the chain instead of the ring
  */
 static unsigned int chain_mode;
-module_param(chain_mode, int, S_IRUGO);
+module_param(chain_mode, int, 0444);
 MODULE_PARM_DESC(chain_mode, "To use chain instead of ring mode");
 
 static irqreturn_t stmmac_interrupt(int irq, void *dev_id);
@@ -4001,7 +4001,7 @@ static int stmmac_init_fs(struct net_device *dev)
 
 	/* Entry to report DMA RX/TX rings */
 	priv->dbgfs_rings_status =
-		debugfs_create_file("descriptors_status", S_IRUGO,
+		debugfs_create_file("descriptors_status", 0444,
 				    priv->dbgfs_dir, dev,
 				    &stmmac_rings_status_fops);
 
@@ -4013,9 +4013,9 @@ static int stmmac_init_fs(struct net_device *dev)
 	}
 
 	/* Entry to report the DMA HW features */
-	priv->dbgfs_dma_cap = debugfs_create_file("dma_cap", S_IRUGO,
-					    priv->dbgfs_dir,
-					    dev, &stmmac_dma_cap_fops);
+	priv->dbgfs_dma_cap = debugfs_create_file("dma_cap", 0444,
+						  priv->dbgfs_dir,
+						  dev, &stmmac_dma_cap_fops);
 
 	if (!priv->dbgfs_dma_cap || IS_ERR(priv->dbgfs_dma_cap)) {
 		netdev_err(priv->dev, "ERROR creating stmmac MMC debugfs file\n");
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 8dd545fed30d..f081de4f38d7 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9437,11 +9437,11 @@ static ssize_t show_num_ports(struct device *dev,
 }
 
 static struct device_attribute niu_parent_attributes[] = {
-	__ATTR(port_phy, S_IRUGO, show_port_phy, NULL),
-	__ATTR(plat_type, S_IRUGO, show_plat_type, NULL),
-	__ATTR(rxchan_per_port, S_IRUGO, show_rxchan_per_port, NULL),
-	__ATTR(txchan_per_port, S_IRUGO, show_txchan_per_port, NULL),
-	__ATTR(num_ports, S_IRUGO, show_num_ports, NULL),
+	__ATTR(port_phy, 0444, show_port_phy, NULL),
+	__ATTR(plat_type, 0444, show_plat_type, NULL),
+	__ATTR(rxchan_per_port, 0444, show_rxchan_per_port, NULL),
+	__ATTR(txchan_per_port, 0444, show_txchan_per_port, NULL),
+	__ATTR(num_ports, 0444, show_num_ports, NULL),
 	{}
 };
 
-- 
2.15.0
