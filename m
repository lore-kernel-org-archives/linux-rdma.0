From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 18/18] staging/rdma/hfi1: Workaround CONFIG_SDMA_VERBOSITY
 timing issue
Date: Fri, 13 Nov 2015 19:37:16 -0800
Message-ID: <1447472236-622-18-git-send-email-jubin.john@intel.com>
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

Enabling CONFIG_SDMA_VERBOSITY exposes a timing issue in the
driver/DC firmware. Removing the CCE_INT_* CSR reads from
sdma_dumpstate and a sdma_dumpstate call from the sdma_sendctrl()
works around the issue

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/sdma.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 2a1da21..b74a451 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -1635,9 +1635,6 @@ static void sdma_sendctrl(struct sdma_engine *sde, unsigned op)
 
 	spin_unlock_irqrestore(&sde->senddmactrl_lock, flags);
 
-#ifdef CONFIG_SDMA_VERBOSITY
-	sdma_dumpstate(sde);
-#endif
 }
 
 static void sdma_setlengen(struct sdma_engine *sde)
@@ -1774,7 +1771,6 @@ static void init_sdma_regs(
 void sdma_dumpstate(struct sdma_engine *sde)
 {
 	u64 csr;
-	unsigned i;
 
 	sdma_dumpstate_helper(SD(CTRL));
 	sdma_dumpstate_helper(SD(STATUS));
@@ -1782,13 +1778,6 @@ void sdma_dumpstate(struct sdma_engine *sde)
 	sdma_dumpstate_helper0(SD(ERR_MASK));
 	sdma_dumpstate_helper(SD(ENG_ERR_STATUS));
 	sdma_dumpstate_helper(SD(ENG_ERR_MASK));
-
-	for (i = 0; i < CCE_NUM_INT_CSRS; ++i) {
-		sdma_dumpstate_helper2(CCE_INT_STATUS);
-		sdma_dumpstate_helper2(CCE_INT_MASK);
-		sdma_dumpstate_helper2(CCE_INT_BLOCKED);
-	}
-
 	sdma_dumpstate_helper(SD(TAIL));
 	sdma_dumpstate_helper(SD(HEAD));
 	sdma_dumpstate_helper(SD(PRIORITY_THLD));
-- 
1.7.0.7
