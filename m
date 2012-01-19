From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: races in ipathfs
Date: Thu, 19 Jan 2012 20:20:04 +0000
Message-ID: <20120119202003.GZ23916@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

	Use of qib_super is seriously racy.  qibfs_add() (and worse,
qibfs_remove()) can happen during qibfs_mount() and qibfs_kill_super().

	1) CPU1: qib_init_one().  The sucker is allocated and placed
on the list.  CPU2: ipathfs is mounted, directory created.  CPU1: finally
gets around to qibfs_add(); by now qib_super is non-NULL and off we go,
trying to create it again.  The worst part is, that code doesn't even
notice that dentry is there and positive; you silently leak the old inode.

	2) CPU1: qib_init_one().  Allocated the sucker.  CPU2: ipathfs
is getting mounted.  Picked the first device off the list, creating
directory for it.  CPU1: inserted new device into the head of the list,
continued working.  Got around to qibfs_add(); qib_super is NULL, so
we do nothing.  CPU2: walked the rest of the list, creating directories
for all devices.  Our device is missed, since we are past that point in
the list.  Worse, shift the timing a bit and it doesn't matter whether
you add to the head or to the tail of the list - if qibfs_add() happens
just before we set qib_super, we are screwed again.

	3) CPU1: qib_remove_one().  CPU2: mount ipathfs is walking that
list and decides to try and create a directory for the device that is
being freed.  Oops...

	4) CPU1: qib_init_one() or qib_remove_one(), doesn't matter which.
CPU2: final umount of ipathfs already got through setting sb->s_root to
NULL but still hadn't set qib_super to the same.  Oops...  And no,
moving that qib_super = NULL; up prior to kill_litter_super() won't
fix the race either, of course.

AFAICS, the older driver (in hw/ipath) has the same problems.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
