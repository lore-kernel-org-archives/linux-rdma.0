From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 00/21] Fixes for packaging
Date: Mon, 24 Jul 2017 14:00:08 -0600
Message-ID: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a grab bag of things I noticed when working on the systemd bootup
process:

- Various cases where multiple RPMs owned the same file
- Incorrect /run/ directory for Debian builds
- Consolidate more things into rdma-core under the theme of 'kernel boot
  support' notably rxe_cfg moves in
- Use the 00-xxx.rules format for all udev rules
- Get srp_daemon running on Debian and fixup some logging issues I noticed
- Move iwpmd to /usr/sbin since it is not user runnable

See https://github.com/linux-rdma/rdma-core/pull/172

Jason Gunthorpe (21):
  srp: Fix redhat packaging
  cbuild: Switch to Fedora Core 26
  cbuild: Add debian stretch
  cbuild: Use opensuse leap 42.2
  Make 'cbuild travis pkg' run sparse like real travis
  Tidy travis sparse check
  redhat: Fix redhat packaging of /etc/rdma/ibacm_opts.cfg
  redhat: Fix duplicated udev rules in redhat packaging
  redhat: Fix duplicated libmlx*.so in redhat packaging
  debian: Set the run directory path to /run/
  debian: Remove infiniband-diags Depends from iwpmd
  debian: Move truescale setup into rdma-core
  Prefix udev rules with a number
  Revise the umad SYSTEMD_ALIAS fake path
  umad: Match only umad kernel devices in the udev rule
  srp_daemon: Do not use LOG_PERROR
  srp_deamon: Using v formatters directly for pr_err
  srp_daemon: Call systemctl properly from udev
  iwpmd: Fix install path for iwpmd
  Move rxe_cfg to the rdma-core package
  Make /etc/modprobe.d/mlx4.conf common

 debian/control                                     |  5 ++---
 debian/ibverbs-providers.install                   |  6 -----
 debian/iwpmd.install                               |  2 +-
 debian/libibumad3.install                          |  2 +-
 debian/rdma-core.install                           |  9 +++++++-
 debian/rules                                       |  1 +
 debian/srptools.install                            |  2 +-
 iwpmd/CMakeLists.txt                               |  8 ++++---
 iwpmd/{iwpmd.service => iwpmd.service.in}          |  2 +-
 iwpmd/{iwpmd_init => iwpmd_init.in}                |  2 +-
 libibumad/CMakeLists.txt                           |  4 ++--
 libibumad/libibumad.udev-rules                     |  2 +-
 providers/mlx4/CMakeLists.txt                      |  2 ++
 .../mlx4/mlx4.conf                                 |  0
 rdma-ndd/CMakeLists.txt                            |  4 +++-
 redhat/rdma-core.spec                              | 26 ++++++++++++----------
 srp_daemon/CMakeLists.txt                          |  4 +++-
 srp_daemon/srp_daemon.c                            | 13 ++++-------
 srp_daemon/srp_daemon.rules                        |  2 +-
 srp_daemon/srp_daemon_port@.service.in             |  4 ++--
 20 files changed, 53 insertions(+), 47 deletions(-)
 rename iwpmd/{iwpmd.service => iwpmd.service.in} (80%)
 rename iwpmd/{iwpmd_init => iwpmd_init.in} (97%)
 mode change 100755 => 100644
 rename redhat/rdma.mlx4.user.modprobe => providers/mlx4/mlx4.conf (100%)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
