From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Wed, 23 Aug 2017 10:52:21 -0600
Message-ID: <20170823165221.GB23928@obsidianresearch.com>
References: <20170817173320.GB22792@obsidianresearch.com>
 <20170817173932.GJ23648@mtr-leonro.local>
 <20170817180349.GD24735@obsidianresearch.com>
 <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
 <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
 <20170822163007.GB4922@obsidianresearch.com>
 <1b7e41dc-4873-7c0a-6cdb-bc499af70af2@dev.mellanox.co.il>
 <20170823160816.GA11188@obsidianresearch.com>
 <20170823164555.GV1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170823164555.GV1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 23, 2017 at 07:45:55PM +0300, Leon Romanovsky wrote:

> > Provide two implementations of mlx5dv_init_obj, one that has the
> > historical behaviour that has existed until now of returning the
> > void **uar and a new version that returns the 'void *' version
> > renamed to arb_db.
> 
> arb_db -> arm_db

Oops, I fixed that, thanks.

> Strange, in github it has 7 digits (the same was with rsocket fixes)
> Fixes: c6e3439 ("mlx5: Return pointer to CQ doorbell")

Yeah, side effect of github rendering it into a web link, I think.

> The overall looks good, but I need to run checks with before
> applying it.

Sure, I didn't test it obviously, but the readelf is what I expect:

   101: 000000000000e4d0    55 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_obj@MLX5_1.0
   168: 000000000000e4d0    55 FUNC    LOCAL  DEFAULT   13 __mlx5dv_init_obj_1_0
   102: 000000000000e300   451 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_obj@@MLX5_1.2
   169: 000000000000e300   451 FUNC    LOCAL  DEFAULT   13 __mlx5dv_init_obj_1_2

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
