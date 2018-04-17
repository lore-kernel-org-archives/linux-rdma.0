From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] infiniband: hw: qib: Change return type to vm_fault_t
Date: Tue, 17 Apr 2018 20:04:28 +0530
Message-ID: <20180417143428.GA31255@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, dledford@redhat.com, jgg@ziepe.ca
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
 drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 52c29db3..52aea84 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -868,7 +868,7 @@ static int mmap_rcvegrbufs(struct vm_area_struct *vma,
 /*
  * qib_file_vma_fault - handle a VMA page fault.
  */
-static int qib_file_vma_fault(struct vm_fault *vmf)
+static vm_fault_t qib_file_vma_fault(struct vm_fault *vmf)
 {
 	struct page *page;

--
1.9.1
