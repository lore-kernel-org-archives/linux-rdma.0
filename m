From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 16:47:44 -0700
Message-ID: <20091111234744.GA1966@obsidianresearch.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com> <adafx8kx41h.fsf@roland-alpha.cisco.com> <1257970050.992.317.camel@chromite.mv.qlogic.com> <adaaayswzrh.fsf@roland-alpha.cisco.com> <alpine.LFD.1.10.0911111303080.25952@topaz.mv.qlogic.com> <adaaaysvf69.fsf@roland-alpha.cisco.com> <1257981770.992.336.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1257981770.992.336.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2009 at 03:22:50PM -0800, Ralph Campbell wrote:

> While this is true for SLtoVL, we create other files which are
> device specific under the port directory too.
> It seems like we might need to introduce a callback into the driver to
> create the port specific sysfs files.

Maybe give some thought to using a syscall interface through uverbs
for some of this?

IMHO, sysfs is getting out of hand for rdma:

$ find /sys/class/infiniband/mlx4_0 -type f | wc -l
660
$ strace -o /tmp/t /opt/ofa-1.5/sbin/perfquery ; grep sys/ /tmp/t | wc -l
289

That is alot of syscalls just to send two SMPs.

It just seems to me there are not that many examples of APIs that
require so much trundling through sysfs to do common every day
application tasks.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
