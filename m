From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: yet again the atomic operations
Date: Fri, 06 Aug 2010 08:49:16 -0700
Message-ID: <adaocdf2137.fsf@roland-alpha.cisco.com>
References: <AANLkTikQX+CKvs_pjkH_Ap358jfjp4dYKYyKG95+eZmt@mail.gmail.com>
	<1281033688.7414.30.camel@chromite.mv.qlogic.com>
	<AANLkTimVTjHOubAaJ5oRHju6C7k7FZMqqq0Mvb4SBztB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimVTjHOubAaJ5oRHju6C7k7FZMqqq0Mvb4SBztB-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Rui Machado's message of "Fri, 6 Aug 2010 13:43:22 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > So if the CPU writes/reads to/from the same address, even atomically
 > (lock), there might be room for some inconsistency on the values? It
 > is not really atomic from the whole system point of view, just for the
 > HCA? If so, is there any possibility to make the whole operation
 > 'system-wide' atomic?

PCI does not have any capability for atomic operations until PCI Express
3.0 (not available in any real devices yet).  So any current HCA
performing atomic operations across a PCI bus will always have to do
read-modify-write which leaves a window for the CPU to mess things up if
it accesses the same location.

You can work around this by creating a loopback connection (ie an RC
connection from the local HCA to itself) and post atomic operations to
that QP instead of accessing the memory directly with the CPU.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
