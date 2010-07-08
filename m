From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 08 Jul 2010 09:12:18 -0700
Message-ID: <adapqyyymu5.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get one security fix for IPoIB, and a bunch of relatively
small fixes to drivers new in 2.6.35 (so perhaps not regression fixes,
but not able to regress anything either ... and you don't care about
RDMA anyway ;)

Dave Olson (1):
      IB/qib: Don't mark VL15 bufs as WC to avoid a rare 7322 chip problem

FUJITA Tomonori (1):
      RDMA/cxgb4: Use the DMA state API instead of the pci equivalents

Or Gerlitz (1):
      IPoIB: Fix world-writable child interface control sysfs attributes

Ralph Campbell (6):
      IB/qib: Mask hardware error during link reset
      IB/qib: Clear eager buffer memory for each new process
      IB/qib: Clear 6120 hardware error register
      IB/qib: Update 7322 serdes tables
      IB/qib: Completion queue callback needs to be single threaded
      IB/qib: Clean up properly if qib_init() fails

Roland Dreier (1):
      Merge branches 'cxgb4', 'ipoib' and 'qib' into for-next

Steve Wise (3):
      RDMA/cxgb4: Don't call abort_connection() for active connect failures
      RDMA/cxgb4: Avoid false GTS CIDX_INC overflows
      RDMA/cxgb4: Derive smac_idx from port viid

 drivers/infiniband/hw/cxgb4/cm.c          |   12 ++++---
 drivers/infiniband/hw/cxgb4/cq.c          |   31 ++++++++++++++-----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h    |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c         |    4 +-
 drivers/infiniband/hw/cxgb4/qp.c          |   12 +++---
 drivers/infiniband/hw/cxgb4/t4.h          |    6 ++--
 drivers/infiniband/hw/qib/qib.h           |    1 +
 drivers/infiniband/hw/qib/qib_7322_regs.h |   48 ++++++++++++++--------------
 drivers/infiniband/hw/qib/qib_diag.c      |   19 +++++++++--
 drivers/infiniband/hw/qib/qib_iba6120.c   |    3 +-
 drivers/infiniband/hw/qib/qib_iba7322.c   |   43 +++++++++++++++++++++----
 drivers/infiniband/hw/qib/qib_init.c      |   21 ++++++++++++-
 drivers/infiniband/hw/qib/qib_pcie.c      |    2 +
 drivers/infiniband/hw/qib/qib_tx.c        |    6 +++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    4 +-
 15 files changed, 148 insertions(+), 66 deletions(-)

-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
