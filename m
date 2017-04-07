From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 9/9] IB/isert: Improve size determinations in three functions
Date: Fri, 7 Apr 2017 23:09:08 +0200
Message-ID: <a19efeb8-fd7c-274b-bd59-adbc3a473cfb@users.sourceforge.net>
References: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>, Doug Ledford <dledford@redhat.com>, Erez Shitrit <erezsh@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Paolo Abeni <pabeni@redhat.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Yuval Shaia <yuval.shaia@oracle.com>, Zhu Yanjun <yanjun.zhu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 7 Apr 2017 22:20:39 +0200

Replace the specification of three data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determinations a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index c56af6183082..5dafda92a642 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -368,7 +368,7 @@ isert_device_get(struct rdma_cm_id *cma_id)
 		}
 	}
 
-	device = kzalloc(sizeof(struct isert_device), GFP_KERNEL);
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (!device) {
 		mutex_unlock(&device_list_mutex);
 		return ERR_PTR(-ENOMEM);
@@ -516,7 +516,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	isert_dbg("cma_id: %p, portal: %p\n",
 		 cma_id, cma_id->context);
 
-	isert_conn = kzalloc(sizeof(struct isert_conn), GFP_KERNEL);
+	isert_conn = kzalloc(sizeof(*isert_conn), GFP_KERNEL);
 	if (!isert_conn)
 		return -ENOMEM;
 
@@ -2306,7 +2306,7 @@ isert_setup_np(struct iscsi_np *np,
 	struct rdma_cm_id *isert_lid;
 	int ret;
 
-	isert_np = kzalloc(sizeof(struct isert_np), GFP_KERNEL);
+	isert_np = kzalloc(sizeof(*isert_np), GFP_KERNEL);
 	if (!isert_np)
 		return -ENOMEM;
 
-- 
2.12.2
