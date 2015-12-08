From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC contig pages support 0/2] Add contiguous pages support
Date: Tue,  8 Dec 2015 17:15:05 +0200
Message-ID: <1449587707-24214-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This RFC introduces an ability to user space application
to work with contiguous pages and boost its performance by
reducing HCA translation's cycles.

IB core introduces a new structure named 'cmem' which
represents a contiguous memory and expose some APIs to
work with it.

IB driver can use those APIs on behalf of a user request to
achieve this task.

Specifically, below APIs were added to enable it:
ib_cmem_alloc_contiguous_pages:
- Allocate contiguous pages based on user context, page order, total size.

ib_cmem_release_contiguous_pages:
- Release memory allocated by ib_cmem_alloc_contiguous_pages.

ib_cmem_map_contiguous_pages_to_vma:
- Map pre-allocated 'cmem' into VMA.

The way to ask from user space this service can be achieved by
calling mmap with some command asking for. The low level driver
will use above APIs to fulfil the request.

Patches:
#1 - This patch exposes the 'cmem' API.
#2 - This patch introduces mlx5 driver usage of this API.

Yishai Hadas (2):
  IB: Supports contiguous memory operations
  IB/mlx5: Exporting to user space the contiguous allocation capability

 drivers/infiniband/core/Makefile     |   2 +-
 drivers/infiniband/core/cmem.c       | 245 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c    |  35 ++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   4 +-
 include/rdma/ib_cmem.h               |  41 ++++++
 5 files changed, 324 insertions(+), 3 deletions(-)
 create mode 100644 drivers/infiniband/core/cmem.c
 create mode 100644 include/rdma/ib_cmem.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
