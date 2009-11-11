From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 11:19:38 -0800
Message-ID: <adafx8kx41h.fsf@roland-alpha.cisco.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1257966478.992.300.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Wed, 11 Nov 2009 11:07:58 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > This patch moves the definition of struct ib_port from
 > sysfs.c to ib_verbs.h so that HCAs can create files in
 > /sys/class/infiniband/<hca>/ports/<N>/

um, maybe, but we need to see how it gets used first.  How do you get
the to struct ib_port in driver code?  Maybe it would make more sense to
add a way for low-level drivers to pass in port attributes that get
added when the port structure gets created?

By the way, any plans to resume working on the upstream driver for
qlogic HCAs?  Do you still plan to deprecate ib_ipath and add a new
driver for new devices?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
