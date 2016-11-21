From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v5 5/9] IB/isert: Replace semaphore sem with completion
Date: Mon, 21 Nov 2016 11:38:12 +0530
Message-ID: <1479708496-9828-6-git-send-email-binoy.jayan@linaro.org>
References: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Jenny Derzhavetz <jennyf@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Steve Wise <swise@opengridcomputing.com>, Mark Bloch <markb@mellanox.com>, Tatyana E Nikolova <tatyana.e.nikolova@intel.com>, Matan Barak <matanb@mellanox.com>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

The semaphore 'sem' in isert_device is used as completion, but in a
counting fashion as isert_connected_handler could be called multiple times
during which it allows for that number of waiters (isert_accept_np) to
continue without blocking, each consuming one node out from the list
isert_np-pending in the same order in which they were enqueued (FIFO). So,
convert it to struct completion. Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 6 +++---
 drivers/infiniband/ulp/isert/ib_isert.h | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 6dd43f6..de80f56 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -619,7 +619,7 @@
 	mutex_unlock(&isert_np->mutex);
 
 	isert_info("np %p: Allow accept_np to continue\n", isert_np);
-	up(&isert_np->sem);
+	complete(&isert_np->comp);
 }
 
 static void
@@ -2311,7 +2311,7 @@ struct rdma_cm_id *
 		isert_err("Unable to allocate struct isert_np\n");
 		return -ENOMEM;
 	}
-	sema_init(&isert_np->sem, 0);
+	init_completion(&isert_np->comp);
 	mutex_init(&isert_np->mutex);
 	INIT_LIST_HEAD(&isert_np->accepted);
 	INIT_LIST_HEAD(&isert_np->pending);
@@ -2427,7 +2427,7 @@ struct rdma_cm_id *
 	int ret;
 
 accept_wait:
-	ret = down_interruptible(&isert_np->sem);
+	ret = wait_for_completion_interruptible(&isert_np->comp);
 	if (ret)
 		return -ENODEV;
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index c02ada5..a1277c0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -3,6 +3,7 @@
 #include <linux/in6.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
+#include <linux/completion.h>
 #include <rdma/rw.h>
 #include <scsi/iser.h>
 
@@ -190,7 +191,7 @@ struct isert_device {
 
 struct isert_np {
 	struct iscsi_np         *np;
-	struct semaphore	sem;
+	struct completion	comp;
 	struct rdma_cm_id	*cm_id;
 	struct mutex		mutex;
 	struct list_head	accepted;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
