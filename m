From: ira.weiny@intel.com
Subject: [RESUBMIT PATCH v2 07/14] staging/rdma/hfi1: Add definitions and
 support functions for TID groups
Date: Mon, 11 Jan 2016 12:56:43 -0500
Message-ID: <1452535010-14087-8-git-send-email-ira.weiny@intel.com>
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

Definitions and functions use to manage sets of TID/RcvArray groups.
These will be used by the TID cacheline functionality coming with
later patches.

TID groups (or RcvArray groups) are groups of TID/RcvArray entries
organized in sets of 8 and aligned on cacheline boundaries. The
TID/RcvArray entries are managed in this way to make taking
advantage of write-combining easier - each group is a entire
cacheline.

rcv_array_wc_fill() is provided to allow of generating writes to
TIDs which are not currently being used in order to cause the
flush of the write-combining buffer.

Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 64 ++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index bafeddf67c8f..7f15024daab9 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -52,6 +52,14 @@
 #include "user_exp_rcv.h"
 #include "trace.h"
 
+struct tid_group {
+	struct list_head list;
+	unsigned base;
+	u8 size;
+	u8 used;
+	u8 map;
+};
+
 struct mmu_rb_node {
 	struct rb_node rbnode;
 	unsigned long virt;
@@ -75,6 +83,8 @@ static const char * const mmu_types[] = {
 	"RANGE"
 };
 
+#define EXP_TID_SET_EMPTY(set) (set.count == 0 && list_empty(&set.list))
+
 static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
 			       unsigned long);
 static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *,
@@ -94,6 +104,43 @@ static inline void mmu_notifier_range_start(struct mmu_notifier *,
 					    struct mm_struct *,
 					    unsigned long, unsigned long);
 
+static inline void exp_tid_group_init(struct exp_tid_set *set)
+{
+	INIT_LIST_HEAD(&set->list);
+	set->count = 0;
+}
+
+static inline void tid_group_remove(struct tid_group *grp,
+				    struct exp_tid_set *set)
+{
+	list_del_init(&grp->list);
+	set->count--;
+}
+
+static inline void tid_group_add_tail(struct tid_group *grp,
+				      struct exp_tid_set *set)
+{
+	list_add_tail(&grp->list, &set->list);
+	set->count++;
+}
+
+static inline struct tid_group *tid_group_pop(struct exp_tid_set *set)
+{
+	struct tid_group *grp =
+		list_first_entry(&set->list, struct tid_group, list);
+	list_del_init(&grp->list);
+	set->count--;
+	return grp;
+}
+
+static inline void tid_group_move(struct tid_group *group,
+				  struct exp_tid_set *s1,
+				  struct exp_tid_set *s2)
+{
+	tid_group_remove(group, s1);
+	tid_group_add_tail(group, s2);
+}
+
 static struct mmu_notifier_ops __maybe_unused mn_opts = {
 	.invalidate_page = mmu_notifier_page,
 	.invalidate_range_start = mmu_notifier_range_start,
@@ -114,6 +161,23 @@ int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 	return -EINVAL;
 }
 
+/*
+ * Write an "empty" RcvArray entry.
+ * This function exists so the TID registaration code can use it
+ * to write to unused/unneeded entries and still take advantage
+ * of the WC performance improvements. The HFI will ignore this
+ * write to the RcvArray entry.
+ */
+static inline void rcv_array_wc_fill(struct hfi1_devdata *dd, u32 index)
+{
+	/*
+	 * Doing the WC fill writes only makes sense if the device is
+	 * present and the RcvArray has been mapped as WC memory.
+	 */
+	if ((dd->flags & HFI1_PRESENT) && dd->rcvarray_wc)
+		writeq(0, dd->rcvarray_wc + (index * 8));
+}
+
 int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 {
 	return -EINVAL;
-- 
1.8.2
