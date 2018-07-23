From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH] IB/mlx5: avoid binding a new mpi unit to the same devices
 repeatedly
Date: Mon, 23 Jul 2018 13:11:12 -0500
Message-ID: <f2a5d82c-f65c-152d-5545-0d50a4e5e150@mellanox.com>
References: <20180713235021.18141-1-qing.huang@oracle.com>
 <CAJ3xEMi5zF83aA_SWfYT+JtWGGhqRhLyTKe-qYwevSBLuiK=cA@mail.gmail.com>
 <dc4d502c-bc3c-46e3-a984-41271951a5f7@mellanox.com>
 <556984ea-c35f-197d-0e45-16272da3f604@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <556984ea-c35f-197d-0e45-16272da3f604@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Qing Huang <qing.huang@oracle.com>, Or Gerlitz <gerlitz.or@gmail.com>, Parav Pandit <parav@mellanox.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, gerald.gibson@oracle.com
List-Id: linux-rdma@vger.kernel.org



On 7/23/2018 10:36 AM, Qing Huang wrote:
>
> Hi Daniel/Parav,
>
> Have you got a chance to review this patch? Thanks!
Hi Qing, sorry for the delay, I just got back to the office today. I don't agree with the proposed fix, I provided an alternative suggestion below.
>
>>> Or.
>>>
>>>> Reported-by: Gerald Gibson <gerald.gibson@oracle.com>
>>>> Signed-off-by: Qing Huang <qing.huang@oracle.com>
>>>> ---
>>>>   drivers/infiniband/hw/mlx5/main.c | 3 ++-
>>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>>>> index b3ba9a2..1ddd1d3 100644
>>>> --- a/drivers/infiniband/hw/mlx5/main.c
>>>> +++ b/drivers/infiniband/hw/mlx5/main.c
>>>> @@ -6068,7 +6068,8 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev, u8 port_num)
>>>>
>>>>          mutex_lock(&mlx5_ib_multiport_mutex);
>>>>          list_for_each_entry(dev, &mlx5_ib_dev_list, ib_dev_list) {
>>>> -               if (dev->sys_image_guid == mpi->sys_image_guid)
>>>> +               if (dev->sys_image_guid == mpi->sys_image_guid &&
>>>> +                   !dev->port[mlx5_core_native_port_num(mdev) - 1].mp.mpi)
You shouldn't check the mpi field that without holding the lock in the mp structure. Prefer you change the print from a warning in mlx5_ib_bind_slave_port to a debug message.

>>>>                          bound = mlx5_ib_bind_slave_port(dev, mpi);
>>>>
>>>>                  if (bound) {
>>>> -- 
>>>> 2.9.3
>>>>
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
