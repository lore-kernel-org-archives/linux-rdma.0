From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 15 Jun 2017 22:09:53 -0400
Message-ID: <1497578993.35484.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

I had thought at the time of the last pull request that there wouldn't
be much more to go, but several things just kept trickling in over the
last week.  Instead of just the 6 patches to bnxt_re that I had
anticipated, there are another 5 IPoIB patches, 2 qedr patches, and a
few other miscellaneous patches.  The bnxt_re patches are more lines of
diff than I like to submit this late in the game.  That's mostly
because of the first two patches in the series of 6.  I almost dropped
them just because of the lines of churn, but on a close review, a lot
of the churn came from removing duplicated code sections and
consolidating them into callable routines.  I felt like this made the
number of lines of change more acceptable, and they address problems,
so I left them.  The remainder of the patches are all small, well
contained, and well understood.  These have passed 0day testing, but
have not been submitted to linux-next (but a local merge test with your
current master was without any conflicts).

There are two patches I have not yet taken.  I won't have time to
process those until Tuesday due to PTO.  So there might be one more
pull request before the -rc cycle is over.

Here's the boilerplate:

The following changes since commit
d3957b86a40612826ef935f474b31359d66cbdca:

  RDMA/SA: Fix kernel panic in CMA request handler flow (2017-06-01
17:20:14 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
d4702645838c8e04893383b50406249382b4e6bf:

  rdma/cxgb4: Fix memory leaks during module exit (2017-06-14 15:24:50
-0400)

----------------------------------------------------------------
Fixes #2 for 4.12-rc

- A fix for fix eea40b8f624 ("infiniband: call ipv6 route lookup via
the
  stub interface")
- 6 patches against bnxt_re...the first two are considerably larger
than
  I would like, but as they address real issues I went ahead and
  submitted them (it also helped that a good deal of the churn was
  removing code repeated in multiple places and consolidating it to one
  common function)
- 2 fixes against qedr that just came in
- 1 fix against rxe that took a few revisions to get right plus time to
  get the proper reviews
- 5 late breaking IPoIB fixes
- 1 late cxgb4 fix

----------------------------------------------------------------
Alex Vesker (4):
      IB/ipoib: Fix memory leaks for child interfaces priv
      IB/ipoib: Limit call to free rdma_netdev for capable devices
      IB/ipoib: Delete napi in device uninit default
      IB/ipoib: Fix access to un-initialized napi struct

Devesh Sharma (2):
      RDMA/bnxt_re: Fixing the Control path command and response
handling
      RDMA/bnxt_re: Fix RQE posting logic

Eddie Wai (1):
      RDMA/bnxt_re: HW workarounds for handling specific conditions

Feras Daoud (1):
      IB/ipoib: Fix memory leak in create child syscall

Jia-Ju Bai (1):
      rxe: Fix a sleep-in-atomic bug in post_one_send

Michal Kalderon (1):
      RDMA/qedr: Initialize byte_len in WC of READ and SEND commands

Raju Rangoju (1):
      rdma/cxgb4: Fix memory leaks during module exit

Ram Amrani (1):
      RDMA/qedr: Add 64KB PAGE_SIZE support to user-space queues

Roland Dreier (1):
      IB/addr: Fix setting source address in addr6_resolve()

Selvin Xavier (2):
      RDMA/bnxt_re: Dereg MR in FW before freeing the
fast_reg_page_list
      RDMA/bnxt_re: Remove FMR support

Somnath Kotur (1):
      RDMA/bnxt_re: Add HW workaround for avoiding stall for UD QPs

 drivers/infiniband/core/addr.c             |  10 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h    |   4 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c   | 471
+++++++++++++++++++++--------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h   |  22 +-
 drivers/infiniband/hw/bnxt_re/main.c       |   4 -
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 384 ++++++++++++---------
--
 drivers/infiniband/hw/bnxt_re/qplib_fp.h   |  18 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 314 ++++++++++---------
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  61 ++--
 drivers/infiniband/hw/bnxt_re/qplib_res.h  |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c   | 333 +++++---------------
 drivers/infiniband/hw/bnxt_re/qplib_sp.h   |   2 +
 drivers/infiniband/hw/cxgb4/device.c       |  10 +-
 drivers/infiniband/hw/mlx5/main.c          |   6 +-
 drivers/infiniband/hw/qedr/qedr.h          |   5 +-
 drivers/infiniband/hw/qedr/verbs.c         |  68 +++--
 drivers/infiniband/sw/rxe/rxe_verbs.c      |   9 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    |   1 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c  |  15 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c  |  11 +-
 20 files changed, 935 insertions(+), 817 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
