From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and
 multicast traffic
Date: Mon, 26 Jan 2015 22:57:29 +0200
Message-ID: <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
	<CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
	<1422301106.2854.41.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422301106.2854.41.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 26, 2015 at 9:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 2015-01-26 at 15:16 +0200, Or Gerlitz wrote:
>> On Mon, Jan 26, 2015 at 3:00 PM, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> > Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage" both
>> > IPv6 traffic and for the most cases all IPv4 multicast traffic aren't
>> > working.
>>
>>
>> Hi Doug + Roland
>>
>> Erez was very patiently reviewing and testing all the six (V0...V5)
>> patch series you sent to fix the 3.19-rc1 regression.
>
> Yes he has.


>>  Can you also give this patch a try?

> I can test it.  But I need to know how it's supposed to be applied.

just apply it on latest upstream and run whatever tests you have, simple.

> It might fix the regression, it might also reintroduce a race on
> ifup/ifdown.  I'll test and see.

Let's see it in action @ your env

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
