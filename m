From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 09/22] staging/rdma/hfi1: Reset firmware instead of reloading Sbus
Date: Mon, 19 Oct 2015 22:11:24 -0400
Message-ID: <1445307097-8244-10-git-send-email-ira.weiny@intel.com>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445307097-8244-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Caz Yokoyama <caz.yokoyama-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Caz Yokoyama <caz.yokoyama-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reset firmware instead of reloading Sbus firmware if it's already done for this
ASIC.  To work around thermal polling problem in firmware, don't reload Sbus
firmware, instead, reset the firmware on the initialization of the second HFI.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Caz Yokoyama <caz.yokoyama-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
