From: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: yet again the atomic operations
Date: Wed, 4 Aug 2010 14:32:18 +0200
Message-ID: <AANLkTikQX+CKvs_pjkH_Ap358jfjp4dYKYyKG95+eZmt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,

I would like to know how do the IB atomic operations work and how much
can one rely on them? Particularly, how does the interaction with the
CPU takes place when for example the CPU is referencing and possibly
modifying the same address, atomically . Does one need to take care of
memory say, with memory barriers?
Does anyone has experience with this? There must be also different
hardware support from the vendors, right?

I hope I'm not sounding too vague, I'm not such a kernel or hw guy. I
tried to look for information on this but found pretty much nothing.
Can the experts shed some light on the problem?

Cheers,
Rui
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
