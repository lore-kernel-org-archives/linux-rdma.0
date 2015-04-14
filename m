From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 10/28] IB/Verbs: Reform cm related part in IB-core cma
Date: Tue, 14 Apr 2015 11:50:34 -0400
Message-ID: <20150414155033.GB13852@phlsvsds.ph.intel.com>
References: <552BB470.4090407@profitbricks.com> <552BB60F.60109@profitbricks.com> <1828884A29C6694DAF28B7E6B8A82373A8FC0ACF@ORSMSX109.amr.corp.intel.com> <552CD156.9060709@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552CD156.9060709-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 14, 2015 at 10:35:34AM +0200, Michael Wang wrote:
> 
> 
> On 04/13/2015 09:25 PM, Hefty, Sean wrote:
> >> @@ -1037,17 +1033,13 @@ void rdma_destroy_id(struct rdma_cm_id *id)
> >>  	mutex_unlock(&id_priv->handler_mutex);
> >>
> >>  	if (id_priv->cma_dev) {
> >> -		switch (rdma_node_get_transport(id_priv->id.device-
> >>> node_type)) {
> >> -		case RDMA_TRANSPORT_IB:
> >> +		if (rdma_ib_or_iboe(id_priv->id.device, id_priv->id.port_num))
> > 
> > A listen id can be associated with a device without being associated with a port (see the listen_any_list). 
> Some other check is needed to handle this case.  I guess the code could check the first port on the device
> (replace port_num with hardcoded value 1).  Then we wouldn't be any more broken than the code already is.
> (The 'break' is conceptual, not practical.)
> 
> Agree, seems like this is very similar to the case of cma_listen_on_dev() which
> do not associated with any particular port in #24.
> 
> If the port 1 is enough to present the whole device's cm capability, maybe we can
> get rid of cap_ib_cm_dev() too?
> 
> And maybe cap_ib_cm(device, device->node_type == RDMA_NODE_IB_SWITCH ? 0:1) would
> be safer?

I don't see support for switch port 0 in cm_add_one() now.  Are switches supposed
to be supported?

Ira

> 
> Regards,
> Michael Wang
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
