From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 00/12] InfiniBand-OCRDMA: Fine-tuning for several function
 implementations
Date: Sat, 22 Apr 2017 16:26:14 +0200
Message-ID: <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492720999.3041.18.camel@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Apr 2017 16:16:06 +0200

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (12):
  Use kcalloc() in ocrdma_mbx_alloc_pd_range()
  Use kcalloc() in five functions
  Improve size determinations in ten functions
  Delete unnecessary variable initialisations in ocrdma_mbx_get_dcbx_config()
  Delete unnecessary braces
  Use kmalloc_array() in ocrdma_create_srq()
  Adjust 21 checks for null pointers
  Delete an error message for a failed memory allocation in ocrdma_add()
  Delete an unnecessary variable assignment in ocrdma_alloc_mr()
  Returning only value constants in ocrdma_resize_cq()
  Delete an unnecessary variable in ocrdma_dealloc_pd()
  One jump label less in ocrdma_alloc_ucontext_pd()
---

v2:
Changes were rebased on source files from Linux next-20170421.
Some of them were recombined into bigger update steps
as requested by Doug Ledford.

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  88 ++++++++++-----------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  19 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 118 ++++++++++++----------------
 3 files changed, 100 insertions(+), 125 deletions(-)

-- 
2.12.2
