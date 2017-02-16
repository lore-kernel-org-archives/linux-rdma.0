From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 03/14] cxgb3: Update to use new udma write barriers
Date: Thu, 16 Feb 2017 16:01:15 -0600
Message-ID: <066c01d288a0$317b1320$94713960$@opengridcomputing.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com> <1487272989-8215-4-git-send-email-jgunthorpe@obsidianresearch.com> <062e01d2889a$8ff847c0$afe8d740$@opengridcomputing.com> <20170216214527.GA13616@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170216214527.GA13616-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Thu, Feb 16, 2017 at 03:20:56PM -0600, Steve Wise wrote:
> 
> > Hey Jason, is it possible the omission on these was never detected because
the
> > memory for cq (and sq and rq) queues is allocated in the kernel by
> > dma_alloc_coherent(), and mapped to the process's address space?
> 
> If the pgprot in userspace is UC then the odds of having a problem are
> much lower (but IIRC dma_alloc_coherent does not do that on
> x86?).
> 
> But DMA coherent memory explicitly doesn't save you from requiring
> barriers and it is still playing with fire as the compiler doesn't
> know the memory is UC and can re-order loads improperly.
> 
> AFAIK, any arch that requires something special for dma_coherent
> mappings is already broken for libibverbs in user space - as we do not
> have any cache flushing support. So it sort of makes sense to use it
> in the kernel, but if it produces anything other than cached memory
> things will go terribly wrong for that arch when using libibverbs.
> 
> I suspect the primary reason is cxgb3 simply got lucky and the
> compiler (that was tested) did not do anything bad, or place any
> dependent loads too closely to the valid bit load.
> 
> x86 is fairly forgiving.. And quite possibly if you test today with
> gcc 6 on ARM64 it might be broken?

Ok thanks for the explanation!

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
