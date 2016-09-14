From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC rdma-next 0/3] Move mlx5 vendor specific to UAPI directory
Date: Wed, 14 Sep 2016 11:21:45 -0600
Message-ID: <20160914172145.GI16014@obsidianresearch.com>
References: <1473841649-8923-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473841649-8923-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 14, 2016 at 11:27:26AM +0300, Leon Romanovsky wrote:
> The consolidate library revealed the fact that vendor specific
> structures and defines are copy/pasted between kernel and user-space,
> instead of sharing.
> 
> This RFC was tested by compilation only and not-ready for merge yet.

Yah, this is exactly what I had in mind. We need to give this
treatment to all the drivers :|

> Leon Romanovsky (3):
>   IB/mlx5: Move and decouple user vendor structures
>   IB/core: Export mlx5 vendor specific strucutres
>   MAINTAINERS: Add mlx5 uapi file

One patch is probably enough, 3 patches per driver is going to be
alot.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
