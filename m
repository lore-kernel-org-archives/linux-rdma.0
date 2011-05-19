From: Roland Dreier <roland@kernel.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 19 May 2011 11:17:43 -0700
Message-ID: <1305829063-12945-1-git-send-email-roland@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the first batch of 2.6.40 changes: mostly fixes to the
cxgb4 and qib low-level drivers, plus a couple of RDMA CM fixes.

Hefty, Sean (2):
      RDMA/cma: Fix handling of IPv6 addressing in cma_use_port
      RDMA/cma: Add an ID_REUSEADDR option

Mitko Haralanov (1):
      IB/qib: Prevent driver hang with unprogrammed boards

Roel Kluin (1):
      RDMA/cxgb4: Fix missing parentheses

Roland Dreier (2):
      RDMA/iwcm: Get rid of enum iw_cm_event_status
      Merge branches 'cma', 'cxgb4' and 'qib' into for-next

Sergei Shtylyov (2):
      IB/ipath: Use pci_dev->revision, again
      IB/qib: Use pci_dev->revision

Steve Wise (4):
      RDMA/cxgb4: Don't change QP state outside EP lock
      RDMA/cxgb4: Initialization errors can cause crash
      RDMA/cxgb4: Reset wait condition atomically
      RDMA/cxgb4: EEH errors can hang the driver

 drivers/infiniband/core/cma.c              |  207 +++++++++++++++++++---------
 drivers/infiniband/core/iwcm.c             |    2 +-
 drivers/infiniband/core/ucma.c             |    7 +
 drivers/infiniband/hw/cxgb4/cm.c           |   46 ++-----
 drivers/infiniband/hw/cxgb4/device.c       |  115 +++++++++-------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h     |   36 ++++--
 drivers/infiniband/hw/cxgb4/provider.c     |    2 -
 drivers/infiniband/hw/cxgb4/qp.c           |    3 +-
 drivers/infiniband/hw/ipath/ipath_driver.c |    9 +-
 drivers/infiniband/hw/nes/nes_cm.c         |   16 +-
 drivers/infiniband/hw/nes/nes_verbs.c      |    2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c    |    3 +-
 drivers/infiniband/hw/qib/qib_pcie.c       |    5 +-
 include/rdma/iw_cm.h                       |   11 +--
 include/rdma/rdma_cm.h                     |   10 ++
 include/rdma/rdma_user_cm.h                |    5 +-
 16 files changed, 278 insertions(+), 201 deletions(-)
