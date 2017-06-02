From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 02 Jun 2017 16:09:47 -0400
Message-ID: <1496434187.7171.106.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This is the majority of the -rc fixes for the rdma subsystem for this
cycle.  I will have one more pull request that I know of with 6
additional patches, all against bnxt_re.  They were mixed among a 14
patch series labeled as being for-next material, but on closer
inspection, some of them should be -rc, but I didn't have them in my
tree that I froze yesterday.

For the most part this is just a minor -rc cycle for the rdma
subsystem.  Even given that this is all of the -rc patches since the
merge window closed, it's still only about 25 patches.

Here's the git boilerplate:

The following changes since commit
5ed02dbb497422bf225783f46e6eadd237d23d6b:

  Linux 4.12-rc3 (2017-05-28 17:20:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
d3957b86a40612826ef935f474b31359d66cbdca:

  RDMA/SA: Fix kernel panic in CMA request handler flow (2017-06-01
17:20:14 -0400)

----------------------------------------------------------------
Fixes for 4.12-rc

- Multiple i40iw, nes, iw_cxgb4, hfi1, qib, mlx4, mlx5 fixes
- A few upper layer protocol fixes (IPoIB, iSER, SRP)
- A modest number of core fixes

----------------------------------------------------------------
Byczkowski, Jakub (1):
      RDMA/hfi1: Defer setting VL15 credits to link-up interrupt

Ganesh Goudar (1):
      RDMA/iw_cxgb4: calculate t4_eq_status_entries properly

Gustavo A. R. Silva (2):
      RDMA/i40iw: fix duplicated code for different branches
      RDMA/qedr: add null check before pointer dereference

Honggang Li (1):
      RDMA/IPoIB: Replace netdev_priv with ipoib_priv for
ipoib_get_link_ksettings

Israel Rukshin (1):
      RDMA/srp: Fix NULL deref at srp_destroy_qp()

Jack Morgenstein (1):
      RDMA/mlx4: Fix MAD tunneling when SRIOV is enabled

Leon Romanovsky (4):
      RDMA/IPoIB: Limit the ipoib_dev_uninit_default scope
      RDMA/netlink: Reduce exposure of RDMA netlink functions
      RDMA/uverbs: Declare local function static and add brackets to
sizeof
      RDMA/umem: Fix missing mmap_sem in get umem ODP call

Majd Dibbiny (1):
      RDMA/SA: Fix kernel panic in CMA request handler flow

Max Gurtovoy (2):
      net/mlx5: Define interface bits for fencing UMR wqe
      RDMA/mlx5: set UMR wqe fence according to HCA cap

Mike Marciniszyn (1):
      RDMA/qib,hfi1: Fix MR reference count leak on write with
immediate

Mustafa Ismail (1):
      RDMA/i40iw: Fix device initialization error path

Qing Huang (1):
      RDMA/core: not to set page dirty bit if it's already set.

Raju Rangoju (2):
      RDMA/iw_cxgb4: Avoid touch after free error in ARP failure
handlers
      RDMA/iw_cxgb4: fix the calculation of ipv6 header size

Shiraz Saleem (1):
      RDMA/i40iw: Remove MSS change support

Steven L. Roberts (2):
      RDMA/hfi1: fix array termination by appending NULL to attr array
      RDMA/hfi1: change PCI bar addr assignments to Linux API functions

Tatyana Nikolova (4):
      RDMA/i40iw: Don't set 0-length FULPDU RTR indication control flag
      RDMA/i40iw: ACK MPA Reject frame
      RDMA/nes: Don't set 0-length FULPDU RTR indication control flag
      RDMA/nes: ACK MPA Reply frame

 drivers/infiniband/core/cm.c                 |  4 +-
 drivers/infiniband/core/cma.c                | 13 +++---
 drivers/infiniband/core/core_priv.h          | 10 +++++
 drivers/infiniband/core/netlink.c            |  2 +-
 drivers/infiniband/core/sa_query.c           |  6 +--
 drivers/infiniband/core/umem.c               |  2 +-
 drivers/infiniband/core/umem_odp.c           |  6 ++-
 drivers/infiniband/core/uverbs_marshall.c    |  8 ++--
 drivers/infiniband/hw/cxgb4/cm.c             |  9 +++-
 drivers/infiniband/hw/cxgb4/device.c         |  2 +-
 drivers/infiniband/hw/hfi1/chip.c            | 67
+++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/chip_registers.h  |  2 +
 drivers/infiniband/hw/hfi1/hfi.h             | 11 ++++-
 drivers/infiniband/hw/hfi1/intr.c            |  3 +-
 drivers/infiniband/hw/hfi1/pcie.c            |  4 +-
 drivers/infiniband/hw/hfi1/rc.c              |  5 ++-
 drivers/infiniband/hw/hfi1/sysfs.c           |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c       |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c     | 12 +----
 drivers/infiniband/hw/i40iw/i40iw_main.c     | 20 ++++++---
 drivers/infiniband/hw/i40iw/i40iw_osdep.h    |  1 -
 drivers/infiniband/hw/i40iw/i40iw_type.h     |  2 -
 drivers/infiniband/hw/i40iw/i40iw_utils.c    | 17 -------
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c |  5 +--
 drivers/infiniband/hw/mlx4/mad.c             |  1 +
 drivers/infiniband/hw/mlx5/main.c            | 14 ++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  3 +-
 drivers/infiniband/hw/mlx5/qp.c              | 59 ++++++++++--------
------
 drivers/infiniband/hw/nes/nes_cm.c           |  3 +-
 drivers/infiniband/hw/qedr/qedr_cm.c         | 10 +++--
 drivers/infiniband/hw/qib/qib_rc.c           |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |  4 +-
 include/linux/mlx5/mlx5_ifc.h                | 10 ++++-
 include/rdma/ib_sa.h                         | 25 ++---------
 include/rdma/rdma_netlink.h                  | 10 -----
 37 files changed, 194 insertions(+), 170 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
