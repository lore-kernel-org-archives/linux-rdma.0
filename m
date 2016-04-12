From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/21] IB/hfi1: First round of fixes for 4.7
Date: Tue, 12 Apr 2016 10:49:52 -0700
Message-ID: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These patches do some clean ups and fix issues which may not be appropriate for
an RC so we are targeting these for 4.7. The current patch series applies on top
of the "Important bug fixes for 4.6 RC" patch set submitted just prior to this.

Patches can be viewed in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.7.

---

Dean Luick (13):
      IB/hfi1: Fix sysfs file offset usage
      IB/hfi1: Fix i2c resource reservation checks
      IB/hfi1: Fix QOS num_vl bit width
      IB/hfi1: Remove invalid QOS check
      IB/hfi1: Fix QOS rule mappings
      IB/hfi1: Correctly obtain the full service class
      IB/hfi1: Simplify init_qpmap_table()
      IB/hfi1: Guard against concurrent I2C access across all chains
      IB/hfi1: Fix double QSFP resource acquire on cache refresh
      IB/hfi1: Extract RSM map table init from QOS
      IB/hfi1: Move QOS decision logic into its own function
      IB/hfi1: Create a routine to set a receive side mapping rule
      IB/hfi1: Add RSM rule for user FECN handling

Easwar Hariharan (2):
      IB/hfi1: Always turn on CDRs for low power QSFP modules
      IB/hfi1: Remove module presence check outside pre-LNI checks

Jianxin Xiong (1):
      IB/hfi1: Reduce kernel context pio buffer allocation

Jubin John (1):
      IB/hfi1: Change default number of user contexts

Mike Marciniszyn (2):
      IB/hfi1: Remove unreachable code
      IB/hfi1: Use global defines for upper bits in opcode

Sebastian Sanchez (2):
      IB/hfi1: Adjust default MTU to be 10KB
      IB/hfi1: Check P_KEY for all sent packets from user mode


 drivers/infiniband/sw/rdmavt/qp.c          |    6 
 drivers/staging/rdma/hfi1/affinity.c       |   93 +++--
 drivers/staging/rdma/hfi1/affinity.h       |   19 +
 drivers/staging/rdma/hfi1/chip.c           |  485 +++++++++++++++++++---------
 drivers/staging/rdma/hfi1/chip.h           |    1 
 drivers/staging/rdma/hfi1/chip_registers.h |    1 
 drivers/staging/rdma/hfi1/diag.c           |    3 
 drivers/staging/rdma/hfi1/driver.c         |    3 
 drivers/staging/rdma/hfi1/firmware.c       |    9 -
 drivers/staging/rdma/hfi1/hfi.h            |   11 -
 drivers/staging/rdma/hfi1/init.c           |    1 
 drivers/staging/rdma/hfi1/pio.c            |   52 ++-
 drivers/staging/rdma/hfi1/pio.h            |    4 
 drivers/staging/rdma/hfi1/platform.c       |   99 +++---
 drivers/staging/rdma/hfi1/qp.c             |    6 
 drivers/staging/rdma/hfi1/qsfp.c           |   58 ++-
 drivers/staging/rdma/hfi1/qsfp.h           |   15 -
 drivers/staging/rdma/hfi1/rc.c             |    2 
 drivers/staging/rdma/hfi1/sysfs.c          |    4 
 drivers/staging/rdma/hfi1/user_sdma.c      |    7 
 drivers/staging/rdma/hfi1/verbs.c          |  108 ++++--
 drivers/staging/rdma/hfi1/verbs.h          |    3 
 22 files changed, 639 insertions(+), 351 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
