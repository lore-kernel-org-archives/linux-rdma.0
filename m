From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: cqe dump errors on target while running nvme-of large block read
 IO
Date: Thu, 13 Apr 2017 14:29:36 +0300
Message-ID: <47f19583-1882-09d4-ce1c-534b8e59068b@mellanox.com>
References: <DE927C68B458BE418D582EC97927A9285505C9EA@ORSMSX113.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DE927C68B458BE418D582EC97927A9285505C9EA-8oqHQFITsIFQxe9IK+vIArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org'" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Sen, Sujoy" <sujoy.sen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/12/2017 7:41 PM, Gruher, Joseph R wrote:
> Hi folks-
>
> Wanted to put this issue out there and see if anyone had thoughts.
>
> Target system - 100Gb dual port CX5, FW 16.19.1000, through Arista 7060X switch with Ethernet flow control
> Initiator system - 25Gb dual port CX4, FW 14.18.2000, through Arista 7060X switch with Ethernet flow control
>
> We attach 16 drives from target to initiator, but are only running IO on four of them in this test, two drives per network port on initiator/target.  Drives in use are Intel P3700 400GB.
>
> We are running Ubuntu 16.10 with the 4.11-rc6 kernel and this patch from Max:
>
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c index ad8a263..c38c4fa 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -3737,8 +3737,7 @@ static void dump_wqe(struct mlx5_ib_qp *qp, int idx, int size_16)
>
>   static u8 get_fence(u8 fence, struct ib_send_wr *wr)
>   {
> -       if (unlikely(wr->opcode == IB_WR_LOCAL_INV &&
> -                    wr->send_flags & IB_SEND_FENCE))
> +       if (wr->opcode == IB_WR_LOCAL_INV || wr->opcode == IB_WR_REG_MR)
>                  return MLX5_FENCE_MODE_STRONG_ORDERING;
>
>          if (unlikely(fence)) {
>
> For the most part we can run FIO IO on the initiator against the attached subsystems without problems.  4KB random read and write, 64KB sequential writes are working OK on this setup.  We seem to encounter errors when we run a 64KB sequential read workload.  I would not the 64KB sequential read workload is the only one which generates enough traffic that we could bottleneck on the initiator NIC throughput - not sure if that is relevant, or just a coincidence.  We can reproduce these errors fairly reliably at this time.  See attached dmesg and example below:
>
> [12728.885267] mlx5_1:dump_cqe:262:(pid 2943): dump error cqe
> [12728.885271] 00000000 00000000 00000000 00000000
> [12728.885272] 00000000 00000000 00000000 00000000
> [12728.885274] 00000000 00000000 00000000 00000000
> [12728.885275] 00000000 00008813 08000240 0255bcd3
> [12728.885852] mlx5_1:dump_cqe:262:(pid 2829): dump error cqe
> [12728.885855] 00000000 00000000 00000000 00000000
> [12728.885857] 00000000 00000000 00000000 00000000
> [12728.885859] 00000000 00000000 00000000 00000000
> [12728.885861] 00000000 00008813 08000239 c2e59fd3
> [12735.782466] nvmet: ctrl 17 keep-alive timer (15 seconds) expired!
> [12735.784949] nvmet: ctrl 17 fatal error occurred!
>
> These target side error prints seem correlated with IO failures and disconnect/reconnect events on the initiator so they are a problem.  Any ideas?  Any additional info we can provide?

hi Joe,
can you run and repro it with null_blk backing store instead the nvme ? 
you can emulate the delay of the nvme device using module param 
completion_nsec.
is it reproducable in case B2B connectivity ?

>
> Thanks,
> Joe
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
