From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/2] Add support for reporting LSO capabilities
Date: Mon, 18 Apr 2016 19:25:15 +0300
Message-ID: <1460996717-18778-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series enabled hardware to report Large Segment
Offload(LSO) capabilities from kernel to user space. LSO enabled NIC
will accept big chuck of data with the size greater than MTU.
The LSO engine will split them into separate packets and insert the
headers automatically. With LSO, CPU is offloaded from dealing with
much less throughput of data.

For detailed info about LSO, please refer to the following link:
https://en.wikipedia.org/wiki/Large_segment_offload

The capabilities are exposed to user space through
query_device, ib_device_attr, and their relevant code is updated
to build the pipe. The following capabilities will be reported:

1. The maximum payload size supported for segmentation by LSO engine.
2. QP types which support LSO operations.

The capabilities of mlx5-related hardware are reported accordingly.

This series conflicts with scatter FCS series that was posted earlier
in this kernel cycle. The resolution for this conflict is available
in Mellanox's git.

Regards,
Bodong and Majd.

Bodong Wang (2):
  IB/core: Report LSO capabilities when querying device
  IB/mlx5: Report mlx5 LSO capabilities when querying device

 drivers/infiniband/core/uverbs_cmd.c |  7 +++++++
 drivers/infiniband/hw/mlx5/main.c    | 13 +++++++++++--
 include/rdma/ib_verbs.h              |  6 ++++++
 include/uapi/rdma/ib_user_verbs.h    |  6 ++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
