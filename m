From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/4] RDMA fixes 2017-12-24
Date: Sun, 24 Dec 2017 13:54:54 +0200
Message-ID: <20171224115458.27577-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The four patches targeted for stable@.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-12-24

	Thanks
---------------------------------------

Leon Romanovsky (1):
  RDMA/core: Enforce requirement to hold lists_rwsem semaphore

Majd Dibbiny (1):
  IB/mlx5: Serialize access to the VMA list

Moni Shoua (2):
  IB/uverbs: Fix command checking as part of ib_uverbs_ex_modify_qp()
  IB/core: Verify that QP is security enabled in create and destroy

 drivers/infiniband/core/device.c     | 7 ++++++-
 drivers/infiniband/core/security.c   | 3 +++
 drivers/infiniband/core/uverbs_cmd.c | 4 ++--
 drivers/infiniband/core/verbs.c      | 3 ++-
 drivers/infiniband/hw/mlx5/main.c    | 8 ++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 6 ++++++
 6 files changed, 27 insertions(+), 4 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
