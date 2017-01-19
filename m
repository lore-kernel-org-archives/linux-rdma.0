From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Fixes for vmw_pvrdma
Date: Thu, 19 Jan 2017 13:20:38 -0800
Message-ID: <cover.1484859556.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are the fixes for vmw_pvrdma for this round of rc. These apply
cleanly to your k.o/for-4.10-rc branch.

Thanks,
Adit

Adit Ranadive (2):
  IB/vmw_pvrdma: Don't leak info from alloc_ucontext
  IB/vmw_pvrdma: Fix incorrect cleanup on pvrdma_pci_probe error path

 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c  | 4 +---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
