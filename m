From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core v2 0/4] rdma-core redhat/ infrastructure
Date: Thu, 20 Oct 2016 11:33:53 -0400
Message-ID: <20161020153357.27286-1-jarod@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a set of patches to make some minor changes to the stock spec file,
add a bunch of userspace glue that Red Hat has been shipping on it's own in
Red Hat Enterprise Linux and Fedora for a while now, and a revised split
package spec file that we're likely to use in at least RHEL, to preserve the
current packaging split, save a change that merges all libibverbs providers
into the libibverbs package itself (with appropriate Obsoletes/Provides).

This second spin incorporates changes that hopefully address all feedback
from the first version of the patchset.

Jarod Wilson (4):
  Install end user focused documentation files
  redhat: add udev/systemd/etc infrastructure bits
  redhat: copy stock spec for RH customization
  redhat/spec: build split rpm packages

 CMakeLists.txt                      |   3 +-
 Documentation/CMakeLists.txt        |  10 +
 debian/ibacm.install                |   1 +
 debian/ibverbs-providers.install    |   1 +
 debian/libibcm1.install             |   1 +
 debian/libibverbs1.install          |   1 +
 debian/librdmacm1.install           |   1 +
 debian/srptools.install             |   1 +
 rdma-core.spec                      |   6 +-
 redhat/ibacm.service                |  12 ++
 redhat/rdma-core.spec               | 417 ++++++++++++++++++++++++++++++++++++
 redhat/rdma.conf                    |  25 +++
 redhat/rdma.cxgb3.sys.modprobe      |   1 +
 redhat/rdma.cxgb4.sys.modprobe      |   1 +
 redhat/rdma.fixup-mtrr.awk          | 160 ++++++++++++++
 redhat/rdma.ifdown-ib               | 183 ++++++++++++++++
 redhat/rdma.ifup-ib                 | 308 ++++++++++++++++++++++++++
 redhat/rdma.kernel-init             | 262 ++++++++++++++++++++++
 redhat/rdma.mlx4-setup.sh           |  91 ++++++++
 redhat/rdma.mlx4.conf               |  27 +++
 redhat/rdma.mlx4.sys.modprobe       |   5 +
 redhat/rdma.mlx4.user.modprobe      |  21 ++
 redhat/rdma.modules-setup.sh        |  30 +++
 redhat/rdma.service                 |  15 ++
 redhat/rdma.sriov-init              | 137 ++++++++++++
 redhat/rdma.sriov-vfs               |  41 ++++
 redhat/rdma.udev-ipoib-naming.rules |  13 ++
 redhat/rdma.udev-rules              |  18 ++
 redhat/srp_daemon.service           |  17 ++
 29 files changed, 1807 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/CMakeLists.txt
 create mode 100644 redhat/ibacm.service
 create mode 100644 redhat/rdma-core.spec
 create mode 100644 redhat/rdma.conf
 create mode 100644 redhat/rdma.cxgb3.sys.modprobe
 create mode 100644 redhat/rdma.cxgb4.sys.modprobe
 create mode 100644 redhat/rdma.fixup-mtrr.awk
 create mode 100644 redhat/rdma.ifdown-ib
 create mode 100644 redhat/rdma.ifup-ib
 create mode 100644 redhat/rdma.kernel-init
 create mode 100644 redhat/rdma.mlx4-setup.sh
 create mode 100644 redhat/rdma.mlx4.conf
 create mode 100644 redhat/rdma.mlx4.sys.modprobe
 create mode 100644 redhat/rdma.mlx4.user.modprobe
 create mode 100644 redhat/rdma.modules-setup.sh
 create mode 100644 redhat/rdma.service
 create mode 100644 redhat/rdma.sriov-init
 create mode 100644 redhat/rdma.sriov-vfs
 create mode 100644 redhat/rdma.udev-ipoib-naming.rules
 create mode 100644 redhat/rdma.udev-rules
 create mode 100644 redhat/srp_daemon.service

-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
