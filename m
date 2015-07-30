From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/22] IB/iser: Remove dead code in fmr_pool alloc/free
Date: Thu, 30 Jul 2015 13:31:07 +0300
Message-ID: <CAJ3xEMh7H4+hUfV8qUr5wTsV02YG0vXTPGWLR=KKHeBMxA-zYA@mail.gmail.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
	<1438243595-32288-12-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-12-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 11:06 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> In the past the we always tried to allocate an fmr_pool
> and if it failed on ENOSYS (not supported) then we continued
> with dma mr. This is not the case anymore and if we tried to
> allocate an fmr_pool then it is supported and we expect to succeed.

AFAIK, the ENOSYS flow was something that came into play when working
e.g over VF drivers such as mlx4 that don't support fmr-ing but we still wanted
an optimal performance. What does "this is not the case anymore" means? these
VF drivers are still out there.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
