From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 0/6] Add DC transport support to mlx5
Date: Tue,  2 Jan 2018 16:19:27 +0200
Message-ID: <20180102141933.24353-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
 v1 -> v2:
  * Renamed functions to better describe functionality.
  * Improve set_mlx5_qp function implementation.
 v0 -> v1:
  * Updated "net/mlx5: Add DCT command interface" patch to
    declare variables in reversed Christmas tree order.

---------------------------------------a
>From Moni,

Following the discussion [1] on the mailing list regarding
"Custom/proprietary QP type support", the following patchset
implements the direct connected QP types functionality over posted RFC.

The dynamically connected (DC) transport service provides a datagram-like
model that allows a DC QP to target multiple remote processes in multiple
remote nodes.

As far as reachability is concerned, the DC model is somewhat similar to
the unreliable datagram (UD) model in the sense that each WR submitted to
the DC SQ carries the information that identifies the remote destination.

The new QP type - IB_QPT_DRIVER is introduced to represent all type of QPs
that are driver specific, like the proposed DC QP. Such minimal change
to the IB/core allows reuse of existing verbs functions to control those
new QPs with already existing functions.

[1] https://www.spinics.net/lists/linux-rdma/msg57598.html

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2018-01-02-1

	Thanks
---------------------------------------

Moni Shoua (6):
  net/mlx5: Add DCT command interface
  net/mlx5: Enable DC transport
  IB/core: Introduce driver QP type
  IB/mlx5: Handle type IB_QPT_DRIVER when creating a QP
  IB/mlx5: Add support for DC Initiator QP
  IB/mlx5: Add support for DC target QP

 drivers/infiniband/hw/mlx5/main.c              |  27 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h           |  12 +
 drivers/infiniband/hw/mlx5/qp.c                | 364 ++++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/qp.c   | 125 ++++++++-
 include/linux/mlx5/device.h                    |   9 +
 include/linux/mlx5/driver.h                    |   8 +
 include/linux/mlx5/qp.h                        |  12 +
 include/rdma/ib_verbs.h                        |   1 +
 include/uapi/rdma/mlx5-abi.h                   |  12 +-
 11 files changed, 560 insertions(+), 22 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
