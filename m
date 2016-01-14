From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v3 0/6] InfiniBand-ocrdma: Fine-tuning for some function
 implementations
Date: Thu, 14 Jan 2016 18:18:29 +0100
Message-ID: <5697D865.5010507@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <567EDED5.4040201@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567EDED5.4040201-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Thu, 14 Jan 2016 18:15:54 +0100

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (6):
  One variable and jump label less in ocrdma_alloc_ucontext_pd()
  Delete unnecessary variable initialisations in 11 functions
  Returning only value constants in ocrdma_qp_state_change()
  Return a value from a function call in _ocrdma_modify_qp() directly
  Returning only value constants in ocrdma_resize_cq()
  Delete an unnecessary variable in ocrdma_dealloc_pd()

---

v3: Rebase proposed changes on the source files for the software
    "Linux next-20160114".
    
v2: Unfortunately, the first update step from this series contained
    an inappropriate suggestion.
    Thus fix that.

 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  7 +++---
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  4 +--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 39 +++++++++++------------------
 4 files changed, 20 insertions(+), 32 deletions(-)

-- 
2.6.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
