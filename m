From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] libibverbs: add new verb command support
Date: Mon, 14 Apr 2014 19:01:06 +0200
Message-ID: <1397494869-43842-3-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1397494869-43842-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397494869-43842-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current implementation of some Infiniband verbs uses mapped memory
to directly access the PCI I/O memory from userspace programs to perform
I/O operations. On the s390x platform the PCI I/O memory can be accessed
only using special privileged CPU instructions and since those instructions
are privileged, they cannot be used from userspace programs. This makes
impossible to use mapped memory areas to access the PCI I/O memory from
userspace on s390x platform and aplications cannot use the Infiniband
verbs on that platform without modification.
There are two approaches could be implemented to solve this problem:
	* using a page fault handler to intercept mapped memory area
	  access errors, and handle them in the handler by issuing the
	  appropriate privileged CPU instructions;
	* modification of the existing verbs to avoid the mapped memory
	  areas usage on the s390x platform.
The page fault handler solution is the most complex one because it requires
not only modifcation of the virtual memory handling in Linux kernel but
also makes the developer to provide code for all the CPU instrutions which
work with memory program interpretation. This approcach requires lots of
lines of code and noticable overhead during the program execution.
The modification of the existing verbs solution is much simpler and more
realible. It requires modification of the libraries provided in the DAPL
support packages to replace the usage of mapped memory areas used to
access the device UAR and Blueflame page with the device driver write
primitive calls supplying a special verb command to kernelspace.
The modification of the existing verbs solution has been choosen for
implementation.
Userspace library libibverbs contains platform independent part of the
Infiniband verb implementation. To allow the privileged CPU instruction
execution in kernel context on request from the userspace programs, this
patch adds a new user verb command IB_USER_VERBS_CMD_KWRITE_MMIO and
its parameter list structure, which is used to identify the PCI I/O
operation request in the kernelspace driver. Also, it adds s390x platform
specific definitions for the macro mb, rmb, wmb, and wc_wmb.

Signed-off-by: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
---
 include/infiniband/arch.h     |    7 +++++++
 include/infiniband/kern-abi.h |    6 ++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/include/infiniband/arch.h
+++ b/include/infiniband/arch.h
@@ -115,6 +115,13 @@ static inline uint64_t ntohll(uint64_t x
 #define wmb()	 mb()
 #define wc_wmb() wmb()
 
+#elif defined(__s390x__)
+
+#define mb()	 { asm volatile("" : : : "memory"); }	/* for s390x */
+#define rmb()	 mb()					/* for s390x */
+#define wmb()	 mb()					/* for s390x */
+#define wc_wmb() wmb()					/* for s390x */
+
 #else
 
 #warning No architecture specific defines found.  Using generic implementation.
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -91,7 +91,8 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_XRCD,
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
 	IB_USER_VERBS_CMD_CREATE_XSRQ,
-	IB_USER_VERBS_CMD_OPEN_QP
+	IB_USER_VERBS_CMD_OPEN_QP,
+	IB_USER_VERBS_CMD_KWRITE_MMIO
 };
 
 #define IB_USER_VERBS_CMD_COMMAND_MASK		0xff
@@ -904,7 +905,8 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_XRCD_V2 = -1,
 	IB_USER_VERBS_CMD_CLOSE_XRCD_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1,
-	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1
+	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1,
+	IB_USER_VERBS_CMD_KWRITE_MMIO_V2 = -1
 };
 
 struct ibv_modify_srq_v3 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
