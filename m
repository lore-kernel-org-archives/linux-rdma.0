From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/6] Enable flow steering on IPoIB UD QP
Date: Tue, 30 May 2017 10:15:56 +0300
Message-ID: <20170530071602.8139-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

---
>From Yishai:

This series comes to allow user space applications to accelerate send
and receive traffic which is typically handled by IPoIB ULP. On the
receive flow, the user space application will use flow steering rules to
direct the ingress IPoIB UD QP traffic to its own user space UD QP. On
the send flow, the user space application will send from its own UD QP
with UD AH, while the packet on the wire will have the source QPN of the
underlay IPoIB UD QP, which is the network interface advertised L2
hardware address.

This will be achieved by extending QP creation of IB UD QP to be
"Associated" with IPoIB UD QP number. In order to create such a UD QP
which can receive and send IPoIB traffic, needs to provide the
associated QPN of the IPoIB network interface. The created QP will
manage the scattering objects as of RQ and SQ, while the transport
attributes will be managed by its underlay QP which is owned by IPoIB
ULP.

The QPN should be achieved by using some networking tool as of ifconfig
,ip link show on the associated interface. For example, when IPoIB is
used, the QPN is the value of 3 bytes from the hardware address starting
after the first byte as defined by rfc4391 [1]

This API enables generic QPN association, current mlx5 driver implements
this API for the IPoIB ULP.

[1] https://tools.ietf.org/html/rfc4391#page-11
---

Available in the "topic/underlay_qp" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/underlay_qp

Possible merge conflicts resolution is available in:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=testing/queue-next

Yishai Hadas (6):
  IB/core: Enable QP creation which is associated to underlay QP
  IB/uverbs: Enable QP creation which is associated to underlay QP
  IB/mlx5: Add support for underlay QP managing
  IB/mlx5: Add multicast flow steering support for underlay QP
  net/mlx5: Report enhanced capabilities for IPoIB
  IB/mlx5: Report RX checksum capabilities for IPoIB

 drivers/infiniband/core/uverbs_cmd.c         | 11 +++--
 drivers/infiniband/hw/mlx5/main.c            | 47 +++++++++++++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  2 +
 drivers/infiniband/hw/mlx5/qp.c              | 72 ++++++++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/fw.c |  6 +++
 include/linux/mlx5/device.h                  |  6 ++-
 include/rdma/ib_verbs.h                      |  2 +
 include/uapi/rdma/ib_user_verbs.h            |  2 +-
 8 files changed, 116 insertions(+), 32 deletions(-)

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
