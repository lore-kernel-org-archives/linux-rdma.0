From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 rdma-core 0/5] Userspace library matching for hip08 RoCE
Date: Tue, 24 Oct 2017 21:21:44 +0800
Message-ID: <1508851309-183263-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series add userspace library for hip08 RoCE driver. It will
work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).

Change from V2:
- Fix the spelling with referred
- Eliminate the warning by travis-CI

Change from V1:
- Fix build warning due to the strange placement of fprintf

Lijun Ou (5):
  libhns: Add new PCI device matching for hip08
  libhns: Introduce QP operations referred to hip08 RoCE device
  libhns: Introduce CQ operations referred to hip08 device
  libhns: Reimplement verbs of post_send and post_recv for hip08 RoCE
  libhns: Update consolidate repo for userspace library of hip08 RoCE

 providers/hns/CMakeLists.txt     |   1 +
 providers/hns/hns_roce_u.c       |  12 +-
 providers/hns/hns_roce_u.h       |  13 +-
 providers/hns/hns_roce_u_hw_v2.c | 907 +++++++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_hw_v2.h | 261 +++++++++++
 providers/hns/hns_roce_u_verbs.c | 121 ++++--
 6 files changed, 1280 insertions(+), 35 deletions(-)
 create mode 100644 providers/hns/hns_roce_u_hw_v2.c
 create mode 100644 providers/hns/hns_roce_u_hw_v2.h

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
