From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: "memory management error" with NFS/RDMA on RoCE
Date: Tue, 27 Jun 2017 12:28:21 +0300
Message-ID: <797a43c4-f30d-9deb-a332-c62cbd01be7b@grimberg.me>
References: <7F0FCF80-DB7B-46F1-BB9A-0B070603DE61@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F0FCF80-DB7B-46F1-BB9A-0B070603DE61-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> While running xfstests on an NFS/RDMA mount, I see this in
> the client's /var/log/messages multiple times:
> 
> Jun 22 14:13:45 manet kernel: mlx5_0:dump_cqe:275:(pid 0): dump error cqe
> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
> Jun 22 14:13:45 manet kernel: 00000000 08007806 250000cd 024027d3
> Jun 22 14:13:45 manet kernel: rpcrdma: fastreg: memory management operation error (6/0x78)
> 
> As far as I can tell the client is able to recover and continue
> the test. However, this error is not supposed to happen in normal
> operation.
> 
> This is with a Mellanox CX4 in RoCEv1 mode, v4.12-rc2.

Is this a regression? What kernel version are you running?
FW revision?

Is the below commit applied?
commit 6e8484c5cf07c7ee632587e98c1a12d319dacb7c
Author: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Sun May 28 10:53:11 2017 +0300

     RDMA/mlx5: set UMR wqe fence according to HCA cap

     Cache the needed umr_fence and set the wqe ctrl segmennt
     accordingly.

     Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Acked-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
     Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This is the only thing that changed in that area
lately...

Can you try without it?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
