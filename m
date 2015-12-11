From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Thu, 10 Dec 2015 23:14:33 -0700
Message-ID: <20151211061433.GB16513@obsidianresearch.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
 <566753E3.9060301@redhat.com>
 <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
 <20151208225940.GB27609@obsidianresearch.com>
 <CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
 <20151209184448.GC4522@infradead.org>
 <5669BA8E.30200@redhat.com>
 <20151210232956.GA26009@infradead.org>
 <566A5792.9080102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <566A5792.9080102-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 11:56:50PM -0500, Doug Ledford wrote:

> Looking at struct netdevice, it has the sort of organization I would
> call reasonable.  Things like struct tx_stats is a struct, even though
> it's embedded in the parent struct and not a pointer and there is
> exactly and only one copy, so it could be flat.

struct net_device_stats exists because it is used in many more places
that just in struct net_device, so this is a code sharing thing.

> something I would call well organized.  And speaking of that, in struct
> netdevice, all of the various ops elements are handled as structs,

.. and 'struct net_device_ops' is used extensively.

Whereas once we get rid of the query call ib_device_attr has no second
user.

> including the base netdevice ops, whereas struct ib_device puts the base
> ops flat in the struct.  So if we wanted to be more like struct
> netdevice, we would move the base ops out of struct ib_device.

It would make the drivers a bit nicer if they initialized an ib_ops
structure like netdev does instead of in code, but performance wise
this is probably better, especially if we sorted the struct members
sanely..

> out like this.  An ib_device can be multi-port, and each port can be a
> different RDMA device type.

I thought we figured out that wasn't actually allowed today when
working on the caps rework?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
