From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] IB/vmw_pvrdma: Rename module to vmw_pvrdma
Date: Fri, 9 Dec 2016 09:10:03 -0800
Message-ID: <f7bff3a4eef57ab6a7cb5c023952b5ab0be7e194.1481303342.git.aditr@vmware.com>
References: <cover.1481303342.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1481303342.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Update make target to vmw_pvrdma.

Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/pvrdma/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/pvrdma/Makefile b/drivers/infiniband/hw/pvrdma/Makefile
index e6f078b..6ef4b98 100644
--- a/drivers/infiniband/hw/pvrdma/Makefile
+++ b/drivers/infiniband/hw/pvrdma/Makefile
@@ -1,3 +1,3 @@
-obj-$(CONFIG_INFINIBAND_PVRDMA) += pvrdma.o
+obj-$(CONFIG_INFINIBAND_PVRDMA) += vmw_pvrdma.o
 
-pvrdma-y := pvrdma_cmd.o pvrdma_cq.o pvrdma_doorbell.o pvrdma_main.o pvrdma_misc.o pvrdma_mr.o pvrdma_qp.o pvrdma_verbs.o
+vmw_pvrdma-y := pvrdma_cmd.o pvrdma_cq.o pvrdma_doorbell.o pvrdma_main.o pvrdma_misc.o pvrdma_mr.o pvrdma_qp.o pvrdma_verbs.o
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
