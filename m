From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 6/7] IB/hfi1: Remove overly conservative VM_EXEC flag
 check
Date: Thu, 17 Jan 2019 12:42:04 -0800
Message-ID: <20190117204159.30826.92063.stgit@scvm10.sc.intel.com>
References: <20190117203920.30826.76720.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190117203920.30826.76720.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

Applications that use the stack for execution purposes cause
PSM jobs to fail during mmap().

Both Fortran (non-standard format parsing) and C (callback
functions located in the stack) applications can be written
such that stack execution is required.

Because of this the EXECSTACK bit can be automatically set at link
time for any application.

On application load, the ELF loader evaluates the EXECSTACK bit
for the application and it's linked libraries.  It will set the
process VM flags to allow the stack to include the VM_EXEC bit
if the EXECSTACK bit is set.  This flag is propagated to the
driver during the mmap() call in the vma flag bits.

Checking for this bit and failing the request with EPERM is overly
conservative and will break any PSM application that has the bit set.

Remove the VM_EXEC flag from the check.

Cc: <stable@vger.kernel.org> #v4.14+
Fixes: 12220267645c ("IB/hfi: Protect against writable mmap")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/file_ops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 0ba0cf5..68c397a 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -488,7 +488,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		vmf = 1;
 		break;
 	case STATUS:
-		if (flags & (unsigned long)(VM_WRITE | VM_EXEC)) {
+		if (flags & VM_WRITE) {
 			ret = -EPERM;
 			goto done;
 		}
