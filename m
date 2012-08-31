From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Fri, 31 Aug 2012 10:12:53 +0300
Message-ID: <CAJZOPZJcxMU48HCu+S8cEUG3VENEzH9SEtVTFzC0sJqZ=oww1g@mail.gmail.com>
References: <1346323085-2665-1-git-send-email-ogerlitz@mellanox.com>
	<CAJZOPZJOWuoBQx49-O2WLk240GWGRsqfJpCXfhxRV6Cmdw7W0w@mail.gmail.com>
	<CAL1RGDX7kx7aypOqYvvwu8KBjMra2Gqq+4OGLz22k0RVmeZ1eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDX7kx7aypOqYvvwu8KBjMra2Gqq+4OGLz22k0RVmeZ1eQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 31, 2012 at 1:35 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> I don't think this is a real problem; the radix tree code is [...]

So maybe this patch wouldn't land in 3.7, we'll see, however, so far
no other patch sits in the for-next branch of your tree for the next
window... any plan to start reviewing / picking patches anytime soon?

Also, there are three more fixes for 3.6 I sent you earlier this week,
which need to get in as they address real bugs (deadlock in IPoIB,
crashes in mlx4 when attempting to register > 512GB, more).

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
