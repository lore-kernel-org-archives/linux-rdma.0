From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/7] IB/hfi1: Destage hfi1 driver and fix a few bugs
Date: Fri, 26 Feb 2016 13:33:02 -0800
Message-ID: <20160226213022.16535.8149.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We believe the TODO list has been satisfied for the hfi1 driver. The main item
was removing the code duplication between hfi1 and qib. That has been handled by
the introduction of rdmavt in previously posted patch series.

There are also a few more bug fixes for hfi1 and one for rdmavt included in this
series.

This series builds on our currently outstanding patch sets and applies on top of
the "Misc bug fixes" series. It can also be seen in the my public git tree at:
https://github.com/ddalessa/kernel/tree/for-4.6.

---

Dennis Dalessandro (1):
      IB/hfi1: Move hfi1 driver out of staging

Easwar Hariharan (1):
      staging/rdma/hfi1: Fix reporting of LED status in Get(LedInfo) and Get(PortInfo)

Jianxin Xiong (1):
      staging/rdma/hfi1: Fix header size calculation for RC/UC QPs with GRH enabled

Jubin John (2):
      IB/rdmavt: Check lkey_table_size value before use
      staging/rdma/hfi1: Fix memory leaks

Kaike Wan (2):
      staging/rdma/hfi1: Avoid using upstream component if it is not accessible
      staging/rdma/hfi1: Check interrupt registers mapping


 MAINTAINERS                                 |   13 +++---
 drivers/infiniband/Kconfig                  |    2 +
 drivers/infiniband/hw/Makefile              |    1 
 drivers/infiniband/hw/hfi1/Kconfig          |    0 
 drivers/infiniband/hw/hfi1/Makefile         |    0 
 drivers/infiniband/hw/hfi1/affinity.c       |    0 
 drivers/infiniband/hw/hfi1/affinity.h       |    0 
 drivers/infiniband/hw/hfi1/aspm.h           |   19 ++++++++-
 drivers/infiniband/hw/hfi1/chip.c           |   56 +++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/chip.h           |    0 
 drivers/infiniband/hw/hfi1/chip_registers.h |    0 
 drivers/infiniband/hw/hfi1/common.h         |    0 
 drivers/infiniband/hw/hfi1/debugfs.c        |    0 
 drivers/infiniband/hw/hfi1/debugfs.h        |    0 
 drivers/infiniband/hw/hfi1/device.c         |    0 
 drivers/infiniband/hw/hfi1/device.h         |    0 
 drivers/infiniband/hw/hfi1/diag.c           |    0 
 drivers/infiniband/hw/hfi1/dma.c            |    0 
 drivers/infiniband/hw/hfi1/driver.c         |   13 +++++-
 drivers/infiniband/hw/hfi1/efivar.c         |    0 
 drivers/infiniband/hw/hfi1/efivar.h         |    0 
 drivers/infiniband/hw/hfi1/eprom.c          |    0 
 drivers/infiniband/hw/hfi1/eprom.h          |    0 
 drivers/infiniband/hw/hfi1/file_ops.c       |    0 
 drivers/infiniband/hw/hfi1/firmware.c       |    0 
 drivers/infiniband/hw/hfi1/hfi.h            |    0 
 drivers/infiniband/hw/hfi1/init.c           |    2 +
 drivers/infiniband/hw/hfi1/intr.c           |    0 
 drivers/infiniband/hw/hfi1/iowait.h         |    0 
 drivers/infiniband/hw/hfi1/mad.c            |   24 +++++++++---
 drivers/infiniband/hw/hfi1/mad.h            |    0 
 drivers/infiniband/hw/hfi1/opa_compat.h     |    0 
 drivers/infiniband/hw/hfi1/pcie.c           |   22 +++++++++--
 drivers/infiniband/hw/hfi1/pio.c            |    2 -
 drivers/infiniband/hw/hfi1/pio.h            |    0 
 drivers/infiniband/hw/hfi1/pio_copy.c       |    0 
 drivers/infiniband/hw/hfi1/platform.c       |    0 
 drivers/infiniband/hw/hfi1/platform.h       |    0 
 drivers/infiniband/hw/hfi1/qp.c             |    0 
 drivers/infiniband/hw/hfi1/qp.h             |    0 
 drivers/infiniband/hw/hfi1/qsfp.c           |    0 
 drivers/infiniband/hw/hfi1/qsfp.h           |    0 
 drivers/infiniband/hw/hfi1/rc.c             |    8 ++--
 drivers/infiniband/hw/hfi1/ruc.c            |    0 
 drivers/infiniband/hw/hfi1/sdma.c           |    2 -
 drivers/infiniband/hw/hfi1/sdma.h           |    0 
 drivers/infiniband/hw/hfi1/sdma_txreq.h     |    0 
 drivers/infiniband/hw/hfi1/sysfs.c          |    0 
 drivers/infiniband/hw/hfi1/trace.c          |    0 
 drivers/infiniband/hw/hfi1/trace.h          |    0 
 drivers/infiniband/hw/hfi1/twsi.c           |    0 
 drivers/infiniband/hw/hfi1/twsi.h           |    0 
 drivers/infiniband/hw/hfi1/uc.c             |    4 +-
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
 drivers/infiniband/sw/rdmavt/mr.c           |    3 -
 drivers/staging/rdma/Kconfig                |    2 -
 drivers/staging/rdma/Makefile               |    1 
 drivers/staging/rdma/hfi1/TODO              |    6 ---
 67 files changed, 143 insertions(+), 37 deletions(-)
 rename drivers/{staging/rdma/hfi1/Kconfig => infiniband/hw/hfi1/Kconfig} (100%)
 rename drivers/{staging/rdma/hfi1/Makefile => infiniband/hw/hfi1/Makefile} (100%)
 rename drivers/{staging/rdma/hfi1/affinity.c => infiniband/hw/hfi1/affinity.c} (100%)
 rename drivers/{staging/rdma/hfi1/affinity.h => infiniband/hw/hfi1/affinity.h} (100%)
 rename drivers/{staging/rdma/hfi1/aspm.h => infiniband/hw/hfi1/aspm.h} (95%)
 rename drivers/{staging/rdma/hfi1/chip.c => infiniband/hw/hfi1/chip.c} (99%)
 rename drivers/{staging/rdma/hfi1/chip.h => infiniband/hw/hfi1/chip.h} (100%)
 rename drivers/{staging/rdma/hfi1/chip_registers.h => infiniband/hw/hfi1/chip_registers.h} (100%)
 rename drivers/{staging/rdma/hfi1/common.h => infiniband/hw/hfi1/common.h} (100%)
 rename drivers/{staging/rdma/hfi1/debugfs.c => infiniband/hw/hfi1/debugfs.c} (100%)
 rename drivers/{staging/rdma/hfi1/debugfs.h => infiniband/hw/hfi1/debugfs.h} (100%)
 rename drivers/{staging/rdma/hfi1/device.c => infiniband/hw/hfi1/device.c} (100%)
 rename drivers/{staging/rdma/hfi1/device.h => infiniband/hw/hfi1/device.h} (100%)
 rename drivers/{staging/rdma/hfi1/diag.c => infiniband/hw/hfi1/diag.c} (100%)
 rename drivers/{staging/rdma/hfi1/dma.c => infiniband/hw/hfi1/dma.c} (100%)
 rename drivers/{staging/rdma/hfi1/driver.c => infiniband/hw/hfi1/driver.c} (98%)
 rename drivers/{staging/rdma/hfi1/efivar.c => infiniband/hw/hfi1/efivar.c} (100%)
 rename drivers/{staging/rdma/hfi1/efivar.h => infiniband/hw/hfi1/efivar.h} (100%)
 rename drivers/{staging/rdma/hfi1/eprom.c => infiniband/hw/hfi1/eprom.c} (100%)
 rename drivers/{staging/rdma/hfi1/eprom.h => infiniband/hw/hfi1/eprom.h} (100%)
 rename drivers/{staging/rdma/hfi1/file_ops.c => infiniband/hw/hfi1/file_ops.c} (100%)
 rename drivers/{staging/rdma/hfi1/firmware.c => infiniband/hw/hfi1/firmware.c} (100%)
 rename drivers/{staging/rdma/hfi1/hfi.h => infiniband/hw/hfi1/hfi.h} (100%)
 rename drivers/{staging/rdma/hfi1/init.c => infiniband/hw/hfi1/init.c} (99%)
 rename drivers/{staging/rdma/hfi1/intr.c => infiniband/hw/hfi1/intr.c} (100%)
 rename drivers/{staging/rdma/hfi1/iowait.h => infiniband/hw/hfi1/iowait.h} (100%)
 rename drivers/{staging/rdma/hfi1/mad.c => infiniband/hw/hfi1/mad.c} (99%)
 rename drivers/{staging/rdma/hfi1/mad.h => infiniband/hw/hfi1/mad.h} (100%)
 rename drivers/{staging/rdma/hfi1/opa_compat.h => infiniband/hw/hfi1/opa_compat.h} (100%)
 rename drivers/{staging/rdma/hfi1/pcie.c => infiniband/hw/hfi1/pcie.c} (98%)
 rename drivers/{staging/rdma/hfi1/pio.c => infiniband/hw/hfi1/pio.c} (99%)
 rename drivers/{staging/rdma/hfi1/pio.h => infiniband/hw/hfi1/pio.h} (100%)
 rename drivers/{staging/rdma/hfi1/pio_copy.c => infiniband/hw/hfi1/pio_copy.c} (100%)
 rename drivers/{staging/rdma/hfi1/platform.c => infiniband/hw/hfi1/platform.c} (100%)
 rename drivers/{staging/rdma/hfi1/platform.h => infiniband/hw/hfi1/platform.h} (100%)
 rename drivers/{staging/rdma/hfi1/qp.c => infiniband/hw/hfi1/qp.c} (100%)
 rename drivers/{staging/rdma/hfi1/qp.h => infiniband/hw/hfi1/qp.h} (100%)
 rename drivers/{staging/rdma/hfi1/qsfp.c => infiniband/hw/hfi1/qsfp.c} (100%)
 rename drivers/{staging/rdma/hfi1/qsfp.h => infiniband/hw/hfi1/qsfp.h} (100%)
 rename drivers/{staging/rdma/hfi1/rc.c => infiniband/hw/hfi1/rc.c} (99%)
 rename drivers/{staging/rdma/hfi1/ruc.c => infiniband/hw/hfi1/ruc.c} (100%)
 rename drivers/{staging/rdma/hfi1/sdma.c => infiniband/hw/hfi1/sdma.c} (99%)
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

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
