From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 5/5] mlx5: Handles QP creation with a given
 parent domain
Date: Mon, 13 Nov 2017 13:05:18 -0700
Message-ID: <20171113200518.GF22610@ziepe.ca>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-6-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510522903-6838-6-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 12, 2017 at 11:41:43PM +0200, Yishai Hadas wrote:
> This patch comes to demonstrate the expected usage of parent domain
> and its internal thread domain as part of QP creation.
> 
> In case a parent domain was set, its internal protection domain (i.e.
> ibv_pd) will be used for the PD usage and if a thread domain exists its
> dedicated UAR will be used by passing its index to the mlx5
> kernel driver. In that way application can control the UAR that this QP
> will use and share it with other QPs upon their creation by suppling the
> same thread domain.
> 
> A full patch will be supplied as part the final series post this RFC.

I thought the plan was to have API entry points under mlx5dv to
access and set the UAR on the TD? Is that still the case?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
