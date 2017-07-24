From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Mon, 24 Jul 2017 14:44:22 -0600
Message-ID: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is my attempt to migrate the module loading functions from RedHat's
rdma.service into common code suitable for all distros.

The approach is completly hotplug safe and relies heavily on udev and systemd
to do the actual decision making and work, there are no shell scripts involved.

I do not have nearly enough hardware to exhaustively test this, I have checked
that the basic elements are working, but there is lots of room for little
errors, particularly in module names and udev matching. It would be great of
someone could try this on iwarp hardware and confirm all the autoloading works
as expected.

As should the active roce vendors. I expect that all roce hardware will
autoload the RDMA modules with this approach.

Compared to redhat/rdma.kernel-init:

 - Config of what ULP modules to load is split into files in
   /etc/rdma/modules/*.conf, each conf reflects a certain configuration. Eg
   infiniband.conf is loaded when IB hardware is present, iwarp.conf is loaded
   for iWarp, etc.

   This allows each techology to load appropriate modules automatically, ie
   roce hardware will not autoload ipoib out of the box

   Users can configure these files to turn things on/off as appropriate, or just
   use the usual /etc/modules-load.d/ mechanism. systemd-modules-load is used
   to  load the modules lists so behavior is identical to the standard loader.
   eg blacklists work, etc.

   This obsoletes the /etc/rdma/rdma.conf file

 - Load of HW support drivers (eg the RDMA component of an ethernet NIC) is
   done completely inside udev using the udev built in module load, based on
   the hotplug event of the ethernet nic.

   This means RDMA support modules are only loaded if the rdma-core package is
   installed and only if the actual base ethernet hardware is present. (rather
   than triggering on loaded modules)

 - More roce hardware is supported now, I filled in entries for all of our
   new providers (eg qedr).

 - srp_daemon and iwpmd support kernel modules autoload automatically as part of
   the .service file, using systemd dependencies. If those packages are not
   installed/running then those modules do not load.

 - iwpmd now automatically activates if iwarp hardware is present, systemd does
   not run it automatically.

 - None of the obsolete mtrr or pci config meddling is included

 - Nothing to do with sriov

 - udev has more information now about rdma devices:

$ udevadm info /sys/class/infiniband/mlx4_0
P: /devices/pci0000:00/0000:00:04.0/infiniband/mlx4_0
E: DEVPATH=/devices/pci0000:00/0000:00:04.0/infiniband/mlx4_0
E: ID_BUS=pci
E: ID_MODEL_FROM_DATABASE=MT27500 Family [ConnectX-3]
E: ID_MODEL_ID=0x1003
E: ID_PCI_CLASS_FROM_DATABASE=Network controller
E: ID_PCI_SUBCLASS_FROM_DATABASE=Network controller
E: ID_RDMA_INFINIBAND=1
E: ID_RDMA_ROCE=1
E: ID_VENDOR_FROM_DATABASE=Mellanox Technologies
E: ID_VENDOR_ID=0x15b3
E: NAME=mlx4_0
E: SUBSYSTEM=infiniband
E: SYSTEMD_WANTS=rdma-ndd.service rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org rdma-load-modules-WW8hglTQ5Ylgot6vXr2xLYq0XWbe/Iga@public.gmane.org rdma-load-modules-eW91h9tu8Y5TDjBF/Jpztg@public.gmane.org
E: TAGS=:systemd:
E: USEC_INITIALIZED=7954413272

    A successful test should show appropriate ID_RDMA_* entries.

I did not go ahead and remove now duplicate functionality from the
redhat/scripts, I think that Jarod should be involved in that. This approach
is not incompatible with the scripts in redhat/, but modules loads will be
attempted twice if both systems are present.

https://github.com/jgunthorpe/rdma-plumbing/tree/systemd

Jason Gunthorpe (5):
  Common infrastructure for auto loading rdma modules
  srp: Autoload the SRP kernel module if required
  iwpmd: Autoload iwpmd if required
  redhat: Remove cxgb3/4.modprobe files
  Move umad udev rules to rdma-core

 CMakeLists.txt                                     |  1 +
 Documentation/udev.md                              | 83 ++++++++++++++++++++++
 debian/control                                     |  2 +-
 debian/iwpmd.install                               |  2 +
 debian/libibumad3.install                          |  1 -
 debian/rdma-core.install                           | 10 +++
 debian/srptools.install                            |  1 +
 iwpmd/CMakeLists.txt                               |  8 +++
 iwpmd/iwpmd.rules                                  |  1 +
 iwpmd/iwpmd.service.in                             |  6 +-
 iwpmd/modules-iwpmd.conf                           |  2 +
 kernel-boot/CMakeLists.txt                         | 28 ++++++++
 kernel-boot/modules/infiniband.conf                | 12 ++++
 kernel-boot/modules/iwarp.conf                     |  1 +
 kernel-boot/modules/opa.conf                       | 10 +++
 kernel-boot/modules/rdma.conf                      | 21 ++++++
 kernel-boot/modules/roce.conf                      |  2 +
 kernel-boot/rdma-description.rules                 | 41 +++++++++++
 kernel-boot/rdma-hw-modules.rules                  | 39 ++++++++++
 kernel-boot/rdma-load-modules@.service.in          | 15 ++++
 kernel-boot/rdma-ulp-modules.rules                 | 11 +++
 .../rdma-umad.rules                                |  0
 libibumad/CMakeLists.txt                           |  5 --
 redhat/rdma-core.spec                              | 20 ++++--
 redhat/rdma.cxgb3.sys.modprobe                     |  1 -
 redhat/rdma.cxgb4.sys.modprobe                     |  1 -
 srp_daemon/CMakeLists.txt                          |  4 ++
 srp_daemon/modules-srp_daemon.conf                 |  2 +
 srp_daemon/srp_daemon.service.in                   |  2 +-
 srp_daemon/srp_daemon_port@.service.in             |  3 +-
 30 files changed, 315 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/udev.md
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
 rename libibumad/libibumad.udev-rules => kernel-boot/rdma-umad.rules (100%)
 delete mode 100644 redhat/rdma.cxgb3.sys.modprobe
 delete mode 100644 redhat/rdma.cxgb4.sys.modprobe
 create mode 100644 srp_daemon/modules-srp_daemon.conf

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
