From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] RDMA/ucma: Use struct_size() helper
Date: Tue, 4 Jun 2019 10:42:22 -0500
Message-ID: <20190604154222.GA8938@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace the following form:

sizeof(*resp) + (i * sizeof(struct ib_path_rec_data))

with:

struct_size(resp, path_data, i)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/core/ucma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 140a338a135f..cbe460076611 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -951,8 +951,7 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
 		}
 	}
 
-	if (copy_to_user(response, resp,
-			 sizeof(*resp) + (i * sizeof(struct ib_path_rec_data))))
+	if (copy_to_user(response, resp, struct_size(resp, path_data, i)))
 		ret = -EFAULT;
 
 	kfree(resp);
-- 
2.21.0
