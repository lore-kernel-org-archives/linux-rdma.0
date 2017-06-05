From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Check return value from get_settings
Date: Mon, 5 Jun 2017 10:59:38 +0300
Message-ID: <20170605075937.GG2572@yuvallap>
References: <20170604170619.3697-1-yuval.shaia@oracle.com>
 <20170604172630.GF6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170604172630.GF6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 04, 2017 at 08:26:30PM +0300, Leon Romanovsky wrote:
> On Sun, Jun 04, 2017 at 08:06:19PM +0300, Yuval Shaia wrote:
> > The functions get_link_ksettings and get_settings might return bad
> > status indicating a failure to retrieve interface atttibutes.
> > Check return value to cover this case.
> >
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/sw/rxe/rxe_verbs.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks Leon for your review.
I'm about to post another version for this patch and will appreciate your
review.
Looks like call to get_link_ksettings should be protected by rtnl lock, it
is undocumented but for example __ethtool_get_link_ksettings prints an ugly
dump_stack when this happen.
I will do the same as what is done in function __to_ib_speed_width

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
