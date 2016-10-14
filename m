From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 0/4] rdma-core infrastructure
Date: Fri, 14 Oct 2016 15:21:32 -0400
Message-ID: <20161014192136.11731-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a set of patches to make some minor changes to the stock spec file,
add a bunch of userspace glue that Red Hat has been shipping on it's own in
Red Hat Enterprise Linux and Fedora for a while now, and a revised split
package spec file that we're likely to use in at least RHEL, to preserve the
current packaging split.

Jarod Wilson (4):
  rpm spec: install documentation too
  glue/redhat: add udev/systemd/etc infrastructure bits
  glue/redhat: copy stock spec for RH customization
  glue/redhat/spec: build split rpm packages

 glue/redhat/ibacm.service                |  12 +
 glue/redhat/iwpmd.service                |  12 +
 glue/redhat/rdma-core.spec               | 534 +++++++++++++++++++++++++++++++
 glue/redhat/rdma.conf                    |  25 ++
 glue/redhat/rdma.cxgb3.sys.modprobe      |   1 +
 glue/redhat/rdma.cxgb4.sys.modprobe      |   1 +
 glue/redhat/rdma.fixup-mtrr.awk          | 160 +++++++++
 glue/redhat/rdma.ifdown-ib               | 183 +++++++++++
 glue/redhat/rdma.ifup-ib                 | 308 ++++++++++++++++++
 glue/redhat/rdma.kernel-init             | 262 +++++++++++++++
 glue/redhat/rdma.mlx4-setup.sh           |  91 ++++++
 glue/redhat/rdma.mlx4.conf               |  27 ++
 glue/redhat/rdma.mlx4.sys.modprobe       |   5 +
 glue/redhat/rdma.mlx4.user.modprobe      |  21 ++
 glue/redhat/rdma.modules-setup.sh        |  30 ++
 glue/redhat/rdma.service                 |  15 +
 glue/redhat/rdma.sriov-init              | 137 ++++++++
 glue/redhat/rdma.sriov-vfs               |  41 +++
 glue/redhat/rdma.udev-ipoib-naming.rules |  13 +
 glue/redhat/rdma.udev-rules              |  18 ++
 glue/redhat/srp_daemon.service           |  17 +
 rdma-core.spec                           |   4 +
 22 files changed, 1917 insertions(+)
 create mode 100644 glue/redhat/ibacm.service
 create mode 100644 glue/redhat/iwpmd.service
 create mode 100644 glue/redhat/rdma-core.spec
 create mode 100644 glue/redhat/rdma.conf
 create mode 100644 glue/redhat/rdma.cxgb3.sys.modprobe
 create mode 100644 glue/redhat/rdma.cxgb4.sys.modprobe
 create mode 100644 glue/redhat/rdma.fixup-mtrr.awk
 create mode 100644 glue/redhat/rdma.ifdown-ib
 create mode 100644 glue/redhat/rdma.ifup-ib
 create mode 100644 glue/redhat/rdma.kernel-init
 create mode 100644 glue/redhat/rdma.mlx4-setup.sh
 create mode 100644 glue/redhat/rdma.mlx4.conf
 create mode 100644 glue/redhat/rdma.mlx4.sys.modprobe
 create mode 100644 glue/redhat/rdma.mlx4.user.modprobe
 create mode 100644 glue/redhat/rdma.modules-setup.sh
 create mode 100644 glue/redhat/rdma.service
 create mode 100644 glue/redhat/rdma.sriov-init
 create mode 100644 glue/redhat/rdma.sriov-vfs
 create mode 100644 glue/redhat/rdma.udev-ipoib-naming.rules
 create mode 100644 glue/redhat/rdma.udev-rules
 create mode 100644 glue/redhat/srp_daemon.service

-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
