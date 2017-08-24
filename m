From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Thu, 24 Aug 2017 09:00:45 -0600
Message-ID: <20170824150045.GA23110@obsidianresearch.com>
References: <20170817180349.GD24735@obsidianresearch.com>
 <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
 <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
 <20170822163007.GB4922@obsidianresearch.com>
 <1b7e41dc-4873-7c0a-6cdb-bc499af70af2@dev.mellanox.co.il>
 <20170823160816.GA11188@obsidianresearch.com>
 <20170823164555.GV1724@mtr-leonro.local>
 <20170823165221.GB23928@obsidianresearch.com>
 <20170824052716.GD1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824052716.GD1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 24, 2017 at 08:27:16AM +0300, Leon Romanovsky wrote:

> It is not complete output as I would expect to see. It doesn't have
> mlx5dv_init_obj (without explicit @MLX5_1.2). There is a need to declare default
> function name for the static linking has no knowledge of versions.

symver support and static linking in verbs has never worked properly,
we need to do more work overall to fix that..

Some common macros a bit of use of .alias will do the job, but nobody
has cared enough about static linking to do it. We shouldn't worry
about that now...

> The simplest approach which is used in whole rdma-core is just retain
> the original function name and the patch below on top of your patch
> achieves it.

Well, if this is the result you got:

>     99: 000000000000dab0    55 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_obj@MLX5_1.0
>    165: 000000000000dab0    55 FUNC    LOCAL  DEFAULT   13 __mlx5dv_init_obj_1_0
>    194: 000000000000d8f0   443 FUNC    LOCAL  DEFAULT   13 mlx5dv_init_obj
>    268: 000000000000dab0    55 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_obj@MLX5_1.0

Then changing the name totally broke the dynamic symbols.

Which is what I remember when I last tried to work on this (to avoid
having to specify a prototype for the __).

I concluded the linkers broke if there was a symbol in the link with
the same name as the versioned symbol when using _symver.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
