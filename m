From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] IB/mlx5: Move locks initialization to the
 corresponding stage
Date: Thu, 28 Dec 2017 19:10:31 +0200
Message-ID: <9f8a7042-7c6a-9929-fa10-0edf5c6e366e@mellanox.com>
References: <20171224124015.31917-1-leon@kernel.org>
 <20171224124015.31917-7-leon@kernel.org> <20171228051806.GP25436@ziepe.ca>
 <20171228053259.GP3494@mtr-leonro.local> <20171228053523.GR25436@ziepe.ca>
 <3ad02325-5244-31c9-eb6d-139a17b064b6@mellanox.com>
 <20171228160310.GW25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228160310.GW25436-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 28/12/2017 18:03, Jason Gunthorpe wrote:
> On Thu, Dec 28, 2017 at 09:51:24AM +0200, Mark Bloch wrote:
> 
>> Yes, let me explain.
>> This entire series aims to allow to turn on/off certain features and to
>> group the init/cleanup of those features together.
>> If you take that into account, the srcu (which is needed only for ODP)
>> needs to be done in the ODP stage, but the issue is that not only ODP code
>> uses the srcu, destroy_mkey() will sync on it.
> 
> Okay, right, so this series creates the united srcu possibility. The
> commit messages are not totally clear..
> 
>> So I can move the srcu initialization to INIT, but this way we lose
>> context when looking at the ODP stage.
> 
> If something is being used by multiple stages then it really seems
> like it should be common.
> 
> Introducing a function call back just to avoid initing a srcu in
> common code for the sole reason of 'keeping like together' seems
> like bad taste to me..

Well, it's not only that, moving the init srcu to the INIT stage
will also make me wrap it around with CONFIG_INFINIBAND_ON_DEMAND_PAGING
which I really don't like seeing in .c files, but we are already doing that
so .... :)

If you feel that strongly about it, let me know and I'll change that,
as well as the comment you had about the const in a different patch
and we'll send v1 with the fixes.

Thanks for the comments!

> Jason
> 

Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
