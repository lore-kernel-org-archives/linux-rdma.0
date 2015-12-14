From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [RFC PATCH 15/15] IB/hfi1: Use rdmavt pkey verbs function
Date: Mon, 14 Dec 2015 12:29:38 -0500
Message-ID: <20151214172936.11576.78739.stgit@phlsvslse11.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

No need to keep providing the query pkey function. This is now being
done in rdmavt. Remove support from hfi1. The allocation and
maintenance of the list still resides in the driver.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/staging/rdma/hfi1/verbs.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index d208717..e1f249a 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1678,24 +1678,6 @@ unsigned hfi1_get_npkeys(struct hfi1_devdata *dd)
 	return ARRAY_SIZE(dd->pport[0].pkeys);
 }
 
-static int query_pkey(struct ib_device *ibdev, u8 port, u16 index,
-		      u16 *pkey)
-{
-	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	int ret;
-
-	if (index >= hfi1_get_npkeys(dd)) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	*pkey = hfi1_get_pkey(to_iport(ibdev, port), index);
-	ret = 0;
-
-bail:
-	return ret;
-}
-
 /**
  * alloc_ucontext - allocate a ucontest
  * @ibdev: the infiniband device
@@ -1863,7 +1845,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->modify_device = modify_device;
 	ibdev->query_port = query_port;
 	ibdev->modify_port = modify_port;
-	ibdev->query_pkey = query_pkey;
+	ibdev->query_pkey = NULL;
 	ibdev->query_gid = query_gid;
 	ibdev->alloc_ucontext = alloc_ucontext;
 	ibdev->dealloc_ucontext = dealloc_ucontext;
