From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V3 01/11] IB/core: Add gid_type to gid attribute
Date: Wed, 23 Dec 2015 17:21:28 +0200
Message-ID: <CAAKD3BBipJ_2vr2=UYnUZhRqFhfp=23i+rG4FRx089cZ=6rTVQ@mail.gmail.com>
References: <1450875417-19262-1-git-send-email-matanb@mellanox.com>
	<1450875417-19262-2-git-send-email-matanb@mellanox.com>
	<20151223134053.GB3599@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151223134053.GB3599-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 23, 2015 at 3:40 PM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> On Wed, Dec 23, 2015 at 02:56:47PM +0200, Matan Barak wrote:
>> In order to support multiple GID types, we need to store the gid_type
>> with each GID. This is also aligned with the RoCE v2 annex "RoCEv2 PORT
>> GID table entries shall have a "GID type" attribute that denotes the L3
>> Address type". The currently supported GID is IB_GID_TYPE_IB which is
>> also RoCE v1 GID type.
>>
>> This implies that gid_type should be added to roce_gid_table meta-data.
>>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/core/cache.c           |  144 +++++++++++++++++++---------
>>  drivers/infiniband/core/cm.c              |    2 +-
>>  drivers/infiniband/core/cma.c             |    3 +-
>>  drivers/infiniband/core/core_priv.h       |    4 +
>>  drivers/infiniband/core/device.c          |    9 ++-
>>  drivers/infiniband/core/multicast.c       |    2 +-
>>  drivers/infiniband/core/roce_gid_mgmt.c   |   60 ++++++++++--
>>  drivers/infiniband/core/sa_query.c        |    5 +-
>>  drivers/infiniband/core/uverbs_marshall.c |    1 +
>>  drivers/infiniband/core/verbs.c           |    1 +
>>  include/rdma/ib_cache.h                   |    4 +
>>  include/rdma/ib_sa.h                      |    1 +
>>  include/rdma/ib_verbs.h                   |   11 ++-
>>  13 files changed, 185 insertions(+), 62 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
>> index 097e9df..566fd8f 100644
>> --- a/drivers/infiniband/core/cache.c
>> +++ b/drivers/infiniband/core/cache.c
>> @@ -64,6 +64,7 @@ enum gid_attr_find_mask {
>>       GID_ATTR_FIND_MASK_GID          = 1UL << 0,
>>       GID_ATTR_FIND_MASK_NETDEV       = 1UL << 1,
>>       GID_ATTR_FIND_MASK_DEFAULT      = 1UL << 2,
>> +     GID_ATTR_FIND_MASK_GID_TYPE     = 1UL << 3,
>>  };
>>
>>  enum gid_table_entry_props {
>> @@ -125,6 +126,19 @@ static void dispatch_gid_change_event(struct ib_device *ib_dev, u8 port)
>>       }
>>  }
>>
>> +static const char * const gid_type_str[] = {
>                    ^^ ^^
> IMHO, The white spaces can be a little bit confusing to understand.
>

Pay attention to the double const - I think it's more clear that way.

>> +     [IB_GID_TYPE_IB]        = "IB/RoCE v1",
>> +};
>> +
>> +const char *ib_cache_gid_type_str(enum ib_gid_type gid_type)
>> +{
>> +     if (gid_type < ARRAY_SIZE(gid_type_str) && gid_type_str[gid_type])
> Why do you need to check second condition?

If we want to leave a gap for an invalid GID type, we could do that.
Anyway, we could remove this as an incremental future patch if that's
really important.

>> +             return gid_type_str[gid_type];
>> +
>> +     return "Invalid GID type";
>> +}
>> +EXPORT_SYMBOL(ib_cache_gid_type_str);
>> +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
