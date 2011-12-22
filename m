From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] libibverbs 1.1.6 is released
Date: Wed, 21 Dec 2011 17:25:22 -0800
Message-ID: <1324517122-15812-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libibverbs is a library that allows programs to use RDMA "verbs" for
direct access to RDMA (currently InfiniBand and iWARP) hardware from
userspace.

The new stable release, 1.1.6, is available from

    http://www.openfabrics.org/downloads/verbs/libibverbs-1.1.6.tar.gz

with sha1sum

    3b407ca32c3bd07782c281d82f045ea8c6672080  libibverbs-1.1.6.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git

(the name of the tag is libibverbs-1.1.6).

The main new feature in this release is support for IBoE.  ibv_devinfo
also now can display FDR and other new link speeds.  There are a few
minor error path bug fixes and the Debian packaging is a bit cleaner.

The git shortlog since libibverbs 1.1.5 is:

Bart Van Assche (2):
      Add "foreign" option to AM_INIT_AUTOMAKE
      Makefile.am: Fix an automake warning

Dotan Barak (1):
      Fix memory leaks in various error flows

Julien BLACHE (1):
      debian/libibverbs1.postinst: Let debhelper code run in all cases

Marcel Apfelbaum (1):
      Add support to ibv_devinfo for displaying extended speeds

Or Gerlitz (4):
      Add link_layer field port attribute
      Update kernel API header to include link_layer
      Add GID change event
      Update examples for IBoE

Roland Dreier (5):
      Package description shouldn't start with an article
      Don't ship .la files in Debian libibverbs-dev
      Update Debian Standards-Version to 3.9.2
      Debian: Don't use brace expansion for {a,so} in libibverbs-dev.install
      Roll libibverbs 1.1.6 release
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
