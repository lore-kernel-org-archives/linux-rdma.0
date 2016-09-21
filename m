From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 21/23] rxe: Move documentation to Documentation/
Date: Wed, 21 Sep 2016 16:08:47 -0600
Message-ID: <1474495729-17604-22-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Very little of the rxe RADME.md is relevant with the kernel driver upstream,
and the userspace provider part of this repository.  Move the remaining bits
to Documentation/rxe.md and delete the rest.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 Documentation/rxe.md | 22 ++++++++++++++++++
 librxe/README.md     | 63 ----------------------------------------------------
 2 files changed, 22 insertions(+), 63 deletions(-)
 create mode 100644 Documentation/rxe.md
 delete mode 100644 librxe/README.md

diff --git a/Documentation/rxe.md b/Documentation/rxe.md
new file mode 100644
index 000000000000..8e753decb3cb
--- /dev/null
+++ b/Documentation/rxe.md
@@ -0,0 +1,22 @@
+# Configure Soft-RoCE (RXE):
+
+Load rdma_rxe kernel module using the rxe_cfg script included in the librxe RPM:
+
+	# rxe_cfg start (this might require sudo or root privileges)
+
+Create RXE device over network interface (e.g. eth0):
+
+	# rxe_cfg add eth0
+
+Use the status command to display the current configuration:
+rxe_cfg status
+
+If configured successfully, you should see output similar to the following:
+
+```
+    Name  Link  Driver   Speed  NMTU  IPv4_addr  RDEV  RMTU
+    eth0  yes   mlx4_en                          rxe0  1024  (3)
+```
+
+If you are using a Mellanox HCA: Need to make sure that the mlx4_ib kernel module is not loaded (modprobe –rv mlx4_ib) in the soft-RoCE machine.
+Now you have an Infiniband device called “rxe0” that can be used to run any RoCE app.
diff --git a/librxe/README.md b/librxe/README.md
deleted file mode 100644
index 743edd1421bf..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
