From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH rdma-core 0/5] srp_daemon: Rework systemd integration
Date: Mon, 15 May 2017 15:47:22 -0700
Message-ID: <20170515224733.29586-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

This patch series implements the changes that were discussed a few days
ago on the linux-rdma mailing list:
- srp_daemon.service is split into srp_daemon.service and the
  srp_daemon_port@.service template. The former does not start any srp_daemon
  process but controls the latter.
- srp_daemon_port@.service  instances are started automatically upon hot-add of
  an RDMA port to support hot-plugging.

As usual, comments and feedback are welcome.

Bart.

Bart Van Assche (5):
  srp_daemon.sh: Improve robustness
  srp_daemon: Use the recommended style in the man page
  srp_daemon: Add command-line option -j
  srp_daemon: Move srp_daemon.service from the redhat directory to the
    srp_daemon directory
  srp_daemon.service: Add support for hot-plugging

 debian/srptools.install                            |  5 ++
 redhat/rdma-core.spec                              |  8 ++--
 srp_daemon/90-srp-daemon.rules                     |  1 +
 srp_daemon/CMakeLists.txt                          |  7 +++
 srp_daemon/srp_daemon.1.in                         | 54 +++++++++++++++-------
 srp_daemon/srp_daemon.c                            | 16 ++++++-
 srp_daemon/srp_daemon.service                      | 15 ++++++
 srp_daemon/srp_daemon.service.5                    | 30 ++++++++++++
 srp_daemon/srp_daemon.sh.in                        | 34 +++++++-------
 .../srp_daemon_port@.service                       |  7 +--
 srp_daemon/srp_daemon_port@.service.5              | 46 ++++++++++++++++++
 11 files changed, 181 insertions(+), 42 deletions(-)
 create mode 100644 srp_daemon/90-srp-daemon.rules
 create mode 100644 srp_daemon/srp_daemon.service
 create mode 100644 srp_daemon/srp_daemon.service.5
 rename redhat/srp_daemon.service => srp_daemon/srp_daemon_port@.service (63%)
 create mode 100644 srp_daemon/srp_daemon_port@.service.5

-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
