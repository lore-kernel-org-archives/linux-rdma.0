From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: ipath now and then (was [PATCH] IB/core: export struct ib_port)
Date: Thu, 12 Nov 2009 12:46:00 +0200
Message-ID: <4AFBE768.7090206@Voltaire.com>
References: <15ddcffd0911111318h425c43f6ya136d8f4aaa6883e@mail.gmail.com> <1257975350.992.324.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1257975350.992.324.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ralph Campbell wrote:
> I don't understand what you are suggesting.
> The kernel module name ib_ipath and/or directory name
> drivers/infiniband/hw/ipath could be reused for some
> other purpose certainly.

In a 2nd thought, its better that you go and remove the hw/ipath directory, I assume the qib code could be made to serve software iboe in the same manner ipath can, just make sure to keep the IB L2 handling in separate files from the L3/L4 ones...

Or
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
