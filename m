From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/2] Validate header in set_armed_active
Date: Tue,  9 Aug 2016 11:19:54 -0400
Message-ID: <1470755996-14187-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

These are 2 simple fixes but there is a dependency here so I'm sending them
together.

Mike Marciniszyn (2):
  IB/hfi1: Pass packet ptr to set_armed_active
  IB/hfi1: Validate header in set_armed_active

 drivers/infiniband/hw/hfi1/driver.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
