From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/mthca: remove deprecated use of pci api
Date: Tue, 17 Feb 2015 10:33:30 -0800
Message-ID: <CAL1RGDU7cnR=uszxLiACEc8rLUty2T6Z6bZVx+_YjSzb9WpsZQ@mail.gmail.com>
References: <20150204140911.GA23076@sloth>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150204140911.GA23076@sloth>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Quentin Lambert <lambert.quentin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 4, 2015 at 6:09 AM, Quentin Lambert
<lambert.quentin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> -       dev->eq_table.icm_dma  = pci_map_page(dev->pdev, dev->eq_table.icm_page, 0,
> -                                             PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
> -       if (pci_dma_mapping_error(dev->pdev, dev->eq_table.icm_dma)) {
> +       dev->eq_table.icm_dma  = dma_map_page(&dev->pdev->dev,
> +                                             dev->eq_table.icm_page, 0,
> +                                             PAGE_SIZE,
> +                                             (enum dma_data_direction)PCI_DMA_BIDIRECTIONAL);

Surely this can't be right?  Shouldn't the direction just change to
DMA_BIDIRECTIONAL?

Are we really sweeping through the kernel and getting rid of pci_map_
etc. calls?

If so please respin your semantic patch so that it doesn't add crazy stuff like

    (enum dma_data_direction)PCI_DMA_BIDIRECTIONAL

and resend the change.

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
