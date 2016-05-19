From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/10] IB/hfi1: Move driver out of staging
Date: Thu, 19 May 2016 05:26:51 -0700
Message-ID: <20160519122649.22041.3462.stgit@scvm10.sc.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519122318.22041.58871.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The TODO list for the hfi1 driver was completed during 4.6. In addition
other objections raised (which are far beyond what was in the TODO list)
have been addressed as well. It is now time to remove the driver from
staging and into the drivers/infiniband sub-tree.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 MAINTAINERS                                 |   13 +++++++------
 drivers/infiniband/Kconfig                  |    2 ++
 drivers/infiniband/hw/Makefile              |    1 +
 drivers/infiniband/hw/hfi1/Kconfig          |    0 
 drivers/infiniband/hw/hfi1/Makefile         |    0 
 drivers/infiniband/hw/hfi1/affinity.c       |    0 
 drivers/infiniband/hw/hfi1/affinity.h       |    0 
 drivers/infiniband/hw/hfi1/aspm.h           |    0 
 drivers/infiniband/hw/hfi1/chip.c           |    0 
 drivers/infiniband/hw/hfi1/chip.h           |    0 
 drivers/infiniband/hw/hfi1/chip_registers.h |    0 
 drivers/infiniband/hw/hfi1/common.h         |    0 
 drivers/infiniband/hw/hfi1/debugfs.c        |    0 
 drivers/infiniband/hw/hfi1/debugfs.h        |    0 
 drivers/infiniband/hw/hfi1/device.c         |    0 
 drivers/infiniband/hw/hfi1/device.h         |    0 
 drivers/infiniband/hw/hfi1/dma.c            |    0 
 drivers/infiniband/hw/hfi1/driver.c         |    0 
 drivers/infiniband/hw/hfi1/efivar.c         |    0 
 drivers/infiniband/hw/hfi1/efivar.h         |    0 
 drivers/infiniband/hw/hfi1/eprom.c          |    0 
 drivers/infiniband/hw/hfi1/eprom.h          |    0 
 drivers/infiniband/hw/hfi1/file_ops.c       |    0 
 drivers/infiniband/hw/hfi1/firmware.c       |    0 
 drivers/infiniband/hw/hfi1/hfi.h            |    0 
 drivers/infiniband/hw/hfi1/init.c           |    0 
 drivers/infiniband/hw/hfi1/intr.c           |    0 
 drivers/infiniband/hw/hfi1/iowait.h         |    0 
 drivers/infiniband/hw/hfi1/mad.c            |    0 
 drivers/infiniband/hw/hfi1/mad.h            |    0 
 drivers/infiniband/hw/hfi1/mmu_rb.c         |    0 
 drivers/infiniband/hw/hfi1/mmu_rb.h         |    0 
 drivers/infiniband/hw/hfi1/opa_compat.h     |    0 
 drivers/infiniband/hw/hfi1/pcie.c           |    0 
 drivers/infiniband/hw/hfi1/pio.c            |    0 
 drivers/infiniband/hw/hfi1/pio.h            |    0 
 drivers/infiniband/hw/hfi1/pio_copy.c       |    0 
 drivers/infiniband/hw/hfi1/platform.c       |    0 
 drivers/infiniband/hw/hfi1/platform.h       |    0 
 drivers/infiniband/hw/hfi1/qp.c             |    0 
 drivers/infiniband/hw/hfi1/qp.h             |    0 
 drivers/infiniband/hw/hfi1/qsfp.c           |    0 
 drivers/infiniband/hw/hfi1/qsfp.h           |    0 
 drivers/infiniband/hw/hfi1/rc.c             |    0 
 drivers/infiniband/hw/hfi1/ruc.c            |    0 
 drivers/infiniband/hw/hfi1/sdma.c           |    0 
 drivers/infiniband/hw/hfi1/sdma.h           |    0 
 drivers/infiniband/hw/hfi1/sdma_txreq.h     |    0 
 drivers/infiniband/hw/hfi1/sysfs.c          |    0 
 drivers/infiniband/hw/hfi1/trace.c          |    0 
 drivers/infiniband/hw/hfi1/trace.h          |    0 
 drivers/infiniband/hw/hfi1/twsi.c           |    0 
 drivers/infiniband/hw/hfi1/twsi.h           |    0 
 drivers/infiniband/hw/hfi1/uc.c             |    0 
 drivers/infiniband/hw/hfi1/ud.c             |    0 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c   |    0 
 drivers/infiniband/hw/hfi1/user_exp_rcv.h   |    0 
 drivers/infiniband/hw/hfi1/user_pages.c     |    0 
 drivers/infiniband/hw/hfi1/user_sdma.c      |    0 
 drivers/infiniband/hw/hfi1/user_sdma.h      |    0 
 drivers/infiniband/hw/hfi1/verbs.c          |    0 
 drivers/infiniband/hw/hfi1/verbs.h          |    0 
 drivers/infiniband/hw/hfi1/verbs_txreq.c    |    0 
 drivers/infiniband/hw/hfi1/verbs_txreq.h    |    0 
 drivers/staging/rdma/Kconfig                |    2 --
 drivers/staging/rdma/Makefile               |    1 -
 drivers/staging/rdma/hfi1/TODO              |    6 ------
 67 files changed, 10 insertions(+), 15 deletions(-)
 rename drivers/{staging/rdma/hfi1/Kconfig => infiniband/hw/hfi1/Kconfig} (100%)
 rename drivers/{staging/rdma/hfi1/Makefile => infiniband/hw/hfi1/Makefile} (100%)
 rename drivers/{staging/rdma/hfi1/affinity.c => infiniband/hw/hfi1/affinity.c} (100%)
 rename drivers/{staging/rdma/hfi1/affinity.h => infiniband/hw/hfi1/affinity.h} (100%)
 rename drivers/{staging/rdma/hfi1/aspm.h => infiniband/hw/hfi1/aspm.h} (100%)
 rename drivers/{staging/rdma/hfi1/chip.c => infiniband/hw/hfi1/chip.c} (100%)
 rename drivers/{staging/rdma/hfi1/chip.h => infiniband/hw/hfi1/chip.h} (100%)
 rename drivers/{staging/rdma/hfi1/chip_registers.h => infiniband/hw/hfi1/chip_registers.h} (100%)
 rename drivers/{staging/rdma/hfi1/common.h => infiniband/hw/hfi1/common.h} (100%)
 rename drivers/{staging/rdma/hfi1/debugfs.c => infiniband/hw/hfi1/debugfs.c} (100%)
 rename drivers/{staging/rdma/hfi1/debugfs.h => infiniband/hw/hfi1/debugfs.h} (100%)
 rename drivers/{staging/rdma/hfi1/device.c => infiniband/hw/hfi1/device.c} (100%)
 rename drivers/{staging/rdma/hfi1/device.h => infiniband/hw/hfi1/device.h} (100%)
 rename drivers/{staging/rdma/hfi1/dma.c => infiniband/hw/hfi1/dma.c} (100%)
 rename drivers/{staging/rdma/hfi1/driver.c => infiniband/hw/hfi1/driver.c} (100%)
 rename drivers/{staging/rdma/hfi1/efivar.c => infiniband/hw/hfi1/efivar.c} (100%)
 rename drivers/{staging/rdma/hfi1/efivar.h => infiniband/hw/hfi1/efivar.h} (100%)
 rename drivers/{staging/rdma/hfi1/eprom.c => infiniband/hw/hfi1/eprom.c} (100%)
 rename drivers/{staging/rdma/hfi1/eprom.h => infiniband/hw/hfi1/eprom.h} (100%)
 rename drivers/{staging/rdma/hfi1/file_ops.c => infiniband/hw/hfi1/file_ops.c} (100%)
 rename drivers/{staging/rdma/hfi1/firmware.c => infiniband/hw/hfi1/firmware.c} (100%)
 rename drivers/{staging/rdma/hfi1/hfi.h => infiniband/hw/hfi1/hfi.h} (100%)
 rename drivers/{staging/rdma/hfi1/init.c => infiniband/hw/hfi1/init.c} (100%)
 rename drivers/{staging/rdma/hfi1/intr.c => infiniband/hw/hfi1/intr.c} (100%)
 rename drivers/{staging/rdma/hfi1/iowait.h => infiniband/hw/hfi1/iowait.h} (100%)
 rename drivers/{staging/rdma/hfi1/mad.c => infiniband/hw/hfi1/mad.c} (100%)
 rename drivers/{staging/rdma/hfi1/mad.h => infiniband/hw/hfi1/mad.h} (100%)
 rename drivers/{staging/rdma/hfi1/mmu_rb.c => infiniband/hw/hfi1/mmu_rb.c} (100%)
 rename drivers/{staging/rdma/hfi1/mmu_rb.h => infiniband/hw/hfi1/mmu_rb.h} (100%)
 rename drivers/{staging/rdma/hfi1/opa_compat.h => infiniband/hw/hfi1/opa_compat.h} (100%)
 rename drivers/{staging/rdma/hfi1/pcie.c => infiniband/hw/hfi1/pcie.c} (100%)
 rename drivers/{staging/rdma/hfi1/pio.c => infiniband/hw/hfi1/pio.c} (100%)
 rename drivers/{staging/rdma/hfi1/pio.h => infiniband/hw/hfi1/pio.h} (100%)
 rename drivers/{staging/rdma/hfi1/pio_copy.c => infiniband/hw/hfi1/pio_copy.c} (100%)
 rename drivers/{staging/rdma/hfi1/platform.c => infiniband/hw/hfi1/platform.c} (100%)
 rename drivers/{staging/rdma/hfi1/platform.h => infiniband/hw/hfi1/platform.h} (100%)
 rename drivers/{staging/rdma/hfi1/qp.c => infiniband/hw/hfi1/qp.c} (100%)
 rename drivers/{staging/rdma/hfi1/qp.h => infiniband/hw/hfi1/qp.h} (100%)
 rename drivers/{staging/rdma/hfi1/qsfp.c => infiniband/hw/hfi1/qsfp.c} (100%)
 rename drivers/{staging/rdma/hfi1/qsfp.h => infiniband/hw/hfi1/qsfp.h} (100%)
 rename drivers/{staging/rdma/hfi1/rc.c => infiniband/hw/hfi1/rc.c} (100%)
 rename drivers/{staging/rdma/hfi1/ruc.c => infiniband/hw/hfi1/ruc.c} (100%)
 rename drivers/{staging/rdma/hfi1/sdma.c => infiniband/hw/hfi1/sdma.c} (100%)
 rename drivers/{staging/rdma/hfi1/sdma.h => infiniband/hw/hfi1/sdma.h} (100%)
 rename drivers/{staging/rdma/hfi1/sdma_txreq.h => infiniband/hw/hfi1/sdma_txreq.h} (100%)
 rename drivers/{staging/rdma/hfi1/sysfs.c => infiniband/hw/hfi1/sysfs.c} (100%)
 rename drivers/{staging/rdma/hfi1/trace.c => infiniband/hw/hfi1/trace.c} (100%)
 rename drivers/{staging/rdma/hfi1/trace.h => infiniband/hw/hfi1/trace.h} (100%)
 rename drivers/{staging/rdma/hfi1/twsi.c => infiniband/hw/hfi1/twsi.c} (100%)
 rename drivers/{staging/rdma/hfi1/twsi.h => infiniband/hw/hfi1/twsi.h} (100%)
 rename drivers/{staging/rdma/hfi1/uc.c => infiniband/hw/hfi1/uc.c} (100%)
 rename drivers/{staging/rdma/hfi1/ud.c => infiniband/hw/hfi1/ud.c} (100%)
 rename drivers/{staging/rdma/hfi1/user_exp_rcv.c => infiniband/hw/hfi1/user_exp_rcv.c} (100%)
 rename drivers/{staging/rdma/hfi1/user_exp_rcv.h => infiniband/hw/hfi1/user_exp_rcv.h} (100%)
 rename drivers/{staging/rdma/hfi1/user_pages.c => infiniband/hw/hfi1/user_pages.c} (100%)
 rename drivers/{staging/rdma/hfi1/user_sdma.c => infiniband/hw/hfi1/user_sdma.c} (100%)
 rename drivers/{staging/rdma/hfi1/user_sdma.h => infiniband/hw/hfi1/user_sdma.h} (100%)
 rename drivers/{staging/rdma/hfi1/verbs.c => infiniband/hw/hfi1/verbs.c} (100%)
 rename drivers/{staging/rdma/hfi1/verbs.h => infiniband/hw/hfi1/verbs.h} (100%)
 rename drivers/{staging/rdma/hfi1/verbs_txreq.c => infiniband/hw/hfi1/verbs_txreq.c} (100%)
 rename drivers/{staging/rdma/hfi1/verbs_txreq.h => infiniband/hw/hfi1/verbs_txreq.h} (100%)
 delete mode 100644 drivers/staging/rdma/hfi1/TODO

