From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] libibverbs 1.1.5 is released
Date: Wed, 29 Jun 2011 09:23:41 -0700
Message-ID: <1309364621-5598-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libibverbs is a library that allows programs to use RDMA "verbs" for
direct access to RDMA (currently InfiniBand and iWARP) hardware from
userspace.

The new stable release, 1.1.5, is available from

    http://www.openfabrics.org/downloads/verbs/libibverbs-1.1.5.tar.gz

with sha1sum

    1b270ff68e6c9413aee96b64b2c312a15649eaa9  libibverbs-1.1.5.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git

(the name of the tag is libibverbs-1.1.5).

This release has a nice fix from Alexander Schmidt to madvise()
handling when huge pages are used, as well as a few robustness fixes
from Yann Droneaud, as well as a few other small fixes.

The git shortlog since libibverbs 1.1.4 is:

Alexander Schmidt (1):
      Handle huge pages in ibv_fork_init() and madvise tracking

Dotan Barak (1):
      Fix date format in RPM spec file changelog

Jason Gunthorpe (1):
      Fix autotools to include the necessary m4 files

Roland Dreier (3):
      Fix crash if no devices and ibv_get_device_list() is called multiple times
      Set DM-Upload-Allowed now that Roland is a Debian Maintainer
      Roll libibverbs 1.1.5 release

Tom Tucker (1):
      Add AC_PROG_LIBTOOL to fix libtool configure warning

Yann Droneaud (1):
      read_config_file: ignore driver line without driver name

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
