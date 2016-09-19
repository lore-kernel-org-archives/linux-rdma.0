From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 4/9] move rxe documentation to Documentation/
Date: Mon, 19 Sep 2016 08:56:28 -0700
Message-ID: <1474300593-31922-5-git-send-email-hch@lst.de>
References: <1474300593-31922-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474300593-31922-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Very little of the rxe RADME.md is relevant with the kernel driver upstream,
and the userspace provider part of this repository.  Move the remaining bits
to Documentation/rxe.md and delete the rest.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 Documentation/rxe.md    | 19 +++++++++++++++
 providers/rxe/README.md | 63 -------------------------------------------------
 2 files changed, 19 insertions(+), 63 deletions(-)
 create mode 100644 Documentation/rxe.md
 delete mode 100644 providers/rxe/README.md

diff --git a/Documentation/rxe.md b/Documentation/rxe.md
new file mode 100644
index 0000000..ec5ba58
--- /dev/null
+++ b/Documentation/rxe.md
@@ -0,0 +1,19 @@
+# Configure Soft-RoCE (RXE):
+
+Load rdma_rxe kernel module using the rxe_cfg script included in the librxe RPM:
+
+rxe_cfg start (this might require sudo or root privileges)
+
+Create RXE device over network interface (e.g. eth0):
+
+rxe_cfg add eth0
+
+Use the status command to display the current configuration:
+rxe_cfg status
+
+If configured successfully, you should see output similar to the following:
+    Name  Link  Driver   Speed  NMTU  IPv4_addr  RDEV  RMTU         
+    eth0  yes   mlx4_en                          rxe0  1024  (3) 
+ 
+If you are using a Mellanox HCA: Need to make sure that the mlx4_ib kernel module is not loaded (modprobe –rv mlx4_ib) in the soft-RoCE machine.
+Now you have an Infiniband device called “rxe0” that can be used to run any RoCE app.
diff --git a/providers/rxe/README.md b/providers/rxe/README.md
deleted file mode 100644
index 743edd1..0000000
--- a/providers/rxe/README.md
+++ /dev/null
@@ -1,63 +0,0 @@
-# librxe-dev
-Development repository for RXE user space code.
-Soft RDMA over Ethernet (RoCE) Driver
-
-Source
-
-Kernel Space Driver
-
-This repository contains a full kernel source tree, with the RoCE driver code located in the directory drivers/infiniband/hw/rxe.
-
-Github: https://github.com/SoftRoCE/rxe-dev.git 
-Active Branch: master-next
-User Space Library
-
-Github: https://github.com/SoftRoCE/librxe-dev.git (this repository)
-Current Version: librxe-1.0.0
-Build Instructions
-
-Compile and install kernel:
-
-Clone kernel git:
-git clone https://github.com/SoftRoCE/rxe-dev.git
-Compile kernel:
-Enter the source directory cd rxe-dev
-cp /boot/config-$(uname –r) .config
-make menuconfig
-Need to enable “Software RDMA over Ethernet (RoCE) driver” in category "Device Drivers -> Infiniband"
-Need to enable CONFIG_INFINIBAND_ADDR_TRANS=y and CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y in new config file .config
-make –j 32
-make modules_install
-make install
-Verify that the new kernel entry is added (e.g. to grub); if not, need to add it manually.
-Boot with new kernel.
-Install user space library (librxe):
-
-Install the following package (example shown using RedHat):
-yum install perl-Switch (name might vary according to distribution)
-Make sure that the following upstream user space libraries are installed:
-libibverbs
-libibverbs-devel
-libibverbs-utils
-librdmacm
-librdmacm-devel
-librdmacm-utils
-Compile and install user space library librxe:
-git clone https://github.com/SoftRoCE/librxe-dev.git
-cd librxe-dev
-./configure --libdir=/usr/lib64/ --prefix=
-make
-make install
-Configure Soft-RoCE (RXE):
-
-Load rdma_rxe kernel module using the rxe_cfg script included in the librxe RPM:
-rxe_cfg start (this might require sudo or root privileges)
-Create RXE device over network interface (e.g. eth0):
-rxe_cfg add eth0
-Use the status command to display the current configuration:
-rxe_cfg status
-If configured successfully, you should see output similar to the following:
-    Name  Link  Driver   Speed  NMTU  IPv4_addr  RDEV  RMTU         
-    eth0  yes   mlx4_en                          rxe0  1024  (3) 
-If you are using a Mellanox HCA: Need to make sure that the mlx4_ib kernel module is not loaded (modprobe –rv mlx4_ib) in the soft-RoCE machine.
-Now you have an Infiniband device called “rxe0” that can be used to run any RoCE app.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
