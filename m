From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Tue, 29 Nov 2016 09:19:00 -0700
Message-ID: <20161129161900.GA742@obsidianresearch.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
 <1480258296-27032-2-git-send-email-leon@kernel.org>
 <20161128170056.GC28381@obsidianresearch.com>
 <CAJ3xEMiv6HCu-9fi12XtafxYWu-+gNPMbnfb-A4-+FrgR6KZNA@mail.gmail.com>
 <20161128222559.GB744@obsidianresearch.com>
 <CAJ3xEMiC3UDujgSL5fwP7ee1=OjhorZ2aeB1k+ptGb9GWaUVkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiC3UDujgSL5fwP7ee1=OjhorZ2aeB1k+ptGb9GWaUVkg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 29, 2016 at 08:35:52AM +0200, Or Gerlitz wrote:
> > or at least it should or things are already broken.
> 
> Can you elaborate what it broken with mlx4? I suspect we
> even have down there some functionality which depends on that,
> but again, I 1st would like to hear if/what is broken - I copied the maintainer.

The semantic we require is that everything under a struct ib_device is
compatible, you can use an AH on any PD with any QP on any port. As an
example wee absolutely do not allow iwarp and ib on the same
ib_device, (rdma_cm will break horribly, at least).

The fact rocee and ib sort of work together as-is represents a fluke
not a design goal :(

> Jason, patches 8-10 which carry the functional change I want to introduce
> (allow mlx5 IB devices to be created when RoCE is not supported) stand
> for themselves.

I asked for the port_num to be removed, and the uapi for it to be
device not port specific. Don't see why that is such a big deal..

> a re-write of the 10y old IB device-ing of things done by mlx4 just
> to be able and introduce this reduced functionally (raw packet qp
> only) of mlx5 devices.

Seems totally fair to me for patches adding a new uapi. Why do you
guys keep thinking uapis should be easy?

Who else is going to fix this?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
