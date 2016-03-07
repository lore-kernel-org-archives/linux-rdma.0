From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 03/10] IB/core: Add subnet prefix to port
 info
Date: Mon, 7 Mar 2016 23:56:08 +0200
Message-ID: <20160307215608.GA33629@x-vnc01.mtx.labs.mlnx>
References: <1457384940-11951-1-git-send-email-eli@mellanox.com>
 <1457384940-11951-4-git-send-email-eli@mellanox.com>
 <20160307214313.GA6706@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160307214313.GA6706-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 07, 2016 at 02:43:13PM -0700, Jason Gunthorpe wrote:
> On Mon, Mar 07, 2016 at 11:08:53PM +0200, Eli Cohen wrote:
> > +	err = ib_query_gid(ibdev, port, 0, &gid, NULL);
> > +	if (err)
> > +		return err;
> > +
> > +	props->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
> 
> Why not put this common pattern in ibv_query_port?
> 
> device->query_port(ibdev, port, ..);
> if (props->subnet_prefix == 0) {

Why do you need this conditional?

>    err = ib_query_gid(ibdev, port, 0, &gid, NULL);
>    if (err)
>    		return err;
> 
>    props->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
> }
> 
> > +++ b/include/rdma/ib_verbs.h
> > @@ -509,6 +509,7 @@ struct ib_port_attr {
> >  	u8			active_width;
> >  	u8			active_speed;
> >  	u8                      phys_state;
> > +	u64			subnet_prefix;
> >  };
> 
> Can we put that at the start for better alignment?
> 

Sure, makes sense.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
