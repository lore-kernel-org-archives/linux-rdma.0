From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Status of "ummunot" branch?
Date: Mon, 10 Jun 2013 09:17:55 +0000
Message-ID: <D554B471892C914E90E136467281724DAD6956E0@MTLDAG01.mtl.com>
References: <51AF3FA8.7000900@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
 <20130605171426.GC30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
 <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com> <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
 <20130607235731.GA25942@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130607235731.GA25942-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here are a few more clarifications:

1) ODP MRs can cover address ranges that do not have a mapping at registration time.

This means that MPI can register in advance, say, the lower GB's of the address space, covering malloc's primary arena.
Thus, there is no need to adjust to each increase in sbrk().

Similarly, you can register the stack region up to the maximum size of the stack.
The stack can grow and shrink, and ODP will always use the current mapping.

2) Virtual addresses covered by an ODP MR must have a valid mapping when they are is accessed (during send/receive WQE processing or as a target of an RDMA/atomic operation).
So, Jeff, the only thing you need to make sure is that you don't free() a buffer that you posted and haven't got a completion yet - but I guess that this is something that you already do... :)

For example, in the following scenario:
a. reg_mr(first GB of the address space)

b. p = malloc()
c. post_send(p)
d. poll for completion
e. free(p)

f. p = malloc()
g. post_send(p)
h. poll for completion
i. free(p)

(c) may incur a page fault (if not pre-fetched or faulted-in by another thread).
(e) happens after the completion, so it is guaranteed that (c), when processed by HW, uses the correct application buffer with the current virt-to-phys mapping (at HW access time)

The reallocation may or may not change the virtual-to-physical mappings.
The message may or may not be paged out (ODP does not hold a reference on the page).
In any case, when (g) is processed, it always uses the current mapping.

--Liran



-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
Sent: Saturday, June 08, 2013 2:58 AM
To: Jeff Squyres (jsquyres)
Cc: Haggai Eran; Or Gerlitz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Shachar Raindel
Subject: Re: Status of "ummunot" branch?

On Fri, Jun 07, 2013 at 10:59:43PM +0000, Jeff Squyres (jsquyres) wrote:

> > I don't think this covers other memory regions, like those added via mmap, right?
>  
> We talked about this at the MPI Forum this week; it doesn't seem like 
> ODP fixes any MPI problems.

ODP without 'register all address space' changes the nature of the problem, and fixes only one problem.

You do need to cache registrations, and all the tuning parameters (how much do I cache, how long do I hold it for, etc, etc) all still apply.

What goes away (is fixed) is the need for intercepts and the need to purge address space from the cache because the backing registration has become non-coherent/invalid. Registrations are always coherent/valid with ODP.

This cache, and the associated optimization problem, can never go away. With a 'register all of memory' semantic the cache can move into the kernel, but the performance implication and overheads are all still present, just migrated.

> 2. MPI still has to intercept (at least) munmap().

Curious to know what for? 

If you want to prune registrations (ie to reduce memory footprint), this can be done lazyily at any time (eg in a background thread or something). Read /proc/self/maps and purge all the registrations pointing to unmapped memory. Similar to garbage collection.

There is no harm in keeping a registration for a long period, except for the memory footprint in the kernel.

> 3. Having mmap/malloc/etc. return "new" memory that may already be 
> registered because of a prior memory registration and subsequent 
> munmap/free/etc. is just plain weird.  Worse, if we re-register it, 
> ref counts could go such that the actual registration will never 
> actually expire until the process dies (which could lead to processes 
> with abnormally large memory footprints, because they never actually 
> let go of memory because it's still registered).

This is entirely on the registration cache implementation to sort out, there are lots of performance/memory trade offs.

It is only weird when you think about it in terms of buffers. memory registration has to do with address space, not buffers.

> What MPI wants is:
> 
> 1. verbs for ummunotify-like functionality 2. non-blocking memory 
> registration verbs; poll the cq to know when it has completed

To me, ODP with an additional 'register all address space' semantic, plus an asynchronous prefetch does both of these for you.

1. ummunotify functionality and caching is now in the kernel, under
   ODP. RDMA access to an 'all of memory' registration always does the
   right thing.
2. asynchronous prefetch (eg as a work request) triggers ODP and
   kernel actions to ready a subset of memory for RDMA, including
   all the work that memory registration does today (get_user_pages,
   COW break, etc)
   
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
