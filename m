From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] libmlx4 1.0.3 is released
Date: Mon, 26 Mar 2012 10:17:23 -0700
Message-ID: <1332782243-26729-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

libmlx4 is a userspace driver for Mellanox ConnectX InfiniBand/IBoE
HCAs.  It si a plug-in module for libibverbs that allows programs to
use Mellanox hardware directly from userspace.

A new stable release is available from

    http://www.openfabrics.org/downloads/mlx4/libmlx4-1.0.3.tar.gz

with sha1sum

    0fea988f8cf9b3b02cd038949aee3ad86281976a  libmlx4-1.0.3.tar.gz

I also pushed the latest tree and tag out to kernel.org:

    git://git.kernel.org/pub/scm/libs/infiniband/libmlx4.git

(the name of the tags is libmlx4-1.0.3)

This release contains support for IBoE and ConnectX-3 adapters.

The git shortlog since libmlx4 1.0.2 is:

Or Gerlitz (6):
      Add IBoE support
      Add IBoE UD/VLANs support
      Align the list of supported ConnectX devices with kernel
      Use Ethernet 802.1Q VLAN-related fields in CQE
      Add link_layer field to mlx4 QPs
      Fix IBoE SL -> 802.1Q priority-bits mapping

Roland Dreier (6):
      Update to Debian standards version 3.9.2
      Acknowledge Debian NMU
      Moving plugin out of /usr/lib means we now depend on libibverbs 1.1.3
      Add "foreign" option to AM_INIT_AUTOMAKE
      Fix possible missed completion event
      Roll libmlx4 1.0.3 release
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
