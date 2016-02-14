From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/2] User-index fixes
Date: Sun, 14 Feb 2016 18:35:50 +0200
Message-ID: <1455467752-3170-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Doug,

This series fixes two issues introduced in 4.5 after applying my
series "Raw Packet QP user-space support for mlx5".

SRQs don't use user-index, therefore the user shouldn't pass it and the
kernel shouldn't verify. The first patch fixes this by avoiding
user-index verification for non-xrc srqs.

The mlx5_ib driver fails libraries that support user-index but don't
pass it. It relies on the input length of the vendor specific part to
determine whether the user-space supports user-index.


In Legacy verbs, the given vendor specific part input length is given
including struct ib_uverbs_cmd_hdr. In contrast, extended commands
pass the same length exluding the header size.
The vendor driver doesn't know whether the command is a legacy
command or an extended command. Thus, we need to modify IB/core
in order to pass a consistent size. The second patch fixes the input
length in the IB/core and the wrong usage in the mlx5_ib.

We verified that other vendors don't use the inlen parameter and thus
won't break by this change.

Thanks,
Majd and Matan


Majd Dibbiny (2):
  IB/mlx5: Avoid using user-index for SRQs
  IB/{core, mlx5}: Fix input len in vendor specific part of
    create_qp/srq cmd

 drivers/infiniband/core/uverbs_cmd.c |  9 +++++---
 drivers/infiniband/hw/mlx5/srq.c     | 41 +++++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 22 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
