From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 1/2] IB/iser: set block queue_virt_boundary
Date: Sun, 11 Oct 2015 22:04:02 +0300
Message-ID: <CAJ3xEMhhFSRcMrDm--PD-ekr6hJZZXGk_3JE2iEmmHN0fi=b-Q@mail.gmail.com>
References: <1444577707-15778-1-git-send-email-sagig@mellanox.com>
	<1444577707-15778-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444577707-15778-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 11, 2015 at 6:35 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> By limiting the sg lists that we are allowing to meet
> and 4k virtual boundary, we can completely remove the
> entire bounce buffering logic.

"limiting the sg lists that we are allowing to meet and 4k virtual boundary"

This "and" must be typo, right? please fix.

What happens now when an app wants to use 1K, 2K, 3K IOs? they can
only use 1/4, 1/2 or 3/4 of the available memory for these
transactions? and we are going to fix it with devices like mlx5 over
the new API you're proposing, right?

If this is the case, aren't we introducing a regression for
applications that used this IO pattern over devices which aren't
capable as mlx5 is (e.g mlx4), in the sense that the required memory
footprint to address the application IO demand can be made 4X bigger?

If the 4X assertion made here is correct, why not keeping the current
BB logic to come into play for such devices? I know that without the
BB code our driver looks much nicer and elegant, but life is sometimes
more complex... thoughts?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
