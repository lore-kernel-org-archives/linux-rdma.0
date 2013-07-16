From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/4] IP based RoCE GID Addressing
Date: Tue, 16 Jul 2013 06:30:01 +0300
Message-ID: <CAJZOPZ+AXCy_ATJUtfOy+i9EHQBRzyRsdtyDgxkphQ8yPBTh8w@mail.gmail.com>
References: <1371135704-5712-1-git-send-email-ogerlitz@mellanox.com>
	<20130613170011.GA21570@obsidianresearch.com>
	<CAJZOPZKMf+HOompez2+3rkqz7jCS=-HEJo9q0quZOc8i7KpLmQ@mail.gmail.com>
	<CALsNU1PdjV2N4c3j9gQ0BRrd4GhOypDMMjmHEgF1ffCYOXeC1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALsNU1PdjV2N4c3j9gQ0BRrd4GhOypDMMjmHEgF1ffCYOXeC1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh28-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Devesh Sharma <devesh28-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
[...]
> What will happen to those devices which does not suppot IP based RoCE, How
> connection management will happen with those if Native RoCE support is
> removed. There may be other devices/implementations which does not support
> IP Base RoCE.


RoCE GIDs is something programmed by the low-level IB driver into the
device GID table, so what ever format used for GIDs, the device has to
support being programmed by the driver.

> How connection management will happen on them, will those devices always
> see Connection Reject event form RDMA-CM?

When a CM connection request is received by a node and the GID inside
it doesn't match any GID on this node GID table, the IB CM sends a
reject message with "invalid gid" reject reason.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
