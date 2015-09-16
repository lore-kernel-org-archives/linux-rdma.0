From: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] Enable checksum offload capability reporting
Date: Wed, 16 Sep 2015 18:56:05 +0300
Message-ID: <cover.1442413048.git.bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The checksum offload capability reporting is enabled based on extended verbs.
The capability field has sub-fields for every link layer, and depends on device
cap, each link layer will support specific QP types. These will be reported to
user space.

I'm new to uverbs extensions and looking forward for review comments on that
aspect of the patches.

Bodong Wang (3):
  IB/core: Add support of checksum capability reporting in ib verbs
  IB/uverbs: Add support for checksum capability reporting in user verbs
  IB/mlx4: Report checksum offload cap when query device

 drivers/infiniband/core/uverbs_cmd.c |  7 +++++++
 drivers/infiniband/hw/mlx4/main.c    |  3 +++
 include/rdma/ib_verbs.h              | 10 ++++++++++
 include/uapi/rdma/ib_user_verbs.h    |  6 ++++++
 4 files changed, 26 insertions(+)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
