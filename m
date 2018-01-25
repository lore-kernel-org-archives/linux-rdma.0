From: Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Thu, 25 Jan 2018 16:10:44 +0200
Message-ID: <CADZhsQpM8=MXRU=_015f3bo_EisM8N4vL=8XkO1a4c4yHwbC3w@mail.gmail.com>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
 <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me> <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
 <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <77cef33e-a563-97fc-7ba6-69f220f1be84-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> Yes, it could be a userspace script/daemon job. But I was under the
>> impression
>> that this group tries to consolidate most (all?) of the functionality into
>> the
>> driver, and not rely on userspace daemons. Maybe a lesson learnt from
>> iSCSI?
>
>
> Indeed that is a guideline that was taken early on. But
> auto-connect/auto-discovery is not something I think we'd like to
> implement in the kernel...

So to summarize your view on this topic:
* Agreed that user experience should be such that after an RDMA device reset
  everything should continue as before without admin intervention.
* Both for host and target stacks.
* This should not be handled by the driver itself.
* A userspace daemon that listens on udev events should retry the reconnects
  or re-binds using configfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
