From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] RDMAVT: Fix synchronization around percpu_ref
Date: Tue,  6 Mar 2018 09:33:12 -0800
Message-ID: <20180306173316.3088458-3-tj@kernel.org>
References: <20180306172657.3060270-1-tj@kernel.org>
 <20180306173316.3088458-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306173316.3088458-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, jannh@google.com, paulmck@linux.vnet.ibm.com, bcrl@kvack.org, viro@zeniv.linux.org.uk, kent.overstreet@gmail.com
Cc: security@kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

rvt_mregion uses percpu_ref for reference counting and RCU to protect
accesses from lkey_table.  When a rvt_mregion needs to be freed, it
first gets unregistered from lkey_table and then rvt_check_refs() is
called to wait for in-flight usages before the rvt_mregion is freed.

rvt_check_refs() seems to have a couple issues.

* It has a fast exit path which tests percpu_ref_is_zero().  However,
  a percpu_ref reading zero doesn't mean that the object can be
  released.  In fact, the ->release() callback might not even have
  started executing yet.  Proceeding with freeing can lead to
  use-after-free.

* lkey_table is RCU protected but there is no RCU grace period in the
  free path.  percpu_ref uses RCU internally but it's sched-RCU whose
  grace periods are different from regular RCU.  Also, it generally
  isn't a good idea to depend on internal behaviors like this.

To address the above issues, this patch removes the the fast exit and
adds an explicit synchronize_rcu().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: linux-rdma@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
Hello, Dennis, Mike.

I don't know RDMA at all and this patch is only compile tested.  Can
you please take a careful look?

Thanks.

 drivers/infiniband/sw/rdmavt/mr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 1b2e536..cc429b5 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -489,11 +489,13 @@ static int rvt_check_refs(struct rvt_mregion *mr, const char *t)
 	unsigned long timeout;
 	struct rvt_dev_info *rdi = ib_to_rvt(mr->pd->device);
 
-	if (percpu_ref_is_zero(&mr->refcount))
-		return 0;
-	/* avoid dma mr */
-	if (mr->lkey)
+	if (mr->lkey) {
+		/* avoid dma mr */
 		rvt_dereg_clean_qps(mr);
+		/* @mr was indexed on rcu protected @lkey_table */
+		synchronize_rcu();
+	}
+
 	timeout = wait_for_completion_timeout(&mr->comp, 5 * HZ);
 	if (!timeout) {
 		rvt_pr_err(rdi,
-- 
2.9.5
