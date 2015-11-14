From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 07/18] staging/rdma/hfi1: Extend quiet timeout
Date: Fri, 13 Nov 2015 19:37:05 -0800
Message-ID: <1447472236-622-7-git-send-email-jubin.john@intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1447472236-622-1-git-send-email-jubin.john@intel.com>
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

From: Dean Luick <dean.luick@intel.com>

The longest quiet timeout is now 6s.  Extend the driver wait.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index be89e37..f1ee644 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6339,9 +6339,10 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 	 * depending on how the link went down.  The 8051 firmware
 	 * will observe the needed wait time and only move to ready
 	 * when that is completed.  The largest of the quiet timeouts
-	 * is 2.5s, so wait that long and then a bit more.
+	 * is 6s, so wait that long and then at least 0.5s more for
+	 * other transitions, and another 0.5s for a buffer.
 	 */
-	ret = wait_fm_ready(dd, 3000);
+	ret = wait_fm_ready(dd, 7000);
 	if (ret) {
 		dd_dev_err(dd,
 			"After going offline, timed out waiting for the 8051 to become ready to accept host requests\n");
-- 
1.7.0.7
