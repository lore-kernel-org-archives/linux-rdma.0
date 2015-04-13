From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 10/28] IB/Verbs: Reform cm related part in IB-core cma
Date: Mon, 13 Apr 2015 13:50:40 -0600
Message-ID: <20150413195040.GB19112@obsidianresearch.com>
References: <552BB470.4090407@profitbricks.com>
 <552BB60F.60109@profitbricks.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC0ACF@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC0ACF-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 07:25:48PM +0000, Hefty, Sean wrote:
> > @@ -1037,17 +1033,13 @@ void rdma_destroy_id(struct rdma_cm_id *id)
> >  	mutex_unlock(&id_priv->handler_mutex);
> > 
> >  	if (id_priv->cma_dev) {
> > -		switch (rdma_node_get_transport(id_priv->id.device-
> > >node_type)) {
> > -		case RDMA_TRANSPORT_IB:
> > +		if (rdma_ib_or_iboe(id_priv->id.device, id_priv->id.port_num))
> 
> A listen id can be associated with a device without being associated
> with a port (see the listen_any_list).  Some other check is needed
> to handle this case.  I guess the code could check the first port on
> the device (replace port_num with hardcoded value 1).  Then we
> wouldn't be any more broken than the code already is.  (The 'break'
> is conceptual, not practical.)

Hum. So, devices on a port must have some compatibility when it comes
to these invariants. It looks like all ports must have the same
iwarpyness, for multiple reasons.

Less clear is how rocee vs ib work within a device... Can you APM
between those two kinds of ports?

All these switches are so ugly :| Function pointers setup in
iw_/ib_create_cm_id would be a lot clearer and safer.

> This appears to be highlighting an architectural flaw in the iboe integration.

You mean iwarp?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
