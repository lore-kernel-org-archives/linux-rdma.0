From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 09:49:15 +0300
Message-ID: <20170612064918.12510-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch set which is based on v4.12-rc4 comes from Parav and it
adds support for out of order data placement for RDMA read and
write requests.

Thanks

---
>From Parav:

In certain fabric configurations IB packets for a given QP may take up
different paths in a network from source to destination. This results
into reaching packets out of order at the receiver side. Instead of
dropping packets, handling out of order packets can improve overall
network performance in following ways:
 * improve network utilization by avoiding retransmission
 * avoiding latency increase due to retransmission

This patchset allows HCA to expose out of order data placement
capability to users who can take benefit of such feature.

This is optional feature of an HCA and enablement of this feature
is done on per QP basis. The optional QP attribute is set when a QP
state is changed from INIT to RTR.

Out of order data placement capability indicates that if HCA receives
out of order RDMA packets, their data placement can be done at the
desired memory destination given in the packet(s). This is applicable
to RDMA read and write operations.

Send queue work requests are still completed in-order regardless of
their data placement order at requester or responder side.

In-order semantics is always guaranteed by setting the Fence
indicator for appropriate WRs.

An application shall not depend on the contents of the RDMA write buffer
at the responder until one of the following occurred:
- Completion of the RDMA WRITE with immediate data receive completion.
- Arrival and completion of the subsequent SEND message.
- Update of a memory element by subsequent ATOMIC operation.

An application shall not depend on the contents of the RDMA read buffer
at the requester until one of the following occurred:
- Completion of the RDMA READ work request if requested or such
  work request completes with error status.
- Completion of the subsequent work request.

Thanks

CC: Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Parav Pandit (3):
  IB/core: Expose out of order data placement capability
  IB/uverbs: Enable user space programs to use out of order placement
  IB/mlx5: Support out of order data placement

 Documentation/infiniband/out_of_order.txt | 60 +++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c      | 16 +++++++++
 drivers/infiniband/core/verbs.c           |  9 +++--
 drivers/infiniband/hw/mlx5/main.c         | 12 +++++++
 drivers/infiniband/hw/mlx5/qp.c           | 25 +++++++++++++
 include/linux/mlx5/mlx5_ifc.h             |  5 ++-
 include/rdma/ib_verbs.h                   | 22 ++++++++++++
 include/uapi/rdma/ib_user_verbs.h         | 16 +++++++--
 8 files changed, 159 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/infiniband/out_of_order.txt

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
