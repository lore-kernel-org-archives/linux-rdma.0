From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/8] mlx4: Add sparse annotations
Date: Thu, 13 Jul 2017 11:16:09 -0600
Message-ID: <20170713171609.GA11069@obsidianresearch.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170713072343.GI1528@mtr-leonro.local>
 <20170713080752.GA25727@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170713080752.GA25727-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 01:07:52AM -0700, Christoph Hellwig wrote:
> > >  	case MLX4_RECV_OPCODE_SEND_INVAL:
> > > -		return be32toh(cq->cqe->immed_rss_invalid);
> > > +		/* This is returning invalidate_rkey which is in host order, see
> > > +		 * ibv_wc_read_invalidated_rkey */
> > > +		return (__force __be32)be32toh(cq->cqe->immed_rss_invalid);
> > 
> > Jason,
> > It is insane construction, convert to host-> force to be32 -> use as uint32_t.
> 
> Yes, this doesn't make sense to me - we are swapping it but pretending
> it's native?  There's certainly something very odd going on here.

Yes, it is odd.

mlx4_cq_read_wc_imm_data is an ABI entry point, we cannot change it.

The ABI defines it to return a be32 when the wc has immediate data and
a u32 when the wc has an remote invalidated rkey - hence the madness.

My approach is to retain this ABI, and put two user facing wrappers
around the function call that return the correct types depending on
the expected data accessed. Since the function is called '*_imm_data'
I choose to return a be32 to match the choice of name.

> It seems like the ->read_imm_data needs to be split and/or have a
> prototype change.  The sad part is that it is an exported ABI, although
> one that is almost undocumented.

Even if we split it, the existing version must retain the same
behavior and the only way to get such insane behaviar and be sparse
clean is with force right here.

Since we are stuck with that I can't really justify adding another
entry point just for invalidated rkey.. I can't really get rid of the
ifdef CHECKER in the public header with this approach.

> > I see that librdmacm/rsocket.c full of these __force annotations.
> > I would be very happy to see it fixed rather suppressed, but don't know
> > if it is realistic goal or not.
> 
> The db local variable in mlx4_alloc_db should be easily changed to a
> __be32 pointer - it is derived from a void pointer using pointer
> arithmetics.

Yeah, OK, I thought I tried that, but yep, it is OK. I will update
both places.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
