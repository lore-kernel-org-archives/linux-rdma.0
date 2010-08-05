From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: yet again the atomic operations
Date: Thu, 5 Aug 2010 11:41:28 -0700
Message-ID: <1281033688.7414.30.camel@chromite.mv.qlogic.com>
References: <AANLkTikQX+CKvs_pjkH_Ap358jfjp4dYKYyKG95+eZmt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikQX+CKvs_pjkH_Ap358jfjp4dYKYyKG95+eZmt-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Atomic ops are optional. Mellanox and QLogic HCAs support them,
I don't know about the other HCAs.

There are two kinds supported. QLogic's driver does them in
the host driver so they are atomic with respect to all the CPUs
in the host. Mellanox uses HCA wide atomic which means the
HCA will do a memory read/write without allowing other reads
or writes from different QP operations passing through that
HCA to get in between. The CPUs on the host won't see
atomic operations since from their perspective, it looks
like a normal read and write from the PCIe bus.

You can see what type the HCA supports with "ibv_devinfo -v"
and look for "atomic_cap: ATOMIC_HCA (1)" or
"atomic_cap: ATOMIC_GLOB (2)".

On Wed, 2010-08-04 at 05:32 -0700, Rui Machado wrote:
> Hi all,
> 
> I would like to know how do the IB atomic operations work and how much
> can one rely on them? Particularly, how does the interaction with the
> CPU takes place when for example the CPU is referencing and possibly
> modifying the same address, atomically . Does one need to take care of
> memory say, with memory barriers?
> Does anyone has experience with this? There must be also different
> hardware support from the vendors, right?
> 
> I hope I'm not sounding too vague, I'm not such a kernel or hw guy. I
> tried to look for information on this but found pretty much nothing.
> Can the experts shed some light on the problem?
> 
> Cheers,
> Rui
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
