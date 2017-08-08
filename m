From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue, 08 Aug 2017 13:27:07 -0400
Message-ID: <1502213227.3002.8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

We had a small set of misc. fixes trickle in, and then we had a larger
set of IPoIB specific fixes that, I believe, were due to an audit come
through.  All totalled, it's not really a large pull request, just the
fixes we have so far.  However, there is an i40iw pull request in the
offing, but it isn't ready yet.  That's another 6 patches when it has
passed muster.

Here's the boilerplate:

The following changes since commit a62ab66b13a0f9bcb17b7b761f6670941ed5cd62:

  RDMA/core: Initialize port_num in qp_attr (2017-07-20 11:24:13 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus

for you to fetch changes up to 48107c4e596c8523d46c7b04f92cf29e7569a01e:

  Merge tag 'rdma-rc-2017-07-26' of git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma into leon-ipoib (2017-08-07 13:30:40 -0400)

----------------------------------------------------------------
Third set of -rc fixes for 4.13 cycle

- small set of miscellanous fixes
- a reasonably sizable set of IPoIB fixes that deal with multiple long
  standing issues

----------------------------------------------------------------
Alex Vesker (2):
      IB/ipoib: Prevent setting negative values to max_nonsrq_conn_qp
      IB/ipoib: Add multicast packets statistics

Dan Carpenter (1):
      IB/hns: checking for IS_ERR() instead of NULL

Doug Ledford (1):
      Merge tag 'rdma-rc-2017-07-26' of git://git.kernel.org/.../leon/linux-rdma into leon-ipoib

Erez Shitrit (3):
      IB/ipoib: Use cancel_delayed_work_sync when needed
      IB/ipoib: Make sure no in-flight joins while leaving that mcast
      IB/ipoib: Notify on modify QP failure only when relevant

Feras Daoud (3):
      IB/ipoib: Fix race between light events and interface restart
      IB/ipoib: Set IPOIB_NEIGH_TBL_FLUSH after flushed completion initialization
      IB/ipoib: Add get statistics support to SRIOV VF

Leon Romanovsky (5):
      IB/ipoib: Clean error paths in add port
      IB/ipoib: Remove double pointer assigning
      Revert "IB/core: Allow QP state transition from reset to error"
      RDMA/uverbs: Prevent leak of reserved field
      RDMA/mlx5: Fix existence check for extended address vector

Parav Pandit (1):
      IB/core: Fix race condition in resolving IP to MAC

Yishai Hadas (1):
      IB/uverbs: Fix device cleanup

 drivers/infiniband/core/addr.c                 | 62 ++++++++++++++++++++------
 drivers/infiniband/core/uverbs_cmd.c           |  2 +-
 drivers/infiniband/core/uverbs_main.c          |  3 +-
 drivers/infiniband/core/verbs.c                |  1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c     |  2 +-
 drivers/infiniband/hw/mlx5/odp.c               |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |  3 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 25 ++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 19 +++++---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 33 +++++---------
 include/linux/mlx5/qp.h                        |  1 -
 13 files changed, 102 insertions(+), 53 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
