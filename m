From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Fri, 12 Jan 2018 10:02:28 -0700
Message-ID: <20180112170228.GD15974@ziepe.ca>
References: <20180112055842.23125-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112055842.23125-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:

So, my take on the for-rc8-ness, based on the commit messages alone:

> Bodong Wang (1):
>   IB/core: Fix ib_wc structure size to remain in 64 bytes boundary

No, performance optimization only, and not a regression in this cycle

> Jack Morgenstein (1):
>   IB/mlx4: Fix incorrectly releasing steerable UD QPs when have only ETH
>     ports

No, only supresses an annoying warning

> Leon Romanovsky (1):
>   RDMA/mlx5: Fix out-of-bound access while querying AH

Yes, fixes a user triggerable out of bounds access

> Parav Pandit (1):
>   RDMA/core: Fix avoid decoding iWarp port as RoCE

Unknown, commit message is too short. Parav, please explain more why this
this is worthy of 'CC: stable' ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
