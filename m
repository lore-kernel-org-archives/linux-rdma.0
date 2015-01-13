From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 FIX for-3.19] IB/ipoib: Fix broken multicast flow
Date: Tue, 13 Jan 2015 22:13:25 +0200
Message-ID: <CAJ3xEMgJ_+b1avw6vacagSw0bxNVzLW064rztvJ6w3Y9Th0GRg@mail.gmail.com>
References: <1420643066-3599-1-git-send-email-ogerlitz@mellanox.com>
	<CAJ3xEMh60SGsK43b49MSozqmL8PDzTevs5CMGCvhPfmL3kHHVQ@mail.gmail.com>
	<1421167544.43839.190.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421167544.43839.190.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 13, 2015 at 6:45 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2015-01-09 at 10:32 +0200, Or Gerlitz wrote:
>> On Wed, Jan 7, 2015 at 5:04 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> > From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >
>> > Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage"
>> > both IPv6 traffic and for the most cases all IPv4 multicast traffic
>> > aren't working.
>>
>> Doug, can you ack the breakage introduced by your commit and the fix?
>
> I haven't double checked the breakage, I'll take your word for it

just try ping6 or iperf multicast and see it for yourself, please.


> (at the time I did my work, I had multicast debugging on and I verified the
> join/leave process, but I had assumed that the process would work the
> same for optional multicast groups as it does for the IPoIB broadcast
> group and other default IPoIB groups, so I didn't specifically test
> additional multicast groups above and beyond the broadcast/etc groups).
>
> However, the fix is not workable.  In particular, as soon as this patch
> is added to the kernel, you will start getting messages like this:
>
> mlx4_ib0: ipoib_mcast_leave on an in-flight join


I don't see it on my systems, is that upstream you're running? what entity does
,;x4_ib0: prefixed prints and under what settings, is that the IPoIB driver?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
