From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 09/12] ehca: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:21 +0900
Message-ID: <1268903124-10237-9-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for ehca.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index b2b6fea..31f3ee1 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -845,7 +845,7 @@ static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
 		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
 		if (!create_comp_task(pool, cpu)) {
 			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		}
 		break;
 	case CPU_UP_CANCELED:
-- 
1.6.0.6
