From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/15] IB/hfi1: Correct log message strings
Date: Thu, 12 May 2016 10:23:35 -0700
Message-ID: <20160512172333.9741.11186.stgit@scvm10.sc.intel.com>
References: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172050.9741.84190.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove "IB" keyword from log messages.
Correct comment for thermal sensor init function.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c   |    2 +-
 drivers/staging/rdma/hfi1/driver.c |    2 +-
 drivers/staging/rdma/hfi1/hfi.h    |    5 ++---
 drivers/staging/rdma/hfi1/sysfs.c  |    4 ++--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index ec0953e..d8cc329 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -14588,7 +14588,7 @@ u64 create_pbc(struct hfi1_pportdata *ppd, u64 flags, int srate_mbs, u32 vl,
 		   (reason), (ret))
 
 /*
- * Initialize the Avago Thermal sensor.
+ * Initialize the thermal sensor.
  *
  * After initialization, enable polling of thermal sensor through
  * SBus interface. In order for this to work, the SBus Master
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 700c6fa..c75b0ae 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -1161,7 +1161,7 @@ int hfi1_set_lid(struct hfi1_pportdata *ppd, u32 lid, u8 lmc)
 	ppd->lmc = lmc;
 	hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_LIDLMC, 0);
 
-	dd_dev_info(dd, "IB%u:%u got a lid: 0x%x\n", dd->unit, ppd->port, lid);
+	dd_dev_info(dd, "port %u: got a lid: 0x%x\n", ppd->port, lid);
 
 	return 0;
 }
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 6485a1d..75911cd 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1883,9 +1883,8 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 		get_unit_name((dd)->unit), ##__VA_ARGS__)
 
 #define hfi1_dev_porterr(dd, port, fmt, ...) \
-	dev_err(&(dd)->pcidev->dev, "%s: IB%u:%u " fmt, \
-			get_unit_name((dd)->unit), (dd)->unit, (port), \
-			##__VA_ARGS__)
+	dev_err(&(dd)->pcidev->dev, "%s: port %u: " fmt, \
+			get_unit_name((dd)->unit), (port), ##__VA_ARGS__)
 
 /*
  * this is used for formatting hw error messages...
diff --git a/drivers/staging/rdma/hfi1/sysfs.c b/drivers/staging/rdma/hfi1/sysfs.c
index 2ff5a14..db1a617 100644
--- a/drivers/staging/rdma/hfi1/sysfs.c
+++ b/drivers/staging/rdma/hfi1/sysfs.c
@@ -729,8 +729,8 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 	}
 
 	dd_dev_info(dd,
-		    "IB%u: Congestion Control Agent enabled for port %d\n",
-		    dd->unit, port_num);
+		    "Congestion Control Agent enabled for port %d\n",
+		    port_num);
 
 	return 0;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
