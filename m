From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 5 Jun 2013 13:05:29 -0600
Message-ID: <20130605190529.GA3044@obsidianresearch.com>
References: <51ADD489.3020902@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com>
 <51AEE53C.2090603@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855@xmb-rcd-x01.cisco.com>
 <51AF3FA8.7000900@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
 <20130605171426.GC30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
 <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 05, 2013 at 06:45:13PM +0000, Jeff Squyres (jsquyres) wrote:

> Hum.  I was under the impression that with today's code (i.e., not ODP), if you
> 
> a = malloc(N);
> ibv_reg_mr(..., a, N, ...);
> free(a);
> 
> (assuming that the memory actually left the process at free)
> 
> Then the relevant kernel verbs driver was notified, and would
> unregister that device.  ...but I'm an MPI guy, not a kernel guy --
> it seems like you're saying that my impression was wrong (which
> doesn't currently matter because we intercept free/sbrk and
> unregister such memory, anyway).

Sadly no, what happens is that once you do ibv_reg_mr that 'HCA
virtual address' is forever tied to the physical memory under the
'process virtual address' *at that moment* forever.

So in the case above, RDMA can continue after the free, and it
continues to hit the same *physical* memory that it always hit, but
due to the free the process has lost access to that memory (the kernel
keeps the physical memory reserved for RDMA purposes until unreg
though).

This is fundamentally why you need to intercept mmap/munmap/sbrk - if
the process's VM mapping is changed through those syscalls then the
HCA's VM and the process VM becomes de-synchronized.

> > 'magically be registered' is the wrong way to think about it - the
> > registration of VA=0x100 is simply kept, and any change to the
> > underlying physical mapping of the VA is synchronized with the HCA.
> 
> What happens if you:
> 
> a = malloc(N * page_size);
> ibv_reg_mr(..., a, N * page_size, ...);
> free(a);
> // incoming RDMA arrives targeted at buffer a

Haggai should comment on this, but my impression/expectation was
you'll get a remote protection fault/

> Or if you:
> 
> a = malloc(N * page_size);
> ibv_reg_mr(..., a, N * page_size, ...);
> free(a);
> a = malloc(N / 2 * page_size);
> // incoming RDMA arrives targeted at buffer a that is of length (N*page_size)

again, I expect a remote protection fault.

Noting of course, both of these cases are only true if the underlying
VM is manipulated in a way that makes the pages unmapped (eg
mmap/munmap, not free)

I would also assume that attempts to RDMA write read only pages
protection fault as well.

> It does seem quite odd, abstractly speaking, that a registration
> would survive a free/re-malloc (which is arguably a "different"
> buffer).

Not at all: the purpose of the registration is to allow access via
RDMA to a portion of the process's address space. The address space
doesn't change, but what it is mapped to can vary.

So - the ODP semantics make much more sense, so much so I'm not sure
we need a ODP flag at all, but that can be discussed when the patches
are proposed...

> That being said, it still seems like MPI needs a registration cache.
> It is several good steps forward if we don't need to intercept
> free/sbrk/whatever, but when MPI_Send(buf, ...) is invoked, we still
> have to check that the entire buf is registered.  If ibv_reg_mr(...,
> 0, 2^64, ...) was supported, that would obviate the entire need for
> registration caches.  That would be wonderful.

Yes, except that this shifts around where the registration overhead
ends up. Basically the HCA driver now has the registration cache you
had in MPI, and all the same overheads still exist. No free lunch
here :(

Haggai: A verb to resize a registration would probably be a helpful
step. MPI could maintain one registration that covers the sbrk
region and one registration that covers the heap, much easier than
searching tables and things.

Also bear in mind that all RDMA access protections will be disabled if
you register the entire process VM, the remote(s) can scribble/read
everything..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
