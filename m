From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [for-next] IB/ipoib: Warn when one port fails to initialize
Date: Wed, 13 Dec 2017 11:19:22 -0700
Message-ID: <20171213181922.GB5984@ziepe.ca>
References: <20171129063402.3963-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171129063402.3963-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 29, 2017 at 08:34:02AM +0200, Yuval Shaia wrote:
> If one port fails to initialize an error message should indicate the
> reason and driver should continue serving the working port(s) and other
> HCA(s).
> 
> Fixes: e4b2d06892c7 ("IB/ipoib: Remove device when one port fails to
> init").
> 
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Thanks, applied to -next

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
