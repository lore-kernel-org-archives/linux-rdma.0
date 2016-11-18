From: Kamal Heib <kamalh.mellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/IPoIB: Remove can't use GFP_NOIO warning
Date: Fri, 18 Nov 2016 12:34:50 +0200
Message-ID: <CANvqgxBQ6BH5avp7=saQayA1AWLB-JKttM06DacXSxmiREmVOg@mail.gmail.com>
References: <1478765808-12517-1-git-send-email-leon@kernel.org> <CAJ3xEMgCFmSMA5F-7D89n248K2HovvwHnnMgke7-FSDbROFA4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgCFmSMA5F-7D89n248K2HovvwHnnMgke7-FSDbROFA4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 18, 2016 at 12:30 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Nov 10, 2016 at 10:16 AM, Leon Romanovsky wrote:
>> From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Remove the warning print of "can't use of GFP_NOIO" to avoid prints in
>> each QP creation when devices aren't supporting IB_QP_CREATE_USE_GFP_NOIO.
>>
>> This print become more annoying when the IPoIB interface is configured
>> to work in connected mode.
>>
>> Fixes: 09b93088d750 ('IB: Add a QP creation flag to use GFP_NOIO allocations')
>
> Hi Kamal,

Hi Or :)

>
> I don't think you're fixing a bug in this commit... you find the print
> annoying and you remove it, okay, maybe we can do that. Why not leave
> it in rate-limited manner? can you elaborate what was that deeply
> annoying with getting the warning?
>

It's really annoying when you have multiple ipoib interfaces and
pkeys, so the dmesg will look like the following:

[933236.858739] mlx5_ib0: can't use GFP_NOIO for QPs on device mlx5_0,
using GFP_KERNEL
[933407.571911] mlx5_ib0.8002: can't use GFP_NOIO for QPs on device
mlx5_0, using GFP_KERNEL
[933634.121955] mlx5_ib0.8006: can't use GFP_NOIO for QPs on device
mlx5_0, using GFP_KERNEL
[934167.851164] mlx5_ib0.8004: can't use GFP_NOIO for QPs on device
mlx5_0, using GFP_KERNEL
[934936.645002] mlx5_ib0.8002: can't use GFP_NOIO for QPs on device
mlx5_0, using GFP_KERNEL

>> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
>> @@ -1053,8 +1053,6 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
>>
>>         tx_qp = ib_create_qp(priv->pd, &attr);
>>         if (PTR_ERR(tx_qp) == -EINVAL) {
>> -               ipoib_warn(priv, "can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
>> -                          priv->ca->name);
>>                 attr.create_flags &= ~IB_QP_CREATE_USE_GFP_NOIO;
>>                 tx_qp = ib_create_qp(priv->pd, &attr);
>>         }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
