From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 0/9] Introduce Signature feature
Date: Tue, 15 Oct 2013 18:38:21 +0300
Message-ID: <1381851510-17290-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset Introduces Verbs level support for signature handover
feature. Siganture is intended to implement end-to-end data integrity
on a transactional basis in a completely offloaded manner.
A signature handover operation is basically a translation of
the data layout between the so called memory domain and wire domain
in the context of data integrity support.

There are several end-to-end data integrity methods used today in various
applications and/or upper layer protocols such as T10-DIF defined by SCSI
specifications (SBC), CRC32, XOR8 and more. This patchset adds verbs
support only for T10-DIF. The proposed framework allows adding more
signature methods.

The way that data integrity is performed is by registering a protected
region with siganture handover attributes and memory domain layout and
in addition define the wire domain layout. defining both domains is
equivalent to determining the signature hanover operation which can be
strip/add/pass and validate data integrity when performing data transfer
from input space and output space. When the data transfer is completed,
the user may check the signature status of the handover operation and
in case some data integrity error has occured receive a signature error
item providing the relevant info on the error.

This feature shall be used in storage upper layer protocols iSER/SRP
implementing end-to-end data integrity T10-DIF. Following this patchset,
we will soon submit krping activation code which will demonstrate
the usage and activation of protected RDMA transactions using signature verbs.

Patchset summary:
- Intoduce verbs for create/destroy memory regions supporting signature.
- Introduce IB core signature verbs API.
- Implement mr create/destroy verbs in mlx5 driver.
- Preperation patches for signature support in mlx5 driver.
- Implement signature handover work request in mlx5 driver.
- Implement signature error collection and handling in mlx5 driver.

Sagi Grimberg (9):
  IB/core: Introduce indirect and protected memory regions
  IB/core: Introduce Signature Verbs API
  IB/mlx5, mlx5_core: Support for create_mr and destroy_mr
  IB/mlx5: Initialize mlx5_ib_qp signature related
  IB/mlx5: Break wqe handling to begin & finish routines
  IB/mlx5: remove MTT access mode from umr flags helper function
  IB/mlx5: Support IB_WR_REG_SIG_MR
  IB/mlx5: Collect signature error completion
  IB/mlx5: Publish support in signature feature

 drivers/infiniband/core/verbs.c              |   47 +++
 drivers/infiniband/hw/mlx5/cq.c              |   49 +++
 drivers/infiniband/hw/mlx5/main.c            |   12 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   11 +
 drivers/infiniband/hw/mlx5/mr.c              |  154 ++++++++
 drivers/infiniband/hw/mlx5/qp.c              |  532 ++++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/mr.c |   64 +++
 include/linux/mlx5/cq.h                      |    1 +
 include/linux/mlx5/device.h                  |   42 ++
 include/linux/mlx5/driver.h                  |   24 ++
 include/linux/mlx5/qp.h                      |   57 +++
 include/rdma/ib_verbs.h                      |  186 +++++++++-
 12 files changed, 1140 insertions(+), 39 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
