From: ira.weiny@intel.com
Subject: [RESUBMIT PATCH v2 09/14] staging/rdma/hfi1: Convert lock to mutex
Date: Mon, 11 Jan 2016 12:56:45 -0500
Message-ID: <1452535010-14087-10-git-send-email-ira.weiny@intel.com>
References: <1452535010-14087-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1452535010-14087-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: dledford@redhat.com, linux-rdma@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, Mitko Haralanov <mitko.haralanov@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov@intel.com>

The exp_lock lock does not need to be a spinlock as
all its uses are in process context and allowing the
process to sleep when the mutex is contended might
be benefitial.

Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/file_ops.c | 12 ++++++------
 drivers/staging/rdma/hfi1/hfi.h      |  2 +-
 drivers/staging/rdma/hfi1/init.c     |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 76fe60315bb4..b0348263b901 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1611,14 +1611,14 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 		 * reserved, we don't need the lock anymore since we
 		 * are guaranteed the groups.
 		 */
-		spin_lock(&uctxt->exp_lock);
+		mutex_lock(&uctxt->exp_lock);
 		if (uctxt->tidusemap[useidx] == -1ULL ||
 		    bitidx >= BITS_PER_LONG) {
 			/* no free groups in the set, use the next */
 			useidx = (useidx + 1) % uctxt->tidmapcnt;
 			idx++;
 			bitidx = 0;
-			spin_unlock(&uctxt->exp_lock);
+			mutex_unlock(&uctxt->exp_lock);
 			continue;
 		}
 		ngroups = ((npages - mapped) / dd->rcv_entries.group_size) +
@@ -1635,13 +1635,13 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 			 * as 0 because we don't check the entire bitmap but
 			 * we start from bitidx.
 			 */
-			spin_unlock(&uctxt->exp_lock);
+			mutex_unlock(&uctxt->exp_lock);
 			continue;
 		}
 		bits_used = min(free, ngroups);
 		tidmap[useidx] |= ((1ULL << bits_used) - 1) << bitidx;
 		uctxt->tidusemap[useidx] |= tidmap[useidx];
-		spin_unlock(&uctxt->exp_lock);
+		mutex_unlock(&uctxt->exp_lock);
 
 		/*
 		 * At this point, we know where in the map we have free bits.
@@ -1677,10 +1677,10 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 			 * Let go of the bits that we reserved since we are not
 			 * going to use them.
 			 */
-			spin_lock(&uctxt->exp_lock);
+			mutex_lock(&uctxt->exp_lock);
 			uctxt->tidusemap[useidx] &=
 				~(((1ULL << bits_used) - 1) << bitidx);
-			spin_unlock(&uctxt->exp_lock);
+			mutex_unlock(&uctxt->exp_lock);
 			goto done;
 		}
 		/*
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 905bb40febb3..9052331ff6c5 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -258,7 +258,7 @@ struct hfi1_ctxtdata {
 	struct exp_tid_set tid_full_list;
 
 	/* lock protecting all Expected TID data */
-	spinlock_t exp_lock;
+	struct mutex exp_lock;
 	/* number of pio bufs for this ctxt (all procs, if shared) */
 	u32 piocnt;
 	/* first pio buffer for this ctxt */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index db80544deb66..ee63fe977ad4 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -227,7 +227,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
 		rcd->numa_id = numa_node_id();
 		rcd->rcv_array_groups = dd->rcv_entries.ngroups;
 
-		spin_lock_init(&rcd->exp_lock);
+		mutex_init(&rcd->exp_lock);
 
 		/*
 		 * Calculate the context's RcvArray entry starting point.
-- 
1.8.2
