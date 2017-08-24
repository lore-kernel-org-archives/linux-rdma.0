From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Thu, 24 Aug 2017 10:40:06 -0600
Message-ID: <20170824164006.GC23110@obsidianresearch.com>
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

> > Some common macros a bit of use of .alias will do the job, but nobody
> > has cared enough about static linking to do it. We shouldn't worry
> > about that now...
> 
> Maybe it is true for libibverbs, but it is not for libmlx4/5 which can
> be statically linked.

Wel.. that is dangerous, there is quite a bit of stuff that the user
has to do exactly right to make that work safely. Including
guarenteeing the exact right version of libibverbs.so is present
when doing the compile.

If people are doing static linking then we should do a lot more to try
and make that work properly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
