From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
Date: Sun, 27 Oct 2013 15:14:09 -0700
Message-ID: <1382912049.30941.5.camel@joe-AO722>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
	 <1382911111.30941.2.camel@joe-AO722>
	 <1382911333.2994.55.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382911333.2994.55.camel-nDn/Rdv9kqW9Jme8/bJn5UCKIB8iOfG2tUK59QYPAWc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2013-10-27 at 22:02 +0000, Ben Hutchings wrote:
> On Sun, 2013-10-27 at 14:58 -0700, Joe Perches wrote:
> > On Sun, 2013-10-27 at 21:50 +0000, Ben Hutchings wrote:
> > > Physical addresses may be wider than virtual addresses (e.g. on i386
> > > with PAE) and must not be formatted with %p.
> > 
> > %pa works.  %pa also prefixes with 0x.
> 
> Only as long as pci_resource_start() happens to be an lvalue.  I'd
> rather not introduce that assumption.

pci_resource_start returns a resource_size_t which is a phys_addr_t.

Changing that from an lvalue would cause a _lot_ of breakage.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
