From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 11:07:50 -0600
Message-ID: <20150715170750.GA23588@obsidianresearch.com>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150715073233.GA11535@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150715073233.GA11535-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 15, 2015 at 12:32:33AM -0700, Christoph Hellwig wrote:
> int rdma_create_mr(struct ib_pd *pd, enum rdma_mr_type mr,
> 	u32 max_pages, int flags);
> 
> >   *     array from a SG list
> >   * @mr:          memory region
> >   * @sg:          sg list
> >   * @sg_nents:    number of elements in the sg
> >   *
> >   * Can fail if the HW is not able to register this
> >   * sg list. In case of failure - caller is responsible
> >   * to handle it (bounce-buffer, multiple registrations...)
> >   */
> > int ib_mr_set_sg(struct ib_mr *mr,
> >                  struct scatterlist *sg,
> >                  unsigned short sg_nents);
> 
> Call this rdma_map_sg?
> 
> >          /* register the MR */
> >          frwr.opcode = IB_WR_FAST_REG_MR;
> >          frwr.wrid = my_wrid;
> >          frwr.wr.fast_reg.mr = mr;
> >          frwr.wr.fast_reg.iova = ib_sg_dma_adress(&sg[0]);
> >          frwr.wr.fast_reg.length = length;
> >          frwr.wr.fast_reg.access_flags = my_flags;
> 
> Provide a helper to hide all this behind the scenes please:
> 
> void rdma_init_mr_wr(struct ib_send_wr *wr, struct rdma_mr *mr,
> 		u64 wr_id, int mr_access_flags);
>
> Or if we got with Jason's suggestion split "int mr_access_flags" into
> "bool remote, bool is_write".

Yes please. Considering the security implications we need to be much
more careful API wise here. This is more of a code-as-documentation
issue than a functional issue.

Lets avoid the issue of implicit posting, but still delegate the WR
construction to the driver:

 rdma_map_sg_lkey(u32 *lkey_out,
                  struct rdma_mr *mr,
		  const struct scatterlist *sg,
 	          unsigned short sg_nents,
		  unsigned int ops_supported,
		  struct ib_send_wr *post_wr,
		  u64 wrid)
 rdma_map_sg_rkey(.. same args ..)

Used as:

 rdma_map_sg_lkey(&wr[1].lkey,mr,sg,sg_nents,RDMA_OP_SEND,
 		 &wr[0],...);
 wr[1].opcode = IB_SEND;
 ib_post_send(wr..)

I'd probably implement the above as two wrappers around a
generic driver/core callback. All the wrappers do is translation of
ops_supports to the IB_ACCESS scheme.

The two entry points interpret their ops_supported differently
(source/sink in Steve's model), so it becomes impossible to
inadvertantly create a remote access lkey. And the API makes it
unnatural to use a MR as both a lkey and rkey.

Just thinking .. I'd probably drop the wrid and have rdma_map_sg_x
create an unsignaled wr by default. If the caller wants to force
signaling they can fill in the write and change the flags.

---------

I'm still unhappy with this, from a broad perspective. Look at what
any ULP has to implement to do a RDMA READ properly:

if (iwarp)
{
    rdma_map_sg_lkey(&wr[1].lkey,mr,sg,sg_nents,RDMA_OP_RDMA_READ,
 		 &wr[0],...);
    wr[1].opcode = IB_RDMA_READ;
    wr[2].opcode = IB_WR_LOCAL_INV;
    wr[2].invalidate_rkey = wr[1].lkey;
}
else if (sg_nents <= device->read_sg_limit)
{
    wr[0].opcode = IB_RDMA_READ;
    wr[0].lkey = pd->local_dma_lkey;
    ... translate struct sctatter_list to a wr ...
}
else if (fmr)
{
     ... ? ...
}
} else { // For IB
    rdma_map_sg_lkey(&wr[1].lkey,mr,sg,sg_nents,RDMA_OP_RDMA_READ,
 		 &wr[0],...);
    wr[1].opcode = IB_RDMA_READ;
    // We can lazy invalidate when we recycle the MR (?)
}

And that isn't even considering the possibility of using multiple
RDMA_READ ops instead of a MR. (which would be smarter that FMR)

I see the above as a common, mandatory, pattern that should be
factored.. If a ULP is doing RDMA_READ and it isn't doing the above,
it is broken. It either doesn't support iWarp, or it is throwing IB
performance away.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
