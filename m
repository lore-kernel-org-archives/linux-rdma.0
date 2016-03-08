From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 03/10] IB/core: Add subnet prefix to port
 info
Date: Tue, 8 Mar 2016 20:04:28 +0200
Message-ID: <20160308180428.GD33629@x-vnc01.mtx.labs.mlnx>
References: <1457455018-17638-1-git-send-email-eli@mellanox.com>
 <1457455018-17638-4-git-send-email-eli@mellanox.com>
 <20160308175752.GD10805@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160308175752.GD10805-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2016 at 10:57:52AM -0700, Jason Gunthorpe wrote:
> 
> Looks reasonable
> 
> Are you going to still send the mlx4/5 changes to avoid the other
> callback?

I don't think it is necessary since the hardware driver will do the
same thing to obtain the subnet prefix so I don't think it has any
siginficant benefit.
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 

Thanks

> > +++ b/include/rdma/ib_verbs.h
> > @@ -509,6 +509,7 @@ struct ib_port_attr {
> >  	u8			active_width;
> >  	u8			active_speed;
> >  	u8                      phys_state;
> > +	u64			subnet_prefix;
> >  };
> 
> This turned out to be aligned then?
> 

Actually I missed this comment of yours. I will fix that as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
