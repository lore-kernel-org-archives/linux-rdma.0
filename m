From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: [PATCH] IB uverbs: add mthca user doorbell record support
Date: Mon, 11 Apr 2016 16:28:16 +0300
Message-ID: <20160411132816.GA27298@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Roland Dreier,

The patch 56483ec1b702: "[PATCH] IB uverbs: add mthca user doorbell
record support" from Jul 7, 2005, leads to the following static
checker warning:

	drivers/infiniband/hw/mthca/mthca_memfree.c:483 mthca_map_user_db()
	warn: bool is not less than zero.

drivers/infiniband/hw/mthca/mthca_memfree.c
   481  
   482          ret = pci_map_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
   483          if (ret < 0) {

pci_map_sg() returns zero on failure and greater than zero on success.

   484                  put_page(pages[0]);
   485                  goto out;
   486          }
   487  
   488          ret = mthca_MAP_ICM_page(dev, sg_dma_address(&db_tab->page[i].mem),
   489                                   mthca_uarc_virt(dev, uar, i));
   490          if (ret) {
   491                  pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
   492                  put_page(sg_page(&db_tab->page[i].mem));
   493                  goto out;
   494          }
   495  
   496          db_tab->page[i].uvirt    = uaddr;
   497          db_tab->page[i].refcount = 1;
   498  
   499  out:
   500          mutex_unlock(&db_tab->mutex);
   501          return ret;
   502  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
