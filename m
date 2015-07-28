From: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with pd->local_dma_lkey
Date: Tue, 28 Jul 2015 11:01:12 -0400
Message-ID: <mp85i7$6hc$1@ger.gmane.org>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

"Jason Gunthorpe" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote in message 
news:1437608083-22898-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMK2raWmgRF17@public.gmane.org

> This series moves dealing with the safe all physical mr:
>
>  ib_get_dma_mr(pd,IB_ACCESS_LOCAL_WRITE);
>
> Into ib_alloc_pd, and in the process makes the global local_dma_lkey functionality
> broadly enabled for all ULPs.

> The remaining users of ib_get_dma_mr are all unsafe:

[snip]

> Calling ib_get_dma_mr with IB_ACCESS_REMOTE_* flags is considered to be a
> serious security problem and should not be done without the user directly
> opting in to an off-by-default scheme. The call allows the peer on the QP
> unrestricted access to local physical memory if they can guess the rkey value.
>
> A future series will cause the kernel to be tainted by the above call sites to
> promote migrating away from this.

[snip]

We use ib_get_dma_mr with IB_ACCESS_REMOTE_* flags in an embedded device environment (in a custom out-of-tree device driver).  Not 
to allow remote access to CPU memory but to allow remote access to PCIe device memory (the IB card makes peer accesses directly to 
other PCIe devices).

I understand the concerns about safety with ib_get_dma_mr but want to be sure there will be a way to "opt-in", as you describe 
above.  I can live with the tainting.

How is the opt-in done?  Is that via a kernel parameter?  Or via a module parameter on one of the IB core modules?  Some other way?

I'm trying to avoid having to run a modified kernel for our environment, so hope this is not a kernel compile option!

Thanks.

John Burr 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
