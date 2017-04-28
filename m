From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 18/19] IB/hfi: Protect against writable mmap
Date: Fri, 28 Apr 2017 10:40:42 -0700
Message-ID: <20170428174041.23960.13849.stgit@scvm10.sc.intel.com>
References: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170428173443.23960.32602.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The device/port status is not intended to be changed from user space.
Prevent a user from mapping them as write or execute.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index f78c739..d575499 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -597,6 +597,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		vmf = 1;
 		break;
 	case STATUS:
+		if (flags & (unsigned long)(VM_WRITE | VM_EXEC)) {
+			ret = -EPERM;
+			goto done;
+		}
 		memaddr = kvirt_to_phys((void *)dd->status);
 		memlen = PAGE_SIZE;
 		flags |= VM_IO | VM_DONTEXPAND;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
