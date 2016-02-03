From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/54] staging/rdma/hfi1: Various bug fixes for hfi1 post
 rdmavt
Date: Wed, 03 Feb 2016 14:30:30 -0800
Message-ID: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a pretty big patch series. It brings in a large number of fixes that we
have been holding onto due to conflicts with rdmavt and the two maintainer model
we were previously operating under.

This applies on top of the previously posted "Finish adding core rdmavt verbs
support" patch and can be seen in context at:
https://github.com/ddalessa/kernel/tree/for-4.6

---

Ashutosh Dixit (1):
      staging/rdma/hfi1: Add support for enabling/disabling PCIe ASPM

Bryan Morgan (1):
      staging/rdma/hfi1: HFI reports wrong offline disabled reason when cable removed

Dean Luick (16):
      staging/rdma/hfi1: Fix missing firmware NULL dereference
      staging/rdma/hfi1: Only warn when board description is not found
      staging/rdma/hfi1: Make firmware failure messages warnings
      staging/rdma/hfi1: No firmware retry for simulation
      staging/rdma/hfi1: Skip lcb init for simulation
      staging/rdma/hfi1: Fix for generic I2C interface
      staging/rdma/hfi1: Use device file minor to identify EPROM
      staging/rdma/hfi1: correctly check for post-interrupt packets
      staging/rdma/hfi1: Report physical state changes per device instead of globally
      staging/rdma/hfi1: Fix fabric serdes reset by re-downloading firmware
      staging/rdma/hfi1: Split last 8 bytes of copy to user buffer
      staging/rdma/hfi1: Remove PCIe AER diagnostic message
      staging/rdma/hfi1: Correct TWSI reset
      staging/rdma/hfi1: Fix snoop packet length calculation
      staging/rdma/hfi1: Make EPROM check per device
      staging/rdma/hfi1: Remove unused variable nsbr

Dennis Dalessandro (1):
      staging/rdma/hfi1: Support query gid in rdmavt

Easwar Hariharan (8):
      staging/rdma/hfi1: cleanup messages on qsfp_read() failure
      staging/rdma/hfi1: Add active and optical cable support
      staging/rdma/hfi1: Get port type from configuration file
      staging/rdma/hfi1: Support external device configuration requests from 8051
      staging/rdma/hfi1: Don't attempt to qualify or tune loopback plugs
      staging/rdma/hfi1: Reduce syslog message severity and provide speed information
      staging/rdma/hfi1: Implement LED beaconing for maintenance
      staging/rdma/hfi1,IB/core: Fix LinkDownReason define for consistency

Harish Chegondi (1):
      staging/rdma/hfi1: Remove modify_port and port_immutable functions

Ira Weiny (1):
      staging/rdma/hfi1: Fix SL->SC checks

Jubin John (2):
      staging/rdma/hfi1: Remove srq functionality
      staging/rdma/hfi1: Clean up init_cntrs()

Mike Marciniszyn (2):
      staging/rdma/hfi1: Fix QSFP memory read/write across 128 byte boundary
      staging/rdma/hfi1: Fix per-VL transmit discard counts

Mitko Haralanov (11):
      staging/rdma/hfi1: Correctly set RcvCtxtCtrl register
      staging/rdma/hfi1: Remove unused code
      staging/rdma/hfi1: Remove unnecessary duplicated variable
      staging/rdma/hfi1: Consolidate CPU/IRQ affinity support
      staging/rdma/hfi1: Allocate send ctxt on device NUMA node
      staging/rdma/hfi1: Verbs Mem affinity support
      staging/rdma/hfi1: Improve performance of TID cache look up
      staging/rdma/hfi1: Improve performance of SDMA transfers
      staging/rdma/hfi1: Properly determine error status of SDMA slots
      staging/rdma/hfi1: Improve performance of user SDMA
      staging/rdma/hfi1: Fix bug that could block the process on context exit

Sadanand Warrier (1):
      staging/rdma/hfi1: Add credits for VL0 to VL7 in snoop mode

