From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] IB/usnic: Use struct_size() in kmalloc()
Date: Mon, 7 Jan 2019 11:39:54 -0600
Message-ID: <20190107173953.GA6154@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Benvenuti <benve@cisco.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
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
 drivers/infiniband/hw/usnic/usnic_uiom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 49275a548751..ce01a59fccc4 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -157,9 +157,8 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 		off = 0;
 
 		while (ret) {
-			chunk = kmalloc(sizeof(*chunk) +
-					sizeof(struct scatterlist) *
-					min_t(int, ret, USNIC_UIOM_PAGE_CHUNK),
+			chunk = kmalloc(struct_size(chunk, page_list,
+					min_t(int, ret, USNIC_UIOM_PAGE_CHUNK)),
 					GFP_KERNEL);
 			if (!chunk) {
 				ret = -ENOMEM;
-- 
2.20.1
