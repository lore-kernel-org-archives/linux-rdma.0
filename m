From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCHv2 rdma-core 0/5] Packaging: fixes and SUSE support
Date: Fri, 25 Aug 2017 12:39:20 +0200
Message-ID: <88926674-d707-6f00-e9a1-e2a823fec323@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series contains a few fixes for the packaging and add support for RPM packaging on SUSE

Patch 1-3 are fixes
#1 adds a CMake variable to select the patch tot systemd-modules-load
#2 installs udev.md which is referenced in multiple service files
#3 fixes a typo in redhat spec file
#4 adds the SUSE spec file
#5 enable the suse spec file do SUSE build in cbuild

Changes since v1:
- Add packaging fixes
- Several fixes on the SUSE spec file:
  * Drop unneeded service file registering
  * Drop duplicate rdma-ndd udev rule


Nicolas Morey-Chaisemartin (5):
  kernel-boot: Add cmake variable to configure the path to systemd-*
    binaries
  Documentation: install udev.md
  redhat: fix typo in librdacm package description
  suse: Add spec file for SUSE
  cbuild: use SUSE spec file for SUSE targets

 CMakeLists.txt                            |   2 +
 Documentation/CMakeLists.txt              |   1 +
 MAINTAINERS                               |   5 +
 buildlib/cbuild                           |   2 +
 debian/rdma-core.install                  |   1 +
 kernel-boot/rdma-load-modules@.service.in |   2 +-
 redhat/rdma-core.spec                     |   3 +-
 suse/rdma-core.spec                       | 688 ++++++++++++++++++++++++++++++
 8 files changed, 702 insertions(+), 2 deletions(-)
 create mode 100644 suse/rdma-core.spec

-- 
2.14.1.252.gf15771ee3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
