From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: rdma_create_qp() and max_send_wr
Date: Thu, 21 Apr 2011 18:44:24 +0200
Message-ID: <1303404264.2243.19.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I have a problem with rdma_create_qp() when I set
qp_init_attr.cap.max_send_wr to something higher than 16351: 
it returns -1 and errno is set to ENOMEM "Cannot allocate memory".

strace doesn't show anything related to memory, but the last write()
syscall returns EINVAL "Invalid Argument".

I'm using a Mellanox ConnectX MT26428 (v2.6.100 / a0) HCA, under Debian
6.0 (kernel 2.6.32-5, librdmacm 1.0.10-1, libibverbs 1.1.3-2, libmlx4
1.0-1).

According to ibv_query_device() informations, 
ibv_device_attr.max_qp_wr is 16384 (and ibv_device_attr.max_qp_wr is
16383). So one might think that 16383 outstanding WR should be OK.

I've also tried to increase the length of the associated CQ, but it
doesn't change anything.

So what's the limit of WR in the QP's SQ ? 
Is it ibv_device_attr.max_qp_wr - 32 ?


Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
