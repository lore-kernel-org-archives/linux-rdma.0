From: joel vennin <joel.vennin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: librdma_cm: client example failed
Date: Tue, 8 Jun 2010 22:54:05 +0200
Message-ID: <AANLkTinzM5AhpctY_psupjvGWcK8io8SwpwsIvYuuiX2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I've downloaded the latest version of librdma_cm 1.0.12.

I got unexpected segfault (hum, usually segfault is not really expected=
 .. ;)

On the same server I execute the rdma_server and rdma_client. The
first is waiting incoming message. The second one segfault. This is
the backtrace of the rdma_client:
#0=A0 0x00007f3de011482d in ?? () from /usr/lib/libmlx4-rdmav2.so
#1=A0 0x00007f3de011640e in ?? () from /usr/lib/libmlx4-rdmav2.so
#2=A0 0x00007f3de0a94244 in __ibv_modify_qp (qp=3D0x2458d40, attr=3D0x0=
,
attr_mask=3D57) at src/verbs.c:474
#3=A0 0x00007f3de0c9b292 in ucma_init_conn_qp (id_priv=3D0x24590d0,
qp=3D0x2458d40) at src/cma.c:1060
#4=A0 0x00007f3de0c9b3a3 in rdma_create_qp (id=3D0x24590d0, pd=3D<value
optimized out>, qp_init_attr=3D0x7fff973aa090) at src/cma.c:1203
#5=A0 0x00007f3de0c9d6a9 in rdma_create_ep (id=3D0x601650, res=3D0x2458=
650,
pd=3D0x0, qp_init_attr=3D0x7fff973aa090) at src/cma.c:2153
#6=A0 0x0000000000400bae in run () at examples/rdma_client.c:67
#7=A0 0x0000000000400fcf in main (argc=3D1, argv=3D0x7fff973aa288) at
examples/rdma_client.c:131


The IB chipset is the following one:
04:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX IB QDR,
PCIe 2.0 5GT/s] (rev a0)

Kernel use:
Linux 2.6.32.7.v01 #1 SMP Wed Feb 3 15:45:37 CET 2010 x86_64 GNU/Linux

libibverbs: 1.1.2
libmlx4: 1.0

Any help will be appreciated,

Thank you

Joel
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
