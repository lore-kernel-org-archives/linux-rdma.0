From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 0/3] Annotate imm_data as be32 in the uapi header
Date: Thu, 11 Jan 2018 14:43:04 -0700
Message-ID: <20180111214307.501-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This matches what the user space version of this struct has had for some time
and it removed several __force casts from the tree.

hns and qedr are updated to match what their userspace providers are doing.

Jason Gunthorpe (3):
  RDMA: Mark imm_data as be32 in the verbs uapi header
  RDMA/hns: Fix endian problems around imm_data and rkey
  RDMA/qedr: Fix endian problems around imm_data

 drivers/infiniband/core/uverbs_cmd.c       | 2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 7 ++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 +++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 5 ++++-
 drivers/infiniband/hw/qedr/verbs.c         | 4 ++--
 drivers/infiniband/sw/rdmavt/cq.c          | 3 +--
 drivers/infiniband/sw/rxe/rxe_resp.c       | 3 +--
 include/uapi/rdma/ib_user_verbs.h          | 4 ++--
 8 files changed, 18 insertions(+), 16 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
