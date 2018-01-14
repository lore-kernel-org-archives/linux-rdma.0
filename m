From: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Sun, 14 Jan 2018 19:15:02 +0200
Message-ID: <20180114191502.00001940@dev.mellanox.co.il>
References: <20180112055842.23125-1-leon@kernel.org>
        <20180112170228.GD15974@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112170228.GD15974-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 12 Jan 2018 10:02:28 -0700
Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:

> On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:
> 
> So, my take on the for-rc8-ness, based on the commit messages alone:
> 
> > Bodong Wang (1):
> >   IB/core: Fix ib_wc structure size to remain in 64 bytes boundary  
> 
> No, performance optimization only, and not a regression in this cycle
> 
> > Jack Morgenstein (1):
> >   IB/mlx4: Fix incorrectly releasing steerable UD QPs when have
> > only ETH ports  
> 
> No, only supresses an annoying warning

It does not "suppress" the warning, it fixes the bug which caused
the warning to be written in the log.

The warning happens BECAUSE of the incorrect release attempt.
When the bug in the code is fixed, the warning does not occur.
It is true that at present the annoying (and worrisome) warning in the
log is the only problem resulting from this bug -- but it is still
a bug, and needs to be fixed.

> 
> > Leon Romanovsky (1):
> >   RDMA/mlx5: Fix out-of-bound access while querying AH  
> 
> Yes, fixes a user triggerable out of bounds access
> 
> > Parav Pandit (1):
> >   RDMA/core: Fix avoid decoding iWarp port as RoCE  
> 
> Unknown, commit message is too short. Parav, please explain more why
> this this is worthy of 'CC: stable' ?
> 
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
