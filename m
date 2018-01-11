From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] Increase number of char devices in RDMA
Date: Wed, 10 Jan 2018 21:28:58 -0700
Message-ID: <20180111042858.GA16668@ziepe.ca>
References: <20180108101538.16451-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180108101538.16451-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 08, 2018 at 12:15:36PM +0200, Leon Romanovsky wrote:
> Hi,
> 
> The following two patches from Huy with a nice diffstat (more removed than
> added) increases upto 1024 the maximum number of available in RDMA stack
> char devices, so it will be possible to use in large SR-IOV instances.
> 
> Thanks
> 
> Huy Nguyen (2):
>   IB/core: Remove the locking for character device bitmap
>   IB/core: Refactor allocation code to increase number of char device

Applied to for-next

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
