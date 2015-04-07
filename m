From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 12/19] IB/mad: Add MAD size parameters to process_mad
Date: Tue, 7 Apr 2015 13:23:04 -0400
Message-ID: <20150407172303.GB433@phlsvsds.ph.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-13-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBD692@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBD692-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 03, 2015 at 04:40:20PM -0600, Hefty, Sean wrote:
> > -static struct ib_mad_private *alloc_mad_priv(struct ib_device *dev)
> > +static struct ib_mad_private *alloc_mad_priv(struct ib_device *dev,
> > +					     size_t *mad_size)
> >  {
> > +	*mad_size = dev->cached_dev_attrs.max_mad_size;
> 
> Why does this function return the value that the caller can just read from the device?
>
> Actually, it's odd for an alloc() call to return how much it allocated, rather than taking that as input.

True.

This was done just for the convenience of the callers.  The previous patch used
ib_device to determine the size I was just trying to keep that semantic with
the function "helping" the caller...

I'll change this to:

static struct ib_mad_private *alloc_mad_priv(size_t mad_size, gfp_t flags);

which also addresses Dougs comments regarding GFP_ATOMIC.

> 
> >  	return (kmalloc(sizeof(struct ib_mad_private_header) +
> > -			sizeof(struct ib_grh) +
> > -			dev->cached_dev_attrs.max_mad_size, GFP_ATOMIC));
> > +			sizeof(struct ib_grh) + *mad_size, GFP_ATOMIC));
> >  }
> > 
> >  /*
> > @@ -741,6 +742,8 @@ static int handle_outgoing_dr_smp(struct
> > ib_mad_agent_private *mad_agent_priv,
> >  	u8 port_num;
> >  	struct ib_wc mad_wc;
> >  	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
> > +	size_t in_mad_size = mad_agent_priv->agent.device-
> > >cached_dev_attrs.max_mad_size;
> > +	size_t out_mad_size;
> > 
> >  	if (device->node_type == RDMA_NODE_IB_SWITCH &&
> >  	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
> > @@ -777,7 +780,7 @@ static int handle_outgoing_dr_smp(struct
> > ib_mad_agent_private *mad_agent_priv,
> >  	local->mad_priv = NULL;
> >  	local->recv_mad_agent = NULL;
> > 
> > -	mad_priv = alloc_mad_priv(mad_agent_priv->agent.device);
> > +	mad_priv = alloc_mad_priv(mad_agent_priv->agent.device,
> > &out_mad_size);
> >  	if (!mad_priv) {
> >  		ret = -ENOMEM;
> >  		dev_err(&device->dev, "No memory for local response MAD\n");
> > @@ -792,8 +795,9 @@ static int handle_outgoing_dr_smp(struct
> > ib_mad_agent_private *mad_agent_priv,
> > 
> >  	/* No GRH for DR SMP */
> >  	ret = device->process_mad(device, 0, port_num, &mad_wc, NULL,
> > -				  (struct ib_mad *)smp,
> > -				  (struct ib_mad *)&mad_priv->mad);
> > +				  (struct ib_mad_hdr *)smp, in_mad_size,
> > +				  (struct ib_mad_hdr *)&mad_priv->mad,
> > +				  &out_mad_size);
> 
> Rather than calling device->process_mad() directly, would it be better to call a common function?  So we can avoid adding:
> 
> > +	struct ib_mad *in_mad = (struct ib_mad *)in;
> > +	struct ib_mad *out_mad = (struct ib_mad *)out;
> > +
> > +	if (in_mad_size != sizeof(*in_mad) || *out_mad_size !=
> > sizeof(*out_mad))
> > +		return IB_MAD_RESULT_FAILURE;
> 
> to existing drivers?

No.  The checks need to be done by the devices.  IB devices expect exactly 256
bytes, OPA devices expect 2K, while some drivers don't care at all (don't
support MADs).

However, upon further reflection these checks indicate a programming error in
which the device is indicating the wrong mad size or there is a bug in the MAD
module.  Therefore these should be WARN_ON.

> 
> 
> >  	switch (ret)
> >  	{
> >  	case IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY:
> > @@ -2011,6 +2015,7 @@ static void ib_mad_recv_done_handler(struct
> > ib_mad_port_private *port_priv,
> >  	struct ib_mad_agent_private *mad_agent;
> >  	int port_num;
> >  	int ret = IB_MAD_RESULT_SUCCESS;
> > +	size_t resp_mad_size;
> > 
> >  	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
> >  	qp_info = mad_list->mad_queue->qp_info;
> > @@ -2038,7 +2043,7 @@ static void ib_mad_recv_done_handler(struct
> > ib_mad_port_private *port_priv,
> >  	if (!validate_mad(&recv->mad.mad.mad_hdr, qp_info->qp->qp_num))
> >  		goto out;
> > 
> > -	response = alloc_mad_priv(port_priv->device);
> > +	response = alloc_mad_priv(port_priv->device, &resp_mad_size);
> >  	if (!response) {
> >  		dev_err(&port_priv->device->dev,
> >  			"ib_mad_recv_done_handler no memory for response
> > buffer\n");
> > @@ -2063,8 +2068,10 @@ static void ib_mad_recv_done_handler(struct
> > ib_mad_port_private *port_priv,
> >  		ret = port_priv->device->process_mad(port_priv->device, 0,
> >  						     port_priv->port_num,
> >  						     wc, &recv->grh,
> > -						     &recv->mad.mad,
> > -						     &response->mad.mad);
> > +						     (struct ib_mad_hdr *)&recv-
> > >mad.mad,
> > +						     port_priv->device-
> > >cached_dev_attrs.max_mad_size,
> 
> This is the size of the allocated buffer.

Yes

> Something based on wc.byte_len seems like a better option.

The IB process_mad calls currently have no size checks and expect the full IB
MAD...  I did not want to break that semantic and risk introducing bugs in
those drivers.

While it seems byte_len should be sufficient I can't test for all devices.

Furthermore for OPA devices there is no issue with passing the full buffer
size.  So I prefer to leave this as is.

Ira

> 
> 
> > +						     (struct ib_mad_hdr *)&response-
> > >mad.mad,
> > +						     &resp_mad_size);
> >  		if (ret & IB_MAD_RESULT_SUCCESS) {
> >  			if (ret & IB_MAD_RESULT_CONSUMED)
> >  				goto out;
> > @@ -2687,7 +2694,10 @@ static int ib_mad_post_receive_mads(struct
> > ib_mad_qp_info *qp_info,
> >  			mad_priv = mad;
> >  			mad = NULL;
> >  		} else {
> > -			mad_priv = alloc_mad_priv(qp_info->port_priv->device);
> > +			size_t mad_size;
> > +
> > +			mad_priv = alloc_mad_priv(qp_info->port_priv->device,
> > +						  &mad_size);
> >  			if (!mad_priv) {
> >  				dev_err(&qp_info->port_priv->device->dev,
> >  					"No memory for receive buffer\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
