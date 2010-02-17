From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: is it possible to avoid syncing after an rdma write?
Date: Wed, 17 Feb 2010 15:25:19 -0700
Message-ID: <20100217222519.GJ16490@obsidianresearch.com>
References: <4B7B2A6C.80101@oracle.com> <20100217005827.GF16490@obsidianresearch.com> <4B7C4984.9050004@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B7C4984.9050004-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 17, 2010 at 11:54:44AM -0800, Andy Grover wrote:

> > What do you intend to replace the SEND with? spin on last byte? There
> > are other issues to consider like ordering within the PCI-E fabric..
> 
> Well, hopefully nothing. What I'm looking for is to write to a target
> region multiple times, as efficiently as possible, but be able to
> occasionally read it on the target machine and get consistent results. I
> definitely don't want to take an event, and avoiding the CQE would be nice.

Ahhh, interesting, I've thought about doing something like that as
well. Sounds to me like you want to often RDMA WRITE some state
information and have the CPU read that state from time to time, ie
some kind of pointer values or whatever.

I didn't come to a satisfactory method and gave up on the idea..

IMHO, the critical problem to solve is that you cannot re-write over
the same region again and again. Guaranteeing CPU and RDMA consistency
is hard. For instance if the CPU reads two 64 bit values from your
WRITE region there is no way to guarentee anything about them, other
than all of the bytes were written at some point by the far side.

For instance, a 32 bit CPU might read a 64 bit value with two memory
transactions and there is no chance of guaranteed coherence.

Basically, it depends on your requirements for the data. If you have
an array of 32 bit values that have no inter-relationships then I
think it can work OK. Anything else becomes alot harder.

> What I'm hearing is that I don't have to worry about what the Linux
> DMA-API docs say about noncoherent mappings, but I need to be mindful of
> IB spec 9.5 section o9-20:

You cannot ignore it completely, but to support userspace there is a
way to ensure you get the right kind of mapping for this to work.

> So if I do an RDMA write and follow it up with an atomic op, it sounds
> like I can achieve the behavior I want, and without an event or CQE.
> Although for my particular use case with ongoing writes, the CPU
> couldn't fetch more than one value (64bit?) without potentially reading
> data from a later write, I would think.

You don't need the atomic at all, it doesn't do anything if you intend
to start another RDMA WRITE to the same memory soon. The problem you
face is not knowing when the last write finished but knowing when the
next write is going to start.

sizeof(atomic_t) is probably all you get, which will be 32 bits on 32
bit Linux.

For instance, a strategy that can work OK would to have an array of
your states and the far side RDMA WRITEs into consecutive positions
and uses an unsignaled immediate data to indicate the tail. The recv
side runs through the CQEs and determines the latest write region. If
you run out of slots or out of CQEs then the sender waits for more..

Or replace the immediate data with a last-byte-written poll (like MPI).

Either way, the key is that you are never writing twice without
synchronizing both sides.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
