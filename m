From: Jubin John <jubin.john@intel.com>
Subject: [PATCH v2] staging/rdma/hfi1: Disable thermal polling before sensor
 initialization
Date: Thu,  5 Nov 2015 18:36:25 -0500
Message-ID: <1446766585-25952-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Jareer Abdel-Qader <jareer.h.abdel-qader@intel.com>

During driver load the thermal sensor needs to be reset prior
to initialization of the sensor. This prevents a possible sensor lock
up which can cause the wrong temperature value to be reported.
This fix leads to remove disabling thermal polling from
reset_asic_csrs() function.

Reviewed by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed by: Easwar Hariharan <easwar.hariharan@intel.com>
Signed-off-by: Jareer Abdel-Qader <jareer.h.abdel-qader@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
Changes in v2:
	- Fixed author name format

 drivers/staging/rdma/hfi1/chip.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e489819..e1951f4 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9455,7 +9455,7 @@ static void reset_asic_csrs(struct hfi1_devdata *dd)
 	/* We might want to retain this state across FLR if we ever use it */
 	write_csr(dd, ASIC_CFG_DRV_STR, 0);
 
-	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0);
+	/* ASIC_CFG_THERM_POLL_EN leave alone */
 	/* ASIC_STS_THERM read-only */
 	/* ASIC_CFG_RESET leave alone */
 
@@ -10803,7 +10803,9 @@ static int thermal_init(struct hfi1_devdata *dd)
 
 	acquire_hw_mutex(dd);
 	dd_dev_info(dd, "Initializing thermal sensor\n");
-
+	/* Disable polling of thermal readings */
+	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0x0);
+	msleep(100);
 	/* Thermal Sensor Initialization */
 	/*    Step 1: Reset the Thermal SBus Receiver */
 	ret = sbus_request_slow(dd, SBUS_THERMAL, 0x0,
-- 
1.7.1
