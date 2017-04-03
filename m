From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/2] Add support for drop action for steering rules
Date: Mon,  3 Apr 2017 13:13:50 +0300
Message-ID: <20170403101352.5692-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch set introduces support for drop steering rule feature.

The application can configure a steering rule to drop all the packets
that match this rule.

In order to create a drop steering rule, the user has to add the drop flow
specification as part of the other flow specifications, otherwise the packet
will be forwarded to the destination QP.

Thanks,
	Slava and Leon.

Slava Shwartsman (2):
  IB/core: Introduce drop flow specification
  IB/mlx5: Add drop flow steering rule support

 drivers/infiniband/core/uverbs.h     |  1 +
 drivers/infiniband/core/uverbs_cmd.c |  7 +++++++
 drivers/infiniband/hw/mlx5/main.c    | 28 +++++++++++++++++++++++-----
 include/rdma/ib_verbs.h              |  7 +++++++
 include/uapi/rdma/ib_user_verbs.h    | 11 +++++++++++
 5 files changed, 49 insertions(+), 5 deletions(-)

--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
