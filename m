From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] [PATCHv8 02/11] ib_core: IBoE support only QP1
Date: Mon, 17 May 2010 14:59:38 +0300
Message-ID: <20100517115938.GB663@mtldesk030.lab.mtl.com>
References: <20100218172344.GC12286@mtls03>
	<ada632svqph.fsf@roland-alpha.cisco.com>
	<20100513065917.GA16073@mtldesk030.lab.mtl.com>
	<adatyqbsszt.fsf@roland-alpha.cisco.com>
	<20100513165201.GA19438@mtldesk030.lab.mtl.com>
	<adahbmbso19.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adahbmbso19.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 13, 2010 at 10:35:14AM -0700, Roland Dreier wrote:
>  > One reason is that get_src_path_mask() may access ah_lock.
> 
> I don't see that:
> 
> static u8 get_src_path_mask(struct ib_device *device, u8 port_num)
> {
> 	struct ib_sa_device *sa_dev;
> 	struct ib_sa_port   *port;
> 	unsigned long flags;
> 	u8 src_path_mask;
> 
> 	sa_dev = ib_get_client_data(device, &sa_client);
> 	if (!sa_dev)
> 		return 0x7f;
> 
> so if we never add the sa_client structure it just returns.
> 
I see... so I have no good reason to not treat sa_query.c in the same
manner I did for multicast.c.
By the way, how do you prefer to work out all these comments.  Would
you prefer a new patch set or would you prefer to push the fixed
versions to your tree?
Also, there are a few fixes that I pushed to OFED that were pushed
after I sent V8. How would you like me to communicate them?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
