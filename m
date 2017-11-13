From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/5] verbs: Introduce thread domain and its
 related verbs
Date: Mon, 13 Nov 2017 12:58:22 -0700
Message-ID: <20171113195822.GD22610@ziepe.ca>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510522903-6838-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 12, 2017 at 11:41:39PM +0200, Yishai Hadas wrote:

> +struct ibv_td {
> +	struct ibv_context     *context;
> +};

As much as possible, I would like to see any new objects be 'opaque'
to the application, so this should just be

struct ibv_td;

And ibv_td should be defined in driver.h or something

This avoids leaking internal details and means we don't have to commit
to an ABI for the insides of these structs.

It was a mistake that so many structs were entirely exposed in the
original verbs :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
