From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 39/53] IB/qib: Add qib_trace.c
Date: Tue, 01 Dec 2009 16:10:18 -0800
Message-ID: <1259712618.992.637.camel@chromite.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
	 <20091119234021.30356.77098.stgit@chromite.mv.qlogic.com>
	 <ada63966oip.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada63966oip.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2009-11-19 at 16:14 -0800, Roland Dreier wrote:
> Seems all this infrastructure could be profitably ripped out and
> replaced with the more powerful and flexible ftrace events stuff...
> 
>  > +#ifndef ATOMIC_NOTIFIER_INIT
>  > +/*
>  > + * Some backports don't have this, so define here for now.
>  > + * We may not want to keep this for upstream.  If we do, we'll
>  > + * do this via the backports at that time.
>  > + */
>  > +#define atomic_notifier_chain_register notifier_chain_register
>  > +#define atomic_notifier_chain_unregister notifier_chain_unregister
>  > +#endif
> 
> Doesn't seem like this was meant to go into the upstream submission?
> Seems like it would be worth going over the patches again and cleaning
> up everything that is solely for compatibility with old kernels.
> 
> I don't think random PCI device drivers hooking into the panic notifier
> chain is really a good idea, so probably ripping this out for now is the
> best thing to do.
> 
>  - R.

I looked at ftrace and I see two problems with using it.

1) It requires CONFIG_TRACING to be set which compiles code -pg
   so that function prologue code calls mcount. What Linux
   distributions will have this configured as the default?

2) We have to backport the ftrace code to whatever OFED kernels
   will be supported for OFED-1.6 which could be painful.

What if we eliminate the notifier_chain_register?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
