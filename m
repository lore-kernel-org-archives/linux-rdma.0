From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Wed, 2 Mar 2016 11:28:36 -0700
Message-ID: <20160302182836.GA7084@obsidianresearch.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
 <1456306924-31298-2-git-send-email-yishaih@mellanox.com>
 <20160224190230.GA10588@obsidianresearch.com>
 <56CEB4C7.60607@dev.mellanox.co.il>
 <20160225170541.GA22513@obsidianresearch.com>
 <56D31A58.20205@mellanox.com>
 <20160229191734.GA15042@obsidianresearch.com>
 <56D55851.60206@mellanox.com>
 <20160301172448.GA24031@obsidianresearch.com>
 <56D6979F.6000400@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D6979F.6000400-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 02, 2016 at 09:34:55AM +0200, Matan Barak (External) wrote:
> >I didn't say it was worse, I questioned that this should be the
> >overarching goal when no data to support this has been posted and it
> >doesn't even make inutitive sense that worrying about the size of
> >*dirty cache lines* is even very important, (well, within limits).
> >
> 
> We ran ib_send_bw (perftest package) when developing this - one time using
> the regular ibv_poll_cq and another time with ibv_poll_cq_ex and got
> identical results (the difference was tiny and not conclusive), but I don't
> have the actual results right now. This was one of the common cases the
> user-space driver optimized. We could re-run them and post results if you
> want.

So all this ugly API to minimize cache line usage has no measured
performance gain?

You see why I'm concerned ..

> >Try a non-memcpy API design. Provide an opaque 'cursor' and functions
> >to return certain data. This has more unconditional branches, but may
> >avoid branching within the driver and certainly avoid memcpy's and
> >pretty much all cache line dirtying. Sean had some results that
> >were positive on this sort of direction.
> >
> 
> Does the opaque pointer guarantees an aligned access? Who allocates the
> space for the vendor's CQE? Any concrete example?
> One of the problems here are that CQEs could be formatted as -
> "if QP type is y, then copy the field z from o". Doing that this way may
> result doing the same "if" multiple times. The current approach could still
> avoid memcpy and write straight to the user's buffer.

No, none of that...

struct ibv_cq
{
    int (*read_next_cq)(ibv_cq *cq,struct common_wr *res);
    int (*read_address)(ibv_cq *cq,struct wr_address *res);
    uint64_t (*read_timestamp(ibv_cq *cq);
    uint32_t (*read_immediate_data(ibv_cq *cq);
    void (*read_something_else)(ibv_cq *cq,struct something_else *res);
};

while (cq->read_next_cq(cq,&wc)) // Advance the cursor
{
    // Read the cursor
    uint64_t ts = cq->read_timestamp(cq);
    if (wc->opcode ==  ..)
        uint32_t imm = cq->read_immediate_data(cq);
}

Lots of variety for syntax, I've choosen the above for clarity.

1) The function pointers provided by the driver read directly from the
   CQ memory written by the adaptor. No memcpy. The pointers vary
   on a CQ by CQ basis so they can be optimal.
   Alignment is a driver/hardware problem and is exactly the same as
   any other scheme
2) The driver fills in the pointers in a way that is optimal for the
   specific CQ - if there are multiple formats then the driver
   provides multiple function implementations and chooses the
   combiantion that matches the CQ when it is created.
   The intent is to avoid all conditional branching in the driver on
   these callbacks. The functions should be small enough to avoid
   a frame setup (eg build them with -fomit-frame-pointer and other
   function call related optimizations to achieve this)
2a) If the CQ does not support an extension like read_something_else
    then the driver fills the pointer with something that calls
    abort(), no conditional branching.
    The application is responsible for only calling allowed accessors
    based on how the CQ is created. No branching is needed.
3) read_next_cq goes entry by entry. If signaling the hardware
   that a CQe is now available is expensive then the driver will need
   some kind of batching scheme for that. Ie signal on empty, signal
   ever N, etc. An additional entry point may be required to manage
   this.
3a) This could also follow the new kAPI pattern and use a callback
    scheme which makes the batching and budgeting alot simpler for
    the application.
4) A basic analysis says this trades cache line dirtying of the wc
   array for unconditional branches.
   It  eliminates at least 1 conditional branch per CQE iteration by
   using only 1 loop.
   For some things it may entirely eliminate memory traffic in favor of
   register returns (eg my read_immediate_data example)
   For some things this may entirely eliminate work, eg the
   address and immediate data rarely need to be parsed for some apps

   Compared to the poll_ex proposal this eliminates a huge
   number of conditional branches as 'wc_flags' and related no longer
   exist at all.

   Only careful benchmarking will tell if the unconditional branch
   overhead is greater than the savings from dropping conditional
   branches and cache line dirtying.

5) If the vendors could get together, it might be possible to replace
   some function pointers with inlined pointer math eg:

   struct ibv_cq
   {
        const void *cur_cqe;
	size_t immdata_offset;
   }

   inline uint32_t ibv_cqe_read_immedate_data(ibv_cq *cq)
   {
      return *(uint32_t *)(cq->cur_cqe + cq->immdata_offset);
   }

   Obvious this requires most vendors to use a HW CQE format that
   can support the above expression.
   
   Further, touching on an idea Cristoph brought up a long time
   ago - it would be easy to use this API to build a Vendor Optimized
   libibverbs this would support a single driver's card and would
   inline the CQE parse using something like the above, tuned for the
   single driver. It would be interesting to see if that is a win or
   not.

I hope you see how this sort of API is alot saner than what is
proposed, it is type safe, misuses not caught by the compiler blow up
100% of the time at runtime, the usage is intuitive and matches
typical C conventions.

The question that must be answered is the peformance for the various
options, and that is what I mean by benchmarking. I would probably
approach this with the perf tool and look at the various CPU counters
for each option and then get someone like Christoph to chime in with
his specalized benchmark environment when I think the best option has
been found and has already been carefully micro optimized.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
