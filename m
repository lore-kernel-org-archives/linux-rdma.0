From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/6] InfiniBand-ocrdma: Fine-tuning for some function
 implementations
Date: Sat, 26 Dec 2015 19:39:17 +0100
Message-ID: <567EDED5.4040201@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 26 Dec 2015 19:30:54 +0100

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (6):
  One variable and jump label less in ocrdma_alloc_ucontext_pd()
  Delete unnecessary variable initialisations in 11 functions
  Returning only value constants in ocrdma_qp_state_change()
  Return a value from a function call in _ocrdma_modify_qp() directly
  Returning only value constants in ocrdma_resize_cq()
  Delete an unnecessary variable in ocrdma_dealloc_pd()

 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  7 +++---
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  4 +--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 39 +++++++++++------------------
 4 files changed, 20 insertions(+), 32 deletions(-)

-- 
2.6.3
