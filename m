From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: RDMA/cxgb4: Support on-chip SQs
Date: Wed, 30 Jan 2013 15:36:48 -0600
Message-ID: <51099270.5070406@opengridcomputing.com>
References: <20130130210006.GA22134@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130130210006.GA22134-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I wonder, then, what the correct service is to get the cpu physical 
address from a kernel virtual address returned from 
dma_alloc_coherent()?  I think this is correct as-is, since I think 
dma_alloc_coherent() falls under the "directly mapped" addresses in the 
virt_to_phys() prototype comment.

What do you think Roland?

On 1/30/2013 3:00 PM, Dan Carpenter wrote:
> Hello Steve Wise,
>
> The patch c6d7b26791a2: "RDMA/cxgb4: Support on-chip SQs" from Sep
> 13, 2010, leads to the following warning:
> "drivers/infiniband/hw/cxgb4/qp.c:98 alloc_host_sq()
> 	error: 'sq->queue' came from dma_alloc_coherent() so we can't
> 	do virt_to_phys()"
>
> drivers/infiniband/hw/cxgb4/qp.c
>      92  static int alloc_host_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
>      93  {
>      94          sq->queue = dma_alloc_coherent(&(rdev->lldi.pdev->dev), sq->memsize,
>      95                                         &(sq->dma_addr), GFP_KERNEL);
>      96          if (!sq->queue)
>      97                  return -ENOMEM;
>      98          sq->phys_addr = virt_to_phys(sq->queue);
>      99          pci_unmap_addr_set(sq, mapping, sq->dma_addr);
>     100          return 0;
>     101  }
>
> This is a new Smatch check.  I don't know the rules on virt_to_phys yet
> but here is the relevant comment.
>
> /**
>   *      virt_to_phys    -       map virtual addresses to physical
>   *      @address: address to remap
>   *
>   *      The returned physical address is the physical (CPU) mapping for
>   *      the memory address given. It is only valid to use this function on
>   *      addresses directly mapped or allocated via kmalloc.
>   *
>   *      This function does not give bus mappings for DMA transfers. In
>   *      almost all conceivable cases a device driver should not be using
>   *      this function
>   */
>
> regards,
> dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
