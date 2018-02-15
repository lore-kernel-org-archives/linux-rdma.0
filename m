From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA uverbs fixes for 4.16
Date: Thu, 15 Feb 2018 15:28:32 -0700
Message-ID: <20180215222832.GB30721@ziepe.ca>
References: <20180214103540.22374-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214103540.22374-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 14, 2018 at 12:35:36PM +0200, Leon Romanovsky wrote:
> Hi,
> 
> The following four patches fix failures found during our
> regression testing.
> 
> Thanks
> 
> Leon Romanovsky (4):
>   RDMA/restrack: Increment CQ restrack object before committing
>   RDMA/uverbs: Fix bad unlock balance in ib_uverbs_close_xrcd
>   RDMA/uverbs: Fix circular locking dependency
>   RDMA/uverbs: Sanitize user entered port numbers prior to access it

I applied all of these to for-rc, thanks

Jasno
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
