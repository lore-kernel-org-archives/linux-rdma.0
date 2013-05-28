From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] libibverbs 1.1.7 is released
Date: Tue, 28 May 2013 16:10:05 -0700
Message-ID: <1369782605-2069-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libibverbs is a library that allows programs to use RDMA "verbs" for
direct access to RDMA (currently InfiniBand and iWARP) hardware from
userspace.

The new stable release, 1.1.7, is available from

    http://www.openfabrics.org/downloads/verbs/libibverbs-1.1.7.tar.gz

with sha1sum

    3def9411b1e443cd3c8dfde761c7c6308cb98e6f  libibverbs-1.1.7.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git

(the name of the tag is libibverbs-1.1.7).

The main new feature in this release is initial support for raw QPs.
This release is intended as a checkpoint to get pending changes out
before starting work on general extension support (with XRC support as
an initial driver).

The git shortlog since libibverbs 1.1.6 is:

Bart Van Assche (1):
      Fix a compiler warnings with NVALGRIND

Dotan Barak (2):
      Add helpers to deal with new InfiniBand link speeds
      Fix resource leaks in the pingpong examples

Doug Ledford (5):
      devinfo: Give an error when the user specifies an invalid port
      devinfo: Don't allow port == 0 as an option
      Fix the compatibility wrapper on PPC
      ud_pingpong: Don't try to send UD messages larger than MTU
      Don't print link phys state on iWARP

Jeff Squyres (2):
      libibverbs: Use autoreconf in autogen.sh
      .gitignore updates; rename configure.in->.ac

Or Gerlitz (1):
      Add raw packet QP type

Roland Dreier (1):
      Roll libibverbs 1.1.7 release

Yann Droneaud (5):
      memory: use SCNxPTR format to read uintptr_t values
      memory: comment out unused verify() function
      Open files with "close on exec" flag
      configure: Apply updates proposed by autoupdate
      configure: Use automake's option "subdir-objects"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
