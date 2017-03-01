From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Wed, 1 Mar 2017 23:57:37 +0200
Message-ID: <CAFgAxU_i+5FtBkdf=t5vdQAvBqDt9aKsFJbAKGN5YWQQ9w-c2A@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <20170301001023.GA3001@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301001023.GA3001-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 1, 2017 at 2:10 AM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Feb 27, 2017 at 06:08:41PM +0200, Alex Rosenbaum wrote:
>> Introduction
>>
>> --------------------------------------------------------------------------------
> After the call
>
> Ira
>

Ira,
On the call we discussed that today there is no 'incarnation' value
exposed for the uverbs%.
You suggested an optimization by using the cdev's file creation
timestamp as option for libibverbs to understand that the driver did
or did-not restart since mapping of that ibv_device.
Main pitfalls with this is if system time is being modified (admin or
ntp/ptp). In the rare case that we have a hoplug event and time is
rewinded we can accidentally reach a very hard debugging exercise.
What do you think?
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