Sebastian Sanchez (6):
      staging/rdma/hfi1: Fix for 32-bit counter overflow in driver and hfi1stats
      staging/rdma/hfi1: Fix for module parameter rcvhdrcnt when it's 2097152
      staging/rdma/hfi1: Change for data type of port number
      staging/rdma/hfi1: Replacement of goto's for break/returns
      staging/rdma/hfi1: Adding support for hfi counters via sysfs
      staging/rdma/hfi1: Removing unused struct hfi1_verbs_counters

Vennila Megavannan (3):
      staging/rdma/hfi1: Method to toggle "fast ECN" detection
      staging/rdma/hfi1: Change send_schedule counter to a per cpu counter
      staging/rdma/hfi1: Allow a fair scheduling of QPs


 Documentation/infiniband/sysfs.txt          |    3 
 drivers/staging/rdma/hfi1/Kconfig           |   10 
 drivers/staging/rdma/hfi1/Makefile          |    7 
 drivers/staging/rdma/hfi1/affinity.c        |  433 ++++++++++++++
 drivers/staging/rdma/hfi1/affinity.h        |   94 +++
 drivers/staging/rdma/hfi1/aspm.h            |  297 ++++++++++
 drivers/staging/rdma/hfi1/chip.c            |  803 +++++++++++++++-----------
 drivers/staging/rdma/hfi1/chip.h            |    9 
 drivers/staging/rdma/hfi1/chip_registers.h  |    3 
 drivers/staging/rdma/hfi1/debugfs.c         |    6 
 drivers/staging/rdma/hfi1/diag.c            |   73 ++
 drivers/staging/rdma/hfi1/driver.c          |  105 ++-
 drivers/staging/rdma/hfi1/eprom.c           |   31 -
 drivers/staging/rdma/hfi1/eprom.h           |    2 
 drivers/staging/rdma/hfi1/file_ops.c        |   51 +-
 drivers/staging/rdma/hfi1/firmware.c        |  100 ++-
 drivers/staging/rdma/hfi1/hfi.h             |   93 ++-
 drivers/staging/rdma/hfi1/init.c            |   69 +-
 drivers/staging/rdma/hfi1/intr.c            |    3 
 drivers/staging/rdma/hfi1/mad.c             |  426 ++++++++++----
 drivers/staging/rdma/hfi1/opa_compat.h      |   15 
 drivers/staging/rdma/hfi1/pcie.c            |   40 +
 drivers/staging/rdma/hfi1/platform.c        |  839 +++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/platform.h        |   44 +
 drivers/staging/rdma/hfi1/qp.c              |   25 +
 drivers/staging/rdma/hfi1/qp.h              |    2 
 drivers/staging/rdma/hfi1/qsfp.c            |  152 +++--
 drivers/staging/rdma/hfi1/qsfp.h            |   35 +
 drivers/staging/rdma/hfi1/rc.c              |   17 -
 drivers/staging/rdma/hfi1/ruc.c             |   62 +-
 drivers/staging/rdma/hfi1/sdma.c            |   12 
 drivers/staging/rdma/hfi1/sdma.h            |    2 
 drivers/staging/rdma/hfi1/srq.c             |  397 -------------
 drivers/staging/rdma/hfi1/sysfs.c           |   66 ++
 drivers/staging/rdma/hfi1/twsi.c            |  198 +++---
 drivers/staging/rdma/hfi1/twsi.h            |    7 
 drivers/staging/rdma/hfi1/uc.c              |   10 
 drivers/staging/rdma/hfi1/ud.c              |    9 
 drivers/staging/rdma/hfi1/user_exp_rcv.c    |  149 +++--
 drivers/staging/rdma/hfi1/user_sdma.c       |  304 ++++------
 drivers/staging/rdma/hfi1/user_sdma.h       |    6 
 drivers/staging/rdma/hfi1/verbs.c           |  143 ++---
 drivers/staging/rdma/hfi1/verbs.h           |   40 -
 include/rdma/opa_port_info.h                |    2 
 44 files changed, 3513 insertions(+), 1681 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/affinity.c
 create mode 100644 drivers/staging/rdma/hfi1/affinity.h
 create mode 100644 drivers/staging/rdma/hfi1/aspm.h
 create mode 100644 drivers/staging/rdma/hfi1/platform.c
 rename drivers/staging/rdma/hfi1/{platform_config.h => platform.h} (91%)
 delete mode 100644 drivers/staging/rdma/hfi1/srq.c

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
