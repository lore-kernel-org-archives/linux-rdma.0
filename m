From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 39/53] IB/qib: Add qib_trace.c
Date: Mon, 23 Nov 2009 20:09:35 -0800
Message-ID: <adaaayc36o0.fsf@roland-alpha.cisco.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
	<20091119234021.30356.77098.stgit@chromite.mv.qlogic.com>
	<ada63966oip.fsf@roland-alpha.cisco.com>
	<alpine.LFD.1.10.0911191652280.21294@topaz.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.1.10.0911191652280.21294-vxnkQ4oxbxUi9g6yJnKVd0EOCMrvLtNR@public.gmane.org> (Dave
	Olson's message of "Thu, 19 Nov 2009 16:53:38 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > | I don't think random PCI device drivers hooking into the panic notifier
 > | chain is really a good idea, so probably ripping this out for now is the
 > | best thing to do.
 > 
 > It's extremely useful to have this, otherwise no trace info gets out
 > when the system panics (one of the big reasons you want tracing
 > in the first place).
 > 
 > As best as I can tell, the panic hooks are intended for just this kind
 > of thing.  If there's some other mechanism, we'd be happy to use it.

I can't find one other "non-special" driver hooking into the panic
notifier.  (The only uses appear to be console drivers doing flushing to
make sure that panic messages actually appear)  Which should be a hint
that you probably don't really need it either.

Really, all this duplicated tracing infrastructure is a no-go.  Take a
look at ftrace events; they're pretty much awesome.  Look in
Documentation/trace and for a practical example all the trace_ext4_xxx
stuff in fs/ext4.  Then you can add a generic mechanism to dump the
trace buffer on panic; I think the tracing guys would be supportive of
that, it makes a lot of sense for debugging.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
