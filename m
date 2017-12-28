From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] IB/mlx5: Move locks initialization to the
 corresponding stage
Date: Thu, 28 Dec 2017 19:22:52 +0200
Message-ID: <70dcf1fa-fd00-7288-3a59-0d61e62e0043@mellanox.com>
References: <20171224124015.31917-1-leon@kernel.org>
 <20171224124015.31917-7-leon@kernel.org> <20171228051806.GP25436@ziepe.ca>
 <20171228053259.GP3494@mtr-leonro.local> <20171228053523.GR25436@ziepe.ca>
 <3ad02325-5244-31c9-eb6d-139a17b064b6@mellanox.com>
 <20171228160310.GW25436@ziepe.ca>
 <9f8a7042-7c6a-9929-fa10-0edf5c6e366e@mellanox.com>
 <20171228171428.GA25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228171428.GA25436-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 28/12/2017 19:14, Jason Gunthorpe wrote:
> On Thu, Dec 28, 2017 at 07:10:31PM +0200, Mark Bloch wrote:
> 
>> Well, it's not only that, moving the init srcu to the INIT stage
>> will also make me wrap it around with CONFIG_INFINIBAND_ON_DEMAND_PAGING
>> which I really don't like seeing in .c files, but we are already doing that
>> so .... :)
> 
> Don't micro-optimize so much. Who cares if the few struct members are
> allocated when !CONFIG_INFINIBAND_ON_DEMAND_PAGING ? Always allocate
> the SRCU and always initialize it.
> 
Well, I didn't write the ODP code, so I don't know why they did it this way.
Any place today that accesses that srcu is already under that CONFIG option, so
the init srcu can also stay under that CONFIG.

> Maybe even get rid of CONFIG_INFINIBAND_ON_DEMAND_PAGING ?
> Never understood why we had it in the first place.
> 

I'll talk with the guys that did/touch last the ODP code and see what they have
to say, if there isn't a valid reason I'll post a patch that cleans this entire thing.

>> If you feel that strongly about it, let me know and I'll change that,
>> as well as the comment you had about the const in a different patch
>> and we'll send v1 with the fixes.
> 
> The function call back thing is really not nice, so I would be happy
> to see it go away.
> 
So I'll move the lock to INIT, but leave it under the ODP CONFIG option for now.
If there isn't (It's already on my TODO list to ask around) a good reason for this CONFIG
I'll send a patch that addresses that, sound good?

> Jason
> 

Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
