From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH 3/3] staging: hfi1: sdma: Use setup_timer
Date: Sun, 25 Oct 2015 16:13:25 +0530
Message-ID: <1445769805-16522-3-git-send-email-falakreyaz@gmail.com>
References: <1445769805-16522-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1445769805-16522-1-git-send-email-falakreyaz@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Muhammad Falak R Wani <falakreyaz@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Use the timer API function setup_timer instead of init_timer, removing
the structure field assignments.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
v2 changes
	->make subject line more specific

 drivers/staging/rdma/hfi1/sdma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 63ab721..16d93ff 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -1094,10 +1094,8 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 
 		sde->progress_check_head = 0;
 
-		init_timer(&sde->err_progress_check_timer);
-		sde->err_progress_check_timer.function =
-						sdma_err_progress_check;
-		sde->err_progress_check_timer.data = (unsigned long)sde;
+		setup_timer(&sde->err_progress_check_timer,
+			    sdma_err_progress_check, (unsigned long)sde);
 
 		sde->descq = dma_zalloc_coherent(
 			&dd->pcidev->dev,
-- 
1.9.1
