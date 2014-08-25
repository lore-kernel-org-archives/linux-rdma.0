From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/8] IPoIB: fix MCAST_FLAG_BUSY usage
Date: Mon, 25 Aug 2014 12:51:13 -0700
Message-ID: <CABgxfbHOD75vLdZ0TtWZbk8ne3kHd_eWObxPHmoJ-D8DjE0bkw@mail.gmail.com>
References: <cover.1407885724.git.dledford@redhat.com>
	<a410e80dc5ca7cfa64229bbbf50c1337317e3bd8.1407885724.git.dledford@redhat.com>
	<CABgxfbH-Dt3CpxJKwCAZeHTUyupaA9y_WXVXuxgiPMet26PTQw@mail.gmail.com>
	<902D5BF2-159A-4B31-A87F-7491F3C8057F@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <902D5BF2-159A-4B31-A87F-7491F3C8057F-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 19, 2014 at 1:28 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> So that's why in this patch we
>
> 1) take a mutex to force ib_sa_join_multicast to return and us to set mcast->mc to the proper return value before we process the join completion callback
> 2) always clear mcast->mc if there is any error since we can't call ib_sa_multicast_leave
> 3) always complete the mcast in case we are waiting on it
> 4) only if our status is ENETRESET set our return to 0 so the ib core code knows we acknowledged the event
>

We don't have IPOIB_MCAST_JOIN_STARTED (and the "done" completion
struct) in our code base (MPSS) yet ...I'm *not* n-acking this patch
but I find it hard to understand the ramifications. It has nothing to
do with this patch - actually the patch itself looks pretty ok (by
eyes).

The original IPOIB mcast flow, particularly its abnormal error path,
confuses me. Is it really possible for ib_sa_join_multicast() to
return *after* its callback (ipoib_mcast_sendonly_join_complete and
ipoib_mcast_join_complete) ? The mcast->done completion struct looks
dangerous as well.

I'll let other capable people to do the final call(s).

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
