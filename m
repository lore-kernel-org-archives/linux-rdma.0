From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2 2/8] IB/core: Replace semaphore sm_sem with completion
Date: Tue, 25 Oct 2016 22:15:33 +0200
Message-ID: <3660358.5IXMF8ssab@wuerfel>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org> <CAHv-k_86z3MTYePPQcs5fWSqFeoGxt7UYG_b-SyZGQ7zVW-hSw@mail.gmail.com> <20161025154822.GA27240@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025154822.GA27240-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday, October 25, 2016 9:48:22 AM CEST Jason Gunthorpe wrote:
> 
> Using a completion to model exclusive ownership seems convoluted to
> me - is that a thing now? What about an atomic?

I also totally missed how this is used. I initially mentioned to Binoy
that almost all semaphores can either be converted to a mutex or a
completion unless they rely on the counting behavior of the semaphore.

This driver clearly falls into another category and none of the above
apply here.

> open:
> 
> while (true) {
>    wait_event_interruptible(priv->queue,test_bit(CLAIMED_BIT, &priv->flags));
>    if (!test_and_set_bit(CLAIMED_BIT, &priv->flags))
>         break;
> }

I'd fold the test_and_set_bit() into the wait_event() and get rid of the
loop here, otherwise this looks nice.

I'm generally a bit suspicious of open() functions that try to
protect you from having multiple file descriptors open, as dup()
or fork() will also result in extra file descriptors, but this
use here seems harmless, as the device itself only supports
open() and close() and the only thing it does is to keep track
of whether it is open or not.

It's also interesting that the ib_modify_port() function also
keeps track of the a flag that is set in open() and cleared
in close(), so in principle we should be able to unify this
with the semaphore, but the wait_event() approach is certainly
much simpler.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
