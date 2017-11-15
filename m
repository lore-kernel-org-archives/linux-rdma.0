From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next 06/31] IB/ipoib: Avoid memory leak if neigh
 destination was changed
Date: Wed, 15 Nov 2017 09:01:07 +0200
Message-ID: <CAAk-MO-QQj3_H2CZuCCOCU51tWwdCfkvhh-Q3LqrKM=Su2Q+Kg@mail.gmail.com>
References: <20171114125218.20477-1-leon@kernel.org> <20171114125218.20477-7-leon@kernel.org>
 <20171115001510.GG25894@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115001510.GG25894-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 2:15 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Tue, Nov 14, 2017 at 02:51:53PM +0200, Leon Romanovsky wrote:
>> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> If from some reason the SM responses to path query request with response
>> that doesn't contain the exact SGID, ipoib should warn and change that
>> part of the response before push it to the path record DB.
>> Otherwise, new record will be added to the path record DB with no access
>> to them from the ipoib.
>>
>> Demonstration of the bug is as the follow:
>> ipoib wants to send to GID fe80:0000:0000:0000:0002:c903:00ef:5ee2, it
>> creates new record in the DB with that gid as a key, and issues a new
>> request to the sm.
>> Now, the SM from some reason returns path-record with other SGID (for
>> example, fe80:0000:0000:0001:0002:c903:00ef:5ee2 that contains the local
>> subnet prefix) now ipoib will overwrite the current entry with the new
>> one, and if new request to the original GID arrives ipoib  will not find
>> it in the DB (was overwritten) and will create new record that in its
>> turn will also be overwritten by the response from the SM, and so on
>> till the driver eats all the device memory.
>>
>> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> index 12b7f911f0e5..b173d618c59c 100644
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>> @@ -775,6 +775,16 @@ static void path_rec_completion(int status,
>>       spin_lock_irqsave(&priv->lock, flags);
>>
>>       if (!IS_ERR_OR_NULL(ah)) {
>> +             /* check there is no mismatch from the request */
>> +             if (memcmp(pathrec->dgid.raw, path->pathrec.dgid.raw,
>> +                        sizeof(union ib_gid))) {
>> +                     pr_warn("%s got PathRec for gid %pI6 while asked for %pI6\n",
>> +                             dev->name, pathrec->dgid.raw, path->pathrec.dgid.raw);
>> +                     /* overwrite the response from the sm  before copy to the db */
>> +                     memcpy(pathrec->dgid.raw, path->pathrec.dgid.raw,
>> +                            sizeof(union ib_gid));
>
> This doesn't seem like it should be a warning, and replacing the
> good DGID from the SA with local garbage seems really wrong.

IPoIB is L2 driver and should act as a pipe and cannot add its opinion
about what is a good or a garbage GID.
If the host is asking for specific mac address, IPoIB should return
the response for the original request/mac and should not decide what
is good for the host.
This issue can happen from several issues, sm-bug or bad
configuration, i don't think IPoIB is the place to fix that.
So, what left for IPoIB is to protect itself from endless memory leak,
and this what the patch tries to do.

>
> The SA should be free to return a correct DGID, for instance by
> replacing a old or link local subnet prefix with the current value of
> the subnet prefix, or by returning a different gid index for the
> destination depending on mulitpath requirements.
>
> So the right thing to do here is to somehow make ipoib use the data
> from the SA.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
