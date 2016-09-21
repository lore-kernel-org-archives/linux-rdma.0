From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 03/23] Add reporting bugs and submitting patches sections to README.md
Date: Wed, 21 Sep 2016 16:08:29 -0600
Message-ID: <1474495729-17604-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Based on the wording from the libibverbs and srp_daemon README files.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 README.md | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/README.md b/README.md
index 65c7644ad770..8c31944c91a8 100644
--- a/README.md
+++ b/README.md
@@ -95,3 +95,31 @@ $ install -m755 ninja /usr/local/bin/ninja
 ```
 
 Use the 'cmake3' program in place of `cmake` in the above instructions.
+
+# Reporting bugs
+
+Bugs should be reported to the <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> mailing list
+In your bug report, please include:
+
+ * Information about your system:
+   - Linux distribution and version
+   - Linux kernel and version
+   - InfiniBand hardware and firmware version
+   - ... any other relevant information
+
+ * How to reproduce the bug.
+
+ * If the bug is a crash, the exact output printed out when the crash
+   occurred, including any kernel messages produced.
+
+# Submitting patches
+
+Patches should also be submitted to the <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
+mailing list.  Please use unified diff form (the -u option to GNU diff),
+and include a good description of what your patch does and why it should
+be applied.  If your patch fixes a bug, please make sure to describe the
+bug and how your fix works.
+
+Make sure that your contribution can be licensed under the same
+license as the original code you are patching, and that you have all
+necessary permissions to release your work.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
