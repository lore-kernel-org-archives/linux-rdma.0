From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 00/13] staging/rdma/hfi1: Driver cleanup and misc fixes
Date: Mon, 16 Nov 2015 21:59:22 -0500
Message-ID: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Rebased this series on top of latest staging-next branch

Changes in v2:
01/13: Updated commit message with more information about changes in patch
04/13: Updated patch subject with "hfi1" instead of "hfi"
07/13: Refreshed patch based on new hfi patches in staging-next
12/13: Changed logic based on Dan's suggestions in
       http://marc.info/?l=linux-driver-devel&m=144723149431368&w=2 

Dean Luick (4):
  staging/rdma/hfi1: Fix downgrade race
  staging/rdma/hfi1: Remove unneeded variable index
  staging/rdma/hfi1: Read EFI variable for device description
  staging/rdma/hfi1: Adjust EPROM partitions, add EPROM commands

Harish Chegondi (1):
  staging/rdma/hfi1: Move s_sde to the read mostly portion of the
    hfi1_qp structure

Ira Weiny (1):
  staging/rdma/hfi1: Remove rcv bubbles code

Jubin John (3):
  staging/rdma/hfi1: Use BIT macro
  staging/rdma/hfi1: Add space between concatenated string elements
  staging/rdma/hfi1: Change default krcvqs

Mark F. Brown (1):
  staging/rdma/hfi1: change krcvqs module parameter type from byte to
    uint

Mike Marciniszyn (1):
  staging/rdma/hfi1: rework is_a0() and is_bx()

Vennila Megavannan (2):
  staging/rdma/hfi1: remove RxCtxRHQS from hfi1stats
  staging/rdma/hfi1: adding per SDMA engine stats to hfistats

 drivers/staging/rdma/hfi1/Makefile         |    2 +-
 drivers/staging/rdma/hfi1/chip.c           |  252 +++++++++++++++++++++-------
 drivers/staging/rdma/hfi1/chip.h           |   55 ++++---
 drivers/staging/rdma/hfi1/chip_registers.h |    2 +-
 drivers/staging/rdma/hfi1/common.h         |    4 +-
 drivers/staging/rdma/hfi1/diag.c           |    4 +-
 drivers/staging/rdma/hfi1/driver.c         |    2 +-
 drivers/staging/rdma/hfi1/efivar.c         |  169 +++++++++++++++++++
 drivers/staging/rdma/hfi1/efivar.h         |   60 +++++++
 drivers/staging/rdma/hfi1/eprom.c          |  119 ++++++++------
 drivers/staging/rdma/hfi1/file_ops.c       |   18 +--
 drivers/staging/rdma/hfi1/firmware.c       |    2 +-
 drivers/staging/rdma/hfi1/hfi.h            |   29 ++--
 drivers/staging/rdma/hfi1/init.c           |    8 +-
 drivers/staging/rdma/hfi1/mad.c            |   68 +-------
 drivers/staging/rdma/hfi1/pcie.c           |    4 +-
 drivers/staging/rdma/hfi1/qp.h             |    2 +-
 drivers/staging/rdma/hfi1/qsfp.h           |   10 +-
 drivers/staging/rdma/hfi1/sdma.c           |   17 ++-
 drivers/staging/rdma/hfi1/sdma.h           |    7 +
 drivers/staging/rdma/hfi1/verbs.h          |    8 +-
 include/uapi/rdma/hfi/hfi1_user.h          |   10 +-
 22 files changed, 587 insertions(+), 265 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/efivar.c
 create mode 100644 drivers/staging/rdma/hfi1/efivar.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
