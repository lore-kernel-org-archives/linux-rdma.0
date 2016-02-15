From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/21] staging/rdma/hfi1: finish checkpatch fixes
Date: Sun, 14 Feb 2016 20:19:13 -0800
Message-ID: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series adds the remaining checkpatch fixes for the hfi1 driver. This was
done with strict. Any remaining checkpatch issues are intentionally left and
should not be changed. A lot of the checkpatch issues were cleaned up as the
code moved to rdmavt, this is the remainder.

Applies on the "Adaptive PIO performance improvement" series and can be seen in
context at https://github.com/ddalessa/kernel/tree/for-4.6.

---

Jubin John (21):
      staging/rdma/hfi1: Add spaces around binary operators
      staging/rdma/hfi1: Remove multiple blank lines
      staging/rdma/hfi1: Remove space after cast
      staging/rdma/hfi1: Fix comparison to NULL
      staging/rdma/hfi1: Remove blank line after an open brace
      staging/rdma/hfi1: Remove blank line before close brace
      staging/rdma/hfi1: Fix logical continuations
      staging/rdma/hfi1: Add blank link after declarations
      staging/rdma/hfi1: Remove unnecessary parentheses
      staging/rdma/hfi1: Use BIT_ULL macro
      staging/rdma/hfi1: Split multiple assignments
      staging/rdma/hfi1: Fix misspellings
      staging/rdma/hfi1: Remove CamelCase
      staging/rdma/hfi1: Use pointer instead of struct name
      staging/rdma/hfi1: Remove void function return statement
      staging/rdma/hfi1: Add comment for spinlock_t definition
      staging/rdma/hfi1: Fix block comments
      staging/rdma/hfi1: Fix code alignment
      staging/rdma/hfi1: Add braces on all arms of statement
      staging/rdma/hfi1: Remove else after break
      staging/rdma/hfi1: Fix header


 drivers/staging/rdma/hfi1/affinity.c       |    5 
 drivers/staging/rdma/hfi1/affinity.h       |    5 
 drivers/staging/rdma/hfi1/aspm.h           |    5 
 drivers/staging/rdma/hfi1/chip.c           | 1200 +++++++++++++-------------
 drivers/staging/rdma/hfi1/chip.h           |   35 -
 drivers/staging/rdma/hfi1/chip_registers.h |    5 
 drivers/staging/rdma/hfi1/common.h         |    5 
 drivers/staging/rdma/hfi1/debugfs.c        |   47 -
 drivers/staging/rdma/hfi1/debugfs.h        |    5 
 drivers/staging/rdma/hfi1/device.c         |    5 
 drivers/staging/rdma/hfi1/device.h         |    5 
 drivers/staging/rdma/hfi1/diag.c           |    5 
 drivers/staging/rdma/hfi1/dma.c            |   17 
 drivers/staging/rdma/hfi1/driver.c         |   75 +-
 drivers/staging/rdma/hfi1/efivar.c         |    5 
 drivers/staging/rdma/hfi1/efivar.h         |    5 
 drivers/staging/rdma/hfi1/eprom.c          |   56 +
 drivers/staging/rdma/hfi1/eprom.h          |    5 
 drivers/staging/rdma/hfi1/file_ops.c       |   42 -
 drivers/staging/rdma/hfi1/firmware.c       |  177 ++--
 drivers/staging/rdma/hfi1/hfi.h            |   28 -
 drivers/staging/rdma/hfi1/init.c           |   49 +
 drivers/staging/rdma/hfi1/intr.c           |   24 -
 drivers/staging/rdma/hfi1/iowait.h         |    5 
 drivers/staging/rdma/hfi1/mad.c            |  342 ++++---
 drivers/staging/rdma/hfi1/mad.h            |   14 
 drivers/staging/rdma/hfi1/opa_compat.h     |    5 
 drivers/staging/rdma/hfi1/pcie.c           |  120 +--
 drivers/staging/rdma/hfi1/pio.c            |   99 +-
 drivers/staging/rdma/hfi1/pio.h            |   12 
 drivers/staging/rdma/hfi1/pio_copy.c       |   67 +
 drivers/staging/rdma/hfi1/platform.c       |    5 
 drivers/staging/rdma/hfi1/platform.h       |   13 
 drivers/staging/rdma/hfi1/qp.c             |   15 
 drivers/staging/rdma/hfi1/qp.h             |    5 
 drivers/staging/rdma/hfi1/qsfp.c           |   17 
 drivers/staging/rdma/hfi1/qsfp.h           |    8 
 drivers/staging/rdma/hfi1/rc.c             |   52 +
 drivers/staging/rdma/hfi1/ruc.c            |   27 -
 drivers/staging/rdma/hfi1/sdma.c           |  219 ++---
 drivers/staging/rdma/hfi1/sdma.h           |   23 
 drivers/staging/rdma/hfi1/sysfs.c          |   52 -
 drivers/staging/rdma/hfi1/trace.c          |   52 +
 drivers/staging/rdma/hfi1/trace.h          | 1289 +++++++++++++---------------
 drivers/staging/rdma/hfi1/twsi.c           |   11 
 drivers/staging/rdma/hfi1/twsi.h           |    6 
 drivers/staging/rdma/hfi1/uc.c             |   40 -
 drivers/staging/rdma/hfi1/ud.c             |   38 -
 drivers/staging/rdma/hfi1/user_exp_rcv.c   |    5 
 drivers/staging/rdma/hfi1/user_exp_rcv.h   |    5 
 drivers/staging/rdma/hfi1/user_pages.c     |    5 
 drivers/staging/rdma/hfi1/user_sdma.c      |   61 +
 drivers/staging/rdma/hfi1/user_sdma.h      |    5 
 drivers/staging/rdma/hfi1/verbs.c          |   27 -
 drivers/staging/rdma/hfi1/verbs.h          |    9 
 55 files changed, 2131 insertions(+), 2332 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
