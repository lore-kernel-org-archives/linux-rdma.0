From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rdma-core: Make room for source GIDs to be added
Date: Wed, 14 Jun 2017 09:54:31 +0530
Message-ID: <CAOBf=mv=EuAUM9Ccy+dHp31jmppir7rDsuNg7wbuP2t6MbFpUA@mail.gmail.com>
References: <20170613025451.31416-1-somnath.kotur@broadcom.com> <20170613060325.GF2576@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170613060325.GF2576-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

On Tue, Jun 13, 2017 at 11:33 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Jun 13, 2017 at 08:24:51AM +0530, Somnath Kotur wrote:
>> Currently sgid_index is of type 'u8' so we can't really go beyond 128
>> unique GID entries(one for each type so total of 256 GID entries).
>> Change it to u16 so atleast 4k GID entries (as many VLANs that can be added)
>> can be accomodated.
>>
>> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/core/verbs.c | 2 +-
>>  include/rdma/ib_verbs.h         | 4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> What type of testing did this change get?
> According to spec, "The maximum number (N) of unicast GIDs supported per endport is
> implementation specific".
>

> mlx5 and mlx4 are limited to 128 GIDs and user will get errors if he try to set
> more than that.
>
Agree with your points, and yes this was tested against an adapter
that could support more than 128 GIDs

Thanks
Som
>>
>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
>> index 4792f52..3161e2c 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -549,7 +549,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
>>               flow_class = be32_to_cpu(grh->version_tclass_flow);
>>               rdma_ah_set_grh(ah_attr, &sgid,
>>                               flow_class & 0xFFFFF,
>> -                             (u8)gid_index, hoplimit,
>> +                             (u16)gid_index, hoplimit,
>>                               (flow_class >> 20) & 0xFF);
>>
>>       }
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index ba8314e..30ce942 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -639,7 +639,7 @@ struct ib_event_handler {
>>  struct ib_global_route {
>>       union ib_gid    dgid;
>>       u32             flow_label;
>> -     u8              sgid_index;
>> +     u16             sgid_index;
>>       u8              hop_limit;
>>       u8              traffic_class;
>>  };
>> @@ -3612,7 +3612,7 @@ static inline void rdma_ah_set_interface_id(struct rdma_ah_attr *attr,
>>
>>  static inline void rdma_ah_set_grh(struct rdma_ah_attr *attr,
>>                                  union ib_gid *dgid, u32 flow_label,
>> -                                u8 sgid_index, u8 hop_limit,
>> +                                u16 sgid_index, u8 hop_limit,
>>                                  u8 traffic_class)
>>  {
>>       struct ib_global_route *grh = rdma_ah_retrieve_grh(attr);
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
