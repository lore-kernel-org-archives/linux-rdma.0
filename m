From: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: yet again the atomic operations
Date: Fri, 6 Aug 2010 13:43:22 +0200
Message-ID: <AANLkTimVTjHOubAaJ5oRHju6C7k7FZMqqq0Mvb4SBztB@mail.gmail.com>
References: <AANLkTikQX+CKvs_pjkH_Ap358jfjp4dYKYyKG95+eZmt@mail.gmail.com>
	<1281033688.7414.30.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281033688.7414.30.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi there,

> There are two kinds supported. QLogic's driver does them in
> the host driver so they are atomic with respect to all the CPUs
> in the host. Mellanox uses HCA wide atomic which means the
> HCA will do a memory read/write without allowing other reads
> or writes from different QP operations passing through that
> HCA to get in between. The CPUs on the host won't see
> atomic operations since from their perspective, it looks
> like a normal read and write from the PCIe bus.

So if the CPU writes/reads to/from the same address, even atomically
(lock), there might be room for some inconsistency on the values? It
is not really atomic from the whole system point of view, just for the
HCA? If so, is there any possibility to make the whole operation
'system-wide' atomic?


> You can see what type the HCA supports with "ibv_devinfo -v"
> and look for "atomic_cap: ATOMIC_HCA (1)" or
> "atomic_cap: ATOMIC_GLOB (2)".

ATOMIC_HCA (1) is what I see in my Mellanox hardware. This is the case
you mentioned, "without allowing other reads or writes from different
QP operations passing through that HCA to get in between"
ATOMIC_GLOB (2) means with respect to all HCAs and even the CPU?

Cheers,
Rui
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
