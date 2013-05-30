From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] libmlx4 1.0.5 is released
Date: Thu, 30 May 2013 11:18:55 -0700
Message-ID: <1369937935-21981-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libmlx4 is a userspace driver for Mellanox ConnectX InfiniBand/IBoE
HCAs.  It is a plug-in module for libibverbs that allows programs to
use Mellanox hardware directly from userspace.

A new stable release is available from

    http://www.openfabrics.org/downloads/mlx4/libmlx4-1.0.5.tar.gz

with sha1sum

    15356e0dfe78f98bf2586c3fa0058b0be6ecfa4f  libmlx4-1.0.5.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libmlx4.git

(the name of the tags is libmlx4-1.0.5)

The main new features of this release are support for 64-byte CQEs
(when turned on in the mlx4_core kernel driver via the
enable_64b_cqe_eqe module parameter) and support for raw QPs.

The git shortlog since libmlx4 1.0.4 is:

Dotan Barak (5):
      Replace sscanf() with strtol()
      Allow using the whole Blue Flame buffer
      Use BlueFlame for RDMA Write [with immediate] without data
      Change enumeration names for masked atomic opcodes
      Have ibv_modify_qp() return right value when ibv_query_port() fails

Or Gerlitz (2):
      Add support for 64B CQEs
      Add raw packet QP support

Roland Dreier (4):
      Rename configure.in -> configure.ac
      Use autoreconf in autogen.sh
      configure: Minor updates suggested by autoupdate
      Roll libmlx4 1.0.5 release
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
