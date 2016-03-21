From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Mon, 21 Mar 2016 11:09:54 -0600
Message-ID: <20160321170954.GA8151@obsidianresearch.com>
References: <20160225170541.GA22513@obsidianresearch.com>
 <56D31A58.20205@mellanox.com>
 <20160229191734.GA15042@obsidianresearch.com>
 <56D55851.60206@mellanox.com>
 <20160301172448.GA24031@obsidianresearch.com>
 <56D6979F.6000400@mellanox.com>
 <20160302182836.GA7084@obsidianresearch.com>
 <alpine.DEB.2.20.1603021300491.15609@east.gentwo.org>
 <20160302195138.GA8427@obsidianresearch.com>
 <56F01227.9050900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56F01227.9050900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 21, 2016 at 05:24:23PM +0200, Matan Barak wrote:

> Our performance team and I measured the new ibv_poll_cq_ex vs the old
> poll_cq implementation. We measured the number of cycles around the poll_cq
> call. We saw ~15 cycles increase for every CQE, which is about 2% over the
> regular poll_cq (which is not extensible). We've used ib_write_lat in order
> to do these measurements.

So you understand my concern, this really ugly interface is
obstensibly designed this way for performance and yet it is 2% slower
than what we have today. :(

> Using a per field getter introduces such a call (unconditional jump) for
> every field.

As I keep saying, there is an overall trade off that could reduce the
number of jumps and code being run.

> In addition, the user has to call read_next_cq for every completion entry
> (which is another unconditional jump).

This is just replacing the loop inside the existing ibv_poll_cq_ex,
the number of overall jumps doesn't change.

> >opcode = cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK;
> >wc->flags |= WITH_IMM_BIT << ((unsigned int)(opcode == MLX4_RECV_OPCODE_RDMA_WRITE_IMM ||
> >                                             opcode == MLX4_RECV_OPCODE_SEND_IMM ...))
> >
> >I bet that is a lot less work going on, even including the indirect
> >jump overhead.
> >
> 
> So we would have read the owner_sr_opcode several times (for almost every
> related wc field)

No, I think you've missed the point, the accessors pretty much just
return fixed offsets in the HW WC. From what I've seen the HW WC looks
well structured, so, eg, the offset of the timestamp field is fixed.
No need to check owner_sr_opcode again.

> "copying" it. In addition, we'll need another API (end_cq) in order to
> indicate return-cq-element-to-hardware-ownership (and release vendor's per
> poll_cq locks if exist). So, as far as we understand, you propose
> something

Yes, I mentioned this, some kind of completion batching scheme would
be needed.

This could actually prove to be a net win, depending on how carefully
it is designed and typical application needs. The current batch every
poll_cq loop is not necessarily ideal.

> Again, every call here introduces an unconditional jump and makes the CQ
> structure larger. So, the CQ struct itself might not fit in the cache line.

Don't obsess so much about 1 or two cache lines in this sort of
context. Burning a large number of stack lines for the wc array is
bad of course, but an extra line isn't so bad, especially if it
is offset by an icache line.

> In addition, ibv_cq isn't extensible as it's today. Addign a new ibv_cq_ex
> will change all APIs that use it.

Not really, it just makes the structure longer, this is trivially
done.

> The current optimization we implement in our user-space drivers is to
> introduce multiple poll_one_ex functions, where every function assigns only
> some of the WC fields. Each function is tailored for a different use case
> and common scenario. By doing this, we don't assign fields that the user
> doesn't care about and we can avoid all conditional branches.

But the provider can't cover all cases - so uncommon cases will run
slow? Do you understand why I keep calling this a horrible API?

> Look at the new code for libmlx5. This code is optimized *at compile time*.
> We create a poll_one_ex function for a common case. This has zero overhead.

I didn't see this on patchworks. Do you have a link?

Even if the wc_flags is constant and thus optimized there is still
alot of opcode related branching and ++'s running around that
code. That is 'free' in the sense is similar to what is in the
existing implementation, but I'm suggesting a direction that largely
merges those branches with the mandatory user branches as well.

> >What I've suggested avoids all the cache line dirtying and avoids all
> >the above conditional branching and data dependencies at the cost of
> >a few indirect unconditional jumps. (and if #5 is possible they aren't
> >even jumps)
> >
> 
> When eliminating "if (wc_flags & IBV_WC_EX_WITH_IMM)" in the user's space
> application, conditional branching is eliminated in this proposal as well.

Just the wc_flags branching is gone, there is still excess branching
around the opcode that is eliminated.

> The question becomes - what costs more - copying the data or using an
> unconditional branch.

This will depend very much on how many completions are being
processed in one go. Copying is almost certainly better for a small
number of completions - but if there is a small number then why care
so much about dcache lines?

> Dynamic WC format (or getter functions) isn't going to be free, at
> least not without linking the vendor's user-space driver to the
> application itself or making all vendors behave the same.

I don't think this should be so quickly discounted - clearly this API
allows for the accessors to be fully inlined if the user desires, and
you can't beat that for performance.

At the very least it, or some other better API option, deserves study
and benchmarking before comitting to the ugly API.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
