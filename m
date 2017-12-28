From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] IB/mlx5: Move locks initialization to the
 corresponding stage
Date: Thu, 28 Dec 2017 10:45:11 -0700
Message-ID: <20171228174511.GC25436@ziepe.ca>
References: <20171224124015.31917-1-leon@kernel.org>
 <20171224124015.31917-7-leon@kernel.org>
 <20171228051806.GP25436@ziepe.ca>
 <20171228053259.GP3494@mtr-leonro.local>
 <20171228053523.GR25436@ziepe.ca>
 <3ad02325-5244-31c9-eb6d-139a17b064b6@mellanox.com>
 <20171228160310.GW25436@ziepe.ca>
 <9f8a7042-7c6a-9929-fa10-0edf5c6e366e@mellanox.com>
 <20171228171428.GA25436@ziepe.ca>
 <70dcf1fa-fd00-7288-3a59-0d61e62e0043@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <70dcf1fa-fd00-7288-3a59-0d61e62e0043-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 28, 2017 at 07:22:52PM +0200, Mark Bloch wrote:

> So I'll move the lock to INIT, but leave it under the ODP CONFIG
> option for now.  If there isn't (It's already on my TODO list to ask
> around) a good reason for this CONFIG I'll send a patch that
> addresses that, sound good?

Yep

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
