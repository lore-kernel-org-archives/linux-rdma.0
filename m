From: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] constify infiniband pci_device_id.
Date: Sun, 16 Jul 2017 12:00:43 +0530
Message-ID: <1500186646-28815-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Arvind Yadav (3):
  [PATCH 1/3] infiniband: mthca: constify pci_device_id.
  [PATCH 2/3] infiniband: nes: constify pci_device_id.
  [PATCH 3/3] infiniband: pvrdma: constify pci_device_id.

 drivers/infiniband/hw/mthca/mthca_main.c       | 2 +-
 drivers/infiniband/hw/nes/nes.c                | 2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
