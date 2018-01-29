From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Mon, 29 Jan 2018 21:58:29 +0200
Message-ID: <05b789c6-b60d-6738-f5a4-dd6df9cb2fcb@grimberg.me>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
 <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
 <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
 <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
 <CADZhsQpM8=MXRU=_015f3bo_EisM8N4vL=8XkO1a4c4yHwbC3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADZhsQpM8=MXRU=_015f3bo_EisM8N4vL=8XkO1a4c4yHwbC3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> So to summarize your view on this topic:
> * Agreed that user experience should be such that after an RDMA device reset
>    everything should continue as before without admin intervention.

Yes

> * Both for host and target stacks.

Yes

> * This should not be handled by the driver itself.
> * A userspace daemon that listens on udev events should retry the reconnects
>    or re-binds using configfs.

No, I'm saying transient errors should be handled by the driver itself,
recovery from permanent errors (like unplug+replug) should be handled
outside the kernel.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
