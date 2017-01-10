From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] IB/vmw_pvrdma patches for 4.10
Date: Tue, 10 Jan 2017 11:15:38 -0800
Message-ID: <cover.1484075557.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

These are a small set of patches for the VMware paravirtual rdma driver.
I hope these can be added to the set of fixes for 4.10. I based these on
Linus' tree but they apply cleanly on your k.o/for-4.10-topics/vmw_pvrdma
branch too.

Thanks,
Adit

Adit Ranadive (3):
  IB/vmw_pvrdma: Defer activating device until vmxnet3 link is up
  IB/vmw_pvrdma: Cleanup unused variables
  IB/vmw_pvrdma: Dont hardcode QP header page

 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h       |   4 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c  | 103 +++++++++++++++---------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c    |  42 +++++-----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c |   2 +-
 4 files changed, 89 insertions(+), 62 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
