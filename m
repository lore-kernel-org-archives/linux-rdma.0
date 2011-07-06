From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] libmthca 1.0.5 and libmlx4 1.0.2 are released
Date: Wed,  6 Jul 2011 12:42:33 -0700
Message-ID: <1309981353-14301-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libmthca and libmlx4 are userspace drivers for Mellanox InfiniBand
HCAs.  They are plug-in modules for libibverbs that allows programs to
use Mellanox hardware directly from userspace.

New stable releases are available from

    http://www.openfabrics.org/downloads/mthca/libmthca-1.0.6.tar.gz
    http://www.openfabrics.org/downloads/mlx4/libmlx4-1.0.2.tar.gz

with sha1sum

    156d90ea343a18fd638c0097ea8d2e97af3f6e25  libmthca-1.0.6.tar.gz
    8c5e9deb47b6a3f0163fa5e85ea7560451c4a09b  libmlx4-1.0.2.tar.gz

I also pushed the latest trees and tags out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libmthca.git
    git://git.kernel.org/pub/scm/libs/infiniband/libmlx4.git

(the name of the tags are libmthca-1.0.6 and libmlx4-1.0.2)

These releases contain a variety of accumulated small fixes since the
previous long-ago releases.

The git shortlog since libmthca 1.0.5 is:

Jack Morgenstein (1):
      Fix race between create QP and destroy QP

Jason Gunthorpe (2):
      Remove empty stubs for detach/attach_mcast
      Update function prototypes to match libibverbs enum type change

Roland Dreier (16):
      Use real Homepage: tag instead of pseudo-header inside description
      Debian changelog should use "unstable" not "hardy"
      Move -dbg Debian package to section debug
      Update build system to use shave
      Update Debian policy version to 3.8.2
      Package description shouldn't start with an article
      Set DM-Upload-Allowed now that Roland is a Debian Maintainer
      Convert to new 3.0 (quilt) source format.
      Change Debian build system from cdbs to debhelper 7
      Move plugin .so to /usr/lib/libibverbs
      Revert "Update build system to use shave"
      Enable quiet build rules with automake 1.11+
      Small configure.in modernizations
      Acknowledge NMU (don't ship .la file)
      Note that we fix Debian bug about maintainer address in Debian changelog
      Roll libmthca 1.0.6 release

Sebastien Dugue (1):
      Use mmap(MAP_ANONYMOUS) to allocate queue buffers


The git shortlog since libmlx4 1.0.1 is:

Jack Morgenstein (1):
      Initialize SRQ scatter entries when creating an SRQ

Jason Gunthorpe (3):
      Remove empty stubs for detach/attach_mcast
      Update function prototypes to match libibverbs enum type change
      Return ERRNO codes from ibv_post_send/recv instead of -1

Roland Dreier (11):
      Package description shouldn't start with an article
      Set DM-Upload-Allowed now that Roland is a Debian Maintainer
      Convert to new 3.0 (quilt) source format.
      Note that we fix Debian bug about maintainer address in Debian changelog
      Don't ship .la files in Debian libmlx4-dev
      Change Debian build system from cdbs to debhelper 7
      Small configure.in modernizations
      Revert "Update build system to use shave"
      Enable quiet build rules with automake 1.11+
      Move plugin .so to /usr/lib/libibverbs
      Roll libmlx4 1.0.2 release

Sebastien Dugue (3):
      Use mmap(MAP_ANONYMOUS) to allocate queue buffers
      mmap() needs some includes
      Fix version in taball filename in RPM spec file
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
