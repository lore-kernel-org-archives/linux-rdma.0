From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: SR-IOV with mlx4 on ConnectX-2 fails with DMAR errors
Date: Wed, 14 Dec 2016 15:38:23 -0700
Message-ID: <20161214223823.GA9986@obsidianresearch.com>
References: <CAN27Ff4RYh3y_45PUxxXhGuDvrrrjm8qe38fj5JPq7oV2QmdYA@mail.gmail.com>
 <CAN27Ff74Ov8bgsZP1QJJOwvWc5_KOW_U=PsP+=Z87AJz+VSAOw@mail.gmail.com>
 <20161213165441.GB11099@obsidianresearch.com>
 <CAN27Ff7hEr4u5nyELjwRXb3W_t0TNefuuT4AzdjAoWWGRHqTFw@mail.gmail.com>
 <20161213190102.GA15119@obsidianresearch.com>
 <CAN27Ff4P_11FQ-VuiPcL4S67uVh4xSJpqyZ0Q4AbPfd64fmO9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAN27Ff4P_11FQ-VuiPcL4S67uVh4xSJpqyZ0Q4AbPfd64fmO9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joshua McBeth <joshua.mcbeth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 14, 2016 at 10:06:13AM -0500, Joshua McBeth wrote:

> > Does this make your 4.8 kernel work? If yes, then I suspect mlx4 has
> > broken IB_DEVICE_LOCAL_DMA_LKEY with SRIOV.. Leon? mlx5 has this
> > broken, doesn't it?

> With 4.8.1 and the below applied to the SR-IOV host and guest kernels,
> SR-IOV functions in both the SR-IOV host and guests and there are no
> DMAR errors emitted.

So strange.

Looking at your original report you see these errors:

[  107.137484] DMAR: [DMA Read] Request device [05:06.1] fault addr

But I don't see where 05:06.01 is a PCI device. That seems like a big
problem.

Based on that this looks like a Mellanox bug where
IB_DEVICE_LOCAL_DMA_LKEY is causing the wrong PCI BDF to be provided
as the requestor. Mellanox will have to help you futher, you are
running the latest firmware, right?

> The NFS/RDMA client in the guest does not work on the SR-IOV virtual
> function with the NFS/RDMA server of the host on the SR-IOV physical
> function, but this may be something else I need to troubleshoot
> further, as both IPoIB and synthetic RDMA traffic passes between the
> guest, host, and remote node just fine.  The remote node's NFS/RDMA
> client is additionally able to function with the host's NFS/RDMA
> server on the SR-IOV physical function.

Try removing IB_DEVICE_LOCAL_DMA_LKEY from the mlx4 driver entirely..

> > It would also be very helpful to try and determine what memory the NIC is
> > trying to read.. If it is the ipoib packet or some mlx4 internal
> > thing.

> How can I determine this?

Print out the dma address of the skb when the SEND is submitted in
ipoib and see if it is similar to the DMAR region..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
