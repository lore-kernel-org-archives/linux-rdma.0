From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] infiniband: hw: hfi1: Change return type to vm_fault_t
Date: Tue, 17 Apr 2018 19:53:58 +0530
Message-ID: <20180417142358.GA30972@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, willy@infradead.org
List-Id: linux-rdma@vger.kernel.org

Use new return type vm_fault_t for fault handler. For
now, this is just documenting that the function returns
a VM_FAULT value rather than an errno. Once all instances
are converted, vm_fault_t will become a distinct type.

Reference id -> 1c8f422059ae ("mm: change return type to
vm_fault_t")

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 41fafeb..b04624d 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -110,7 +110,7 @@ static int user_event_ack(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 static int ctxt_reset(struct hfi1_ctxtdata *uctxt);
 static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 		       unsigned long arg);
-static int vma_fault(struct vm_fault *vmf);
+static vm_fault_t vma_fault(struct vm_fault *vmf);
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			    unsigned long arg);

@@ -591,7 +591,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
  * Local (non-chip) user memory is not mapped right away but as it is
  * accessed by the user-level code.
  */
-static int vma_fault(struct vm_fault *vmf)
+static vm_fault_t vma_fault(struct vm_fault *vmf)
 {
 	struct page *page;

--
1.9.1
