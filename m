From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 00/26] InfiniBand-OCRDMA: Fine-tuning for several function
 implementations
Date: Wed, 8 Mar 2017 13:30:16 +0100
Message-ID: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Wed, 8 Mar 2017 13:14:56 +0100

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (26):
  Use kcalloc() in ocrdma_create_eqs()
  Use kcalloc() in ocrdma_mbx_alloc_pd_range()
  Improve size determinations in ocrdma_mbx_get_dcbx_config()
  Delete unnecessary variable initialisations in ocrdma_mbx_get_dcbx_config()
  Improve another size determination in ocrdma_mbx_query_qp()
  Improve another size determination in ocrdma_alloc_pd_pool()
  Improve another size determination in ocrdma_mbx_get_ctrl_attribs()
  Improve size determinations in ocrdma_mbx_rdma_stats()
  Improve another size determination in ocrdma_mq_cq_handler()
  Improve another size determination in ocrdma_init_emb_mqe()
  Delete unnecessary braces
  Adjust ten checks for null pointers
  Use kcalloc() in ocrdma_alloc_resources()
  Improve another size determination in ocrdma_add()
  Delete an error message for a failed memory allocation in ocrdma_add()
  Adjust a null pointer check in ocrdma_alloc_resources()
  Use kmalloc_array() in ocrdma_create_srq()
  Use kcalloc() in three functions
  Improve another size determination in ocrdma_alloc_mr()
  Delete an unnecessary variable assignment in ocrdma_alloc_mr()
  Improve another size determination in ocrdma_create_srq()
  Returning only value constants in ocrdma_resize_cq()
  Delete an unnecessary variable in ocrdma_dealloc_pd()
  One jump label less in ocrdma_alloc_ucontext_pd()
  Delete unnecessary braces
  Adjust further ten checks for null pointers

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  88 ++++++++++-----------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  19 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 118 ++++++++++++----------------
 3 files changed, 100 insertions(+), 125 deletions(-)

-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
