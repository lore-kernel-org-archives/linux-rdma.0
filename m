From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Pro/Cons of send/receive/read/write operations?
Date: Wed, 10 Nov 2010 17:35:00 -0700
Message-ID: <20101111003500.GF23923@obsidianresearch.com>
References: <20101110101416.p006bad7hyc88wog@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101110101416.p006bad7hyc88wog-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 10, 2010 at 10:14:16AM -0700, ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org wrote:

> It seems there are several ways to transfer data via RDMA: Send/Send
> w/immediate, Receive, RDMA Write/RDMA Write w/immediate, the Atomic
> extensions, and then the various transport modes variations with
> some of these operations.  As an RDMA/IB newbie, it is somewhat
> confusing when determining the best operations for my application.
> What are the various pros/cons of each?

Well, there really are quite a few trade offs, typically the main
issue for RDMA systems should be in managing the data buffers across
the whole application. A big cost in RDMA is registering buffers so
you want to design a scheme that minimizes how often that is done.

Some basic patterns you can consider:
 - SEND is used for small messaging and one of the small messages is
   'I want to send you a large message, give me parameters for RDMA
    WRITE'
 - Or above with 'here is where you can RDMA READ' from. Writes
   are better than reads, as there are HW limits on parallel read
   requests.
 - You use SEND for everything and allocate 16MB recv buffers
 - You construct a stream semantic (like TCP) using RDMA_WRITE. This
   is useful if the data is consumed in some way and then discarded
   right away.

You can start by reflecting on where the data is coming from and where
it is headed and use that to devise a buffer management strategy.

The choice of SEND/READ/WRITE will be more evident once you understand
how you want your data to flow. 

You almost always want to use RC connections, and if you needed to use
Atomic's you'd probably know already :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
