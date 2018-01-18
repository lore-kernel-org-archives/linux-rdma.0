From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 0/2] Support rq and cq record doorbell
Date: Thu, 18 Jan 2018 10:35:59 +0800
Message-ID: <1516242961-154453-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch-set updates to support rq record doorbell and
cq record doorbell in the user space.

Yixian Liu (2):
  libhns: Support rq record doorbell
  libhns: Support cq record doorbell

 providers/hns/CMakeLists.txt     |   1 +
 providers/hns/hns_roce_u.h       |  25 +++++
 providers/hns/hns_roce_u_db.c    | 196 +++++++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_db.h    |   5 +
 providers/hns/hns_roce_u_hw_v2.c |  52 +++--------
 providers/hns/hns_roce_u_verbs.c |  38 +++++++-
 6 files changed, 274 insertions(+), 43 deletions(-)
 create mode 100644 providers/hns/hns_roce_u_db.c

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
