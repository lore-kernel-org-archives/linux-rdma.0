From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-next 0/2] Bugfixes for eq support in hns
Date: Wed, 27 Dec 2017 19:04:02 +0800
Message-ID: <1514372644-171663-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set fixes the bugs according to Jason's two comments
on my previous patch set, which listed in the NOTE.

NOTE: This patch set is dependent on the following patches.
   "RDMA/hns: Add eq support of hip08"
   "RDMA/hns: Refactor eq code for hip06"

v1 -> v2:
1. Update according to Leon's comment, see the changelog
   of patch [2/2].

Yixian Liu (2):
  RDMA/hns: Add detailed comments for mb() call
  RDMA/hns: Fix alignment problem of the doorbell

 drivers/infiniband/hw/hns/hns_roce_device.h |  5 ++++
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 19 ++++++++++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 40 +++++++++++++++--------------
 3 files changed, 40 insertions(+), 24 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
