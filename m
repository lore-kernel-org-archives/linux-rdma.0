From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: kernel memory registration (was: RDMA/core: Transport-independent
 access flags)
Date: Fri, 10 Jul 2015 11:55:29 +0300
Message-ID: <559F8881.7070308@dev.mellanox.co.il>
References: <559B9891.8060907@dev.mellanox.co.il>
 <000b01d0b8bd$f2bfcc10$d83f6430$@opengridcomputing.com>
 <20150707161751.GA623@obsidianresearch.com>
 <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com> <559D983D.6000804@talpey.com>
 <20150708233604.GA20765@obsidianresearch.com>
 <559E54AB.2010905@dev.mellanox.co.il>
 <20150709170142.GA21921@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709170142.GA21921-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 8:01 PM, Jason Gunthorpe wrote:
> On Thu, Jul 09, 2015 at 02:02:03PM +0300, Sagi Grimberg wrote:
>
>> We have protocol that involves remote memory keys transfer in their
>> standards so I don't see how we can remove it altogether from ULPs.
>
> This is why I've been talking about local and remote MRs
> differently.

IMHO, memory registration is memory registration. The fact that we are
distinguishing between local and remote might be a sign that this might
be a wrong direction to take. Sorry.

Besides, if a ULP wants to register memory for local access why should
we temper with that or deny it?

What if a ULP has a pre-allocated pool of large buffers that it knows
it is going to use for its entire lifetime? silent driver driven FRWRs
would perform a lot worse than pre-registering these buffers.

Or what if the ULP wants to register the memory region with data
integrity (signature) parameters?

I must say, whenever I find myself trying to assume/guess what the
ULP/APP might do from the driver PoV and try to see if I'm covered,
I shake my head saying:
"This is a hack, go drink some water and rethink the whole thing".

If there is one thing worse than a complicated API, it is a restrictive
one. I'd much rather ULPs just having a simple API for registering
memory.

> A Local MR is one where the Key is never put on the wire,
> it exists soley to facilitate DMA between the CPU and the local HCA,
> and it would never be needed if we had infinitely long S/G lists.
>
>> My main problem with this approach is that once you do non-trivial
>> things such as memory registration completely under the hood, it is
>> a slippery slope for device drivers.
>
> Yes, there is going to be some stuff going on, but the simplification
> for the ULP side is incredible, it is certainly something that should
> be explored and not dismissed without some really good reasons.
>
>> If say a driver decides to register memory without the caller knowing,
>> it would need to post an extra work request on the send queue.
>
> Yes, the first issue is how to do flow control the sendq.
>
> But this seems easily solved, every ULP is already tracking the
> number of available entries in the senq, and it will not start new ops
> until there is space, so instead of doing the computation internally
> on how much space is needed to do X, we factor it out:
>
>     if (rdma_sqes_post_read(...) < avail_sqe)
>       avail_sqe -= rdma_post_read(...)
>     else
>       // Try again after completions advance
>
> Every new-style post op is paired with a 'how many entires do I need'
> call.
>
> This is not a new concept, a ULP working with FRMR already has to know
> it cannot start a FRMR using OP unless there is 2 SQE's
> available. (and it has to make all this conditional on if it using
> FRMR or something else). All this is doing is shifting the computation
> of '2' out of the ULP and into the driver.
>
>> So once it sees the completion, it needs to silently consume it and
>> have some non trivial logic to invalidate it (another work request!)
>> either from poll_cq context or another thread.
>
> Completions are driven by the ULP. Every new-style post also has a
> completion entry point. The ULP calls it when it knows the op has
> done, either because the WRID it provided has signaled completed, or
> because a later op has completed (signalling was supressed).
>
> Since that may also be an implicitly posting API (if necessary, is
> it?), it follows the same rules as above. This isn't changing
> anything. ULPs would already have to drive invalidate posts from
> completion with flow control, we are just moving the actul post
> construction and computation of the needed SQEs out of the ULP.
>
>> This would also require the drivers to take a huristic approach on how
>> much memory registration resources are needed for all possible
>> consumers (ipoib, sdp, srp, iser, nfs, more...) which might have
>> different requirements.
>
> That doesn't seem like a big issue. The ULP can give a hint on the PD
> or QP what sort of usage it expects. 'Up to 16 RDMA READS' 'Up to 1MB
> transfer per RDMA' and the core can use a pre-allocated pool scheme.
>
> I was thinking about a pre-allocation for local here, as Christoph
> suggests, I think that is a refinement we could certainly add on, once
> there is some clear idea what allocations are acutally necessary to
> spin up a temp MR. The basic issue I'd see is that the preallocation
> would be done without knowledge of the desired SG list, but maybe some
> kind of canonical 'max' SG could be used as a stand in...
>
> Put together, it would look like this:
>     if (rdma_sqes_post_read(...) < avail_sqe)
>           avail_sqe -= rdma_post_read(qp,...,read_wrid)
>    [.. fetch wcs ...]
>     if (wc.wrid == read_wrid)
>          if (rdma_sqes_post_complete_read(...,read_wrid) < avail_sqe)
> 	      rdma_post_complete_read(qp,...,read_wrid);
>          else
> 	      // queue read_wrid for later rdma_post_complete_read
>
> I'm not really seeing anything here that screams out this is
> impossible, or performance is impacted, or it is too messy on either
> the ULP or driver side.

