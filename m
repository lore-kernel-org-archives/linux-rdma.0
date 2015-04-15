From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 01/28] IB/Verbs: Implement new callback query_transport()
Date: Wed, 15 Apr 2015 16:33:33 -0400
Message-ID: <20150415203332.GA15877@phlsvsds.ph.intel.com>
References: <552BB470.4090407@profitbricks.com> <552BB4FA.5000109@profitbricks.com> <552EAF9D.8050400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552EAF9D.8050400-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 15, 2015 at 02:36:13PM -0400, Hal Rosenstock wrote:
> On 4/13/2015 8:22 AM, Michael Wang wrote:
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 65994a1..d54f91e 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -75,10 +75,13 @@ enum rdma_node_type {
> >  };
> >  
> >  enum rdma_transport_type {
> > +	/* legacy for users */
> >  	RDMA_TRANSPORT_IB,
> >  	RDMA_TRANSPORT_IWARP,
> >  	RDMA_TRANSPORT_USNIC,
> > -	RDMA_TRANSPORT_USNIC_UDP
> > +	RDMA_TRANSPORT_USNIC_UDP,
> > +	/* new transport */
> > +	RDMA_TRANSPORT_IBOE,
> >  };
> >  
> >  __attribute_const__ enum rdma_transport_type
> > @@ -1501,6 +1504,8 @@ struct ib_device {
> >  	int		           (*query_port)(struct ib_device *device,
> >  						 u8 port_num,
> >  						 struct ib_port_attr *port_attr);
> > +	enum rdma_transport_type   (*query_transport)(struct ib_device *device,
> > +						      u8 port_num);
> >  	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
> >  						     u8 port_num);
> >  	int		           (*query_gid)(struct ib_device *device,
> 
> libibverbs also exposes transport at the device level. Isn't a change to
> make transport per port rather than per device needed there as well to
> be consistent with these proposed kernel changes ? If so, would the
> additional IBoE transport be exposed ? We also need to worry about
> backward compatibility for existing applications.

Early on in this thread we agreed that user space would stay the same until we
get the kernel straightened out.  The above enum and function are not exported
to user space so I believe this is in alignment with that plan.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
