From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/core: Only maintain real QPs in the
 security lists
Date: Tue, 7 Nov 2017 10:32:15 -0700
Message-ID: <20171107173215.GD7063@ziepe.ca>
References: <20171107163326.23881-1-leon@kernel.org>
 <20171107164632.GA7063@ziepe.ca>
 <065e66ff-e901-bd5c-674d-173eab720989@mellanox.com>
 <20171107165539.GB7063@ziepe.ca>
 <87a902ae-351b-43c4-4a42-b362c981a767@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87a902ae-351b-43c4-4a42-b362c981a767-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 07, 2017 at 11:15:12AM -0600, Daniel Jurgens wrote:

> This flow is through ib_modify_qp, it's not user space specific. If
> it really pains you that much it can be changed an inclusive compare
> instead of exclusive.

There was already a RFC on re-purpsing those constants and exposing
them to user space.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
