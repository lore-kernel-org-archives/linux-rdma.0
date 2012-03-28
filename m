From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] libmlx4 1.0.4 is released
Date: Wed, 28 Mar 2012 11:42:25 -0700
Message-ID: <1332960145-8598-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libmlx4 is a userspace driver for Mellanox ConnectX InfiniBand/IBoE
HCAs.  It is a plug-in module for libibverbs that allows programs to
use Mellanox hardware directly from userspace.

A new stable release is available from

    http://www.openfabrics.org/downloads/mlx4/libmlx4-1.0.4.tar.gz

with sha1sum

    ad7f3f60a4b4da63924344d61363e7f690070750  libmlx4-1.0.4.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libmlx4.git

(the name of the tags is libmlx4-1.0.4)

This is a quick release to get IBoE multicast support out.

The git shortlog since libmlx4 1.0.3 is:

Roland Dreier (2):
      Update maintainer now that I'm a DD
      Roll libmlx4 1.0.4 release

Shawn Bohrer (1):
      Add IBoE multicast support
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
