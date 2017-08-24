From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Thu, 24 Aug 2017 14:30:19 -0600
Message-ID: <20170824203019.GA9154@obsidianresearch.com>
References: <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
 <20170822163007.GB4922@obsidianresearch.com>
 <1b7e41dc-4873-7c0a-6cdb-bc499af70af2@dev.mellanox.co.il>
 <20170823160816.GA11188@obsidianresearch.com>
 <20170823164555.GV1724@mtr-leonro.local>
 <20170823165221.GB23928@obsidianresearch.com>
 <20170824052716.GD1724@mtr-leonro.local>
 <20170824150045.GA23110@obsidianresearch.com>
 <20170824155036.GN1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824155036.GN1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 24, 2017 at 06:50:36PM +0300, Leon Romanovsky wrote:

> > symver support and static linking in verbs has never worked properly,
> > we need to do more work overall to fix that..
> 
> Fix yes, but push something that works to be broken is a different story.

I'm not sure it matters to any users, since mlx5.a was broken until I
fixed it two months ago.. https://github.com/linux-rdma/rdma-core/pull/142

But, I fixed all the issues with symbol versioning here:

https://github.com/linux-rdma/rdma-core/pull/191

I revised the mlx5dv fix to use the new macros so static builds will
work for it as well.

So we should be good to go to fix this before rdma core 15

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
