From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next v1 0/2] RDMA/vmw_pvrdma: Patches for 4.14
Date: Tue, 29 Aug 2017 15:51:28 -0700
Message-ID: <cover.1504045411.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are a couple more patches for the VMware PVRDMA driver for 4.14.
These are based on your for-next branch.

Thanks,
Adit
---
Changes v0 -> v1:
 - Dropped the PVRDMA network type enums and the conversion function.
---
Adit Ranadive (1):
  RDMA/vmw_pvrdma: Fix a signedness

Aditya Sarwade (1):
  RDMA/vmw_pvrdma: Report network header type in WC

 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 3 ++-
 include/uapi/rdma/vmw_pvrdma-abi.h           | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
