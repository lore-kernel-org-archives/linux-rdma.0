From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/2] Introduce Multi-Packet receive work queue
Date: Tue, 17 Oct 2017 18:01:11 +0300
Message-ID: <20171017150113.8544-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A Multi-Packet receive WQ comes to improve performance and memory
footprint. It is comprised of work requests that can be consumed by
multiple packets. Buffers pointed by SGEs of each work request in a
multi packet WQ are divided into strides. Both buffer size and stride
size must be identical in all work requests of the same multi packet
WQ and are set during WQ creation.

A single WR in a Multi-Packet WQ can generate multiple completions,
depends on the number of packets consumed. Each packet starts at the
beginning of a stride and is written in stride granularity.

Here is an example of a work request comprised of 3 strides. Packet 1
is larger than a stride so it occupies 2 strides. Packet 2 fits in a
single stride. Each packet will generate its own completion.

|         |         |[packet2]|
|    [packet1]      |         |
|_________|_________|_________|
 stride      stride     stride
 <--      work request     -->

A Multi-Packet WQ reduces the number of needed post-recv operations
thus increasing performance: In the example above, a single post-recv
operation was performed instead of 2.

It reduces memory footprint by allowing each packet to consume a
different number of strides instead of the whole WR. For example, a
large work request with many small strides: If the incoming packet is
smaller than a stride, the waste will be <stride size> - <packet size>
while for a large packet the waste will be:
<stride size> - (<packet size> % <stride size>)

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-17

	Thanks
---------------------------------------

Noa Osherovich (2):
  IB/mlx5: Expose multi-packet RQ capabilities
  IB/mlx5: Allow creation of a multi-packet RQ

 drivers/infiniband/hw/mlx5/main.c    | 16 +++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  9 +++++++
 drivers/infiniband/hw/mlx5/qp.c      | 52 ++++++++++++++++++++++++++++++------
 include/linux/mlx5/mlx5_ifc.h        |  1 +
 include/uapi/rdma/mlx5-abi.h         | 22 ++++++++++++++-
 5 files changed, 91 insertions(+), 9 deletions(-)

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
