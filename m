From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/4] Introduce IBV_QPT_DRIVER for mlx5 DC
Date: Thu,  4 Jan 2018 18:49:17 +0200
Message-ID: <1515084561-11374-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series from Moni is the supplementary part of the kernel series that was
sent upstream for 4.16.

It's under final review steps and is sent to demonstrate the expected usage of
the DC QP type in the user area around the control path.

In General:
Vendors can implement types of QPs that are not described in the
InfiniBand specification. Verbs layer doesn't know which services this QP
provides but it assumes that the hardware driver does.  The new QP type
IBV_QPT_DRIVER should be used for this kind of QP.  Any extra data that
describes this QP should be stored in a context in the hardware driver that is
associated with this QP.

The Dynamically Connected (DC) Transport Service provides a datagram-like
model that allows a DC QP to target multiple remote processes in multiple
remote nodes. As far as reachability is concerned, the DC model is somewhat
similar to the Unreliable Datagram (UD) model in the sense that each WR
submitted to the DC SQ carries the information that identifies the remote
destination.

The patches in this series add the DC support to the mlx5 driver by using the
IBV_QPT_DRIVER and some extensions in the mlx5 DV path to create a QP.

Yishai


Moni Shoua (4):
  verbs: Introduce driver QP type
  mlx5: Add interface to create DC transport QPs
  mlx5: Create DC transport QPs
  mlx5: Destroy and modify a DC target QP

 libibverbs/man/ibv_create_qp.3    |   5 +-
 libibverbs/man/ibv_create_qp_ex.3 |   5 +-
 libibverbs/verbs.h                |   3 +-
 providers/mlx5/mlx5-abi.h         |  24 +++++-
 providers/mlx5/mlx5.h             |   1 +
 providers/mlx5/mlx5dv.h           |  12 +++
 providers/mlx5/verbs.c            | 156 ++++++++++++++++++++++++++++++++++++--
 7 files changed, 192 insertions(+), 14 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
