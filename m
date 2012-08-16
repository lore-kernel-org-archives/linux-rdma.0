From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [infiniband:for-next 9/19] drivers/net/ethernet/mellanox/mlx4/mr.c:134:4:
 error: implicit declaration of function 'vmalloc'
Date: Thu, 16 Aug 2012 09:05:56 -0700
Message-ID: <CAL1RGDW0w3oi+HuENWBqzAXMvLpHji_Z+B4qO9XNvvDsKEnrEA@mail.gmail.com>
References: <20120816003552.GA3532@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120816003552.GA3532@localhost>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 15, 2012 at 5:35 PM, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> drivers/net/ethernet/mellanox/mlx4/mr.c: In function 'mlx4_buddy_init':
> drivers/net/ethernet/mellanox/mlx4/mr.c:134:4: error: implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
> drivers/net/ethernet/mellanox/mlx4/mr.c:134:19: warning: assignment makes pointer from integer without a cast [enabled by default]
> drivers/net/ethernet/mellanox/mlx4/mr.c:149:4: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

Stephen caught this in -next testing too, should be fixed today.

Thanks!
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
