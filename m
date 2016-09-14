From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 0/7] RSS support
Date: Wed, 14 Sep 2016 16:56:21 +0300
Message-ID: <1473861388-22064-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Sending V1 to address the symbol table note that Jason pointed
on, no other changes from V0, details below.

The series was tested successfully with mlx5 driver (lib, kernel) and can be
accessed also from my openfabrics GIT at:
git://openfabrics.org/~yishaih/libibverbs.git branch: rss_v1

This patch-set exposes to user space the required objects and verbs in order to
allow verbs based solution to utilize the RSS offload capability.

The kernel part for the 5 first patches was already accepted into 4.8, the
capabilities patch (#6) was sent few weeks ago into 4.9, reviewed by Sagi
Grimberg and waits to your acceptance. The last patch adds and updates relevant
man pages.

Yishai

In General:
RSS (Receive Side Scaling) technology allows to spread incoming 
traffic between different receive descriptor queues.
Assigning each queue to different CPU core allows to better load 
balance the incoming traffic and improve performance.

Extra details can be found in each commit message. 

Patches:
#1: Introduces Work Queue object and its verbs.
#2: Introduces Receive Work Queue indirection table and its verbs.
#3: Extends create QP to get a Receive-Work-Queue-indirection table.
#4: Extends create QP to get RX hash data.
#5: Tracks asynchronous events on a work queue.
#6: Exposes RSS related capabilities.
#7: Updates man pages for RSS usage.

Changes from V0:
patches 1 & 2: Use IBVERBS_1.3 as the symbol label.

Yishai Hadas (7):
  Introduce Work Queue object and its verbs
  Introduce Receive Work Queue indirection table and its verbs
  Extend create QP to get a Receive Work Queue indirection table
  Extend create QP to get RX hash data
  Track asynchronous events on a work queue
  Expose RSS related capabilities
  Update man pages for RSS usage

 Makefile.am                    |  10 +-
 examples/devinfo.c             |  24 ++++
 include/infiniband/driver.h    |  23 ++++
 include/infiniband/kern-abi.h  |  92 +++++++++++++-
 include/infiniband/verbs.h     | 282 ++++++++++++++++++++++++++++++++++++++++-
 man/ibv_create_qp_ex.3         |  14 +-
 man/ibv_create_rwq_ind_table.3 |  58 +++++++++
 man/ibv_create_wq.3            |  59 +++++++++
 man/ibv_modify_wq.3            |  43 +++++++
 man/ibv_query_device_ex.3      |  10 ++
 src/cmd.c                      | 213 ++++++++++++++++++++++++++++++-
 src/device.c                   |  15 +++
 src/libibverbs.map             |   9 ++
 13 files changed, 842 insertions(+), 10 deletions(-)
 create mode 100644 man/ibv_create_rwq_ind_table.3
 create mode 100644 man/ibv_create_wq.3
 create mode 100644 man/ibv_modify_wq.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
