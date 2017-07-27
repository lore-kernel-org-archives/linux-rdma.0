From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto loading
Date: Thu, 27 Jul 2017 16:31:19 -0600
Message-ID: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here is the next revision of the systemd module autoloading approach.

All the comments have been collected and a few other things addressed.

Notably, at least on debian, when rdma-core is installed for the first time it
activates the new udev rules and moduels autoload immediately, no reboot
required. Not sure about RH's policies, so leaving this to them to copy if
desired.

There have been positive test results now for rxe, mlx4 (IB), qedr and cxgb4
on Debian derived.

This is now a PR:

 https://github.com/linux-rdma/rdma-core/pull/174/commits

Jason Gunthorpe (6):
  Common infrastructure for auto loading rdma modules
  Move umad udev rules to rdma-core
  debian: Cause udev to evaluate the installed rules after install
  redhat: Remove cxgb3/4.modprobe files
  srp_daemon: Autoload the SRP kernel module if required
  iwpmd: Autoload iwpmd if required

 CMakeLists.txt                            |  1 +
 Documentation/udev.md                     | 83 +++++++++++++++++++++++++++++++
 debian/control                            |  5 +-
 debian/iwpmd.install                      |  2 +
 debian/iwpmd.postinst                     | 11 ++++
 debian/libibumad3.install                 |  1 -
 debian/rdma-core.install                  | 10 ++++
 debian/rdma-core.postinst                 | 13 +++++
 debian/srptools.install                   |  1 +
 debian/srptools.postinst                  | 11 ++++
 iwpmd/CMakeLists.txt                      |  8 +++
 iwpmd/iwpmd.rules                         |  1 +
 iwpmd/iwpmd.service.in                    |  6 +--
 iwpmd/modules-iwpmd.conf                  |  2 +
 kernel-boot/CMakeLists.txt                | 28 +++++++++++
 kernel-boot/modules/infiniband.conf       | 12 +++++
 kernel-boot/modules/iwarp.conf            |  1 +
 kernel-boot/modules/opa.conf              | 10 ++++
 kernel-boot/modules/rdma.conf             | 21 ++++++++
 kernel-boot/modules/roce.conf             |  2 +
 kernel-boot/rdma-description.rules        | 42 ++++++++++++++++
 kernel-boot/rdma-hw-modules.rules         | 39 +++++++++++++++
 kernel-boot/rdma-load-modules@.service.in | 15 ++++++
 kernel-boot/rdma-ulp-modules.rules        | 11 ++++
 kernel-boot/rdma-umad.rules               |  1 +
 libibumad/CMakeLists.txt                  |  5 --
 libibumad/libibumad.udev-rules            |  1 -
 rdma-core.spec                            |  1 +
 redhat/rdma-core.spec                     | 20 +++++---
 redhat/rdma.cxgb3.sys.modprobe            |  1 -
 redhat/rdma.cxgb4.sys.modprobe            |  1 -
 srp_daemon/CMakeLists.txt                 |  4 ++
 srp_daemon/modules-srp_daemon.conf        |  2 +
 srp_daemon/srp_daemon.rules               |  2 +-
 srp_daemon/srp_daemon.service.in          |  2 +-
 srp_daemon/srp_daemon_port@.service.in    |  3 +-
 36 files changed, 357 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/udev.md
 create mode 100644 debian/iwpmd.postinst
 create mode 100644 debian/rdma-core.postinst
 create mode 100644 debian/srptools.postinst
 create mode 100644 iwpmd/iwpmd.rules
 create mode 100644 iwpmd/modules-iwpmd.conf
 create mode 100644 kernel-boot/CMakeLists.txt
 create mode 100644 kernel-boot/modules/infiniband.conf
 create mode 100644 kernel-boot/modules/iwarp.conf
 create mode 100644 kernel-boot/modules/opa.conf
 create mode 100644 kernel-boot/modules/rdma.conf
 create mode 100644 kernel-boot/modules/roce.conf
 create mode 100644 kernel-boot/rdma-description.rules
 create mode 100644 kernel-boot/rdma-hw-modules.rules
 create mode 100644 kernel-boot/rdma-load-modules@.service.in
 create mode 100644 kernel-boot/rdma-ulp-modules.rules
 create mode 100644 kernel-boot/rdma-umad.rules
 delete mode 100644 libibumad/libibumad.udev-rules
 delete mode 100644 redhat/rdma.cxgb3.sys.modprobe
 delete mode 100644 redhat/rdma.cxgb4.sys.modprobe
 create mode 100644 srp_daemon/modules-srp_daemon.conf

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
