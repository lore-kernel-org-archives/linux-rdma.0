From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
 registration
Date: Thu, 25 Jan 2018 09:07:25 -0700
Message-ID: <20180125160725.GC10706@ziepe.ca>
References: <1515088046-26605-1-git-send-email-alexma@mellanox.com>
 <1515088046-26605-2-git-send-email-alexma@mellanox.com>
 <20180111122206.GB2800@yuvallap>
 <20180111164455.GA1309@ziepe.ca>
 <VI1PR05MB1278C4C4FF78B4B1A551252EB9EC0@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20180123202954.GA14007@yuvallap>
 <VI1PR05MB12787572593F02F05AA20DE1B9E10@VI1PR05MB1278.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR05MB12787572593F02F05AA20DE1B9E10-79XLn2atqDMOK6E67s+DINqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 25, 2018 at 12:43:05PM +0000, Alex Margolin wrote:

> Actually, I realized it can be implemented with the proposed API.
> All that is missing is a capability bit and a flag for set_layout_*,
> and the implementation could work as follows (changes relative to SG example):

This can work..

> In this case calling ibv_mr_set_layout_sg() will cause an internal registration
> replacing the ibv_reg_mr calls for mr1 and mr2, and the registration will be stored
> in mr3.

Yuval is right though, in cases where the buffers are page aligned we
can ask the kernel to create a single normal MR supported by all HW.

Could be a useful feature.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
