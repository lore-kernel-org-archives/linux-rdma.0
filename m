From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/14] IB/mad: Create an RMPP Base header
Date: Wed, 20 May 2015 17:23:45 -0400
Message-ID: <20150520212344.GB22981@phlsvsds.ph.intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com> <1432109615-19564-3-git-send-email-ira.weiny@intel.com> <20150520182735.GG28496@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520182735.GG28496-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 12:27:35PM -0600, Jason Gunthorpe wrote:
> On Wed, May 20, 2015 at 04:13:23AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > -struct ib_rmpp_mad {
> > +struct ib_rmpp_base {
> >  	struct ib_mad_hdr	mad_hdr;
> >  	struct ib_rmpp_hdr	rmpp_hdr;
> > +} __packed;
> > +
> > +struct ib_rmpp_mad {
> > +	struct ib_rmpp_base	base;
> >  	u8			data[IB_MGMT_RMPP_DATA];
> >  };
> 
> Why can't we just use:
> 
>  u8 data[];
> 
> And replace various sizeof(ib_rmpp_mad) with a rmpp_payload_size()
> call?

I don't think it makes much difference.  I think there is just 1 place we use
that.

> 
> That would make patch 12 alot cleaner

How would this make patch 12 cleaner?

I do see 1 remaining place where the sizeof is used in patch 12 which I can
probably remove.


The other purpose of this patch is to make those functions which used to
process ib_rmpp_mad's generic for both IB and OPA, I'll make that clear
directly in this patches comment.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
