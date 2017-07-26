From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/8] Various fixes for daemons and systemd
Date: Wed, 26 Jul 2017 13:59:04 -0600
Message-ID: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These were found during my kernel-boot work

- Broadly make iwpmd work sanely as a daemon with systemd, do not fork, use
  the right daemon name for syslog, and do not send stderr to /dev/null

- Fix duplicated log messages in srp_daemon by removing LOG_PERROR when in
  systemd mode

This is pull request https://github.com/linux-rdma/rdma-core/pull/173

Jason Gunthorpe (8):
  srp_daemon: Move the setup of the wakeup_pipe after openlog
  srp_daemon: Fix missing free_config for ibsrpdm
  srp_daemon: Add a --systemd option
  Consistently open syslog in daemons
  iwpmd: Move iwpmd.1 man page to iwpmd.8
  iwpm: Use daemon() instead of open coding a version
  iwpmd: Add --systemd option
  rdma-ndd: Tidy getopt_long call

 debian/iwpmd.install                      |   4 +-
 iwpmd/CMakeLists.txt                      |   2 +-
 iwpmd/iwarp_pm_server.c                   |  64 +++++++-------
 iwpmd/{iwpmd.1.in => iwpmd.8.in}          |   6 +-
 iwpmd/iwpmd.conf.5.in                     |   2 +-
 iwpmd/{iwpmd.service => iwpmd.service.in} |   3 +-
 rdma-ndd/rdma-ndd.c                       |   7 +-
 redhat/rdma-core.spec                     |   2 +-
 srp_daemon/srp_daemon.1.in                |   3 +
 srp_daemon/srp_daemon.c                   | 140 +++++++++++++++++++++---------
 srp_daemon/srp_daemon_port@.service.in    |   2 +-
 11 files changed, 147 insertions(+), 88 deletions(-)
 rename iwpmd/{iwpmd.1.in => iwpmd.8.in} (95%)
 rename iwpmd/{iwpmd.service => iwpmd.service.in} (75%)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
