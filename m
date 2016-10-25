From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] IB/hfi1: Remove incorrect IS_ERR check
Date: Tue, 25 Oct 2016 13:12:46 -0700
Message-ID: <20161025201245.15765.69984.stgit@scvm10.sc.intel.com>
References: <20161025194241.15765.8903.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025194241.15765.8903.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove IS_ERR check from caching code as the function being called does
not actually return error pointers.

Fixes: f19bd643dbde: "IB/hfi1: Prevent NULL pointer deferences in caching code"
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index a761f80..77697d6 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1144,7 +1144,7 @@ static int pin_vector_pages(struct user_sdma_request *req,
 	rb_node = hfi1_mmu_rb_extract(pq->handler,
 				      (unsigned long)iovec->iov.iov_base,
 				      iovec->iov.iov_len);
-	if (rb_node && !IS_ERR(rb_node))
+	if (rb_node)
 		node = container_of(rb_node, struct sdma_mmu_node, rb);
 	else
 		rb_node = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
