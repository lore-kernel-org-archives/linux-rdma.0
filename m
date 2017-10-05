From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: Convert timers to use timer_setup()
Date: Thu, 5 Oct 2017 15:48:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1710051546130.2083@nanos>
References: <20171005004527.GA22607@beast> <622bfd9d-69df-9d78-d72b-5bd49d979afa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <622bfd9d-69df-9d78-d72b-5bd49d979afa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 5 Oct 2017, Doug Ledford wrote:

> On 10/4/2017 8:45 PM, Kees Cook wrote:
> > In preparation for unconditionally passing the struct timer_list pointer to
> > all timer callbacks, switch to using the new timer_setup() and from_timer()
> > to pass the timer pointer explicitly. A pointer from nesadapter back to
> > nesdev was added.
> > 
> > Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > ---
> > This requires commit 686fef928bba ("timer: Prepare to change timer
> > callback argument type") in v4.14-rc3, but should be otherwise
> > stand-alone.
> 
> What is your intention with this, and the other RDMA related, patches?
> Is it your intention that I should pick these up or is someone else
> supposed to (you sent it to linux-kernel and only Cc:ed linux-rdma)?
> Also, are you intending this to go into -rc?  If so, why is it dependent
> on a patch that didn't land until -rc3?

That's 4.15 material and should preferrably be picked up by the relevant
maintainers. The 4.14-rc3 reference is there just in case a maintainer tree
is based on pre 4.14-rc3, so applying the patch would break the build.

Thanks,

	tglx

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
