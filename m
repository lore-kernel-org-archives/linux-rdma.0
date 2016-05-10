From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/hfi1: Fix buffer cache races which may cause corruption
Date: Tue, 10 May 2016 13:41:49 +0300
Message-ID: <20160510104149.GA1326@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Mitko Haralanov,

The patch e88c9271d9f8: "IB/hfi1: Fix buffer cache races which may
cause corruption" from Apr 12, 2016, leads to the following static
checker warning:

	drivers/staging/rdma/hfi1/user_sdma.c:1053 sdma_cache_evict()
	warn: test_bit() takes a bit number

drivers/staging/rdma/hfi1/user_sdma.c
  1043  static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
  1044  {
  1045          u32 cleared = 0;
  1046          struct sdma_mmu_node *node, *ptr;
  1047          struct list_head to_evict = LIST_HEAD_INIT(to_evict);
  1048  
  1049          spin_lock(&pq->evict_lock);
  1050          list_for_each_entry_safe_reverse(node, ptr, &pq->evict, list) {
  1051                  /* Make sure that no one is still using the node. */
  1052                  if (!atomic_read(&node->refcount)) {
  1053                          set_bit(SDMA_CACHE_NODE_EVICT, &node->flags);
                                        ^^^^^^^^^^^^^^^^^^^^^
This is doing set_bit(BIT(0), &node->flags); but presumably the intent
was to do "set_bit(0, &node->flags);".  In other words it is setting bit
1 instead of 0.

  1054                          list_del_init(&node->list);
  1055                          list_add(&node->list, &to_evict);
  1056                          cleared += node->npages;
  1057                          if (cleared >= npages)
  1058                                  break;
  1059                  }
  1060          }
  1061          spin_unlock(&pq->evict_lock);
  1062  
  1063          list_for_each_entry_safe(node, ptr, &to_evict, list)
  1064                  hfi1_mmu_rb_remove(&pq->sdma_rb_root, &node->rb);
  1065  
  1066          return cleared;
  1067  }


regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
