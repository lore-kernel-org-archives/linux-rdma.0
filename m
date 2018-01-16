From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/2] Expose mlx5 core driver's clock information
Date: Tue, 16 Jan 2018 20:08:39 +0200
Message-ID: <20180116180841.18976-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From Feras:

This series adds the ability to query mlx5 core clock info from userspace
applications. This will allow userspace applications to translate timestamps
from HCA core clock units to nanoseconds using the latest clock info.

The first patch creates a new clock info page, which will be updated in
the kernel only, and the second patch maps the page to userspace.

In order to read the clock info correctly, a sequence number is incremented
at the beginning and end of each update. An odd number means the data is
being updated while an even means the access was already done.

To ensure correctness, the user will:

repeat:
        seq1 = <read sequence>
        goto <repeate> while odd
        <read data structure>
        seq2 = <read sequence>
        if seq1 != seq2 goto repeat

Thanks

Feras Daoud (2):
  net/mlx5e: Add clock info page to mlx5 core devices
  IB/mlx5: Mmap the HCA's clock info to user-space

 drivers/infiniband/hw/mlx5/main.c                  | 44 ++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               | 10 ----
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 55 ++++++++++++++++++++++
 include/linux/mlx5/driver.h                        |  3 ++
 include/uapi/rdma/mlx5-abi.h                       | 34 ++++++++++++-
 5 files changed, 133 insertions(+), 13 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
