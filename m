From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/6] Final NFS/RDMA series for v4.16
Date: Wed, 03 Jan 2018 15:38:01 -0500
Message-ID: <20180103203540.29209.4620.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Anna-

Here are some minor fixes and clean ups to finish out the set of
patches for v4.16. Included are fixes for a few issues I noticed
in sunrpc.ko.

---

Chuck Lever (6):
      xprtrdma: Fix "bytes registered" accounting
      xprtrdma: Correct some documenting comments
      SUNRPC: Trace xprt_timer events
      sunrpc: Format RPC events consistently for display
      SUNRPC: task_run_action should display tk_callback
      SUNRPC: Micro-optimize __rpc_execute


 include/trace/events/sunrpc.h     |    8 ++++++--
 net/sunrpc/sched.c                |   26 ++++++++++++--------------
 net/sunrpc/xprt.c                 |    2 +-
 net/sunrpc/xprtrdma/backchannel.c |    2 +-
 net/sunrpc/xprtrdma/rpc_rdma.c    |    4 ++--
 net/sunrpc/xprtrdma/transport.c   |    2 --
 net/sunrpc/xprtrdma/verbs.c       |    2 +-
 7 files changed, 23 insertions(+), 23 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
