From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
Date: Thu, 8 Dec 2011 09:47:18 -0800
Message-ID: <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com>
References: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Any help would be appreciated. Would a firmware upgrade make a difference?

Almost certainly not a firmware issue.

 > [  597.412843] kernel BUG at drivers/iommu/intel-iommu.c:1767!

So this is

        BUG_ON(addr_width < BITS_PER_LONG && (iov_pfn + nr_pages - 1)
>> addr_width);

in __domain_mapping() I believe.  And we have:

        int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;

How much RAM does you system have?

I don't know too much about the low-level VT-d details, but is it
possible the setup code
is choosing a too small "guest address width" to cover all your memory?

drivers/net/ethernet/mellanox/mlx4/main.c has

        err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
        if (err) {
                dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI
DMA mask.\n");
                err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
                if (err) {
                        dev_err(&pdev->dev, "Can't set PCI DMA mask,
aborting.\n");
                        goto err_release_regions;
                }
        }
        err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
        if (err) {
                dev_warn(&pdev->dev, "Warning: couldn't set 64-bit "
                         "consistent PCI DMA mask.\n");
                err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
                if (err) {
                        dev_err(&pdev->dev, "Can't set consistent PCI
DMA mask, "
                                "aborting.\n");
                        goto err_release_regions;
                }
        }

do you see any warnings in your kernel log about setting the PCI DMA mask?
(in any case that should only affect bus addresses, not "guest addresses")

David, any idea?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
