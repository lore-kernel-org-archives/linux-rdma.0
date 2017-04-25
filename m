From: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] Please pull NFSoRDMA client side changes for 4.12
Date: Tue, 25 Apr 2017 16:53:11 -0400
Message-ID: <d114d121-28f5-7057-e193-539260f92476@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Trond,

The following changes since commit 39da7c509acff13fc8cb12ec1bb20337c988ed36:

  Linux 4.11-rc6 (2017-04-09 09:49:44 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/anna/nfs-rdma.git tags/nfs-rdma-4.12-1

for you to fetch changes up to 2be1fce95e5b017dd7d23ca039d58cbefd0221e6:

  xprtrdma: Remove rpcrdma_buffer::rb_pool (2017-04-25 16:12:35 -0400)
----------------------------------------------------------------
New Features:
- Break RDMA connections after a connection timeout
- Support for unloading the underlying device driver

Bugfixes and cleanups:
- Mark the receive workqueue as "read-mostly"
- Silence warnings caused by ENOBUFS
- Update a comment in xdr_init_decode_pages()
- Remove rpcrdma_buffer->rb_pool.

Thanks,
Anna
----------------------------------------------------------------
Chuck Lever (13):
      xprtrdma: Cancel refresh worker during buffer shutdown
      sunrpc: Export xprt_force_disconnect()
      xprtrdma: Detect unreachable NFS/RDMA servers more reliably
      xprtrdma: Refactor rpcrdma_ia_open()
      xprtrdma: Use same device when mapping or syncing DMA buffers
      xprtrdma: Support unplugging an HCA from under an NFS mount
      xprtrdma: Refactor rpcrdma_ep_connect
      xprtrdma: Restore transport after device removal
      xprtrdma: Revert commit d0f36c46deea
      xprtrdma: Annotate receive workqueue
      xprtrdma: Squelch ENOBUFS warnings
      sunrpc: Fix xdr_init_decode_pages() documenting comment
      xprtrdma: Remove rpcrdma_buffer::rb_pool

 net/sunrpc/xdr.c                |   2 +-
 net/sunrpc/xprt.c               |   1 +
 net/sunrpc/xprtrdma/rpc_rdma.c  |  12 +++++----
 net/sunrpc/xprtrdma/transport.c |  57 +++++++++++++++++++++++++++++++++------
 net/sunrpc/xprtrdma/verbs.c     | 323 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h |  22 ++++++++++++---
 6 files changed, 295 insertions(+), 122 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
