From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue, 18 Jul 2017 11:51:01 -0400
Message-ID: <1500393061.23761.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This is the first round of fixes for the -rc cycle.  It isn't all
because a few of the drivers have lots of backlogged fixes so I'll do
those separately.  I've tried to pare this down to just important
things that qualify for -rc fixes and not new development.  The one
thing sitting in a grey area is the four patch series that fixes the
bad noio memalloc usage in the IPoIB ULP (I included it because using
the proper API instead of a poor hack around solution seems like a
"fix" to me), there is a two patch series that changes how ib_modify_qp
is called and seems like lots of lines, but it clearly makes the code
better and the second patch is the problem resolution, and I kept one
patch in that was not a fix only patch because it was part of a 5 patch
series and it was the only non-fix in the bunch (checkpatch.pl warnings
patch from Lijun Ou).  This specific branch/HEAD has not been through
linux-next, although all of the patches in this branch went through
linux-next previously as part of a larger branch, just since I pared it
down to fixes only it has not.  And it went to 0day, where it timed out
all but 13 configs, but in the 13 that passed was the 7.2-rhel-x86_64
config which I know will build the majority of the RDMA subsystem.

Here's the boilerplate:

The following changes since commit
5771a8c08880cdca3bfb4a3fc6d309d6bba20877:

  Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
ebc9ca43e1d52a85c72fc2d343f353386ed6c188:

  IB/core: Allow QP state transition from reset to error (2017-07-17
21:21:30 -0400)

----------------------------------------------------------------
First set of -rc fixes for 4.13 cycle

- Misc. iSER fixes
- Namespace fixups
- Fix the fact that IPoIB didn't use the proper API for noio mem allocs
- rxe driver fixes
- hns_roce fixes
- Misc core fixes
- Misc IPoIB fixes

----------------------------------------------------------------
Amrani, Ram (1):
      RDMA/qedr: Add qedr to MAINTAINERS file

Bart Van Assche (1):
      mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array

Dennis Dalessandro (1):
      IB/hfi1: Ensure dd->gi_mask can not be overflowed

Doug Ledford (1):
      Merge tag 'v4.13-rc1' into k.o/for-4.13-rc

Erez Shitrit (2):
      IB/IPoIB: Forward MTU change to driver below
      IB/ipoib: Let lower driver handle get_stats64 call

Gustavo A. R. Silva (1):
      RDMA/core: Document confusing code

Leon Romanovsky (6):
      IB: Convert msleep below 20ms to usleep_range
      IB/IPoIB: Convert IPoIB to memalloc_noio_* calls
      IB/{rdmavt, qib, hfi1}: Remove gfp flags argument
      {net, IB}/mlx4: Remove gfp flags argument
      IB/core: Remove NOIO QP create flag
      IB/mlx5: Clean mr_cache debugfs in case of failure

Majd Dibbiny (1):
      IB/core: Add ordered workqueue for RoCE GID management

Mike Marciniszyn (1):
      IB/iser: Handle lack of memory management extentions correctly

Moni Shoua (2):
      IB/core: Namespace is mandatory input for address resolution
      IB/core: Don't resolve IP address to the loopback device

Parav Pandit (2):
      IB/core: Introduce modify QP operation with udata
      IB/uverbs: Make use of ib_modify_qp variant to avoid resolving
DMAC

Tadeusz Struk (1):
      IB/core: Allow QP state transition from reset to error

Vladimir Neyelov (1):
      IB/iser: Fix connection teardown race condition

Yonatan Cohen (1):
      IB/rxe: Fix kernel panic from skb destructor

oulijun (5):
      IB/hns: Fix the bug of polling cq failed for loopback Qps
      IB/hns: Fix the bug with wild pointer when destroy rc qp
      IB/hns: Fix the bug with rdma operation
      IB/hns: Fix the bug with modifying the MAC address without
removing the driver
      IB/hns: Fix for checkpatch.pl comment style warnings

yonatanc (1):
      IB/rxe: Set dma_mask and coherent_dma_mask

 MAINTAINERS                                        |  8 ++
 drivers/infiniband/core/addr.c                     | 46 +++++++++---
 drivers/infiniband/core/cma.c                      | 32 +-------
 drivers/infiniband/core/roce_gid_mgmt.c            | 11 ++-
 drivers/infiniband/core/uverbs_cmd.c               | 23 +-----
 drivers/infiniband/core/verbs.c                    | 51 +++++++++----
 drivers/infiniband/hw/hfi1/chip.c                  |  7 +-
 drivers/infiniband/hw/hfi1/qp.c                    |  7 +-
 drivers/infiniband/hw/hfi1/qp.h                    |  3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         | 86 +++++++++++++-
--------
 drivers/infiniband/hw/hns/hns_roce_main.c          |  3 -
 drivers/infiniband/hw/mlx4/cq.c                    |  6 +-
 drivers/infiniband/hw/mlx4/main.c                  |  2 +-
 drivers/infiniband/hw/mlx4/mcg.c                   |  2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  1 -
 drivers/infiniband/hw/mlx4/qp.c                    | 40 +++++-----
 drivers/infiniband/hw/mlx4/srq.c                   |  8 +-
 drivers/infiniband/hw/mlx5/mr.c                    | 36 +++++----
 drivers/infiniband/hw/nes/nes_hw.c                 |  4 +-
 drivers/infiniband/hw/qib/qib_qp.c                 | 15 ++--
 drivers/infiniband/hw/qib/qib_verbs.h              |  4 +-
 drivers/infiniband/sw/rdmavt/qp.c                  | 48 ++++--------
 drivers/infiniband/sw/rxe/rxe_net.c                |  3 +
 drivers/infiniband/sw/rxe/rxe_verbs.c              |  2 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            | 20 +++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          | 31 +++++++-
 drivers/infiniband/ulp/iser/iscsi_iser.c           | 11 +++
 drivers/infiniband/ulp/iser/iser_verbs.c           | 10 ++-
 drivers/net/ethernet/mellanox/mlx4/alloc.c         | 29 ++++----
 drivers/net/ethernet/mellanox/mlx4/cq.c            |  4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |  7 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |  2 +-
 drivers/net/ethernet/mellanox/mlx4/icm.c           |  7 +-
 drivers/net/ethernet/mellanox/mlx4/icm.h           |  3 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |  4 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            | 17 ++---
 drivers/net/ethernet/mellanox/mlx4/qp.c            | 20 ++---
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |  4 +-
 include/linux/mlx4/device.h                        | 10 +--
 include/rdma/ib_verbs.h                            | 18 ++++-
 include/rdma/rdma_vt.h                             |  5 +-
 43 files changed, 366 insertions(+), 290 deletions(-)


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
