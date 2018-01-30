From: Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Tue, 30 Jan 2018 17:03:48 +0200
Message-ID: <CADZhsQpWXQQ2dKxAorGMhk7HFvqoQ2Y5LxVKt66XjkcUbEuXpA@mail.gmail.com>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
 <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me> <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
 <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me> <1516904022.27592.187.camel@redhat.com>
 <26056a83-2f81-6b56-7bbf-fcecfc4518d6@grimberg.me> <1517264899.27592.277.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517264899.27592.277.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 30, 2018 at 12:28 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 2018-01-29 at 22:36 +0200, Sagi Grimberg wrote:
>> >
>> That is the case for nvme as well, but I was merely saying that device
>> reset is not really a device removal. And this makes it hard for the ULP
>> to understand what to do (or for me at least...)
>
> OK, I get that the difference between the two is making it hard to
> understand what to do.  But, the truth of the issue is that whether you
> are doing a reset or a remove/add cycle, what *your* code needs to do
> doesn't change.  For both cases, your code must A) drop everything on
> the floor like a hot potato and B) restart from scratch.

Fully agree here. You don't want different code flow for reset. You already
have remove/add flows, which require to to act the right way as Doug
described. A reset is exactly remove and add of the same device.

> The only thing
> that's confusing you is that it's more or less assumed on a reset that
> you would auto-restart, where as it isn't so clear that you would want
> to do the same on a remove/add cycle.  I think the answer to your
> question is: if the same device comes back that went away, then yes,
> auto-restart would seem appropriate.  If you make that policy decision,
> then the *only* difference between device reset and device hot-replug is
> that you actually have to verify that the same device came back as went
> away.
>
> As an optional item, you could start a timer when the device disappears,
> and if it takes more than, say, 10 minutes to reappear, you could cancel
> the auto-restart on the basis that someone probably physically unplugged
> and replugged the card and they might not want that.  But really, aside
> from the fact that the hot plug flow needs you to check the same device
> comes back, reset and hot plug have the exact same requirements/needs
> and can be serviced by a single code path.

Not sure why we need to keep track whether it is the same device or not.
I fail to understand why we trust the system admin to create the connections
at the beginning, but we should not trust him anymore if the device was
removed, a new device was added in place of it, and it was configured with the
same network IP/subnet. To me it looks like the admin wanted exactly that:
for the connections to be restored over the new device.

If the admin does not want the reconnections to happen, he has the option
to explicitly request to disconnect. Same if the device was removed forever.

And to help us with all that, we have rdma_cm. As long as we repeat the
rdma_connect() on the initiator side and rdma_bind/resolve_addr()... on
the target side, we'll get exactly this behaviour.

If we want this using userspace daemons - that's fine. We'll need one for the
initiator stack and one for the target stack. And we'll probably need some
missing udev events and configfs entry?

-- 
Oren
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
