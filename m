From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] IB/core: Use struct_size() in kzalloc()
Date: Fri, 4 Jan 2019 12:15:58 -0600
Message-ID: <20190104181558.GA2403@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
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
 drivers/infiniband/core/sa_query.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 97e6d7b69abf..7925e45ea88a 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -2342,9 +2342,7 @@ static void ib_sa_add_one(struct ib_device *device)
 	s = rdma_start_port(device);
 	e = rdma_end_port(device);
 
-	sa_dev = kzalloc(sizeof *sa_dev +
-			 (e - s + 1) * sizeof (struct ib_sa_port),
-			 GFP_KERNEL);
+	sa_dev = kzalloc(struct_size(sa_dev, port, e - s + 1), GFP_KERNEL);
 	if (!sa_dev)
 		return;
 
-- 
2.20.1
