From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 1/2] IB/core: Introduce Fast Indirect Memory Registration verbs API
Date: Mon, 20 Oct 2014 09:54:01 -0500
Message-ID: <003101cfec75$af7d7fc0$0e787f40$@opengridcomputing.com>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <1412693281-6161-2-git-send-email-sagig@mellanox.com> <543CB76B.7020208@acm.org> <54440A7E.200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54440A7E.200-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sagi Grimberg
> Sent: Sunday, October 19, 2014 2:01 PM
> To: Bart Van Assche; Sagi Grimberg; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; Chuck Lever; Steve
> Wise
> Subject: Re: [PATCH RFC 1/2] IB/core: Introduce Fast Indirect Memory Registration verbs API
> 
> On 10/14/2014 8:40 AM, Bart Van Assche wrote:
> > On 10/07/14 16:48, Sagi Grimberg wrote:
> >> In order to support that we provide the user with an interface
> >> to pass a scattered list of buffers to the IB core layer called
> >> ib_indir_reg_list and provide the a new send work request opcode
> >> called IB_WR_REG_INDIR_MR. We extend wr union with a new type of
> >> memory registration called indir_reg where the user can place the
> >> relevant information to perform such a memory registration.
> >>
> >> The verbs user is expected to perform these steps:
> >> 0. Make sure that the device supports Indirect memory registration via
> >>     ib_device_cap_flag IB_DEVICE_INDIR_REGISTRATION and make sure
> >>     that ib_device_attr max_indir_reg_mr_list_len suffice for the
> >>     expected scatterlist length
> >>
> >> 1. Allocate a memory region with IB_MR_INDIRECT_REG creation flag
> >>     This is done via ib_create_mr() with mr_init_attr.flags =
> >> IB_MR_INDIRECT_REG
> >>
> >> 2. Allocate an ib_indir_reg_list structure to hold the scattered buffers
> >>     pointers. This is done via new ib_alloc_indir_reg_list() verb
> >>
> >> 3. Populate the scattered buffers in ib_indir_reg_list.sg_list
> >>
> >> 4. Post a work request with a new opcode IB_WR_REG_INDIR_MR and
> >>     provide the populated ib_indir_reg_list
> >>
> >> 5. Perform data transfer
> >>
> >> 6. Get completion of kind IB_WC_REG_INDIR_MR (if requested)
> >>
> >> 7. Free indirect MR and ib_indir_reg_list via
> >>     ib_destroy_mr() and ib_free_indir_reg_list()
> >
> > Hello Sagi,
> >
> > Is there documentation available somewhere about the order in which an
> > HCA must execute an indirect memory registration request relative to
> > other work requests, similar to the "Work Request Operation Ordering"
> > table in the InfiniBand specification ? I think such documentation is
> > needed to ensure consistent behavior across HCA models.
> >
> 
> So basically Indirect registration request generalizes fast registration
> work request, so it naturally it complies to the same operation ordering
> specification as fast memory registration operations.
> 
> Does it make sense to add some form of
> "Documentation/infiniband/registration_ordering_rules.txt"? This should
> probably include bind_mw, fastreg, indirect_reg, local_inv..
> 
> I'd like to hear more opinions here before I add it...
> Roland, Sean, Steve, Chuck, Or?
> 
> Sagi.

I wouldn't replicate the IB and IW specs in Documentation/infiniband/.   Perhaps just something referencing the specs and then
saying the indirect registration adheres exactly to the fast registration rules?

Steve


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
