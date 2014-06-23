From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 00/13] NFS/RDMA patches for 3.17
Date: Mon, 23 Jun 2014 18:39:00 -0400
Message-ID: <20140623223201.1634.83888.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The main purpose of this series is to address more connection drop
recovery issues by fixing FRMR re-use to make it less likely the
client will drop the connection due to a memory operation error.

Some other clean-ups and fixes are present as well.

See topic branch nfs-rdma-for-3.17 in

  git://git.linux-nfs.org/projects/cel/cel-2.6.git

I tested with NFSv3 and NFSv4 on all three supported memory
registration modes. Used cthon04 and iozone with both Solaris
and Linux NFS/RDMA servers. Used xfstests with Linux.

---

Chuck Lever (13):
      xprtrdma: Fix panic in rpcrdma_register_frmr_external()
      xprtrdma: Protect ->qp during FRMR deregistration
      xprtrdma: Limit data payload size for ALLPHYSICAL
      xprtrdma: Update rkeys after transport reconnect
      xprtrdma: Don't drain CQs on transport disconnect
      xprtrdma: Unclutter struct rpcrdma_mr_seg
      xprtrdma: Encode Work Request opcode in wc->wr_id
      xprtrdma: Back off rkey when FAST_REG_MR fails
      xprtrdma: Refactor rpcrdma_buffer_put()
      xprtrdma: Release FRMR segment buffers during LOCAL_INV completion
      xprtrdma: Clean up rpcrdma_ep_disconnect()
      xprtrdma: Remove RPCRDMA_PERSISTENT_REGISTRATION macro
      xprtrdma: Handle additional connection events


 include/linux/sunrpc/xprtrdma.h |    2 
 net/sunrpc/xprtrdma/rpc_rdma.c  |   77 +++++----
 net/sunrpc/xprtrdma/transport.c |   17 +-
 net/sunrpc/xprtrdma/verbs.c     |  330 +++++++++++++++++++++++++++------------
 net/sunrpc/xprtrdma/xprt_rdma.h |   63 ++++++-
 5 files changed, 332 insertions(+), 157 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
