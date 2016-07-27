From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB/mlx4: Use EAGAIN error code instead or EINVAL in function
 mlx4_ib_poll_one
Date: Wed, 27 Jul 2016 13:26:41 +0300
Message-ID: <20160727102640.GA3549@yuval-lap.uk.oracle.com>
References: <1469607893-10657-1-git-send-email-yuval.shaia@oracle.com>
 <20160727085800.GF4628@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160727085800.GF4628-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 27, 2016 at 11:58:00AM +0300, Leon Romanovsky wrote:
> On Wed, Jul 27, 2016 at 01:24:51AM -0700, Yuval Shaia wrote:
> > Please review the following two patches.
> > First patch makes int-return function to a void one as it anyway returns 0.
> > Second patch replace all EINVAL error codes returned from mlx4_ib_poll_one
> > to EAGAIN.
> 
> Thanks Yuval for taking time to do it.
> After your's IPoIB patches, we prepared patch similar to these and
> planned to send it after merge window will close.

Great new!
So, will you also take care of making the function use_tunnel_data void?

> 
> > 
> > [PATCH 1/2] IB/mlx4: Make function use_tunnel_data return void
> > [PATCH 2/2] IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
