From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libibverbs 1.1.3 is released
Date: Thu, 29 Oct 2009 14:37:37 -0700
Message-ID: <adaskd151b2.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libibverbs is a library that allows programs to use RDMA "verbs" for
direct access to RDMA (currently InfiniBand and iWARP) hardware from
userspace.

The new stable release, 1.1.3, is available from

    http://www.openfabrics.org//downloads/verbs/libibverbs-1.1.3.tar.gz

with sha1sum

    aa8eb44c84e326799d986c8f07d636afd0b8b7eb  libibverbs-1.1.3.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git

(the name of the tag is libibverbs-1.1.3).

It's been too long since the previous release, and this release
contains many small fixes and cleanups, including a few that have API
impacts (although no changes in code using the library should be
required).

The git shortlog since libibverbs 1.1.2 is:

Dotan Barak (2):
      Code formatting cleanups
      Update Dotan's email

Jason Gunthorpe (5):
      Allow config file paths to the driver library to be absolute
      Make the gid argument to ibv_attach_mcast and ibv_detach_mcast const
      Do not use enum types for bit flags
      Fix double free in find_sysfs_devs()
      Return errors from ibv_get_device_list() via errno

Jeff Squyres (1):
      Show transport (IB vs. iWARP) type in ibv_devinfo

Robert Pearson (1):
      Fix fall-through bug in options case in pingpong examples

Roland Dreier (16):
      Change .nl macro in man pages to .sp
      Include NMU changes for version 1.1.1-1.1 in Debian changelog
      Update Debian packaging to include new manpage symlinks
      Revert conversion of ibv_devinfo to use ibv_port_state_str()
      Update build system to use shave
      Move -dbg Debian package to section debug
      Update Debian policy version to 3.8.2
      Merge branch 'stable'
      Revert "Update build system to use shave"
      Enable quiet build rules with automake 1.11+
      Use AC_GNU_SOURCE in configure.in instead of -D_GNU_SOURCE in Makefile
      Change Debian build system from cdbs to debhelper 7
      Update Debian Standards-Version to 3.8.3
      Rewrite GID output in ibv_devinfo to avoid type punning warnings
      Merge Fedora spec file changes
      Roll libibverbs 1.1.3 release

Shirley Ma (1):
      Implement PPC wmb() with sync instead of eieio
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
