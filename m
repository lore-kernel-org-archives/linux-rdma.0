From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB: allows build of hw/ and ulp/ subdirectory independently
Date: Thu, 27 Mar 2014 12:10:33 +0100
Message-ID: <1395918633-26765-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It is not possible to build only drivers/infiniband/hw/ (and ulp/)
subdirectory with command such as:

    $ make ARCH=x86_64 O=./obj-x86_64/ drivers/infiniband/hw/

This fails with following error messages:

    make[2]: Nothing to be done for `all'.
    make[2]: Nothing to be done for `relocs'.
      CHK     include/config/kernel.release
      Using /home/ydroneaud/src/linux as source for kernel
      GEN     /home/ydroneaud/src/linux/obj-x86_64/Makefile
      CHK     include/generated/uapi/linux/version.h
      CHK     include/generated/utsrelease.h
      CALL    /home/ydroneaud/src/linux/scripts/checksyscalls.sh
    /home/ydroneaud/src/linux/scripts/Makefile.build:44: /home/ydroneaud/src/linux/drivers/infiniband/hw/Makefile: No such file or directory
    make[2]: *** No rule to make target `/home/ydroneaud/src/linux/drivers/infiniband/hw/Makefile'.  Stop.
    make[1]: *** [drivers/infiniband/hw/] Error 2
    make: *** [sub-make] Error 2

This patch creates a Makefile in hw/ and ulp/ and moves
each corresponding parts of drivers/infiniband/Makefile
in the new Makefiles.

It should not break build except if some hw/ drivers or ulp/
were allowed previously to be built while CONFIG_INFINIBAND
is set to 'n', but according to drivers/infiniband/Kconfig,
it's not possible. So it should be safe to apply.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/Makefile     | 19 ++-----------------
 drivers/infiniband/hw/Makefile  | 12 ++++++++++++
 drivers/infiniband/ulp/Makefile |  5 +++++
 3 files changed, 19 insertions(+), 17 deletions(-)
 create mode 100644 drivers/infiniband/hw/Makefile
 create mode 100644 drivers/infiniband/ulp/Makefile

diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
index bf508b5550c4..dc21836b5a8d 100644
--- a/drivers/infiniband/Makefile
+++ b/drivers/infiniband/Makefile
@@ -1,18 +1,3 @@
 obj-$(CONFIG_INFINIBAND)		+= core/
-obj-$(CONFIG_INFINIBAND_MTHCA)		+= hw/mthca/
-obj-$(CONFIG_INFINIBAND_IPATH)		+= hw/ipath/
-obj-$(CONFIG_INFINIBAND_QIB)		+= hw/qib/
-obj-$(CONFIG_INFINIBAND_EHCA)		+= hw/ehca/
-obj-$(CONFIG_INFINIBAND_AMSO1100)	+= hw/amso1100/
-obj-$(CONFIG_INFINIBAND_CXGB3)		+= hw/cxgb3/
-obj-$(CONFIG_INFINIBAND_CXGB4)		+= hw/cxgb4/
-obj-$(CONFIG_MLX4_INFINIBAND)		+= hw/mlx4/
-obj-$(CONFIG_MLX5_INFINIBAND)		+= hw/mlx5/
-obj-$(CONFIG_INFINIBAND_NES)		+= hw/nes/
-obj-$(CONFIG_INFINIBAND_OCRDMA)		+= hw/ocrdma/
-obj-$(CONFIG_INFINIBAND_USNIC)		+= hw/usnic/
-obj-$(CONFIG_INFINIBAND_IPOIB)		+= ulp/ipoib/
-obj-$(CONFIG_INFINIBAND_SRP)		+= ulp/srp/
-obj-$(CONFIG_INFINIBAND_SRPT)		+= ulp/srpt/
-obj-$(CONFIG_INFINIBAND_ISER)		+= ulp/iser/
-obj-$(CONFIG_INFINIBAND_ISERT)		+= ulp/isert/
+obj-$(CONFIG_INFINIBAND)		+= hw/
+obj-$(CONFIG_INFINIBAND)		+= ulp/
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
new file mode 100644
index 000000000000..e900b03531a9
--- /dev/null
+++ b/drivers/infiniband/hw/Makefile
@@ -0,0 +1,12 @@
+obj-$(CONFIG_INFINIBAND_MTHCA)		+= mthca/
+obj-$(CONFIG_INFINIBAND_IPATH)		+= ipath/
+obj-$(CONFIG_INFINIBAND_QIB)		+= qib/
+obj-$(CONFIG_INFINIBAND_EHCA)		+= ehca/
+obj-$(CONFIG_INFINIBAND_AMSO1100)	+= amso1100/
+obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/
+obj-$(CONFIG_INFINIBAND_CXGB4)		+= cxgb4/
+obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
+obj-$(CONFIG_MLX5_INFINIBAND)		+= mlx5/
+obj-$(CONFIG_INFINIBAND_NES)		+= nes/
+obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
+obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
diff --git a/drivers/infiniband/ulp/Makefile b/drivers/infiniband/ulp/Makefile
new file mode 100644
index 000000000000..f3c7dcf03098
--- /dev/null
+++ b/drivers/infiniband/ulp/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_INFINIBAND_IPOIB)		+= ipoib/
+obj-$(CONFIG_INFINIBAND_SRP)		+= srp/
+obj-$(CONFIG_INFINIBAND_SRPT)		+= srpt/
+obj-$(CONFIG_INFINIBAND_ISER)		+= iser/
+obj-$(CONFIG_INFINIBAND_ISERT)		+= isert/
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
