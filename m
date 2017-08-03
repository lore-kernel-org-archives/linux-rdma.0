From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/4] sd_notify for daemons
Date: Thu,  3 Aug 2017 16:04:02 -0600
Message-ID: <1501797846-8228-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This adds calls to sd_notify for iwpmd, ibacm and rdma-ndd daemons.

This allows systemd to know when the daemon has completed startup and is ready
to act. This is a necessary element to solve bootup races.

The choice is to use sd_notify instead of Type=forking, mainly because most of
our daemons are using threads and moving the fork point till after the threads
are setup (where sd_notify is placed) is a major change in daemon design..

https://github.com/linux-rdma/rdma-core/pull/178

Jason Gunthorpe (4):
  Shim sd_notify when libsystemd is not present
  rdma-ndd: Use sd_notify to synchronize bootup
  iwpmd: Use sd_notify to synchronize bootup
  ibacm: Use sd_notify to synchronize bootup

 buildlib/fixup-include/systemd-sd-daemon.h |  5 +++++
 ibacm/ibacm.service.in                     |  1 +
 ibacm/src/acm.c                            |  3 +++
 iwpmd/CMakeLists.txt                       |  1 +
 iwpmd/iwarp_pm_server.c                    |  5 +++++
 iwpmd/iwpmd.service.in                     |  1 +
 rdma-ndd/CMakeLists.txt                    |  5 ++++-
 rdma-ndd/rdma-ndd.8.in                     |  3 +++
 rdma-ndd/rdma-ndd.8.in.rst                 |  3 +++
 rdma-ndd/rdma-ndd.c                        | 15 ++++++++++++---
 rdma-ndd/rdma-ndd.service.in               |  3 ++-
 11 files changed, 40 insertions(+), 5 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
