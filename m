From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 22/23] srp_daemon: Move documentation to Documentation/
Date: Wed, 21 Sep 2016 16:08:48 -0600
Message-ID: <1474495729-17604-23-git-send-email-jgunthorpe@obsidianresearch.com>
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
 Documentation/ibsrpdm.md | 41 ++++++++++++++++++++++++
 srp_daemon/README        | 82 ------------------------------------------------
 2 files changed, 41 insertions(+), 82 deletions(-)
 create mode 100644 Documentation/ibsrpdm.md
 delete mode 100644 srp_daemon/README

diff --git a/Documentation/ibsrpdm.md b/Documentation/ibsrpdm.md
new file mode 100644
index 000000000000..0fc544d0352a
--- /dev/null
+++ b/Documentation/ibsrpdm.md
@@ -0,0 +1,41 @@
+# Using ibsrpdm
+
+ibsrpdm is used for discovering and connecting to SRP SCSI targets on
+InfiniBand fabrics.  These targets can be accessed with the InfiniBand SRP
+initiator module, "ib_srp," included in Linux kernels 2.6.15 and newer.
+
+To run ibsrpdm, the ib_umad module must be loaded, as well as an appropriate
+low-level driver for the installed IB hardware.
+
+With no command line parameters, ibsrpdm displays information about
+SRP targets in human-readable form:
+
+    # ibsrpdm
+    IO Unit Info:
+        port LID:        0009
+        port GID:        fe800000000000000005ad00000013e9
+        change ID:       73b0
+        max controllers: 0x01
+
+        controller[  1]
+            GUID:      0005ad00000013e7
+            vendor ID: 0005ad
+            device ID: 0005ad
+            IO class : 0100
+            ID:        Topspin SRP/FC TCA
+            service entries: 2
+                service[  0]: 0000000000000066 / SRP.T10:20030003BA27CC7A
+                service[  1]: 0000000000000066 / SRP.T10:20030003BA27CF53
+
+With the "-c" flag, ibsrpdm displays information in a form that can be
+written to the kernel SRP initiators add_target file to connect to the
+SRP targets.  For example:
+
+    # ibsrpdm -c
+    id_ext=20030003BA27CC7A,ioc_guid=0005ad00000013e7,dgid=fe800000000000000005ad00000013e9,pkey=ffff,service_id=0000000000000066
+    id_ext=20030003BA27CF53,ioc_guid=0005ad00000013e7,dgid=fe800000000000000005ad00000013e9,pkey=ffff,service_id=0000000000000066
+
+Given this, the command below will connect to the first target
+discovered from the first port of the local HCA device "mthca0":
+
+    # echo -n id_ext=20030003BA27CC7A,ioc_guid=0005ad00000013e7,dgid=fe800000000000000005ad00000013e9,pkey=ffff,service_id=0000000000000066 > /sys/class/infiniband_srp/srp-mthca0-1/add_target
diff --git a/srp_daemon/README b/srp_daemon/README
deleted file mode 100644
index c44f11c5c51e..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
