From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] IB/core: Fine-tuning for ib_is_udata_cleared()
Date: Sun, 21 Aug 2016 19:39:20 +0200
Message-ID: <f7bb3caf-81cd-fba9-afc8-5fac72b8a4b3@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 21 Aug 2016 19:34:12 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use memdup_user()
  Delete an unnecessary initialisation

 include/rdma/ib_verbs.h | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

-- 
2.9.3
