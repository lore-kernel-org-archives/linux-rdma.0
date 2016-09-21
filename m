From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 11/23] verbs: Move documentation to Documentation/
Date: Wed, 21 Sep 2016 16:08:37 -0600
Message-ID: <1474495729-17604-12-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

And drop bits that are outdated or replaced by top-level Documentation.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 Documentation/libibverbs.md |  58 ++++++++++++++++
 libibverbs/README           | 164 --------------------------------------------
 2 files changed, 58 insertions(+), 164 deletions(-)
 create mode 100644 Documentation/libibverbs.md
 delete mode 100644 libibverbs/README

diff --git a/Documentation/libibverbs.md b/Documentation/libibverbs.md
new file mode 100644
index 000000000000..cbe076e0fcab
--- /dev/null
+++ b/Documentation/libibverbs.md
@@ -0,0 +1,58 @@
+# Introduction
+
+libibverbs is a library that allows programs to use RDMA "verbs" for
+direct access to RDMA (currently InfiniBand and iWARP) hardware from
+userspace.  For more information on RDMA verbs, see the InfiniBand
+Architecture Specification vol. 1, especially chapter 11, and the RDMA
+Consortium's RDMA Protocol Verbs Specification.
+
+# Using libibverbs
+
+### Device nodes
+
+The verbs library expects special character device files named
+/dev/infiniband/uverbsN to be created.  When you load the kernel
+modules, including both the low-level driver for your IB hardware as
+well as the ib_uverbs module, you should see one or more uverbsN
+entries in /sys/class/infiniband_verbs in addition to the
+/dev/infiniband/uverbsN character device files.
+
+To create the appropriate character device files automatically with
+udev, a rule like
+
+    KERNEL="uverbs*", NAME="infiniband/%k"
+
+can be used.  This will create device nodes named
+
+    /dev/infiniband/uverbs0
+
+and so on.  Since the RDMA userspace verbs should be safe for use by
+non-privileged users, you may want to add an appropriate MODE or GROUP
+to your udev rule.
+
+### Permissions
+
+To use IB verbs from userspace, a process must be able to access the
+appropriate /dev/infiniband/uverbsN special device file.  You can
+check the permissions on this file with the command
+
+	ls -l /dev/infiniband/uverbs*
+
+Make sure that the permissions on these files are such that the
+user/group that your verbs program runs as can access the device file.
+
+To use IB verbs from userspace, a process must also have permission to
+tell the kernel to lock sufficient memory for all of your registered
+memory regions as well as the memory used internally by IB resources
+such as queue pairs (QPs) and completion queues (CQs).  To check your
+resource limits, use the command
+
+	ulimit -l
+
+(or "limit memorylocked" for csh-like shells).
+
+If you see a small number such as 32 (the units are KB) then you will
+need to increase this limit.  This is usually done for ordinary users
+via the file /etc/security/limits.conf.  More configuration may be
+necessary if you are logging in via OpenSSH and your sshd is
+configured to use privilege separation.
diff --git a/libibverbs/README b/libibverbs/README
deleted file mode 100644
index 848eb05917fb..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
