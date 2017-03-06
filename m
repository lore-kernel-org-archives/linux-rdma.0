From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Mon, 6 Mar 2017 13:28:56 +0200
Message-ID: <16c4bd86-fd63-f230-40bc-f52cb106e11b@grimberg.me>
References: <08131a05-1f56-ef61-990a-7fff04eea095@gmail.com>
 <de1a559a-bf24-0d73-5fc7-148d6cd4d4e0@grimberg.me>
 <1848296658.37025722.1487782361271.JavaMail.zimbra@redhat.com>
 <1554c1d1-6bf4-9ca2-12d4-a0125d8c5715@gmail.com>
 <DE927C68B458BE418D582EC97927A92854655137@ORSMSX112.amr.corp.intel.com>
 <3eb5814f-14cb-2b94-adf8-335d4b2eb7e9@grimberg.me>
 <26912d0c-578f-26e9-490d-94fc95bdf259@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26912d0c-578f-26e9-490d-94fc95bdf259-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hi Sagi,
>
> I think we need to add fence to the UMR wqe.
>
> so lets try this one:
>
> diff --git a/drivers/infiniband/hw/mlx5/qp.c
> b/drivers/infiniband/hw/mlx5/qp.c
> index ad8a263..c38c4fa 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -3737,8 +3737,7 @@ static void dump_wqe(struct mlx5_ib_qp *qp, int
> idx, int size_16)
>
>  static u8 get_fence(u8 fence, struct ib_send_wr *wr)
>  {
> -       if (unlikely(wr->opcode == IB_WR_LOCAL_INV &&
> -                    wr->send_flags & IB_SEND_FENCE))
> +       if (wr->opcode == IB_WR_LOCAL_INV || wr->opcode == IB_WR_REG_MR)
>                 return MLX5_FENCE_MODE_STRONG_ORDERING;
>
>         if (unlikely(fence)) {

This will kill performance, isn't there another fix that can
be applied just for retransmission flow?

> Couldn't repro that case but I run some initial tests in my Lab (with my
> patch above) - not performace servers:
>
> Initiator with 24 CPUs (2 threads/core, 6 cores/socket, 2 sockets),
> Connect IB (same driver mlx5_ib), kernel 4.10.0, fio test with 24 jobs
> and 128 iodepth.
> register_always=N
>
> Target - 1 subsystem with 1 ns (null_blk)
>
> bs   read (without/with patch)   write (without/with patch)
> --- --------------------------  ---------------------------
> 512     1019k / 1008k                 1004k / 992k
> 1k      1021k / 1013k                 1002k / 991k
> 4k      1030k / 1022k                 978k  / 969k
>
> CPU usage is 100% for both cases in the initiator side.
> haven't seen difference with bs = 16k.
> No so big drop like we would expect,

Obviously you won't see a drop without registering memory
for small IO (register_always=N), this would bypass registration
altogether... Please retest with register_always=Y.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
