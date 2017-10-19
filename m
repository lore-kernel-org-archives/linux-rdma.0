From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/6] RDMA mlx5 driver updates rdma-next-2017-10-19
Date: Thu, 19 Oct 2017 08:25:50 +0300
Message-ID: <20171019052556.8514-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch set adds two local to mlx5 features.

The first feature comes from Guy, who updated the mlx5 driver to support
CQE compression for 128B-sized CQEs in addition to already supported
64B-sized CQEs: commit 1cbe6fc86ccf ("IB/mlx5: Add support for CQE compressing").

The second feature comes from Maor, this feature enables receive stateless
offloading support for incoming tunneling traffic for raw ethernet QP.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-19-1

	Thanks
---------------------------------------

Guy Levi (3):
  IB/mlx5: Add 128B CQE compression and padding HW bits
  IB/mlx5: Support 128B CQE compression feature
  IB/mlx5: Support padded 128B CQE feature

Maor Gottlieb (3):
  IB/mlx5: Update tunnel offloads bits
  IB/mlx5: Add tunneling offloads support
  IB/mlx5: Add support for RSS on the inner packet

 drivers/infiniband/hw/mlx5/cq.c      | 33 +++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/main.c    | 26 +++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  7 +++++
 drivers/infiniband/hw/mlx5/qp.c      | 50 ++++++++++++++++++++++++++++++++----
 include/linux/mlx5/cq.h              |  6 +++--
 include/linux/mlx5/mlx5_ifc.h        |  8 ++++--
 include/uapi/rdma/mlx5-abi.h         | 29 ++++++++++++++++++---
 7 files changed, 138 insertions(+), 21 deletions(-)

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
