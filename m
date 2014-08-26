From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/8] IPoIB: fix MCAST_FLAG_BUSY usage
Date: Tue, 26 Aug 2014 11:04:05 -0700
Message-ID: <CABgxfbED1RjBhxFJu+3RyiL2WrTKxJnsb-eJ30a3JHS80+X70Q@mail.gmail.com>
References: <cover.1407885724.git.dledford@redhat.com>
	<a410e80dc5ca7cfa64229bbbf50c1337317e3bd8.1407885724.git.dledford@redhat.com>
	<CABgxfbH-Dt3CpxJKwCAZeHTUyupaA9y_WXVXuxgiPMet26PTQw@mail.gmail.com>
	<902D5BF2-159A-4B31-A87F-7491F3C8057F@redhat.com>
	<CABgxfbHOD75vLdZ0TtWZbk8ne3kHd_eWObxPHmoJ-D8DjE0bkw@mail.gmail.com>
	<E3EFCBAC-2D6E-49D3-A556-DBD40701CC5F@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E3EFCBAC-2D6E-49D3-A556-DBD40701CC5F-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 25, 2014 at 1:03 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Aug 25, 2014, at 2:51 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Is it really possible for ib_sa_join_multicast() to
>> return *after* its callback (ipoib_mcast_sendonly_join_complete and
>> ipoib_mcast_join_complete) ?
>
> Yes.  They are both on work queues and ib_sa_join_multicast simply fires off another workqueue task.  The scheduler is free to start that task instantly if the workqueue isn't busy, and it often does (although not necessarily on the same CPU).  Then it is a race to see who finishes first.
>

Ok, thanks for the explanation. I also googled and found the original
patch where the IPOIB_MCAST_JOIN_STARTED was added. This patch now
makes sense.

Acked-by: Wendy Cheng <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On the other hand, I'm still puzzled why ib_sa_join_multicast() can't
be a blocking call (i.e. wait until callback is executed) - why would
IPOIB pay the price to work around these nasty issues ? But I guess
that is off-topic too much ..

BTW, thanks for the work. Our users will be doing if-up-down a lot for
power management, patches like these help !

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
