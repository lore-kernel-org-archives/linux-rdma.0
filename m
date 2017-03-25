From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Sat, 25 Mar 2017 14:29:38 -0400
Message-ID: <1490466578.2404.55.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This has been a slow -rc cycle for the RDMA subsystem.  We really
haven't had a lot of rc fixes come in.  This pull request is the first
of this entire rc cycle and it has all of the suitable fixes so far and
it's still only about 20 patches.  The fix for the minor breakage cause
by the dma mapping patchset is in here, as well as a couple other
potential oops fixes, but the rest is more minor.

Here's the boilerplate:

The following changes since commit
97da3854c526d3a6ee05c849c96e48d21527606c:

  Linux 4.11-rc3 (2017-03-19 19:09:39 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
f6aafac184a3e46e919769dd4faa8bf0dc436534:

  IB/qib: fix false-postive maybe-uninitialized warning (2017-03-24
22:44:29 -0400)

----------------------------------------------------------------
Fixups for -rc4 kernel

- Fix for dma_ops change in this kernel, resolving the s390, powerpc,
  and IOMMU operation
- A few other oops fixes
- The rest are all minor fixes

----------------------------------------------------------------
Adit Ranadive (2):
      RDMA/vmw_pvrdma: Cleanup unused variables
      RDMA/vmw_pvrdma: Dont hardcode QP header page

Aditya Sarwade (1):
      RDMA/vmw_pvrdma: Activate device on ethernet link up

Arnd Bergmann (1):
      IB/qib: fix false-postive maybe-uninitialized warning

Bart Van Assche (1):
      IB/core: Restore I/O MMU, s390 and powerpc support

Dan Carpenter (2):
      IB/rxe: double free on error
      RDMA/ocrdma: fix a type issue in ocrdma_put_pd_num()

David Marchand (1):
      IB/rxe: increment msn only when completing a request

Dmitry V. Levin (1):
      uapi: fix rdma/mlx5-abi.h userspace compilation errors

Jason Gunthorpe (1):
      infiniband: Fix alignment of mmap cookies to support VIPT caching

Leon Romanovsky (1):
      IB/rxe: Update documentation link

Sagi Grimberg (4):
      IB/core: Protect against self-requeue of a cq work item
      IB/cq: Don't process more than the given budget
      IB/device: Convert ib-comp-wq to be CPU-bound
      RDMA/iser: Fix possible mr leak on device removal event

Shiraz Saleem (1):
      i40iw: Receive netdev events post INET_NOTIFIER state

 drivers/infiniband/core/cq.c                      | 10 ++++--
 drivers/infiniband/core/device.c                  | 29 +++++++++++--
---
 drivers/infiniband/hw/i40iw/i40iw_utils.c         |  8 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c       |  2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c           |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |  3 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    | 17 ++++++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c      | 42 ++++++++++-----
--------
 drivers/infiniband/sw/rdmavt/mmap.c               |  4 +--
 drivers/infiniband/sw/rxe/Kconfig                 |  2 +-
 drivers/infiniband/sw/rxe/rxe_mmap.c              |  4 +--
 drivers/infiniband/sw/rxe/rxe_req.c               |  2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c              |  9 +++--
 drivers/infiniband/ulp/iser/iscsi_iser.h          |  2 ++
 drivers/infiniband/ulp/iser/iser_verbs.c          |  8 +++--
 include/rdma/ib_verbs.h                           | 30 +++++++++----
---
 include/uapi/rdma/mlx5-abi.h                      |  3 +-
 18 files changed, 110 insertions(+), 69 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
