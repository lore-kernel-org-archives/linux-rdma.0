From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 22 Sep 2017 17:12:49 -0400
Message-ID: <1506114769.120853.7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

I'm back from PTO (if you can call it that, moves are more stress than
relaxation).  As I mentioned in my pull request prior to leaving there
was an outstanding 8 patch series and a couple misc items that I knew I
needed to look at when I got back.  In the intervening time, a few more
things also cropped up.  All in all, the 8 patch bnxt_re series looked
-rc appropriate to me.  The 5 patch i40iw series looked mostly
appropriate.  One of it's patches is larger than I would like to see,
but it solves a scale up issue in a reasonable way despite its size, to
I took it too.  Then there were a smattering of random patches, all
appropriate for an early -rc cycle.  For three weeks of buildup while I
was out, it's really not bad.  Here's the boilerplate:

 The following changes since commit 8eb19e8e7c8658226d8b7e75728e6dfa2ef32717:

  IB/core: Expose ioctl interface through experimental Kconfig (2017-08-31 08:35:14 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus

for you to fetch changes up to 89aaca54ba60e91f02c1c168fbef5d71f71a6d43:

  bnxt_re: Don't issue cmd to delete GID for QP1 GID entry before the QP is destroyed (2017-09-22 13:57:33 -0400)

----------------------------------------------------------------
First -rc update for 4.14 kernel

- Smattering of miscellanous fixes
- A five patch series for i40iw that had a patch (5/5) that was larger
  than I would like, but I took it because it's needed for large scale
  users
- An 8 patch series for bnxt_re that landed right as I was leaving on
  PTO and so had to wait until now...they are all appropriate fixes for
  -rc IMO

----------------------------------------------------------------
Adit Ranadive (1):
      RDMA/vmw_pvrdma: Fix reporting correct opcodes for completion

Alex Estrin (1):
      IB/core: Fix for core panic

Colin Ian King (1):
      IB/ocrdma: fix incorrect fall-through on switch statement

Devesh Sharma (2):
      bnxt_re: Fix update of qplib_qp.mtu when modified
      bnxt_re: Fix compare and swap atomic operands

Leon Romanovsky (1):
      IB/bnxt_re: Fix frame stack compilation warning

Mustafa Ismail (1):
      i40iw: Add missing VLAN priority

Santosh Shilimkar (1):
      IB/ipoib: Suppress the retry related completion errors

Selvin Xavier (1):
      bnxt_re: Fix memory leak in FRMR path

Shiraz Saleem (4):
      i40iw: Fail open if there are no available MSI-X vectors
      i40iw: Prevent multiple netdev event notifier registrations
      i40iw: Call i40iw_cm_disconn on modify QP to disconnect
      i40iw: Add support for port reuse on active side connections

Somnath Kotur (5):
      bnxt_re: Stop issuing further cmds to FW once a cmd times out
      bnxt_re: Free up devices in module_exit path
      bnxt_re: Fix race between the netdev register and unregister events
      bnxt_re: Remove RTNL lock dependency in bnxt_re_query_port
      bnxt_re: Don't issue cmd to delete GID for QP1 GID entry before the QP is destroyed

Steve Wise (3):
      iw_cxgb4: put ep reference in pass_accept_req()
      iw_cxgb4: drop listen destroy replies if no ep found
      iw_cxgb4: remove the stid on listen create failure

Sudip Mukherjee (1):
      IB/mlx5: fix debugfs cleanup

 drivers/infiniband/core/verbs.c            |   4 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h    |  14 ++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c   | 107 ++++++++++++--------
 drivers/infiniband/hw/bnxt_re/main.c       |  28 ++++++
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |   3 +-
 drivers/infiniband/hw/cxgb4/cm.c           |   9 +-
 drivers/infiniband/hw/i40iw/i40iw.h        |   1 -
 drivers/infiniband/hw/i40iw/i40iw_cm.c     | 154 ++++++++++++++---------------
 drivers/infiniband/hw/i40iw/i40iw_cm.h     |   5 +
 drivers/infiniband/hw/i40iw/i40iw_main.c   |  39 +++++---
 drivers/infiniband/hw/i40iw/i40iw_utils.c  |   6 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c  |  12 +++
 drivers/infiniband/hw/mlx5/main.c          |   6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c   |   3 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h  |  31 +++++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    |  16 ++-
 17 files changed, 281 insertions(+), 161 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
