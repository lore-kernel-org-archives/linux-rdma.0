From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/14] IB/mad: Create an RMPP Base header
Date: Wed, 27 May 2015 14:13:03 -0400
Message-ID: <20150527181302.GA6713@phlsvsds.ph.intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com> <1432109615-19564-3-git-send-email-ira.weiny@intel.com> <20150520182735.GG28496@obsidianresearch.com> <20150520212344.GB22981@phlsvsds.ph.intel.com> <20150520220333.GA5970@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520220333.GA5970-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 04:03:33PM -0600, Jason Gunthorpe wrote:
> On Wed, May 20, 2015 at 05:23:45PM -0400, ira.weiny wrote:
> > On Wed, May 20, 2015 at 12:27:35PM -0600, Jason Gunthorpe wrote:
> > > On Wed, May 20, 2015 at 04:13:23AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > > -struct ib_rmpp_mad {
> > > > +struct ib_rmpp_base {
> > > >  	struct ib_mad_hdr	mad_hdr;
> > > >  	struct ib_rmpp_hdr	rmpp_hdr;
> > > > +} __packed;
> > > > +
> > > > +struct ib_rmpp_mad {
> > > > +	struct ib_rmpp_base	base;
> > > >  	u8			data[IB_MGMT_RMPP_DATA];
> > > >  };
> > > 
> > > Why can't we just use:
> > > 
> > >  u8 data[];
> > > 
> > > And replace various sizeof(ib_rmpp_mad) with a rmpp_payload_size()
> > > call?
> > 
> > I don't think it makes much difference.  I think there is just 1 place we use
> > that.
> 
> There are many lines that are just churning rmpp_mad to
> rmpp_base, using a flex array avoids that entirely.

Ok.

> 
> Similarly patch 12 doesn't have to introduce a opa specific structure anymore.

Ok.

> 
> The same sort of comment probably applies to the mad_hdr/etc as well,
> but I didn't look very closely.

This would mean changing all the existing drivers which I'm not really keen on
doing.  Existing drivers using IBTA MADs expect the MADs to be exactly 256
bytes and that is exactly how struct ib_mad is defined.  So I think we need to
keep the definitions for drivers to use.

However, I think we can clean up the use of sizeof(ib_mad) in the MAD code such
that it is agnostic to the device/port type once the MAD size patch is in
place.  I'll look at doing that early in the series.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
