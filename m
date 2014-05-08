From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] libmlx4 1.0.6 is released
Date: Wed,  7 May 2014 17:06:22 -0700
Message-ID: <1399507582-23912-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libmlx4 is a library that allows programs to use RDMA "verbs" for
direct access to RDMA (currently InfiniBand and iWARP) hardware from
userspace.

The new stable release, 1.0.6, is available from

    http://www.openfabrics.org/downloads/mlx4/libmlx4-1.0.6.tar.gz

with sha1sum

    ee22cc20f537b5e794465682d97e5ad0647d9464  libmlx4-1.0.6.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libmlx4.git

(the name of the tag is libmlx4-1.0.6).

The main new features in this release are: generic infrastructure for
"verbs extensions", support for XRC, and support for flow steering.
This release requires libiverbs >= 1.1.8 to build.

This will be my last release of libmlx4; I am turning maintenance of
the library over to Mellanox.

The git shortlog since libmlx4 1.0.5 is:

Matan Barak (1):
      Add receive flow steering support

Roland Dreier (5):
      resize_cq: Fix possible endless loop scanning CQ
      Remove compatibility with libibverbs < 1.1.7
      Use dh-autoreconf to fix build on ppc64el
      Enable subdir-objects for automake
      Roll libmlx4 1.0.6 release

Sean Hefty (1):
      Add support for XRC QPs

Yishai Hadas (1):
      Update to use libiverbs extension support / verbs_register_driver()
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
