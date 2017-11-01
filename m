From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 0/3] Bugfixes for hip08 libhns
Date: Wed, 1 Nov 2017 18:00:37 +0800
Message-ID: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This path series fix a bug with endian format for compatibility,
as well as update the usage of two fields in cq doorbell and
sqwqe.

Lijun Ou (3):
  libhns: Set owner bit of SQWQE in user mode
  libhns: Modify the usage of cmd_sn in hip08 RoCE userspace
  libhns: Fix endian format of payload and immediate

 providers/hns/hns_roce_u_hw_v2.c | 14 +++++++++++---
 providers/hns/hns_roce_u_hw_v2.h |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
