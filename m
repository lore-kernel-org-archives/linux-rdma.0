From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: races in ipathfs
Date: Sun, 18 Mar 2012 18:45:47 +0000
Message-ID: <20120318184547.GA6814@ZenIV.linux.org.uk>
References: <20120119202003.GZ23916@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120119202003.GZ23916-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 19, 2012 at 08:20:04PM +0000, Al Viro wrote:
> 	Use of qib_super is seriously racy.  qibfs_add() (and worse,
> qibfs_remove()) can happen during qibfs_mount() and qibfs_kill_super().

[snip]

FWIW, I've put a completely untested patchset into
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git qibfs

It tries to avoid that kind of crap by getting rid of "populate at mount
time" logics - we keep (internal) mount of that sucker for as long as
there are any devices owned by ib_qib, adding them on add_device() and
removing on remove_device().  The only complication is with module
use counts - that fs has to be a separate module, or we'll have ib_qib
impossible to rmmod, because fs keeps its module pinned and any devices
held by ib_qib PCI driver will keep the fs pinned, so we never get
to unregistering said PCI driver.  With skeleton of qibfs (static parts
only) taken to ib_qib_fs.c we avoid that problem - it is what ends up
being pinned down for as long as ib_qib owns any devices, but then it's
pinned down by ib_qib using exports from ib_qib_fs anyway.  And once
ib_qib is removed, all internal references to that vfsmount and superblock
disappear as well...

This stuff is completely untested; I don't have the hardware in question.
It does compile and survive modpost, but that's it.  Please, review and
comment...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
