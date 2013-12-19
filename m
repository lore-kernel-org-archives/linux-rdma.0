From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/core: OFED DAPL support on System z platform
Date: Thu, 19 Dec 2013 12:53:13 +0100
Message-ID: <1387453998-27416-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, klaus.wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series provides support for PCI devices on Linux on System z
for userspace applications that use the DAPL library and its components to
perform RDMA operations. The patch allows the userspace DAPL libraries to
request priveleged CPU instruction execution in the kernel context required
for PCI I/O.

Alexey Ishchuk (1):
  IB/core: OFED DAPL support on System z platform

 drivers/infiniband/core/uverbs.h      |  3 ++
 drivers/infiniband/core/uverbs_cmd.c  | 46 ++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |  8 +++++
 drivers/infiniband/hw/mlx4/main.c     | 67 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |  8 +++++
 include/rdma/ib_verbs.h               |  8 +++++
 include/uapi/rdma/ib_user_verbs.h     | 22 ++++++++++++
 7 files changed, 162 insertions(+)

-- 
1.8.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
