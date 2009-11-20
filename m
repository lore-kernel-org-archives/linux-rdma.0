From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 39/53] IB/qib: Add qib_trace.c
Date: Thu, 19 Nov 2009 16:14:22 -0800
Message-ID: <ada63966oip.fsf@roland-alpha.cisco.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
	<20091119234021.30356.77098.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091119234021.30356.77098.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 19 Nov 2009 15:40:21 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Seems all this infrastructure could be profitably ripped out and
replaced with the more powerful and flexible ftrace events stuff...

 > +#ifndef ATOMIC_NOTIFIER_INIT
 > +/*
 > + * Some backports don't have this, so define here for now.
 > + * We may not want to keep this for upstream.  If we do, we'll
 > + * do this via the backports at that time.
 > + */
 > +#define atomic_notifier_chain_register notifier_chain_register
 > +#define atomic_notifier_chain_unregister notifier_chain_unregister
 > +#endif

Doesn't seem like this was meant to go into the upstream submission?
Seems like it would be worth going over the patches again and cleaning
up everything that is solely for compatibility with old kernels.

I don't think random PCI device drivers hooking into the panic notifier
chain is really a good idea, so probably ripping this out for now is the
best thing to do.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
