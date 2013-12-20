From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/15]: IB/usnic: Bug fixes
Date: Fri, 20 Dec 2013 12:26:31 -0800
Message-ID: <1387571206-8043-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

@Roland - This patch set suceeds http://www.spinics.net/lists/linux-rdma/msg18126.html.  It is a superset of that patch set.

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

[PATCH for-next 01/15] IB/usnic: Fix stack frame size exceed warnings
[PATCH for-next 02/15] IB/usnic: Fix format not a string literal
[PATCH for-next 03/15] IB/usnic: Make usNIC built depend on Intel
[PATCH for-next 04/15] IB/usnic: Fix error handling with
[PATCH for-next 05/15] IB/usnic: Change BUG_ON to WARN_ON
[PATCH for-next 06/15] IB/usnic: Initialize all of the data returned
[PATCH for-next 07/15] IB/usnic: Fix printk format warnings
[PATCH for-next 08/15] IB/usnic: Remove duplicate and unnecessary
[PATCH for-next 09/15] IB/usnic: Fix sparse should be static warnings
[PATCH for-next 10/15] IB/usnic: Fix accounting of qp_grp_ref_cnt
[PATCH for-next 11/15] IB/usnic: Remove extraneous if check
[PATCH for-next 12/15] IB/usnic: Change GFP_KERNEL TO GFP_ATOMIC if
[PATCH for-next 13/15] IB/usnic: Handle NETDEV_CHANGE
[PATCH for-next 14/15] IB/usnic: Use netdev_notifier_info_to_dev to
[PATCH for-next 15/15] IB/usnic: Fix false log

drivers/infiniband/hw/usnic/Kconfig                    |  3 +-
drivers/infiniband/hw/usnic/usnic_fwd.c                |  2 +-
drivers/infiniband/hw/usnic/usnic_ib_main.c            | 40 ++++++++---------
drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c          | 52 +++++++++++------------
drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h          | 12 +++---
drivers/infiniband/hw/usnic/usnic_ib_sysfs.c           |  2 +-
drivers/infiniband/hw/usnic/usnic_ib_verbs.c           | 10 +++--
drivers/infiniband/hw/usnic/usnic_transport.c          |  4 +-
drivers/infiniband/hw/usnic/usnic_transport.h          |  1 +
drivers/infiniband/hw/usnic/usnic_uiom.c               | 36 +++++++++-------
drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c |  2 +-
drivers/infiniband/hw/usnic/usnic_vnic.c               | 24 ++++-------
drivers/infiniband/hw/usnic/usnic_vnic.h               | 12 +++---
13 files changed, 98 insertions(+), 102 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
