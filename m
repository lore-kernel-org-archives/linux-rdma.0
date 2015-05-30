From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 10/11] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Sat, 30 May 2015 23:49:28 +0300
Message-ID: <CAJ3xEMhbB62nfOgAf3SYif+RWPaAb-8Ko5byZWtWxyZxKZ2Kgw@mail.gmail.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
	<1432220202-9834-11-git-send-email-ogerlitz@mellanox.com>
	<1432917684.114391.98.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432917684.114391.98.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 29, 2015 at 7:41 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2015-05-21 at 17:56 +0300, Or Gerlitz wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> mlx4 needs to report the number of supported timestamp
>> bits (mask) and the hca_core_clock frequency.
>>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/mlx4/main.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
>> index ef211c8..a5a90c4 100644
>> --- a/drivers/infiniband/hw/mlx4/main.c
>> +++ b/drivers/infiniband/hw/mlx4/main.c
>> @@ -233,6 +233,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
>>       props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
>>                                          props->max_mcast_grp;
>>       props->max_map_per_fmr = dev->dev->caps.max_fmr_maps;
>> +     props->hca_core_clock = dev->dev->caps.hca_core_clock;
>> +     props->timestamp_mask = 0xFFFFFFFFFFFFULL;
>>
>>  out:
>>       kfree(in_mad);
>
> Or, please squash 8, 9, and 10 to a single patch.  They all are "add
> support for timestamping to mlx4" but without squashing them together,
> the support they add is broken/partial.

Sure, will do.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
