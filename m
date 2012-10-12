From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: if/how to dictate IB device name per PCI BDF
Date: Fri, 12 Oct 2012 17:38:02 -0600
Message-ID: <20121012233802.GD25541@obsidianresearch.com>
References: <5076A755.30605@mellanox.com>
 <20121012224332.GB25541@obsidianresearch.com>
 <20121012160418.385ace32ddde5379381d5889@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121012160418.385ace32ddde5379381d5889-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 12, 2012 at 04:04:18PM -0700, Ira Weiny wrote:

> > FWIW, I reflected on this once (I belive it was for the netlink
> > discussion).. Allowing for a device to be renamed creates a serious
> > problem for RDMA since there isn't a stable 'if-index' like way for
> > software to refer to it.
> > 
> > The udev rules all rely on a means to rename the device once the
> > kernel has created it.
> > 
> > For this reason, all the software I've built uses the port GID to ID
> > the resource for bind/etc and strongly discourages use of the RDMA
> > device name.
> 
> IMHO, from a user perspective using GID's or GUIDs is just too hard.
> While the port GID is unique across reboots in practice with 1000's
> of nodes in a cluster names are much more useful and, at least here
> at LLNL, nobody refers to HCA's by GUID.  They refer to them by
> hostname/card name.  This is especially true when HCA's get swapped
> out for maintenance.

Textual names (ie a name service) for GID alleviate alot of that pain,
but really, how often do you need to use device RDMA name??

Assuming GID port selection is available, the only case that requires
the full GID is when you have multiple HCAs and ports are active on
the *same subnet*.

Otherwise you can refer to the port by: port number, by GID prefix or
by 'first found active port' without ever involving the rdma device
name.

I never did it, but it did occur to me to support the IBoIB device
name and IP addresses as a port specifier..

> Furthermore, how would you propose MPI selects a card when the job
> is launched on different nodes, chosen by a scheduler, from run to
> run?

Three things spring to mind:
 - Choose an active port at random that matches a set of subnet prefixes
 - Choose an active port at random from a globally known list of
   job-acceptable GIDs
 - Choose an active port #X that matches a set of subnet prefixes,
   from a random device

Relying on rdma device name for MPI wouldn't work in a heterogeneous
environment where different nodes have a different 'correct' device
name.

> Unfortunately, I don't know the details of the "serious problem" you
> describe above but it seems that a udev solution to renaming things
> would be worth trying to solve from a users perspective.

Renaming the device changes the name of all the sysfs directories, so
any 'handle' is invalidated at rename time. All udev can do for you is
trigger the rename call, you still have to somewhat sanely enable
renaming in the kernel.

And it is not entirely theoretical, with threaded startup and things
like systemd, it is very plausible that the rename could hit in the
middle of something like opensm starting up and create a flakey
system. Particularly since we'd want to see opensm's startup triggered
by directory creation in sysfs.

I think it would be great to be able to do the rename, but to do it
properly things need to be more like the net stack - netlink for
configuration/discovery, and a stable ifindex for use in all netlink
messages.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
