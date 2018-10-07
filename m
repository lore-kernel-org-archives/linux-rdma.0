From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/4] Scatter to CQE
Date: Sun,  7 Oct 2018 12:03:33 +0300
Message-ID: <20181007090337.21037-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

>From Yonatan,

Scatter to CQE is a HW offload feature that saves PCI writes by scattering
the payload to the CQE.

The feature depends on the CQE size and if the CQE size is 64B, it will work
for payload smaller than 32. If the CQE size is 128B, it will work for payload
smaller than 64.

The feature works for responder and requestor:
1. For responder, if the payload is small as required above, the data will
be part of the CQE, and thus we save another PCI transaction the recv buffers.
2. For requestor, this can be used to get the RDMA_READ response and RDMA_ATOMIC
response in the CQE. This feature is already supported in upstream.

As part of this series, we are adding support for DC transport type and
ability to enable the feature (force enable) in the requestor when SQ
is not configured to signal all WRs.

Thanks

Yonatan Cohen (4):
  net/mlx5: Expose DC scatter to CQE capability bit
  IB/mlx5: Support scatter to CQE for DC transport type
  IB/mlx5: Verify that driver supports user flags
  IB/mlx5: Allow scatter to CQE without global signaled WRs

 drivers/infiniband/hw/mlx5/cq.c      |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
 drivers/infiniband/hw/mlx5/qp.c      | 91 ++++++++++++++++++++++++++++--------
 include/linux/mlx5/mlx5_ifc.h        |  3 +-
 include/uapi/rdma/mlx5-abi.h         |  1 +
 5 files changed, 77 insertions(+), 22 deletions(-)
