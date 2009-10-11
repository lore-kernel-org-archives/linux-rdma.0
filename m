From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: infiniband BKL leftovers
Date: Sun, 11 Oct 2009 21:52:44 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.0910112151490.9428@localhost.localdomain>
References: <alpine.LFD.2.00.0910102015400.9428@localhost.localdomain> <adad44tj090.fsf@cisco.com> <ada8wfhivdd.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada8wfhivdd.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 11 Oct 2009, Roland Dreier wrote:

> [Adding Ralph's direct email]
> 
> And the address in MAINTAINERS of infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org appears to be
> bouncing... so I think it's pretty safe to say that Qlogic doesn't care
> too much about the ipath driver any more.

Time to create drivers/bitrotting which serves the opposite purpose of
drivers/staging :) I have a huge list of candidates for that.

Thanks,

	tglx
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
