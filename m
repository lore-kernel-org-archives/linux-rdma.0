From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 00/15] IB/usnic: Bug fixes
Date: Thu,  9 Jan 2014 14:47:28 -0800
Message-ID: <1389307663-11296-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch fixes the below bugs reported by kbuild robot, sparse and smatch.
https://lists.01.org/pipermail/kbuild/2013-December/000877.html
https://lists.01.org/pipermail/kbuild-all/2013-December/002354.html
https://lists.01.org/pipermail/kbuild-all/2013-December/002335.html
https://lists.01.org/pipermail/kbuild-all/2013-December/002337.html
http://www.spinics.net/lists/linux-rdma/msg18047.html
http://www.spinics.net/lists/linux-rdma/msg18048.html
http://www.spinics.net/lists/linux-rdma/msg18049.html
http://www.spinics.net/lists/linux-rdma/msg18050.html

As well as bugs found at Cisco.

V1 Changes:
Use lockdep_assert instead of spin_is_locked(...

Upinder Malhi (15):
  IB/usnic: Fix stack frame size exceed warnings
  IB/usnic: Fix format not a string literal warning
  IB/usnic: Make usNIC built depend on Intel IOMMU
  IB/usnic: Fix error handling with IS_ERR_OR_NULL
  IB/usnic: Change BUG_ON to lockdep_assert_held
  IB/usnic: Initialize all of the data returned to userspace
  IB/usnic: Fix printk format warnings
  IB/usnic: Remove duplicate and unnecessary consts
  IB/usnic: Fix sparse should be static warnings
  IB/usnic: Fix accounting of qp_grp_ref_cnt
  IB/usnic: Remove extraneous if check
  IB/usnic: Change GFP_KERNEL TO GFP_ATOMIC if spinlock is held
  IB/usnic: Handle NETDEV_CHANGE
  IB/usnic: Use netdev_notifier_info_to_dev to get netdev
  IB/usnic: Fix false log

 drivers/infiniband/hw/usnic/Kconfig                |  3 +-
 drivers/infiniband/hw/usnic/usnic_fwd.c            |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        | 40 ++++++++---------
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      | 52 +++++++++++-----------
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h      | 12 +++--
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       | 10 +++--
 drivers/infiniband/hw/usnic/usnic_transport.c      |  4 +-
 drivers/infiniband/hw/usnic/usnic_transport.h      |  1 +
 drivers/infiniband/hw/usnic/usnic_uiom.c           | 36 ++++++++-------
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.c |  2 +-
 drivers/infiniband/hw/usnic/usnic_vnic.c           | 24 ++++------
 drivers/infiniband/hw/usnic/usnic_vnic.h           | 12 +++--
 13 files changed, 98 insertions(+), 102 deletions(-)

--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
