From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/core: Formalize the creation of immutable per port data within the ib_device object
Date: Tue, 12 May 2015 17:02:25 -0400
Message-ID: <20150512210225.GA7341@phlsvsds.ph.intel.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com> <1431395218-27693-3-git-send-email-ira.weiny@intel.com> <20150512192109.GC3503@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150512192109.GC3503-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 12, 2015 at 01:21:09PM -0600, Jason Gunthorpe wrote:
> On Mon, May 11, 2015 at 09:46:55PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > As of commit 5eb620c81ce3 "IB/core: Add helpers for uncached GID and P_Key
> > searches"; pkey_tbl_len and gid_tbl_len are immutable data which are stored in
> > the ib_device.
> > 
> > The per port core capability flags to be added later are also immutable data to
> > be stored in the ib_device object.
> > 
> > In preparation for this create a structure for per port immutable data and
> > place the pkey and gid table lengths within this structure.
> > 
> > This type of data requires a new call back "port_immutable" parameter to
> > ib_register_device to allow each driver to create this data as appropriate.
> > This callback is added to ib_register_device rather than as a new device
> > function because the callback should only be used when devices are first
> > registered.
> 
> Ugh, gross, it should just be a normal callback, the existing argument call back
> shouldn't have been ever added, IMHO.

Changing based on Dougs feedback.

> 
> > +	device->port_immutable = kmalloc(sizeof(*device->port_immutable)
> > +						* (num_ports+1),
> > +					 GFP_KERNEL);
> 
> kzalloc?

Yea

> 
> > +	if (!device->port_immutable)
> >  		goto err;
> >  
> > -	for (port_index = 0; port_index < num_ports; ++port_index) {
> > -		ret = ib_query_port(device, port_index + start_port(device),
> > -					tprops);
> > +	for (port = 0; port <= num_ports; ++port) {
> > +
> > +		if (port == 0 && device->node_type != RDMA_NODE_IB_SWITCH)
> > +			continue;
> > +
> > +		if (port > 0 && device->node_type == RDMA_NODE_IB_SWITCH)
> > +			break;
> 
> This is confusing, we are iterating over the range of the array, but
> some values don't fill anything, leaving garbage? So, is the array
> size wrong, or what is going on here?

The port_immutable array is indexed based on the port number.  So on an HCA 0
is invalid.  On a switch 1 is invalid.

This is done to optimize the helper functions as much as possible.

I'll special case the switch to not allocate the additional entry.

But for an HCA 0 is just invalid.

> 
> > @@ -349,8 +350,7 @@ void ib_unregister_device(struct ib_device *device)
> >  
> >  	list_del(&device->core_list);
> >  
> > -	kfree(device->gid_tbl_len);
> > -	kfree(device->pkey_tbl_len);
> > +	kfree(device->port_immutable);
> 
> The kfree should be in the ib_device_release function.

ok.

> 
> > +static int c2_port_immutable(struct ib_device *ibdev, u8 port_num,
> > +			     struct ib_port_immutable *immutable)
> > +{
> 
> Lets just have the core swap in this generic function if it detects
> the port_immutable function pointer is null. Then this patch doesn't
> have to update drivers.

Ignoring based on other comment.

> 
> > @@ -1494,8 +1500,7 @@ struct ib_device {
> >  	struct list_head              client_data_list;
> >  
> >  	struct ib_cache               cache;
> > -	int                          *pkey_tbl_len;
> > -	int                          *gid_tbl_len;
> > +	struct ib_port_immutable     *port_immutable;
> 
> Add const

Agreed.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
