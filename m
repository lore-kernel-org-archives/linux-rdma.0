From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs V5 2/2] Use neighbour lookup for RoCE UD QPs Eth L2 resolution
Date: Mon, 25 Aug 2014 15:33:57 -0400 (EDT)
Message-ID: <5C3BB7B1-07E6-431F-98E5-13543AAA897D@redhat.com>
References: <1408517381-17523-1-git-send-email-matanb@mellanox.com> <1408517381-17523-3-git-send-email-matanb@mellanox.com> <20140820170142.GC12605@obsidianresearch.com> <53F9EDCD.9060105@mellanox.com> <20140825183325.GC1298@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140825183325.GC1298-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Aug 25, 2014, at 1:33 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
>>>> +    timer_fd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK | TFD_CLOEXEC);
>>>> +    if (-1 == timer_fd) {
>>>> +        print_err("Couldn't create timer\n");
>>>> +        return timer_fd;
>>>> +    }
>>> 
>>> The use of timerfd will impact the minimum OS version, have you
>>> checked this is OK? Does RHEL5 still work?
> 
>> It was added in linux v2.6.25. I think that an API that's more than
>> 6.5 years old is valid.
> 
> RHEL5 is using 2.6.18 as their base kernel. You should at least
> consult with the OFED people to determine if this is a problem for
> them.

Please don't.  This code should not be changed for something as ancient as rhel5.

Sent from my iPad

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
