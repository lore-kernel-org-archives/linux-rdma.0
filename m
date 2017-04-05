From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/5] IB/qib: Fine-tuning for four function implementations
Date: Wed, 5 Apr 2017 15:50:19 +0200
Message-ID: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Apr 2017 15:34:32 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (5):
  Use kcalloc() in qib_init_iba7322_funcs()
  Use kmalloc_array() in qib_init_7322_variables()
  Use kcalloc() in qib_alloc_devdata()
  Use kcalloc() in qib_init_pportdata()
  Adjust two size determinations in qib_init_pportdata()

 drivers/infiniband/hw/qib/qib_iba7322.c | 20 ++++++++++++--------
 drivers/infiniband/hw/qib/qib_init.c    | 27 +++++++++++++--------------
 2 files changed, 25 insertions(+), 22 deletions(-)

-- 
2.12.2
