From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: yet again the atomic operations
Date: Tue, 10 Aug 2010 10:26:33 -0700
Message-ID: <1281461193.7414.152.camel@chromite.mv.qlogic.com>
References: <AANLkTikQX+CKvs_pjkH_Ap358jfjp4dYKYyKG95+eZmt@mail.gmail.com>
	 <1281033688.7414.30.camel@chromite.mv.qlogic.com>
	 <AANLkTikPAqopgFR_vSnj9qkQu77S1RWixgM0POUQ5LM9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikPAqopgFR_vSnj9qkQu77S1RWixgM0POUQ5LM9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-08-10 at 04:46 -0700, Rui Machado wrote:
> > There are two kinds supported. QLogic's driver does them in
> > the host driver so they are atomic with respect to all the CPUs
> > in the host.
> 
> I'm just curious about this: how does this work? Is the CPU getting
> interrupted and doing the operation while the Mellanox HCA does
> everything in hardware?

Yes.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
