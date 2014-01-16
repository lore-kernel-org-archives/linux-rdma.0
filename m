From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/2] Add RDMA_NODE_USNIC_UDP
Date: Wed, 15 Jan 2014 17:02:35 -0800
Message-ID: <1389834157-16635-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland - Consider merging this with 248567f79304b953ea492fb92ade097b62ed09b2.

This patchset add the complementary RDMA_NODE_USNIC_UDP for RDMA_TRANSPORT_USNIC_UDP.

Upinder Malhi (2):
  IB/core: Add support for RDMA_NODE_USNIC_UDP
  IB/usnic: Advertise usNIC devices as RDMA_NODE_USNIC_UDP

 drivers/infiniband/core/sysfs.c             | 1 +
 drivers/infiniband/core/verbs.c             | 2 ++
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 2 +-
 include/rdma/ib_verbs.h                     | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