diff --git a/MAINTAINERS b/MAINTAINERS
index c802594..9823456 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5086,6 +5086,13 @@ F:	drivers/block/cciss*
 F:	include/linux/cciss_ioctl.h
 F:	include/uapi/linux/cciss_ioctl.h
 
+HFI1 DRIVER
+M:	Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+M:	Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Supported
+F:	drivers/infiniband/hw/hfi1
+
 HFS FILESYSTEM
 L:	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Orphan
@@ -10661,12 +10668,6 @@ M:	Arnaud Patard <arnaud.patard-dQbF7i+pzddAfugRpC6u6w@public.gmane.org>
 S:	Odd Fixes
 F:	drivers/staging/xgifb/
 
-HFI1 DRIVER
-M:	Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
-L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-S:	Supported
-F:	drivers/staging/rdma/hfi1
-
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut-Rv4seVrz/scdnm+yROfE0A@public.gmane.org>
 S:	Odd Fixes
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 6425c0e..2137adf 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -85,4 +85,6 @@ source "drivers/infiniband/ulp/isert/Kconfig"
 
 source "drivers/infiniband/sw/rdmavt/Kconfig"
 
+source "drivers/infiniband/hw/hfi1/Kconfig"
+
 endif # INFINIBAND
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index c7ad0a4..c0c7cf8 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_MLX5_INFINIBAND)		+= mlx5/
 obj-$(CONFIG_INFINIBAND_NES)		+= nes/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
 obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
+obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
similarity index 100%
rename from drivers/staging/rdma/hfi1/Kconfig
rename to drivers/infiniband/hw/hfi1/Kconfig
diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/infiniband/hw/hfi1/Makefile
similarity index 100%
rename from drivers/staging/rdma/hfi1/Makefile
rename to drivers/infiniband/hw/hfi1/Makefile
diff --git a/drivers/staging/rdma/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/affinity.c
rename to drivers/infiniband/hw/hfi1/affinity.c
diff --git a/drivers/staging/rdma/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/affinity.h
rename to drivers/infiniband/hw/hfi1/affinity.h
diff --git a/drivers/staging/rdma/hfi1/aspm.h b/drivers/infiniband/hw/hfi1/aspm.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/aspm.h
rename to drivers/infiniband/hw/hfi1/aspm.h
diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/chip.c
rename to drivers/infiniband/hw/hfi1/chip.c
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/chip.h
rename to drivers/infiniband/hw/hfi1/chip.h
diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/infiniband/hw/hfi1/chip_registers.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/chip_registers.h
rename to drivers/infiniband/hw/hfi1/chip_registers.h
diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/infiniband/hw/hfi1/common.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/common.h
rename to drivers/infiniband/hw/hfi1/common.h
diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/debugfs.c
rename to drivers/infiniband/hw/hfi1/debugfs.c
diff --git a/drivers/staging/rdma/hfi1/debugfs.h b/drivers/infiniband/hw/hfi1/debugfs.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/debugfs.h
rename to drivers/infiniband/hw/hfi1/debugfs.h
diff --git a/drivers/staging/rdma/hfi1/device.c b/drivers/infiniband/hw/hfi1/device.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/device.c
rename to drivers/infiniband/hw/hfi1/device.c
diff --git a/drivers/staging/rdma/hfi1/device.h b/drivers/infiniband/hw/hfi1/device.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/device.h
rename to drivers/infiniband/hw/hfi1/device.h
diff --git a/drivers/staging/rdma/hfi1/dma.c b/drivers/infiniband/hw/hfi1/dma.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/dma.c
rename to drivers/infiniband/hw/hfi1/dma.c
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/driver.c
rename to drivers/infiniband/hw/hfi1/driver.c
diff --git a/drivers/staging/rdma/hfi1/efivar.c b/drivers/infiniband/hw/hfi1/efivar.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/efivar.c
rename to drivers/infiniband/hw/hfi1/efivar.c
diff --git a/drivers/staging/rdma/hfi1/efivar.h b/drivers/infiniband/hw/hfi1/efivar.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/efivar.h
rename to drivers/infiniband/hw/hfi1/efivar.h
diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/infiniband/hw/hfi1/eprom.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/eprom.c
rename to drivers/infiniband/hw/hfi1/eprom.c
diff --git a/drivers/staging/rdma/hfi1/eprom.h b/drivers/infiniband/hw/hfi1/eprom.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/eprom.h
rename to drivers/infiniband/hw/hfi1/eprom.h
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/file_ops.c
rename to drivers/infiniband/hw/hfi1/file_ops.c
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/firmware.c
rename to drivers/infiniband/hw/hfi1/firmware.c
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/hfi.h
rename to drivers/infiniband/hw/hfi1/hfi.h
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/init.c
rename to drivers/infiniband/hw/hfi1/init.c
diff --git a/drivers/staging/rdma/hfi1/intr.c b/drivers/infiniband/hw/hfi1/intr.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/intr.c
rename to drivers/infiniband/hw/hfi1/intr.c
diff --git a/drivers/staging/rdma/hfi1/iowait.h b/drivers/infiniband/hw/hfi1/iowait.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/iowait.h
rename to drivers/infiniband/hw/hfi1/iowait.h
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/mad.c
rename to drivers/infiniband/hw/hfi1/mad.c
diff --git a/drivers/staging/rdma/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/mad.h
rename to drivers/infiniband/hw/hfi1/mad.h
diff --git a/drivers/staging/rdma/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/mmu_rb.c
rename to drivers/infiniband/hw/hfi1/mmu_rb.c
diff --git a/drivers/staging/rdma/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/mmu_rb.h
rename to drivers/infiniband/hw/hfi1/mmu_rb.h
diff --git a/drivers/staging/rdma/hfi1/opa_compat.h b/drivers/infiniband/hw/hfi1/opa_compat.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/opa_compat.h
rename to drivers/infiniband/hw/hfi1/opa_compat.h
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/pcie.c
rename to drivers/infiniband/hw/hfi1/pcie.c
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/pio.c
rename to drivers/infiniband/hw/hfi1/pio.c
diff --git a/drivers/staging/rdma/hfi1/pio.h b/drivers/infiniband/hw/hfi1/pio.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/pio.h
rename to drivers/infiniband/hw/hfi1/pio.h
diff --git a/drivers/staging/rdma/hfi1/pio_copy.c b/drivers/infiniband/hw/hfi1/pio_copy.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/pio_copy.c
rename to drivers/infiniband/hw/hfi1/pio_copy.c
diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/platform.c
rename to drivers/infiniband/hw/hfi1/platform.c
diff --git a/drivers/staging/rdma/hfi1/platform.h b/drivers/infiniband/hw/hfi1/platform.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/platform.h
rename to drivers/infiniband/hw/hfi1/platform.h
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/qp.c
rename to drivers/infiniband/hw/hfi1/qp.c
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/infiniband/hw/hfi1/qp.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/qp.h
rename to drivers/infiniband/hw/hfi1/qp.h
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/infiniband/hw/hfi1/qsfp.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/qsfp.c
rename to drivers/infiniband/hw/hfi1/qsfp.c
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/infiniband/hw/hfi1/qsfp.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/qsfp.h
rename to drivers/infiniband/hw/hfi1/qsfp.h
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/rc.c
rename to drivers/infiniband/hw/hfi1/rc.c
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/ruc.c
rename to drivers/infiniband/hw/hfi1/ruc.c
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/sdma.c
rename to drivers/infiniband/hw/hfi1/sdma.c
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/sdma.h
rename to drivers/infiniband/hw/hfi1/sdma.h
diff --git a/drivers/staging/rdma/hfi1/sdma_txreq.h b/drivers/infiniband/hw/hfi1/sdma_txreq.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/sdma_txreq.h
rename to drivers/infiniband/hw/hfi1/sdma_txreq.h
diff --git a/drivers/staging/rdma/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/sysfs.c
rename to drivers/infiniband/hw/hfi1/sysfs.c
diff --git a/drivers/staging/rdma/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/trace.c
rename to drivers/infiniband/hw/hfi1/trace.c
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/infiniband/hw/hfi1/trace.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/trace.h
rename to drivers/infiniband/hw/hfi1/trace.h
diff --git a/drivers/staging/rdma/hfi1/twsi.c b/drivers/infiniband/hw/hfi1/twsi.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/twsi.c
rename to drivers/infiniband/hw/hfi1/twsi.c
diff --git a/drivers/staging/rdma/hfi1/twsi.h b/drivers/infiniband/hw/hfi1/twsi.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/twsi.h
rename to drivers/infiniband/hw/hfi1/twsi.h
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/uc.c
rename to drivers/infiniband/hw/hfi1/uc.c
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/ud.c
rename to drivers/infiniband/hw/hfi1/ud.c
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/user_exp_rcv.c
rename to drivers/infiniband/hw/hfi1/user_exp_rcv.c
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/user_exp_rcv.h
rename to drivers/infiniband/hw/hfi1/user_exp_rcv.h
diff --git a/drivers/staging/rdma/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/user_pages.c
rename to drivers/infiniband/hw/hfi1/user_pages.c
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/user_sdma.c
rename to drivers/infiniband/hw/hfi1/user_sdma.c
diff --git a/drivers/staging/rdma/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/user_sdma.h
rename to drivers/infiniband/hw/hfi1/user_sdma.h
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/verbs.c
rename to drivers/infiniband/hw/hfi1/verbs.c
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/verbs.h
rename to drivers/infiniband/hw/hfi1/verbs.h
diff --git a/drivers/staging/rdma/hfi1/verbs_txreq.c b/drivers/infiniband/hw/hfi1/verbs_txreq.c
similarity index 100%
rename from drivers/staging/rdma/hfi1/verbs_txreq.c
rename to drivers/infiniband/hw/hfi1/verbs_txreq.c
diff --git a/drivers/staging/rdma/hfi1/verbs_txreq.h b/drivers/infiniband/hw/hfi1/verbs_txreq.h
similarity index 100%
rename from drivers/staging/rdma/hfi1/verbs_txreq.h
rename to drivers/infiniband/hw/hfi1/verbs_txreq.h
diff --git a/drivers/staging/rdma/Kconfig b/drivers/staging/rdma/Kconfig
index f1f3eca..2c5b018 100644
--- a/drivers/staging/rdma/Kconfig
+++ b/drivers/staging/rdma/Kconfig
@@ -22,6 +22,4 @@ menuconfig STAGING_RDMA
 # Please keep entries in alphabetic order
 if STAGING_RDMA
 
-source "drivers/staging/rdma/hfi1/Kconfig"
-
 endif
diff --git a/drivers/staging/rdma/Makefile b/drivers/staging/rdma/Makefile
index 8c7fc1d..b5e94f1 100644
--- a/drivers/staging/rdma/Makefile
+++ b/drivers/staging/rdma/Makefile
@@ -1,2 +1 @@
 # Entries for RDMA_STAGING tree
-obj-$(CONFIG_INFINIBAND_HFI1)	+= hfi1/
diff --git a/drivers/staging/rdma/hfi1/TODO b/drivers/staging/rdma/hfi1/TODO
deleted file mode 100644
index 4c6f1d7..0000000
--- a/drivers/staging/rdma/hfi1/TODO
+++ /dev/null
@@ -1,6 +0,0 @@
-July, 2015
-
-- Remove unneeded file entries in sysfs
-- Remove software processing of IB protocol and place in library for use
-  by qib, ipath (if still present), hfi1, and eventually soft-roce
-- Replace incorrect uAPI

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
