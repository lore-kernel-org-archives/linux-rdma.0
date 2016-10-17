From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 12/12] IB/hfi1: Fix rnr_timer addition
Date: Mon, 17 Oct 2016 04:20:09 -0700
Message-ID: <20161017112009.7934.44049.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The new s_rnr_timeout was not properly being set and the code was
incorrectly setting a different timer.

Found by code inspection.

Cc: <stable@vger.kernel.org> # 4.7.x
Fixes: 08279d5c9424 ("staging/rdma/hfi1: use new RNR timer")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 8bc5013..83198a8 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -89,7 +89,7 @@ void hfi1_add_rnr_timer(struct rvt_qp *qp, u32 to)
 
 	lockdep_assert_held(&qp->s_lock);
 	qp->s_flags |= RVT_S_WAIT_RNR;
-	qp->s_timer.expires = jiffies + usecs_to_jiffies(to);
+	priv->s_rnr_timer.expires = jiffies + usecs_to_jiffies(to);
 	add_timer(&priv->s_rnr_timer);
 }
 
