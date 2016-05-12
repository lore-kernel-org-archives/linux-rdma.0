From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] IB/hfi1: Clean up char devs and destage driver
Date: Thu, 12 May 2016 10:27:49 -0700
Message-ID: <20160512172500.11667.11333.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Based on feedback we have received during review of recent hfi1 driver patches
[1] we have decided to go ahead and remove the driver specific character devices
for the UI and snoop/diag. Furthermore we remove the EPROM specific code since 
we have discovered a way to do this sort of stuff from user space.

This series also removes the multi-purpose hfi1 cdev. We still maintain a per
hfi cdev (/dev/hfi1_x) but the /dev/hfi1 cdev has been removed.

The write()/writev() problem [2] has been addressed in a patch series previously
posted and resubmitted just prior to this.

Since the hfi1 TODO file is complete and we have removed the parts of the code
which have drawn the most ire from the community list we believe it is now fair
to let the driver move out of staging and into the mainline. We will work with
the community to get back the features that have been removed as separate
patches that can be more easily reviewed and commented on.

We realize there is still an on-going effort to redo the verbs uAPI and
understand that may have an impact on our use of the /dev/hfi1_x cdevs and are
looking forward to working with the community on that front. However we do not
believe that alone should hold the hfi1 driver in staging.

There is one other aspect that has been called out, which is the
driver's use of twsi code. We are currently working on a patch set to address
that which will hopefully be out soon, but want to get this on the mailing list
for comments rather than wait.

[1] https://www.spinics.net/lists/linux-rdma/msg35319.html
[2] https://www.spinics.net/lists/linux-rdma/msg34451.html

This patch series applies on Doug's k.o/for-4.7 branch.

Patches can also be viewed in my repo at:
https://github.com/ddalessa/kernel/tree/for-4.7

---

Dennis Dalessandro (6):
      IB/hfi1: Remove multiple device cdev
      IB/hfi1: Remove UI char device
      IB/hfi1: Remove EPROM functionality from data device
      IB/hfi1: Remove snoop/diag interface
      IB/hfi1: Remove anti-pattern in cdev init
      IB/hfi1: Move driver out of staging


 MAINTAINERS                                 |   13 
 drivers/infiniband/Kconfig                  |    2 
 drivers/infiniband/hw/Makefile              |    1 
 drivers/infiniband/hw/hfi1/Kconfig          |    0 
 drivers/infiniband/hw/hfi1/Makefile         |    2 
 drivers/infiniband/hw/hfi1/affinity.c       |    0 
 drivers/infiniband/hw/hfi1/affinity.h       |    0 
 drivers/infiniband/hw/hfi1/aspm.h           |    0 
 drivers/infiniband/hw/hfi1/chip.c           |    0 
 drivers/infiniband/hw/hfi1/chip.h           |    0 
 drivers/infiniband/hw/hfi1/chip_registers.h |    0 
 drivers/infiniband/hw/hfi1/common.h         |    0 
 drivers/infiniband/hw/hfi1/debugfs.c        |    0 
 drivers/infiniband/hw/hfi1/debugfs.h        |    0 
 drivers/infiniband/hw/hfi1/device.c         |   14 
 drivers/infiniband/hw/hfi1/device.h         |    0 
 drivers/infiniband/hw/hfi1/dma.c            |    0 
 drivers/infiniband/hw/hfi1/driver.c         |    0 
 drivers/infiniband/hw/hfi1/efivar.c         |    0 
 drivers/infiniband/hw/hfi1/efivar.h         |    0 
 drivers/infiniband/hw/hfi1/eprom.c          |   84 +
 drivers/infiniband/hw/hfi1/eprom.h          |    0 
 drivers/infiniband/hw/hfi1/file_ops.c       |  301 ----
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
 drivers/staging/rdma/Kconfig                |    2 
 drivers/staging/rdma/Makefile               |    1 
 drivers/staging/rdma/hfi1/TODO              |    6 
 drivers/staging/rdma/hfi1/diag.c            | 1918 ---------------------------
 drivers/staging/rdma/hfi1/eprom.c           |  471 -------
 include/uapi/rdma/hfi/hfi1_user.h           |   43 -
 70 files changed, 93 insertions(+), 2765 deletions(-)
 rename drivers/{staging/rdma/hfi1/Kconfig => infiniband/hw/hfi1/Kconfig} (100%)
 rename drivers/{staging/rdma/hfi1/Makefile => infiniband/hw/hfi1/Makefile} (88%)
 rename drivers/{staging/rdma/hfi1/affinity.c => infiniband/hw/hfi1/affinity.c} (100%)
 rename drivers/{staging/rdma/hfi1/affinity.h => infiniband/hw/hfi1/affinity.h} (100%)
 rename drivers/{staging/rdma/hfi1/aspm.h => infiniband/hw/hfi1/aspm.h} (100%)
 rename drivers/{staging/rdma/hfi1/chip.c => infiniband/hw/hfi1/chip.c} (100%)
 rename drivers/{staging/rdma/hfi1/chip.h => infiniband/hw/hfi1/chip.h} (100%)
 rename drivers/{staging/rdma/hfi1/chip_registers.h => infiniband/hw/hfi1/chip_registers.h} (100%)
 rename drivers/{staging/rdma/hfi1/common.h => infiniband/hw/hfi1/common.h} (100%)
 rename drivers/{staging/rdma/hfi1/debugfs.c => infiniband/hw/hfi1/debugfs.c} (100%)
 rename drivers/{staging/rdma/hfi1/debugfs.h => infiniband/hw/hfi1/debugfs.h} (100%)
 rename drivers/{staging/rdma/hfi1/device.c => infiniband/hw/hfi1/device.c} (96%)
 rename drivers/{staging/rdma/hfi1/device.h => infiniband/hw/hfi1/device.h} (100%)
 rename drivers/{staging/rdma/hfi1/dma.c => infiniband/hw/hfi1/dma.c} (100%)
 rename drivers/{staging/rdma/hfi1/driver.c => infiniband/hw/hfi1/driver.c} (100%)
 rename drivers/{staging/rdma/hfi1/efivar.c => infiniband/hw/hfi1/efivar.c} (100%)
 rename drivers/{staging/rdma/hfi1/efivar.h => infiniband/hw/hfi1/efivar.h} (100%)
 copy drivers/{staging/rdma/hfi1/user_sdma.h => infiniband/hw/hfi1/eprom.c} (61%)
 rename drivers/{staging/rdma/hfi1/eprom.h => infiniband/hw/hfi1/eprom.h} (100%)
 rename drivers/{staging/rdma/hfi1/file_ops.c => infiniband/hw/hfi1/file_ops.c} (85%)
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
 delete mode 100644 drivers/staging/rdma/hfi1/diag.c
 delete mode 100644 drivers/staging/rdma/hfi1/eprom.c

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
