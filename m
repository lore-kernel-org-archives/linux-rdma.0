From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mlx5 driver load error
Date: Mon, 25 Jul 2016 00:28:51 -0700
Message-ID: <CAF1ivSZarECVv9J2epbtmhgD9txfhZXGRiAnCpVPh+rP4ib3PQ@mail.gmail.com>
References: <CAF1ivSa1vtCzGX7tkyTwxQr7zbSZ-e=p8vJPFT=DANS7ZaE_eA@mail.gmail.com>
 <20160725070059.GA20674@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725070059.GA20674-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 25, 2016 at 12:00 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Thu, Jul 21, 2016 at 03:54:31PM -0700, Ming Lin wrote:
>> Hi,
>>
>> I build k.o/for-4.8 branch(commit fb92d8fb1b9). But mlx5 driver doesn't work.
>>
>> root@host:~# lspci |grep -i mellanox
>> 03:00.0 Ethernet controller: Mellanox Technologies MT27700 Family [ConnectX-4]
>> 03:00.1 Ethernet controller: Mellanox Technologies MT27700 Family [ConnectX-4]
>>
>> root@host:~# dmesg |grep -i mlx5
>> [    3.833348] mlx5_core 0000:03:00.0: firmware version: 12.12.1100
>> [    4.024478] mlx5_core 0000:03:00.0: enable hca failed
>> [    4.260086] mlx5_core 0000:03:00.0: mlx5_load_one failed with error code -5
>> [    4.333568] mlx5_core: probe of 0000:03:00.0 failed with error -5
>> [    4.339977] mlx5_core 0000:03:00.1: firmware version: 12.12.1100
>> [    4.410366] mlx5_core 0000:03:00.1: enable hca failed
>> [    4.562862] mlx5_core 0000:03:00.1: mlx5_load_one failed with error code -5
>> [    4.570046] mlx5_core: probe of 0000:03:00.1 failed with error -5
>>
>> Could you help on this?
>
> Hi Ming,
> Sorry for slow response,

Hi Leon,

>
> We tested this commit with this firmware version to eliminate the case
> that it is related to FW and it works.
>
> Can you please post your "grep MLX5 .config" output?

$ grep MLX5 .config
CONFIG_MLX5_CORE=m
# CONFIG_MLX5_CORE_EN is not set
CONFIG_MLX5_INFINIBAND=m


>
> Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
