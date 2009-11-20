From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 39/53] IB/qib: Add qib_trace.c
Date: Thu, 19 Nov 2009 16:53:38 -0800
Message-ID: <alpine.LFD.1.10.0911191652280.21294@topaz.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com> <20091119234021.30356.77098.stgit@chromite.mv.qlogic.com> <ada63966oip.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada63966oip.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 19 Nov 2009, Roland Dreier wrote:
| I don't think random PCI device drivers hooking into the panic notifier
| chain is really a good idea, so probably ripping this out for now is the
| best thing to do.

It's extremely useful to have this, otherwise no trace info gets out
when the system panics (one of the big reasons you want tracing
in the first place).

As best as I can tell, the panic hooks are intended for just this kind
of thing.  If there's some other mechanism, we'd be happy to use it.

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
