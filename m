From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] IB/mlx5: Add create_cq extended command
Date: Tue, 10 Nov 2015 10:28:58 +0200
Message-ID: <CAAKD3BC9yGWwj91_WPN8XVNUKkqTHHhNR7jK99Vi3r8688OE_Q@mail.gmail.com>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
	<1447086657-15358-2-git-send-email-matanb@mellanox.com>
	<20151109232259.GB20707@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151109232259.GB20707-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 1:22 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Nov 09, 2015 at 06:30:54PM +0200, Matan Barak wrote:
>> In order to create a CQ that supports timestamp, mlx5 needs to
>> support the extended create CQ command with the timestamp flag.
>>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>  drivers/infiniband/hw/mlx5/cq.c   | 7 +++++++
>>  drivers/infiniband/hw/mlx5/main.c | 3 ++-
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index 2d0dbbf..674f857 100644
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>> @@ -743,6 +743,10 @@ static void destroy_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq)
>>       mlx5_db_free(dev->mdev, &cq->db);
>>  }
>>
>> +enum {
>> +     CQ_CREATE_FLAGS_SUPPORTED = IB_CQ_FLAGS_TIMESTAMP_COMPLETION
>> +};
>> +
>>  struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
>>                               const struct ib_cq_init_attr *attr,
>>                               struct ib_ucontext *context,
>> @@ -766,6 +770,9 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
>>       if (entries < 0)
>>               return ERR_PTR(-EINVAL);
>>
>> +     if (attr->flags & ~CQ_CREATE_FLAGS_SUPPORTED)
>> +             return ERR_PTR(-EINVAL);
>
> And this is what I was just mentioning to Eli, EINVAL is not the right
> return, and this same comment applies to the places where the above
> was copy and pasted into drivers during the ex patching.
>
> Try for EOPNOTSUPP maybe?
>

Agree. Thanks, I'll fix.

> Jason

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
