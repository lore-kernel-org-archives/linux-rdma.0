From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH V2 0/2] Add cross-channel support
Date: Thu, 24 Dec 2015 10:51:10 +0200
Message-ID: <1450947072-9295-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The following set of patches implements cross-channel (CC) support
in the RDMA core and in the mlx5 infiniband driver.

The cross-channel feature allows to execute WQEs that involve
cross-channel synchronization of IO operations=E2=80=99 on different QP=
s.

Complex applications usually requires synchronizations for IO
operations from multiple sources before continuing their
execution. In order to implement this the host software
needs to handle completions from each one of the receive
queues (arriving in arbitrary order), process the data after
last message arrival and only then post work request on the
send queue to send the combined data to its destination.

Execution of such an operation generates multiple interrupts at
an unpredictable time with huge overhead for interrupt handling
and context switch.

Current submission adds synchronization primitives which gives
ability to perform conditional flows and a following submission
will introduce arithmetic calculation offload.

Synchronization abilities combined with arithmetic calculations
will allow to program complex flows with a single function call,
hereby significantly reducing overhead associated with IO processing.

Patch #1 adds CQ and QP initialization flags to RDMA core structures
in order to support cross-channel feature.
Patch #2 implements mlx5 infiniband driver configuration logic.

Changes from v1:
  * Enrich cover message and commit messages.
  * Drop patch with checkpatch warning fix.

Changes from v0:
  * Set UAR to be the same for QP and CQ.

Leon Romanovsky (2):
  IB/core: Add cross-channel support
  IB/mlx5: Add driver cross-channel support

 drivers/infiniband/core/uverbs_cmd.c |  5 +++-
 drivers/infiniband/hw/mlx5/cq.c      |  7 ++++-
 drivers/infiniband/hw/mlx5/main.c    |  3 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 16 +++++++++++
 drivers/infiniband/hw/mlx5/qp.c      | 54 ++++++++++++++++++++++++++++=
+-------
 include/linux/mlx5/qp.h              |  3 ++
 include/rdma/ib_verbs.h              | 11 ++++++++
 7 files changed, 87 insertions(+), 12 deletions(-)

--=20
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
