From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] IB/srp: Use struct_size() in kzalloc()
Date: Tue, 8 Jan 2019 10:08:05 -0600
Message-ID: <20190108160805.GA22698@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

One of the more common cases of allocation size calculations is finding the
size of a structure that has a zero-sized array at the end, along with memory
for some number of elements for that array. For example:

struct foo {
    int stuff;
    void *entry[];
};

instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can now
use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 31d91538bbf4..0f855294ff3f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -443,8 +443,7 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
 	if (pool_size <= 0)
 		goto err;
 	ret = -ENOMEM;
-	pool = kzalloc(sizeof(struct srp_fr_pool) +
-		       pool_size * sizeof(struct srp_fr_desc), GFP_KERNEL);
+	pool = kzalloc(struct_size(pool, desc, pool_size), GFP_KERNEL);
 	if (!pool)
 		goto err;
 	pool->size = pool_size;
-- 
2.20.1
