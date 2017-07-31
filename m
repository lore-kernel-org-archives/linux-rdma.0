From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/6] Systemd integration for ibacm
Date: Mon, 31 Jul 2017 14:25:39 -0600
Message-ID: <1501532745-28378-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series makes ibacm socket activable and fine tunes the systemd
integration by running with stderr directed to the logger.

socket activation will help solve some of our boot time ordering issues by
allowing services that use rdma cm to startup without having to be concerned
with the ordering relative to ibacm.

This also makes ibacm more reliable when upgrading as systemd ensures there is
never a time when the listening socket does not exist.

Unlike other socket activation's this does not make ibacm demand start on
first use, this is because the kernel uses ibacm for RDMA local services.

https://github.com/linux-rdma/rdma-core/pull/176

Jason Gunthorpe (6):
  Detect if libsystemd is present
  ibacm: Avoid using @prefix@
  ibacm: Use daemon() instead of open coding
  ibacm: Do not fork under systemd
  ibacm: Adjust systemd service Description
  ibacm: Support systemd socket activation

 CMakeLists.txt                             |  7 +++
 buildlib/FindSystemd.cmake                 | 30 +++++++++++
 buildlib/cbuild                            | 18 ++++---
 buildlib/fixup-include/systemd-sd-daemon.h | 11 ++++
 debian/control                             |  1 +
 debian/ibacm.install                       |  1 +
 ibacm/CMakeLists.txt                       |  7 ++-
 ibacm/ibacm.init.in                        |  6 +--
 ibacm/ibacm.service.in                     |  7 +--
 ibacm/ibacm.socket                         | 10 ++++
 ibacm/man/ibacm.1                          |  4 ++
 ibacm/src/acm.c                            | 87 +++++++++++++++++++-----------
 rdma-core.spec                             |  3 ++
 redhat/rdma-core.spec                      |  2 +
 14 files changed, 150 insertions(+), 44 deletions(-)
 create mode 100644 buildlib/FindSystemd.cmake
 create mode 100644 buildlib/fixup-include/systemd-sd-daemon.h
 create mode 100644 ibacm/ibacm.socket

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
