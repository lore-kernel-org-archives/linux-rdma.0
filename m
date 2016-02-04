From: "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>
Subject: [PATCH] staging: rdma: use setup_timer() api
Date: Thu, 4 Feb 2016 13:22:05 +0000
Message-ID: <20160204132316.GA25672@IND12F0122>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <9EC918487913D54AB295F19EFE54CBA9@eurprd06.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "infinipath@intel.com" <infinipath@intel.com>, "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>, "sagig@mellanox.com" <sagig@mellanox.com>
Cc: "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "matanb@mellanox.com" <matanb@mellanox.com>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Hari Prasath Gujulan Elango <hgujulan@visteon.com>

Date: Thu, 4 Feb 2016 18:46:31 +0530
Replace the timer API's to initialize a timer & then assign the callback
function by the setup_timer() API.

Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
---
 drivers/staging/rdma/ehca/ehca_main.c | 3 +--
 drivers/staging/rdma/hfi1/verbs.c     | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/ehca/ehca_main.c b/drivers/staging/rdma/ehca/ehca_main.c
index 832f22f..e545712 100644
--- a/drivers/staging/rdma/ehca/ehca_main.c
+++ b/drivers/staging/rdma/ehca/ehca_main.c
@@ -1073,8 +1073,7 @@ static int __init ehca_module_init(void)
 		ehca_gen_err("WARNING!!!");
 		ehca_gen_err("It is possible to lose interrupts.");
 	} else {
-		init_timer(&poll_eqs_timer);
-		poll_eqs_timer.function = ehca_poll_eqs;
+		setup_timer(&poll_eqs_timer, ehca_poll_eqs, 0UL);
 		poll_eqs_timer.expires = jiffies + HZ;
 		add_timer(&poll_eqs_timer);
 	}
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 09b8d41..769388d 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1926,8 +1926,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	spin_lock_init(&dev->n_qps_lock);
 	spin_lock_init(&dev->n_srqs_lock);
 	spin_lock_init(&dev->n_mcast_grps_lock);
-	init_timer(&dev->mem_timer);
-	dev->mem_timer.function = mem_timer;
+	setup_timer(&dev->mem_timer, mem_timer, 0UL);
 	dev->mem_timer.data = (unsigned long) dev;
 
 	/*
-- 
1.9.1
