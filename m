From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Mon, 27 Apr 2015 15:10:31 -0400
Message-ID: <20150427191030.GA5347@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com> <20150422024123.GA18675@phlsvsds.ph.intel.com> <DB4PR05MB086335365371E756B789FE84B1EE0@DB4PR05MB0863.eurprd05.prod.outlook.com> <20150422164034.GB19500@obsidianresearch.com> <DB4PR05MB08633B2B2E3BA32752EE8098B1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com> <20150424164226.GB9305@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150424164226.GB9305-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 24, 2015 at 10:42:26AM -0600, Jason Gunthorpe wrote:
> On Fri, Apr 24, 2015 at 03:00:15PM +0000, Liran Liss wrote:
> 
> > Currently, the only code in the kernel that has an SMI interface is IB.
> > When OPA is introduced, add the proper helper.
> 
> We already have tests checking for SMI is supported so QP0 can be
> created, this is to support ROCEE
>  
> > All I am saying is that there will always be code paths that are
> > technology- and standards-specific.  For example, the low-level MAD
> > processing code *must* do stuff like:
> 
> > if (rdma_is_transport_ib())
> > 	/* IB-spec compliant stuff */
> > else if (rdma_is_transport_opa())
> > 	/* OPA stuff */

The issue is that opa is _not_ a new "transport".  It is just like RoCEE which
supports the IB transport with some differences.

We need a way to explain what those differences are while keeping each section
of code as clean and clear as possible.  Many of us have spent a lot of time
trying to figure out what each section of the current code is doing when they
call "get_transport" and/or "get_link_layer".

> 
> Why should we open code that? It is back to what I said - that doesn't
> help the reader. Which of the few differences between OPA and IB MADs
> is that code trying to deal with?
> 
> Heck, what are the differences? Do you know? Do I know?
> 
> If you don't know what the differences are, you can't realistically
> work on the MAD layer anymore, because you might break OPA.
> 
> Whereas, If I see:
> 
> if (cap_2k_mad())
>  /* Special handling for OPA 2k mad support */

FWIW we decided not to special case 2K and simply provide the max MAD size
which a driver supports.  This is much more flexible.  I think the semantics
are equivalent to your example here but I don't think we need a discussion
around a "cap_2k_mad" helper.

> if (cap_opa_mad_space() && mad->baseVersion == ... )
>  /* Decode OPA mads */
> if (cap_ib_mad_space() && mad->baseVersion == ... )
>  /* Decode IB mads */

Agreed.

> 
> The I *know* what to look for when writing new code.
> 
> That is the problem we are trying to address here. iWarp has already
> created it, we addressed it using 'rdma_is_transport_iwarp' and I
> don't think those results were very satisfying.

No they are not and it is getting more complicated.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
