From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 0/8] infiniband: Remove semaphores
Date: Mon, 17 Oct 2016 22:06:16 +0200
Message-ID: <6244597.a6XMUIxjP0@wuerfel>
References: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org> <216461f1-3070-c93a-a560-7560a727cb8d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <216461f1-3070-c93a-a560-7560a727cb8d-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Monday, October 17, 2016 9:57:34 AM CEST Bart Van Assche wrote:
> On 10/17/2016 09:30 AM, Binoy Jayan wrote:
> > These are a set of patches which removes semaphores from infiniband.
> > These are part of a bigger effort to eliminate all semaphores from the
> > linux kernel.
> 
> Hello Binoy,
> 
> Why do you think it would be a good idea to eliminate all semaphores 
> from the Linux kernel? I don't know anyone who doesn't consider 
> semaphores a useful abstraction.

There are a several reasons why the semaphores as defined in the
kernel are bad and we should get rid of them:

- semaphores cannot be analysed using lockdep, since they don't
  always fit in the simpler 'mutex' semantics

- those that are basically mutexes should be converted to mutexes
  for efficiency and consistency anyway

- the semaphores that are not just used as mutexes are typically
  used as completions and should just be converted to completions
  for simplicity

- when running a preempt-rt kernel, semaphores suffer from priority
  inversion problems, while mutexes use use priority inheritance
  as a countermeasure

There are very few remaining semaphores in the kernel and generally
speaking we'd be better off removing them all so no new users
show up in the future. Most of them are trivial to replace with
mutexes or completions. For the ones that are not trivially replaced,
we have to look at each one and decide what to do about them,
there usually is some solution that actually improves the code.

Using an open-coded semaphore as a replacement is probably just
the last resort that we can consider once we are down to the
last handful of users. I haven't looked at drivers/infiniband/
yet for this, but I believe that drivers/acpi/ is a case for
which I see no better alternative (the AML bytecode requires
counting semaphore semantics).

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
