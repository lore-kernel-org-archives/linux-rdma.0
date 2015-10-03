From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] IB/hfi1: use offset_in_page macro
Date: Sat,  3 Oct 2015 10:34:59 +0800
Message-ID: <20ad2117b3ba065a6e00e80f3c27682f70a53c6f.1443839524.git.geliangtang@163.com>
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
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-rdma@vger.kernel.org, Geliang Tang <geliangtang@163.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Use offset_in_page macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rdma/hfi1/file_ops.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 9a77221..7d28680 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -168,7 +168,7 @@ enum mmap_types {
 	HFI1_MMAP_TOKEN_SET(TYPE, type) | \
 	HFI1_MMAP_TOKEN_SET(CTXT, ctxt) | \
 	HFI1_MMAP_TOKEN_SET(SUBCTXT, subctxt) | \
-	HFI1_MMAP_TOKEN_SET(OFFSET, ((unsigned long)addr & ~PAGE_MASK)))
+	HFI1_MMAP_TOKEN_SET(OFFSET, (offset_in_page(addr))))
 
 #define EXP_TID_SET(field, value)			\
 	(((value) & EXP_TID_TID##field##_MASK) <<	\
@@ -1335,9 +1335,9 @@ static int get_base_info(struct file *fp, void __user *ubase, __u32 len)
 	 */
 	binfo.user_regbase = HFI1_MMAP_TOKEN(UREGS, uctxt->ctxt,
 					    subctxt_fp(fp), 0);
-	offset = ((((uctxt->ctxt - dd->first_user_ctxt) *
+	offset = offset_in_page((((uctxt->ctxt - dd->first_user_ctxt) *
 		    HFI1_MAX_SHARED_CTXTS) + subctxt_fp(fp)) *
-		  sizeof(*dd->events)) & ~PAGE_MASK;
+		  sizeof(*dd->events));
 	binfo.events_bufbase = HFI1_MMAP_TOKEN(EVENTS, uctxt->ctxt,
 					      subctxt_fp(fp),
 					      offset);
@@ -1573,7 +1573,7 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 
 	vaddr = tinfo->vaddr;
 
-	if (vaddr & ~PAGE_MASK) {
+	if (offset_in_page(vaddr)) {
 		ret = -EINVAL;
 		goto bail;
 	}
-- 
2.5.0
