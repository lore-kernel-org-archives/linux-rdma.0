From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 7/7] IB/mlx4: Advertise RoCE support
Date: Wed, 30 Dec 2015 10:25:08 +0200
Message-ID: <568394E4.90708@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
 <1451395447-5198-8-git-send-email-matanb@mellanox.com>
 <56829C3D.5050009@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56829C3D.5050009-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 12/29/2015 4:44 PM, Or Gerlitz wrote:
> On 12/29/2015 3:24 PM, Matan Barak wrote:
>> Advertise RoCE support in port_immutable according to the hardware
>> capabilities. This enables the verbs stack to use RoCE v2 mode.
>
> Advertise RoCE V2 support
>
>>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> I guess you wanted  "IB/mlx4: Advertise RoCE V2 support" for the patch
> title? since we did
> advertise RDMA_CORE_PORT_IBA_ROCE prior to this patch.
>

Correct, thanks!

> Or.
>> ---
>>   drivers/infiniband/hw/mlx4/main.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx4/main.c
>> b/drivers/infiniband/hw/mlx4/main.c
>> index 44e5699..8cf2575 100644
>> --- a/drivers/infiniband/hw/mlx4/main.c
>> +++ b/drivers/infiniband/hw/mlx4/main.c
>> @@ -2183,6 +2183,7 @@ static int mlx4_port_immutable(struct ib_device
>> *ibdev, u8 port_num,
>>                      struct ib_port_immutable *immutable)
>>   {
>>       struct ib_port_attr attr;
>> +    struct mlx4_ib_dev *mdev = to_mdev(ibdev);
>>       int err;
>>       err = mlx4_ib_query_port(ibdev, port_num, &attr);
>> @@ -2192,10 +2193,15 @@ static int mlx4_port_immutable(struct
>> ib_device *ibdev, u8 port_num,
>>       immutable->pkey_tbl_len = attr.pkey_tbl_len;
>>       immutable->gid_tbl_len = attr.gid_tbl_len;
>> -    if (mlx4_ib_port_link_layer(ibdev, port_num) ==
>> IB_LINK_LAYER_INFINIBAND)
>> +    if (mlx4_ib_port_link_layer(ibdev, port_num) ==
>> IB_LINK_LAYER_INFINIBAND) {
>>           immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
>> -    else
>> -        immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
>> +    } else {
>> +        if (mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
>> +            immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
>> +        if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2)
>> +            immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE |
>> +                RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
>> +    }
>>       immutable->max_mad_size = IB_MGMT_MAD_SIZE;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
