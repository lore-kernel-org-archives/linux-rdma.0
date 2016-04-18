From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/mlx5: Report mlx5 LSO capabilities when
 querying device
Date: Mon, 18 Apr 2016 21:23:22 +0000
Message-ID: <HE1PR05MB16427E57D25F16ACAA919C7FAA6B0@HE1PR05MB1642.eurprd05.prod.outlook.com>
References: <1460996717-18778-1-git-send-email-majd@mellanox.com>
 <1460996717-18778-3-git-send-email-majd@mellanox.com>
 <CAJ3xEMjS4BOLxgG+L3Nx+8-5NPgGsXM2E13up=_+wVvWDSBjSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/18/2016 3:42 PM, Or Gerlitz wrote:
> On Mon, Apr 18, 2016 at 7:25 PM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> mlx5 based hardware supports LSO for Raw Ethernet QPs.
>> LSO (large segment offload) applied here is mainly used
>> for TCP (also known as TSO).
>>
>> Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/mlx5/main.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index 5acf346..09502ad 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -454,6 +454,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>>         int max_rq_sg;
>>         int max_sq_sg;
>>         u64 min_page_size = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
>> +       u64 max_lso;
>>
>>         if (uhw->inlen || uhw->outlen)
>>                 return -EINVAL;
>> @@ -508,10 +509,18 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>>         if (MLX5_CAP_GEN(mdev, block_lb_mc))
>>                 props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
>>
>> -       if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
>> -           (MLX5_CAP_ETH(dev->mdev, csum_cap)))
>> +       if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads)) {
>> +               if (MLX5_CAP_ETH(mdev, csum_cap))
>>                         props->device_cap_flags |= IB_DEVICE_RAW_IP_CSUM;
>>
>> +               max_lso = MLX5_CAP_ETH(mdev, max_lso_cap);
>> +               if (max_lso) {
>> +                       props->lso_caps.max_lso = 1 << max_lso;
>> +                       props->lso_caps.supported_qpts |=
>> +                               1 << IB_QPT_RAW_ETHERTYPE;
> what?!
>
> This QP type is not supported by the driver
>
>
>> +               }
>> +       }
>> +
>>         if (MLX5_CAP_GEN(mdev, ipoib_basic_offloads)) {
>>                 props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
>>                 props->device_cap_flags |= IB_DEVICE_UD_TSO;
>> --

Will change to IB_QPT_RAW_PACKET

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
