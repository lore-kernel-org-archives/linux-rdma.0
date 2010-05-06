From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] [PATCHv8 02/11] ib_core: IBoE support only QP1
Date: Thu, 6 May 2010 17:28:49 +0300
Message-ID: <20100506142849.GC29792@mtldesk030.lab.mtl.com>
References: <20100218172344.GC12286@mtls03>
	<ada1vdqaqpc.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada1vdqaqpc.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 05, 2010 at 04:12:15PM -0700, Roland Dreier wrote:
>  > @@ -795,11 +799,12 @@ static void mcast_add_one(struct ib_device *device)
>  >  	struct mcast_device *dev;
>  >  	struct mcast_port *port;
>  >  	int i;
>  > +	int count = 0;
>  >  
>  >  	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
>  >  		return;
>  >  
>  > -	dev = kmalloc(sizeof *dev + device->phys_port_cnt * sizeof *port,
>  > +	dev = kzalloc(sizeof *dev + device->phys_port_cnt * sizeof *port,
> 
>  > @@ -1007,7 +1010,7 @@ static void ib_sa_add_one(struct ib_device *device)
>  >  		e = device->phys_port_cnt;
>  >  	}
>  >  
>  > -	sa_dev = kmalloc(sizeof *sa_dev +
>  > +	sa_dev = kzalloc(sizeof *sa_dev +
> 
> Do you happen to remember why you needed these kmalloc -> kzalloc conversions?

I can't remember why. I do have this habbit of prefering kzalloc
over kmalloc because it saves troubles sometimes.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
