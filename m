From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] Add IPv6 support to flow steering
Date: Fri, 17 Jun 2016 15:14:49 +0300
Message-ID: <1466165691-32538-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following two patches add and enable IPv6 support to flow
steering.

Maor Gottlieb (2):
  IB/core: Add IPv6 support to flow steering
  IB/mlx5: Enable flow steering for IPv6 traffic

 drivers/infiniband/core/uverbs.h     |  1 +
 drivers/infiniband/core/uverbs_cmd.c |  9 +++++++++
 drivers/infiniband/hw/mlx5/main.c    | 26 ++++++++++++++++++++++++++
 include/rdma/ib_verbs.h              | 14 ++++++++++++++
 include/uapi/rdma/ib_user_verbs.h    | 18 ++++++++++++++++++
 5 files changed, 68 insertions(+)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
