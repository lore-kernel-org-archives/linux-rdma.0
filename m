From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/17] IB/hfi1: Bug fixes post destaging of driver
Date: Sat, 05 Mar 2016 08:49:18 -0800
Message-ID: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are a few more bug fixes, most of these are in the lower levels of the
driver. There are some coccinelle fix-ups as well.

This series will apply on the patch to move the driver out of staging
and should apply cleanly to the hfi1 branch of Doug's GitHub.

I have also staged these in my GitHub tree at:
https://github.com/ddalessa/kernel/tree/for-4.6.

---

Dean Luick (12):
      IB/hfi1: Remove ASIC block clear
      IB/hfi1: Add shared ASIC structure
      IB/hfi1: Add ASIC resource reservation functions
      IB/hfi1: Change EPROM handling to use resource reservation
      IB/hfi1: Change SBus handling to use resource reservation
      IB/hfi1: Change QSFP functions to use resource reservation
      IB/hfi1: Change thermal init to use resource reservation
      IB/hfi1: Remove unused HFI1_DO_INIT_ASIC flag
      IB/hfi1: Reduce hardware mutex timeout
      IB/hfi1: Hold i2c resource across debugfs open/close
      IB/hfi1: Add ASIC flag view/clear
      IB/hfi1: Add adaptive cacheless verbs copy

Harish Chegondi (3):
      IB/hfi1: Add the break statement that was removed in an earlier patch
      IB/hfi1: Move constant to the right in bitwise operations
      IB/hfi1: Replace kmalloc and memcpy with a kmemdup

Jubin John (1):
      IB/hfi1: Handle host handshake timeout

Kaike Wan (1):
      IB/hfi1: Don't call cond_resched in atomic mode when sending packets


 drivers/infiniband/hw/hfi1/chip.c     |  172 ++++++++---------------
 drivers/infiniband/hw/hfi1/chip.h     |   39 +++++
 drivers/infiniband/hw/hfi1/debugfs.c  |  248 ++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/hfi1/efivar.c   |    3 
 drivers/infiniband/hw/hfi1/eprom.c    |   36 ++---
 drivers/infiniband/hw/hfi1/firmware.c |  238 +++++++++++++++++++++++++++++---
 drivers/infiniband/hw/hfi1/hfi.h      |   24 +++
 drivers/infiniband/hw/hfi1/init.c     |   27 +++-
 drivers/infiniband/hw/hfi1/pcie.c     |   13 +-
 drivers/infiniband/hw/hfi1/pio.c      |    4 -
 drivers/infiniband/hw/hfi1/platform.c |   26 ++-
 drivers/infiniband/hw/hfi1/qsfp.c     |  108 ++++++++++----
 drivers/infiniband/hw/hfi1/qsfp.h     |    4 +
 drivers/infiniband/hw/hfi1/rc.c       |    2 
 drivers/infiniband/hw/hfi1/ruc.c      |    8 +
 drivers/infiniband/hw/hfi1/verbs.c    |  185 ++++++++++++++++++++++++-
 drivers/infiniband/hw/hfi1/verbs.h    |   22 +++
 17 files changed, 934 insertions(+), 225 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
