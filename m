From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/usnic: Add Cisco VIC low-level hardware driver
Date: Thu, 12 Oct 2017 15:57:55 +0300
Message-ID: <20171012125754.wh6rkkeh6yyo2wpj@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Upinder Malhi,

The patch e3cf00d0a87f: "IB/usnic: Add Cisco VIC low-level hardware
driver" from Sep 10, 2013, leads to the following static checker
warning:

	drivers/infiniband/hw/usnic/usnic_uiom.c:366 usnic_uiom_reg_get()
	warn: overflowed symbol reused:  'size'

drivers/infiniband/hw/usnic/usnic_uiom.c
   335  struct usnic_uiom_reg *usnic_uiom_reg_get(struct usnic_uiom_pd *pd,
   336                                                  unsigned long addr, size_t size,
                                                                            ^^^^^^^^^^^
The size is comes from the user.  The call tree is:

  ib_uverbs_reg_mr() <-- does a copy_from_user()
    -> pd->device->reg_user_mr()
       -> usnic_ib_reg_mr()
          -> usnic_uiom_reg_get()

   337                                                  int writable, int dmasync)
   338  {
   339          struct usnic_uiom_reg *uiomr;
   340          unsigned long va_base, vpn_start, vpn_last;
   341          unsigned long npages;
   342          int offset, err;
   343          LIST_HEAD(sorted_diff_intervals);
   344  
   345          /*
   346           * Intel IOMMU map throws an error if a translation entry is
   347           * changed from read to write.  This module may not unmap
   348           * and then remap the entry after fixing the permission
   349           * b/c this open up a small windows where hw DMA may page fault
   350           * Hence, make all entries to be writable.
   351           */
   352          writable = 1;
   353  
   354          va_base = addr & PAGE_MASK;
   355          offset = addr & ~PAGE_MASK;
   356          npages = PAGE_ALIGN(size + offset) >> PAGE_SHIFT;
                         ^^^^^^^^^^^^^^^^^^^^^^^^^
size + offset can wrap and PAGE_ALIGN() has an addition as well.

   357          vpn_start = (addr & PAGE_MASK) >> PAGE_SHIFT;
   358          vpn_last = vpn_start + npages - 1;
   359  
   360          uiomr = kmalloc(sizeof(*uiomr), GFP_KERNEL);
   361          if (!uiomr)
   362                  return ERR_PTR(-ENOMEM);
   363  
   364          uiomr->va = va_base;
   365          uiomr->offset = offset;
   366          uiomr->length = size;
                                ^^^^
The test is trying to be a tiny bit smart by not immediately complaining
about the user controlled integer overflow but instead waiting to see if
we use "size" again.  I don't know if this code has a real bug.  I'm
casting about trying to find a heuristic which is easy enough for static
analysis but doesn't have too many false positives.

   367          uiomr->writable = writable;
   368          uiomr->pd = pd;
   369  
   370          err = usnic_uiom_get_pages(addr, size, writable, dmasync,
   371                                          &uiomr->chunk_list);
   372          if (err) {
   373                  usnic_err("Failed get_pages vpn [0x%lx,0x%lx] err %d\n",
   374                                  vpn_start, vpn_last, err);
   375                  goto out_free_uiomr;
   376          }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
