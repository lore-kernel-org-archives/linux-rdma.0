From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 0/2] Fixes for hip8 libhns
Date: Sat, 18 Nov 2017 18:21:34 +0800
Message-ID: <1511000496-181604-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These series fix two bugs with filtering the 0 length sge
as well as make hns sparse clean.

Lijun Ou (2):
  libhns: Make the provider sparse clean
  libhns: Filter for zero length of sge in hip08 userspace

 CMakeLists.txt                   |   2 +-
 providers/hns/hns_roce_u.h       |   6 +--
 providers/hns/hns_roce_u_hw_v1.c |  60 +++++++++++----------
 providers/hns/hns_roce_u_hw_v1.h | 114 +++++++++++++++++++--------------------
 providers/hns/hns_roce_u_hw_v2.c |  79 +++++++++++++++++----------
 providers/hns/hns_roce_u_hw_v2.h |  56 ++++++++++---------
 6 files changed, 175 insertions(+), 142 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
