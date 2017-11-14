From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/2] PCI write end padding
Date: Tue, 14 Nov 2017 15:47:06 +0200
Message-ID: <1510667228-18579-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series from Noa is the supplementary part of the kernel series that was
merged into 4.15 'for-next' branch by Doug few days ago.

The series exposes the "PCI write end padding" device capability and enables QP
and WQ creation with that option.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/250

Note:
The Travis issue that was reported in GITHUB is not related to this series but
to some 'vmw_pvrdma' patches that were previously taken.

Noa Osherovich (2):
  verbs: Report the device's PCI write end paddding capability
  verbs: Enable QP and WQ creation with PCI write end padding option

 libibverbs/cmd.c                  | 3 ++-
 libibverbs/examples/devinfo.c     | 5 ++++-
 libibverbs/man/ibv_create_qp_ex.3 | 1 +
 libibverbs/man/ibv_create_wq.3    | 3 ++-
 libibverbs/verbs.h                | 5 ++++-
 5 files changed, 13 insertions(+), 4 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
