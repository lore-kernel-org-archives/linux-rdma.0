From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 08/14] IB/core: Add rdma_max_mad_size helper
Date: Wed, 20 May 2015 12:19:28 -0600
Message-ID: <20150520181928.GE28496@obsidianresearch.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
 <1432109615-19564-9-git-send-email-ira.weiny@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDDACE@ORSMSX109.amr.corp.intel.com>
 <20150520180226.GC14309@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520180226.GC14309-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 02:02:27PM -0400, ira.weiny wrote:
> On Wed, May 20, 2015 at 11:37:47AM -0600, Hefty, Sean wrote:
> > > +/**
> > > + * rdma_max_mad_size - Return the max MAD size required by this RDMA
> > > Port.
> > > + *
> > > + * @device: Device
> > > + * @port_num: Port number
> > > + *
> > > + * Return the max MAD size required by the Port.  Should return 0 if the
> > > port
> > > + * does not support MADs
> > > + */
> > > +static inline size_t rdma_max_mad_size(struct ib_device *device, u8
> > > port_num)
> > > +{
> > > +	return device->port_immutable[port_num].max_mad_size;
> > > +}
> > 
> > Should this function check the mad_cap bit and return 0 if not set?  If not,
> > I would remove the 'should return 0...' statement from the comment above and
> > state that the caller should check the mad_cap bit first.
> 
> I'll change the comment.

If there is no mad support the port_immutable.max_mad_size should be
0, force it during registration, then the comment is right.

Force to 0 is better than 'some random value'

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
