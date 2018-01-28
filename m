From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
 registration
Date: Sun, 28 Jan 2018 22:37:47 +0200
Message-ID: <20180128203746.GA11635@yuvallap>
References: <1515088046-26605-1-git-send-email-alexma@mellanox.com>
 <1515088046-26605-2-git-send-email-alexma@mellanox.com>
 <20180111122206.GB2800@yuvallap>
 <20180111164455.GA1309@ziepe.ca>
 <VI1PR05MB1278C4C4FF78B4B1A551252EB9EC0@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20180123202954.GA14007@yuvallap>
 <VI1PR05MB12787572593F02F05AA20DE1B9E10@VI1PR05MB1278.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR05MB12787572593F02F05AA20DE1B9E10-79XLn2atqDMOK6E67s+DINqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 25, 2018 at 12:43:05PM +0000, Alex Margolin wrote:
> 
> 
> > -----Original Message-----
> > From: Yuval Shaia [mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> > Sent: Tuesday, January 23, 2018 10:30 PM
> > To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Marcel Apfelbaum
> > <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
> > registration
> > 
> > On Mon, Jan 22, 2018 at 03:59:51PM +0000, Alex Margolin wrote:
> > > > -----Original Message-----
> > > > From: Jason Gunthorpe
> > > > Sent: Thursday, January 11, 2018 6:45 PM
> > > > To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous
> > > > memory registration
> > > >
> > > > On Thu, Jan 11, 2018 at 02:22:07PM +0200, Yuval Shaia wrote:
> > > > > > +The following code example demonstrates non-contiguous memory
> > > > > > +registration, by combining two contiguous regions, along with
> > > > > > +the
> > > > WR-based completion semantic:
> > > > > > +.PP
> > > > > > +.nf
> > > > > > +mr1 = ibv_reg_mr(pd, addr1, len1, 0); if (!mr1) {
> > > > > > +        fprintf(stderr, "Failed to create MR #1\en");
> > > > > > +        return 1;
> > > > > > +}
> > > > > > +
> > > > > > +mr2 = ibv_reg_mr(pd, addr2, len2, 0); if (!mr2) {
> > > > > > +        fprintf(stderr, "Failed to create MR #2\en");
> > > > > > +        return 1;
> > > > > > +}
> > > > >
> > > > > So, to register non-contiguous 512 random buffers i would have to
> > > > > create
> > > > > 512 MRs?
> > >
> > >
> > > I think typically if you have a large amount of buffers - it would be
> > located in fairly close proximity, so you'd prefer one MR to cover all
> > of them and the SGEs will only differ in base address.
> > 
> > Define "large amount".
> > I did several experiments with something like hundred or few hundred
> > (Marcel, do you remember how many?) and they were scattered at the range
> > of about 3G so one MR is not an option. Our application is QEMU so 3G
> > for one MR means no memory overcommit.
> > 
> > >
> > > Are you proposing the function also replaces ibv_reg_mr() if the user
> > passes multiple unregistered regions?
> > > I could see the benefit, but then we'd require additional parameters
> > (i.e. send_flags) and those MRs couldn't be reused (otherwise need to
> > add output pointers for resulting MRs).
> 
> Actually, I realized it can be implemented with the proposed API.
> All that is missing is a capability bit and a flag for set_layout_*,
> and the implementation could work as follows (changes relative to SG example):
> 
> +assert(caps & IBV_MR_SET_LAYOUT_INTERNAL_REGISTRATION);
> -mr1 = ibv_reg_mr(pd, addr1, len1, 0);
> -if (!mr1) {
> -        fprintf(stderr, "Failed to create MR #1\en");
> -        return 1;
> -}
> -
> -mr2 = ibv_reg_mr(pd, addr2, len2, 0);
> -if (!mr2) {
> -        fprintf(stderr, "Failed to create MR #2\en");
> -        return 1;
> -}
> 
> mr3 = ibv_reg_mr(pd, NULL, 0, IBV_ACCESS_ZERO_BASED);
> if (!mr3) {
>         fprintf(stderr, "Failed to create result MR\en");
>         return 1;
> }
> 
> struct ibv_sge composite[] =
> {
>         {
>                 .addr = addr1,
>                 .length = len1,
> -                .lkey = mr1->lkey
>         },
>         {
>                 .addr = addr2,
>                 .length = len2,
> -                .lkey = mr2->lkey
>         }
> };
> 
> +ret = ibv_mr_set_layout_sg(mr3, IBV_MR_SET_LAYOUT_REGISTER_BUFFERS, 2, composite);
> -ret = ibv_mr_set_layout_sg(mr3, 0, 2, composite);
> if (ret) {
>         fprintf(stderr, "Non-contiguous registration failed\en");
>         return 1;
> }
> 
> In this case calling ibv_mr_set_layout_sg() will cause an internal registration
> replacing the ibv_reg_mr calls for mr1 and mr2, and the registration will be stored
> in mr3.
> 
> Is this what you had in mind?

Yes.

But let's try to take it one step further, what if all my buffers are the
same size, of even better, all are PAGE_SIZE. So in case of "composite"
array of let's say 262144 elements i would have wasteful 262144 * 8 bytes.

This problem could be solved with a bitmap to a given range where only the
bits that are set composed the MR.

> 
> > 
> > Yeah, more or less the same ib_reg_mr but one that gets list of pages
> > instead of virtual address and will skip the "while (npages)" loop in
> > ib_umem_get and just go directly to dma_map_sg. Idea here is that anyway
> > the HW supports scattered list of buffers so why to limit the API to
> > contiguous virtual address.
> > 
> > We dropped this idea as it turns out that we need extra help from the HW
> > in post_send phase where the virtual address received in the SGE refers
> > to the virtual address given at ib_reg_mr.
> > We somehow believed that zero-based-mr will solve this by maybe allowing
> > addresses in SGE to be something like an index to a entry in the page-
> > list given to ib_reg_mr but apparently zero-based-mr is not yet
> > functional (at least not in CX3).
> > (We have lack of knowledge in what exactly zero-based-mr is).
> > 
> > > The benefit will probably not be latency, though, since IIRC the MR
> > creation can't really be parallelized.
> > > Yuval - are you aware of a scenario implementing a high amount of
> > ibv_reg_mr() calls?
> > 
> > High amount of ibv_reg_mr calls no but i have a scenario where my
> > application can potentially receive request to create MR for 262144
> > scattered pages.
> > By the way, using the suggested API from Jason below, SG list will still
> > limits us, not sure how big SG list can be but sure not 262144.
> > So what we were thinking is to give ib_reg_mr a huge range, even 4G but
> > then use a bitmap parameter that will specify only the pages in that
> > range that take part in the MR.
> > 
> > >
> > > >
> > > > That is a fair point - I wonder if some of these API should have an
> > > > option to accept a pointer directly? Maybe the driver requires a MR
> > > > but we don't need that as an the API?
> > > >
> > > > Particularly the _sg one..
> > > >
> > > > Jason
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
> > > info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
