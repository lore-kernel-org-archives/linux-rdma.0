From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] IB/cm: Use struct_size() in kmalloc()
Date: Mon, 7 Jan 2019 11:26:16 -0600
Message-ID: <20190107172616.GA3099@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    void *entry[];
};

instance = kmalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kmalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/core/cm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index edb2cb758be7..af7f74faa448 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -4052,8 +4052,7 @@ static void cm_recv_handler(struct ib_mad_agent *mad_agent,
 	atomic_long_inc(&port->counter_group[CM_RECV].
 			counter[attr_id - CM_ATTR_ID_OFFSET]);
 
-	work = kmalloc(sizeof(*work) + sizeof(struct sa_path_rec) * paths,
-		       GFP_KERNEL);
+	work = kmalloc(struct_size(work, path, paths), GFP_KERNEL);
 	if (!work) {
 		ib_free_recv_mad(mad_recv_wc);
 		return;
-- 
2.20.1
