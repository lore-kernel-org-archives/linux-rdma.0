From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/hfi1: Prevent NULL pointer deferences in caching code
Date: Wed, 12 Oct 2016 09:06:29 +0300
Message-ID: <20161012060402.GC12841@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Mitko Haralanov,

The patch f19bd643dbde: "IB/hfi1: Prevent NULL pointer deferences in
caching code" from Apr 12, 2016, leads to the following static
checker warning:

	drivers/infiniband/hw/hfi1/user_sdma.c:1147 pin_vector_pages()
	warn: 'rb_node' isn't an ERR_PTR

drivers/infiniband/hw/hfi1/user_sdma.c
  1135  static int pin_vector_pages(struct user_sdma_request *req,
  1136                              struct user_sdma_iovec *iovec)
  1137  {
  1138          int ret = 0, pinned, npages, cleared;
  1139          struct page **pages;
  1140          struct hfi1_user_sdma_pkt_q *pq = req->pq;
  1141          struct sdma_mmu_node *node = NULL;
  1142          struct mmu_rb_node *rb_node;
  1143  
  1144          rb_node = hfi1_mmu_rb_extract(pq->handler,
  1145                                        (unsigned long)iovec->iov.iov_base,
  1146                                        iovec->iov.iov_len);
  1147          if (rb_node && !IS_ERR(rb_node))
                                ^^^^^^^^^^^^^^^

hfi1_mmu_rb_extract() never returns error pointers.  Plz delete.

  1148                  node = container_of(rb_node, struct sdma_mmu_node, rb);
  1149          else
  1150                  rb_node = NULL;
  1151  
  1152          if (!node) {
  1153                  node = kzalloc(sizeof(*node), GFP_KERNEL);
  1154                  if (!node)
  1155                          return -ENOMEM;
  1156  
  1157                  node->rb.addr = (unsigned long)iovec->iov.iov_base;
  1158                  node->pq = pq;
  1159                  atomic_set(&node->refcount, 0);
  1160          }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
