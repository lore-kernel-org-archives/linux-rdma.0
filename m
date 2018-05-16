From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH v2] {net, IB}/mlx5: Use 'kvfree()' for memory allocated by 'kvzalloc()'
Date: Tue, 15 May 2018 17:12:36 -0700
Message-ID: <CALzJLG-Fzev4U3dUKSVb2pm=rknSGVoMW4mbbjTugdP+e13XKQ@mail.gmail.com>
References: <20180513070041.24246-1-christophe.jaillet@wanadoo.fr> <20180515222125.GA20160@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180515222125.GA20160@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, "David S. Miller" <davem@davemloft.net>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 15, 2018 at 3:21 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Sun, May 13, 2018 at 09:00:41AM +0200, Christophe JAILLET wrote:
>> When 'kvzalloc()' is used to allocate memory, 'kvfree()' must be used to
>> free it.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> v1 -> v2: More places to update have been added to the patch
>> ---
>>  drivers/infiniband/hw/mlx5/cq.c                            | 2 +-
>>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
>>  drivers/net/ethernet/mellanox/mlx5/core/vport.c            | 6 +++---
>>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> I agree with Eric on the need for fixes lines in v3..
>
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index 77d257ec899b..6d52ea03574e 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>> @@ -849,7 +849,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
>>       return 0;
>>
>>  err_cqb:
>> -     kfree(*cqb);
>> +     kvfree(*cqb);
>
> For the infiniband part:
>
> Acked-by: Jason Gunthorpe <jgg@mellanox.com>
>
> Since this is mostly ethernet, can it go through netdev? thanks
>

for the mlx5 core parts:

Acked-by: Saeed Mahameed <saeedm@mellanox.com>

Yes i will take v3 to mlx5-next branch.

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
