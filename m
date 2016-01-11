From: Jubin John <jubin.john@intel.com>
Subject: [PATCH RESEND v3 4/6] staging/rdma/hfi1: Change default krcvqs
Date: Mon, 11 Jan 2016 18:30:55 -0500
Message-ID: <1452555057-5155-5-git-send-email-jubin.john@intel.com>
References: <1452555057-5155-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1452555057-5155-1-git-send-email-jubin.john@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-rdma@vger.kernel.org, dledford@redhat.com
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org
List-Id: linux-rdma@vger.kernel.org

Change the default number of krcvqs to number of numa nodes + 1
based on the performance data collected.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
Changes in v2:
	- None

Changes in v3:
	- Refreshed patch against latest staging-next

 drivers/staging/rdma/hfi1/chip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index bbe5ad8..503bfca 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -12445,7 +12445,7 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 		 */
 		num_kernel_contexts = n_krcvqs + MIN_KERNEL_KCTXTS - 1;
 	else
-		num_kernel_contexts = num_online_nodes();
+		num_kernel_contexts = num_online_nodes() + 1;
 	num_kernel_contexts =
 		max_t(int, MIN_KERNEL_KCTXTS, num_kernel_contexts);
 	/*
-- 
1.7.1
