From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH] IB/mlx5: avoid binding a new mpi unit to the same devices
 repeatedly
Date: Sun, 15 Jul 2018 14:48:44 -0500
Message-ID: <dc4d502c-bc3c-46e3-a984-41271951a5f7@mellanox.com>
References: <20180713235021.18141-1-qing.huang@oracle.com>
 <CAJ3xEMi5zF83aA_SWfYT+JtWGGhqRhLyTKe-qYwevSBLuiK=cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMi5zF83aA_SWfYT+JtWGGhqRhLyTKe-qYwevSBLuiK=cA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>, Parav Pandit <parav@mellanox.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, gerald.gibson@oracle.com, Qing Huang <qing.huang@oracle.com>
List-Id: linux-rdma@vger.kernel.org


On 7/14/2018 10:57 AM, Or Gerlitz wrote:
> On Sat, Jul 14, 2018 at 2:50 AM, Qing Huang <qing.huang@oracle.com> wrote:
>> When a CX5 device is configured in dual-port RoCE mode, after creating
>> many VFs against port 1, creating the same number of VFs against port 2
>> will flood kernel/syslog with something like
>> "mlx5_*:mlx5_ib_bind_slave_port:4266:(pid 5269): port 2 already
>> affiliated."
>>
>> So basically, when traversing mlx5_ib_dev_list, mlx5_ib_add_slave_port()
>> shouldn't repeatedly attempt to bind the new mpi data unit to every device
>> on the list until it finds an unbound device.
> Daniel,
>
> What is mpi data unit?
It's a structure to keep track affiliated port info in dual port RoCE mode, mpi meaning multi-port info. Parav can review this it my absence, otherwise I can take a closer look when I return to the office.
>
> Or.
>
>> Reported-by: Gerald Gibson <gerald.gibson@oracle.com>
>> Signed-off-by: Qing Huang <qing.huang@oracle.com>
>> ---
>>  drivers/infiniband/hw/mlx5/main.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index b3ba9a2..1ddd1d3 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -6068,7 +6068,8 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev, u8 port_num)
>>
>>         mutex_lock(&mlx5_ib_multiport_mutex);
>>         list_for_each_entry(dev, &mlx5_ib_dev_list, ib_dev_list) {
>> -               if (dev->sys_image_guid == mpi->sys_image_guid)
>> +               if (dev->sys_image_guid == mpi->sys_image_guid &&
>> +                   !dev->port[mlx5_core_native_port_num(mdev) - 1].mp.mpi)
>>                         bound = mlx5_ib_bind_slave_port(dev, mpi);
>>
>>                 if (bound) {
>> --
>> 2.9.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
