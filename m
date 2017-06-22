From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: "memory management error" with NFS/RDMA on RoCE
Date: Thu, 22 Jun 2017 14:28:53 -0400
Message-ID: <7F0FCF80-DB7B-46F1-BB9A-0B070603DE61@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While running xfstests on an NFS/RDMA mount, I see this in
the client's /var/log/messages multiple times:

Jun 22 14:13:45 manet kernel: mlx5_0:dump_cqe:275:(pid 0): dump error cqe
Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
Jun 22 14:13:45 manet kernel: 00000000 08007806 250000cd 024027d3
Jun 22 14:13:45 manet kernel: rpcrdma: fastreg: memory management operation error (6/0x78)

As far as I can tell the client is able to recover and continue
the test. However, this error is not supposed to happen in normal
operation.

This is with a Mellanox CX4 in RoCEv1 mode, v4.12-rc2.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
