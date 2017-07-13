From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] Fix modify_qp failure
Date: Thu, 13 Jul 2017 14:37:36 -0500
Message-ID: <1499974658-6180-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 5ecce4c9b17b("Check port number supplied by user verbs cmds") causes
modify_qp to fail because port_num is only valid when the mask is set.

Additionally, for iWARP, the port_num is not initialized which also causes
modify_qp to fail.

This series fixes both issues.

Mustafa Ismail (2):
  RDMA/uverbs: Fix the check for port number
  RDMA/core: Initialize port_num in qp_attr

 drivers/infiniband/core/cma.c        | 2 ++
 drivers/infiniband/core/uverbs_cmd.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
