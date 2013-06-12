From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 12 Jun 2013 15:47:08 -0600
Message-ID: <20130612214708.GD8625@obsidianresearch.com>
References: <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com>
 <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
 <20130607235731.GA25942@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59@xmb-rcd-x01.cisco.com>
 <20130610172627.GC2391@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F680A2B@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F680A2B-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 12, 2013 at 09:18:34PM +0000, Jeff Squyres (jsquyres) wrote:

> > Well, it creates a mess in another sense, because now you've lost
> > context. When your MPI goes to do a 1byte send the kernel may well
> > prefetch a few megabytes of page tables, whereas an implementation in
> > userspace still has the context and can say, no I don't need that..
> 
> It seems like there are Big Problems on either side of this problem
> (userspace and kernel).
> 
> I thought that ummunotify was a good balance between the two -- MPI
> kept its registration caches (which are annoying, but we have
> long-since understood that *someone* has to maintain them), but it
> gets a bulletproof way to keep them coherent.  That is what is
> missing in today's solutions: bulletproofness (plus we have to use
> the horrid glibc malloc hooks, which are deprecated and are going
> away).

Ditto.

Someone has to finish the ummunotify rewrite Roland
started. Realistically MPI is going to be the only user, can someone
from the MPI world do this?
 
> > It doesn't matter if there is no memory mapped to the address space,
> > the address space is still there.
> > 
> > Liran had a good example. You can register address space and then use
> > mmap/munmap/MAP_FIXED to mess around with where it points to
> 
> ...but this is not how people write applications.  Real apps use
> malloc (and some direct mmap, and perhaps even some shared memory).

*shrug* I used MAP_FIXED for some RDMA regions in my IB verbs apps,
specifically to create specalized high-performance memory
structures.

It isn't a general purpose technique for non-RDMA apps - but
especially when combined with ODP it is useful in some places.

> > A practical example of using this would be to avoid the need to send
> > scatter buffer pointers to the remote. The remote writes into a memory
> > ring and the ring is made 'endless' by clever use of remapping.
> 
> I don't understand -- please explain your example a bit more...?

You have a memory pool.

There are two mappings to this physical memory, one for the CPU to
use, one for RDMA to use.

The RDMA mapping is a linear ring, the remote just spews linearly via
RDMA WRITE.

When messages arrive the CPU xlates the RDMA ring virtual address to
the CPU address, and accesses the memory from there.

It then finds a free block in the memory pool and remaps it into the
RDMA pool and tells the remote that there is more free memory.

>From the perspective of the remote this creates an endless, apparently
linear, ring.

When the CPU is done with its memory it adds it back to free block
pool.

At the start of time the RDMA ring maps 1:1 to the CPU pool.  As xfers
happen the RDMA rings maps non-linearly depending on when the CPU is
done with the memory.

There are lots of details to make this work, but you avoid sending s/g
lists, and generally make communication more asynchronous.

s/g lists are expensive. A 1GB ring requires nearly 2MB to describe
with s/g lists, and a 40GB nic can turn that ring over 4 times per
second!

You can do something similar with sends, but sends have to
pre-size buffers, wheras this scheme lets you send any size message
with optimal memory usage.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
