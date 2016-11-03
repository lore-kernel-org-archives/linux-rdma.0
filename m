From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 00/17] Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 07:02:16 +0200
Message-ID: <1478149353-12125-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro a <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug and all,

This is semantic cleanup of infiniband stack from printks immediately
after allocation failure. It doesn't get rid from all printks, but only from
the ones which were found by the following grep construction.

➜  linux-rdma git:(topic/clean-alloc-prints) grep -rI "[k|v][m|z|c]alloc(" drivers/infiniband/* -A5 | grep "n\""

The patchset consists from the 16 almost identical patches and from one fix
which was discovered during the cleanup work.

The fix is presented in the patch "IB/core: Release allocated memory in cache setup failure"

Available in the "topic/clean-alloc-prints" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/clean-alloc-prints

CC: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
CC: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
CC: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
CC: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
CC: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
CC: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>a
CC: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

Leon Romanovsky (17):
  IB/mad: Remove debug prints after allocation failure
  IB/core: Remove debug prints after allocation failure
  IB/core: Release allocated memory in cache setup failure
  IB/mlx4: Remove debug prints after allocation failure
  IB/mlx5: Remove debug prints after allocation failure
  IB/hfi1: Remove debug prints after allocation failure
  IB/cxgb3: Remove debug prints after allocation failure
  IB/cxgb4: Remove debug prints after allocation failure
  IB/i40iw: Remove debug prints after allocation failure
  IB/qib: Remove debug prints after allocation failure
  IB/nes: Remove debug prints after allocation failure
  IB/mthca: Remove debug prints after allocation failure
  IB/usninc: Remove and fix debug prints after allocation failure
  IB/ocrdma: Remove and fix debug prints after allocation failure
  IB/rxe: Remove and fix debug prints after allocation failure
  IB/isert: Remove and fix debug prints after allocation failure
  IB/ipoib: Remove and fix debug prints after allocation failure

 drivers/infiniband/core/agent.c               |  1 -
 drivers/infiniband/core/cache.c               | 16 ++++-----
 drivers/infiniband/core/device.c              |  5 +--
 drivers/infiniband/core/fmr_pool.c            |  1 -
 drivers/infiniband/core/iwpm_msg.c            |  1 -
 drivers/infiniband/core/iwpm_util.c           | 12 +++----
 drivers/infiniband/core/mad.c                 | 40 ++++-------------------
 drivers/infiniband/core/roce_gid_mgmt.c       | 21 ++++--------
 drivers/infiniband/hw/cxgb3/cxio_dbg.c        | 20 +++++-------
 drivers/infiniband/hw/cxgb4/device.c          |  4 ---
 drivers/infiniband/hw/hfi1/pio.c              |  1 -
 drivers/infiniband/hw/i40iw/i40iw_cm.c        |  2 --
 drivers/infiniband/hw/i40iw/i40iw_main.c      |  5 ++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     |  1 -
 drivers/infiniband/hw/mlx4/alias_GUID.c       |  4 +--
 drivers/infiniband/hw/mlx4/cm.c               |  4 +--
 drivers/infiniband/hw/mlx4/mad.c              |  9 ++---
 drivers/infiniband/hw/mlx4/main.c             | 16 ++-------
 drivers/infiniband/hw/mlx4/mcg.c              |  5 +--
 drivers/infiniband/hw/mlx5/srq.c              |  2 --
 drivers/infiniband/hw/mthca/mthca_reset.c     |  4 ---
 drivers/infiniband/hw/nes/nes.c               |  1 -
 drivers/infiniband/hw/nes/nes_cm.c            |  4 +--
 drivers/infiniband/hw/nes/nes_hw.c            |  6 ++--
 drivers/infiniband/hw/nes/nes_mgt.c           | 10 ++----
 drivers/infiniband/hw/nes/nes_verbs.c         |  4 ---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c      |  5 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c   |  4 +--
 drivers/infiniband/hw/qib/qib_diag.c          |  6 +---
 drivers/infiniband/hw/qib/qib_eeprom.c        |  6 +---
 drivers/infiniband/hw/qib/qib_iba6120.c       |  8 +----
 drivers/infiniband/hw/qib/qib_iba7220.c       |  8 +----
 drivers/infiniband/hw/qib/qib_iba7322.c       | 22 +++----------
 drivers/infiniband/hw/qib/qib_init.c          | 47 +++++----------------------
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 10 +-----
 drivers/infiniband/hw/usnic/usnic_vnic.c      | 22 ++++---------
 drivers/infiniband/sw/rxe/rxe_pool.c          |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       | 12 ++-----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |  5 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  5 +--
 drivers/infiniband/ulp/isert/ib_isert.c       | 23 ++++---------
 41 files changed, 86 insertions(+), 297 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