I think it is possible (at the moment). But I don't know if we should
have the drivers abusing the send/completion queues like that.

I can't say I'm fully on board with the idea of silent send-queue
posting and silent completion consuming.

>
> Laid out like this, I think it even means we can nuke the IB DMA API
> for these cases. rdma_post_read and rdma_post_complete_read are the
> two points that need dma api calls (cache flushes), and they can just
> do them internally.
>
> This also tells me that the above call sites must already exist in
> every ULP, so we, again, are not really substantially changing
> core control flow for the ULP.
>
> Are there more details that wreck the world?
>
> Just to break it down:
>    - rdma_sqes_post_read figures out how many SQEs are needed to post
>      the specified RDMA READ.
>        On IB, if the SG list can be used then this is always 1.
>        If the RDMA READ is split into N RDMA READS then it is N.
>        For something like iWarp this would be (?)
>          * FRMR SQE
> 	* RDMA READ SQE
> 	* FRMR Invalidate (signaled)
>
>        Presumably we can squeeze FMR and so forth into this scheme as
>        well? They don't seem to use SQE's so it is looks simpler..
>
>        Perhaps if an internal MR pool is exhausted this returns 0xFFFF
>        and the caller will do a completion cycle, which may provide
>        free MR's back to the pool. Ultimately once the SQ and CQ are
>        totally drained the pool should be back to 100%?
>    - rdma_post_read generates the necessary number of posts.
>      The SQ must have the right number of entires available
>      (see above)
>    - rdma_post_complete_read is doing any clean up posts to make a MR
>      ready to go again. Perhaps this isn't even posting?
>
>      Semantically, I'd want to see rdma_post_complete_read returning to
>      mean that the local read buffer is ready to go, and the ULP can
>      start using it instantly. All invalidation is complete and all
>      CPU caches are sync'd.
>
>      This is where we'd start the recycling process for any temp MR,
>      whatever that means..
>
> I expect all these calls would be function pointers, and each driver
> would provide a function pointer that is optimal for it's use. Eg mlx4
> would provide a pointer that used the S/G list, then falls back to
> FRMR if the S/G list is exhausted. The core code would provide a
> toolbox of common functions the drivers can use here.

Maybe it's just me, but I can't help but wander if this is facilitating
an atmosphere where drivers will keep finding new ways to abuse even
the most simple operations.

I need more time to comprehend.

>
> I didn't explore how errors work, but, I think, errors are just a
> labeling exercise:
>    if (wc is error && wc.wrid == read_wrid
>       rdma_error_complete_read(...,read_wrid,wc)
>
> Error recovery blows up the QP, so we just need to book keep and get
> the MRs accounted for. The driver could do a synchronous clean up of
> whatever mess is left during the next create_qp, or on the PD destroy.
>
>> I know that these are implementation details, but the point is that
>> vendor drivers can easily become a complete mess. I think we should
>> try to find a balanced approach where both consumers and providers are
>> not completely messed up.
>
> Sure, but today vendor drivers and the core is trivial while ULPs are
> an absolute mess.
>
> Goal #1 should be to move all the mess into the API and support all
> the existing methods. We should try as hard as possible to do that,
> and if along the way, it is just isn't possible, then fine. But that
> should be the first thing we try to reach for.
>
> Just tidying FRMR so it unifies with indirect, is a fine consolation
> prize, but I believe we can do better.
>
> To your point in another message, I'd say, as long as the new API
> supports FRMR at full speed with no performance penalty we are
> good. If the other variants out there take a performance hit, then I
> think that is OK. As you say, they are on the way out, we just need to
> make sure that ULPs continue to work with FMR with the new API so
> legacy cards don't completely break.

My intention is to improve FRWR API and gradually remove the other APIs
from the kernel (i.e. FMR/FMR_POOL/MW). As I said, I don't think that
striving to an API that implicitly chooses how to register memory is a
good idea.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
