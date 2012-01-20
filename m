From: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: memory region limit at 32 GB?
Date: Fri, 20 Jan 2012 19:39:37 +0200
Message-ID: <CALfB72D_bp-XEBtAyntZzxF6RvxGyHJjsmsVEzjP8LyVxgAi7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello all

Is there some kind of limit that would prevent me from registering
more than 32 GiB worth of memory regions with ibv_reg_mr in
libibverbs?

>From strace I can see:

open("/dev/infiniband/uverbs0", O_RDWR) = 8
...
write(8, "\t\0\0\0\f\0\3\0\340o\255\35\377\177\0\0\0P\211\336\26\177\0\0\0\0\0@\0\0\0\0\0P\211\336\26\177\0\0\1\0\0\0\3\0\0\0",
48) = -1 ENOMEM (Cannot allocate memory)

when trying to register my 33rd 1 GiB buffer.

cat /proc/meminfo
MemTotal:       198075136 kB
MemFree:        186688448 kB
CommitLimit:    185892796 kB

so it doesn't look like a memory thing.

IB adapter details:

hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.8.600
        vendor_id:                      0x02c9
        vendor_part_id:                 26428
        hw_ver:                         0xB0
        board_id:                       MT_0FC0110009

I'm using libibverbs 1.1.6 on kernel 3.2.1-1.fc16.x86_64.

Regards

Albert
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
