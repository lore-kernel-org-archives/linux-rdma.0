From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/3] Add user MR re-registeration support
Date: Thu, 31 Jul 2014 11:01:27 +0300
Message-ID: <1406793690-3816-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Memory re-registration enables one to change the attributes of a 
memory region registered by user-space, including PD, translation 
(address and length) and access flags.

Matan and Or.

Matan Barak (3):
  IB/core: Add user MR re-registeration support
  mlx4_core: Add helper functions to support MR re-registration
  IB/mlx4_ib: Add support for user MR re-registration

 drivers/infiniband/core/uverbs.h                   |    1 +
 drivers/infiniband/core/uverbs_cmd.c               |   93 +++++++++++
 drivers/infiniband/core/uverbs_main.c              |    1 +
 drivers/infiniband/hw/mlx4/main.c                  |    2 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |    4 +
 drivers/infiniband/hw/mlx4/mr.c                    |   88 +++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    2 +
 drivers/net/ethernet/mellanox/mlx4/mr.c            |  160 ++++++++++++++++++++
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   26 +++-
 include/linux/mlx4/device.h                        |   16 ++
 include/rdma/ib_verbs.h                            |   10 +-
 include/uapi/rdma/ib_user_verbs.h                  |   16 ++
 12 files changed, 415 insertions(+), 4 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
