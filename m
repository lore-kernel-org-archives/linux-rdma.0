From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: "memory management error" with NFS/RDMA on RoCE
Date: Thu, 22 Jun 2017 14:57:02 -0600
Message-ID: <CAANLjFopp04JSOrOGivHkA2DcSFu9JER3P0_5MMYEZWfUutj6A@mail.gmail.com>
References: <7F0FCF80-DB7B-46F1-BB9A-0B070603DE61@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F0FCF80-DB7B-46F1-BB9A-0B070603DE61-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 22, 2017 at 12:28 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
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
>
>
> --
> Chuck Lever

Surprisingly, I've hit this today on iSER, but using 4.9 using CX4 ROcEv2 IPv6:

[Thu Jun 22 14:37:11 2017] mlx5_0:dump_cqe:262:(pid 0): dump error cqe
[Thu Jun 22 14:37:11 2017] 00000000 00000000 00000000 00000000
[Thu Jun 22 14:37:11 2017] 00000000 00000000 00000000 00000000
[Thu Jun 22 14:37:11 2017] 00000000 00000000 00000000 00000000
[Thu Jun 22 14:37:11 2017] 00000000 08007806 2500011f ca4f0fd3
[Thu Jun 22 14:37:11 2017] iser: iser_err_comp: memreg failure: memory
management operation error (6) vend_err 78
[Thu Jun 22 14:37:11 2017]  connection4:0: detected conn error (1011)

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
