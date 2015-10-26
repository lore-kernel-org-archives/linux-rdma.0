From: ira.weiny@intel.com
Subject: [PATCH v3 08/23] staging/rdma/hfi1: Reset firmware instead of
 reloading Sbus
Date: Mon, 26 Oct 2015 10:28:34 -0400
Message-ID: <1445869729-7507-9-git-send-email-ira.weiny@intel.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, dledford@redhat.com, Caz Yokoyama <caz.yokoyama@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Caz Yokoyama <caz.yokoyama@intel.com>

Reset firmware instead of reloading Sbus firmware if it's already done for this
ASIC.  To work around thermal polling problem in firmware, don't reload Sbus
firmware, instead, reset the firmware on the initialization of the second HFI.

Reviewed-by: Easwar Hariharan <easwar.hariharan@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Caz Yokoyama <caz.yokoyama@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/chip.h     |  1 +
 drivers/staging/rdma/hfi1/firmware.c |  4 +---
 drivers/staging/rdma/hfi1/pcie.c     | 13 ++++++++++++-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index f89a432c7334..497c5de23d53 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -609,6 +609,7 @@ static inline void write_uctxt_csr(struct hfi1_devdata *dd, int ctxt,
 u64 create_pbc(struct hfi1_pportdata *ppd, u64, int, u32, u32);
 
 /* firmware.c */
+#define SBUS_MASTER_BROADCAST 0xfd
 #define NUM_PCIE_SERDES 16	/* number of PCIe serdes on the SBus */
 extern const u8 pcie_serdes_broadcast[];
 extern const u8 pcie_pcs_addrs[2][NUM_PCIE_SERDES];
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 15c9cb7a3150..ace75ce3da3f 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -924,9 +924,6 @@ static int load_8051_firmware(struct hfi1_devdata *dd,
 	return 0;
 }
 
-/* SBus Master broadcast address */
-#define SBUS_MASTER_BROADCAST 0xfd
-
 /*
  * Write the SBus request register
  *
@@ -1255,6 +1252,7 @@ int load_firmware(struct hfi1_devdata *dd)
 			ret = load_sbus_firmware(dd, &fw_sbus);
 			if (ret)
 				goto clear;
+			fw_sbus_load = 0;
 		}
 
 		if (fw_fabric_serdes_load) {
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index ac5653c0f65e..3b50cdda1c0a 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -946,9 +946,20 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 			    __func__);
 	}
 
+retry:
+	if (therm) {
+		/* toggle SPICO_ENABLE to get back to the state
+		   just after the firmware load */
+		sbus_request(dd, SBUS_MASTER_BROADCAST, 0x01,
+			WRITE_SBUS_RECEIVER, 0x00000040);
+		sbus_request(dd, SBUS_MASTER_BROADCAST, 0x01,
+			WRITE_SBUS_RECEIVER, 0x00000140);
+		dd_dev_info(dd, "%s: toggle SPICO_ENABLE to reset the bus\n",
+			    __func__);
+	}
+
 	/* step 3: download SBus Master firmware */
 	/* step 4: download PCIe Gen3 SerDes firmware */
-retry:
 	dd_dev_info(dd, "%s: downloading firmware\n", __func__);
 	ret = load_pcie_firmware(dd);
 	if (ret)
-- 
1.8.2
