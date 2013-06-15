From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] qib debugfs supportablity enhancements
Date: Sat, 15 Jun 2013 17:06:53 -0400
Message-ID: <20130615210633.6069.14865.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The original qib submission contained a sysfs "stats"
file the reported multiple values with multiple lines.

This set of patches adds a debugfs to replace that
functionality for supportablity reasons.

The first patch adjusts QP reference counting as a prerequisite.

The final patches are all based on the seq_file api to allow
access information from internal qib data structures.

The next patches add:
- IBTA opcode counters
- per receive context countes
- per QP attributes 


---

Mike Marciniszyn (4):
      IB/qib: remove atomic_inc_not_zero from QP RCU
      IB/qib: Convert opcode counters to per context
      IB/qib: add per context stats interface
      IB/qib: add qp_stats debug file


 drivers/infiniband/hw/qib/Makefile      |    1 
 drivers/infiniband/hw/qib/qib.h         |   36 ++--
 drivers/infiniband/hw/qib/qib_debugfs.c |  283 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_debugfs.h |   45 +++++
 drivers/infiniband/hw/qib/qib_driver.c  |    1 
 drivers/infiniband/hw/qib/qib_init.c    |   41 ++++
 drivers/infiniband/hw/qib/qib_qp.c      |  123 ++++++++++++-
 drivers/infiniband/hw/qib/qib_verbs.c   |    8 +
 drivers/infiniband/hw/qib/qib_verbs.h   |   23 ++-
 9 files changed, 523 insertions(+), 38 deletions(-)
 create mode 100644 drivers/infiniband/hw/qib/qib_debugfs.c
 create mode 100644 drivers/infiniband/hw/qib/qib_debugfs.h

-- 
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
