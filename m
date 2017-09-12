From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/6] Add RSS support in mlx4
Date: Tue, 12 Sep 2017 15:53:02 +0300
Message-ID: <1505220788-23849-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set from Guy Levi implements the RSS related verbs for ConnectX-3
devices in the mlx4 provider.

The matching kernel part was already merged into 4.14.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/218

Guy Levi (6):
  mlx4: Add support for WQ control path related verbs
  mlx4: Introduce the direct verb mlx4dv_set_ctx_attr
  mlx4: Add support for WQ indirection table related verbs
  mlx4: Add support for RSS QP
  mlx4: Add WQ data path support
  mlx4: Support WQ object type in direct verb mlx4dv_init_obj

 debian/ibverbs-providers.symbols     |   1 +
 providers/mlx4/cq.c                  |   5 +-
 providers/mlx4/libmlx4.map           |   1 +
 providers/mlx4/man/mlx4dv_init_obj.3 |  20 +++
 providers/mlx4/mlx4-abi.h            |  33 ++++
 providers/mlx4/mlx4.c                |  42 +++++
 providers/mlx4/mlx4.h                |  30 +++-
 providers/mlx4/mlx4dv.h              |  32 +++-
 providers/mlx4/qp.c                  |  34 +++-
 providers/mlx4/verbs.c               | 339 ++++++++++++++++++++++++++++++++++-
 10 files changed, 525 insertions(+), 12 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
