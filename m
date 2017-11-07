From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] IB/core: disable memory registration of fileystem-dax
 vmas
Date: Mon, 06 Nov 2017 16:57:21 -0800
Message-ID: <151001624138.16354.16836728315400060928.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151001623063.16354.14661493921524115663.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <151001623063.16354.14661493921524115663.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-mm@kvack.org, Doug Ledford <dledford@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Until there is a solution to the dma-to-dax vs truncate problem it is
not safe to allow RDMA to create long standing memory registrations
against filesytem-dax vmas.

Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: <linux-rdma@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/infiniband/core/umem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 21e60b1e2ff4..130606c3b07c 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -191,7 +191,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	sg_list_start = umem->sg_head.sgl;
 
 	while (npages) {
-		ret = get_user_pages(cur_base,
+		ret = get_user_pages_longterm(cur_base,
 				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
 				     gup_flags, page_list, vma_list);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
