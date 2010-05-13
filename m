From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] [PATCHv8 02/11] ib_core: IBoE support only QP1
Date: Thu, 13 May 2010 09:59:18 +0300
Message-ID: <20100513065917.GA16073@mtldesk030.lab.mtl.com>
References: <20100218172344.GC12286@mtls03>
	<ada632svqph.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada632svqph.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 12, 2010 at 12:56:58PM -0700, Roland Dreier wrote:
>  > @@ -1017,9 +1020,12 @@ static void ib_sa_add_one(struct ib_device *device)
>  >  	sa_dev->end_port   = e;
>  >  
>  >  	for (i = 0; i <= e - s; ++i) {
>  > +		spin_lock_init(&sa_dev->port[i].ah_lock);
>  > +		if (rdma_port_link_layer(device, i + 1) != IB_LINK_LAYER_INFINIBAND)
>  > +			continue;
> 
> Not sure I understand why you move the initialization of the spinlock up
> here?  It seems we ignore everything that might have to do with spinlock
> if this is an IBoE port.
We need the spinlock initialized for get_src_path_mask() which is
called by ib_init_ah_from_path() which in turn is called for IBoE
ports as well.

> 
> But the larger issue is what if someone calls one of the ib_sa_XXX_query
> functions on an IBoE port?  Seems we just crash on uninitialized
> structures.  I guess we're assuming that the kernel is smart enough not
> to do that?
Yes, we're not calling the SA for IBoE.

> 
> Also I'm wondering why you did the "count" stuff to ignore IBoE-only
> devices in multicast.c but not sa_query.c?
> 
It seems to me the right place to put this logic as the mutlicast code
registers as an IB client and the add_one implemntation is
multicast.c.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
