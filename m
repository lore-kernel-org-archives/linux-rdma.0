From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 0/2] Add support for enhanced atomic operations
Date: Mon, 01 Feb 2010 17:59:16 +0200
Message-ID: <4B66FA54.6030408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This patchset adds support for the following enhanced atomic operations:
- Masked atomic compare and swap
- Masked atomic fetch and add

These operations enable using a smaller amount of memory when using multiple locks
by using portions of a 64 bit value in an atomic operation.

Vladimir Sokolovsky(2):
IB/core: Add support for enhanced atomic operations
mlx4/IB: Add support for enhanced atomic operations

  drivers/infiniband/hw/mlx4/cq.c   |    8 ++++++++
  drivers/infiniband/hw/mlx4/main.c |    2 ++
  drivers/infiniband/hw/mlx4/qp.c   |   27 +++++++++++++++++++++++++++
  include/linux/mlx4/device.h       |    4 ++--
  include/linux/mlx4/qp.h           |    7 +++++++
  include/rdma/ib_verbs.h           |    9 ++++++++-
  6 files changed, 54 insertions(+), 3 deletions(-)

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
