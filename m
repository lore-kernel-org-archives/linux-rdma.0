From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] RDMA/cxgb3: stack info leak in iwch_craete_cq()
Date: Mon, 29 Jul 2013 22:19:14 +0300
Message-ID: <20130729191914.GA11977@elgon.mountain>
References: <51F171D0.7050204@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51F171D0.7050204@opengridcomputing.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The "uresp.reserved" field isn't initialized on this path so it could
leak uninitialized stack information to the user.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: different approach to fixing the problem

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index e87f220..d228383 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -226,6 +226,7 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int ve
 			mm->len = PAGE_ALIGN(((1UL << uresp.size_log2) + 1) *
 					     sizeof(struct t3_cqe));
 			uresp.memsize = mm->len;
+			uresp.reserved = 0;
 			resplen = sizeof uresp;
 		}
 		if (ib_copy_to_udata(udata, &uresp, resplen)) {
