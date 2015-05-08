From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/2][RESEND] General MAD clean up
Date: Fri,  8 May 2015 13:10:02 -0400
Message-ID: <1431105004-23585-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Resend due to Patchwork being reset.  Also added Jason's Reviewed-By and Sean's
Acked-By lines.

These 2 patches contain some clean ups to the MAD module.  One was reviewed
months ago by Sean and the other was suggested by Doug.

These are based on Doug's for-4.2 branch

Ira Weiny (2):
  IB/mad: Rename is_data_mad to is_rmpp_data_mad
  IB/mad: Clean up comments in smi.c

 drivers/infiniband/core/mad.c | 7 ++++---
 drivers/infiniband/core/smi.c | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
