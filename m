From: =?GB2312?B?tqG2qLuq?= <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: two questions about RDMA-WRITE
Date: Tue, 13 Apr 2010 18:08:15 +0800
Message-ID: <q2v7bb361261004130308za7b4d6ccj6fdb657b7c7cc7e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi guys:
I'm doing a project using RDMA to transfer data between servers.  I'm
using RDMA_PS_TCP type and do RDMA_WRITE operations from client node
to server node. While the program succeed in setting up connection and
transferring data, I 'm still very confused about two problems:
(1)  After transfer the data using IB_WR_RDMA_WRITE , the complete
queue entry found that the opcode turned from IB_WR_RDMA_WRITE to
IB_WR_RDMA_WRITE_WITH_IMM, I don't know the meaning of this opcode and
the reason of the change.
(2)  It takes a long time to finish rdma_disconnect work (about 10
seconds), so is it a reasonable time?

My develop environment is Centos5.3, kernel version: 2.6.18-128.el5. I
will very appreciated if you guys can give me some tips. Please CC to
me since I didn't subscribe this list.
Thanks.

--=20
=B6=A1=B6=A8=BB=AA
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
