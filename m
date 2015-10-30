From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v4 0/9] staging/rdma/hfi1: Fix bugs and performance issues
Date: Fri, 30 Oct 2015 18:58:39 -0400
Message-ID: <1446245928-12675-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following are fixes to the hfi1 driver for stability, security, and
performance.

New series based off of the latest staging-next.  Large patches were split up
and a new patch was added to remove offending macros.

NOTE: My apologies for not putting v4 in all the patches.  I was not sure how
to handle the fact that some of these had been previously submitted.

Ira Weiny (1):
  staging/rdma/hfi1: Remove file pointer macros

Mike Marciniszyn (3):
  staging/rdma/hfi1: move hfi1_migrate_qp
  staging/rdma/hfi1: Use parallel workqueue for SDMA engines
  staging/rdma/hfi: pre-compute sc and sde for RC/UC QPs

Mitko Haralanov (5):
  staging/rdma/hfi1: Clean up macro indentation
  staging/rdma/hfi1: Remove unnecessary include files
  staging/rdma/hfi1: Move macros to a common header
  staging/rdma/hfi1: Add function stubs for TID caching
  staging/rdma/hfi1: Implement Expected Receive TID caching

 drivers/staging/rdma/hfi1/Kconfig        |    1 +
 drivers/staging/rdma/hfi1/Makefile       |    2 +-
 drivers/staging/rdma/hfi1/chip.c         |    1 +
 drivers/staging/rdma/hfi1/common.h       |   15 +-
 drivers/staging/rdma/hfi1/file_ops.c     |  598 +++------------
 drivers/staging/rdma/hfi1/hfi.h          |   55 +-
 drivers/staging/rdma/hfi1/init.c         |   18 +-
 drivers/staging/rdma/hfi1/iowait.h       |    6 +-
 drivers/staging/rdma/hfi1/qp.c           |   47 +-
 drivers/staging/rdma/hfi1/qp.h           |   38 +-
 drivers/staging/rdma/hfi1/ruc.c          |   30 +-
 drivers/staging/rdma/hfi1/sdma.c         |    8 +-
 drivers/staging/rdma/hfi1/sdma.h         |    8 +-
 drivers/staging/rdma/hfi1/trace.h        |  132 ++--
 drivers/staging/rdma/hfi1/ud.c           |    1 +
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 1174 ++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/user_exp_rcv.h |   82 +++
 drivers/staging/rdma/hfi1/user_pages.c   |  110 +--
 drivers/staging/rdma/hfi1/user_sdma.c    |   47 +-
 drivers/staging/rdma/hfi1/user_sdma.h    |   10 +-
 drivers/staging/rdma/hfi1/verbs.c        |   34 +-
 drivers/staging/rdma/hfi1/verbs.h        |    6 +-
 include/uapi/rdma/hfi/hfi1_user.h        |   42 +-
 23 files changed, 1670 insertions(+), 795 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.c
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.h

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
