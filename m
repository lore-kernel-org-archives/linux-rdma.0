From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Two short NFS/RDMA subjects
Date: Wed, 31 Jan 2018 12:33:56 -0500
Message-ID: <20180131173308.11367.93367.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Anna-

Cavium has reported two issues for which I have fixes. These
should also go to stable.

---

Chuck Lever (2):
      xprtrdma: Fix calculation of ri_max_send_sges
      xprtrdma: Fix BUG after a device removal


 net/sunrpc/xprtrdma/rpc_rdma.c |    2 +-
 net/sunrpc/xprtrdma/verbs.c    |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
