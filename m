From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 06/31] IB/ipoib: Avoid memory leak if neigh
 destination was changed
Date: Thu, 16 Nov 2017 18:28:42 +0100
Message-ID: <3321F53B-3534-4433-B627-80959DEA1850@oracle.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-7-leon@kernel.org> <20171115001510.GG25894@ziepe.ca>
 <CAAk-MO-QQj3_H2CZuCCOCU51tWwdCfkvhh-Q3LqrKM=Su2Q+Kg@mail.gmail.com>
 <20171115153946.GP25894@ziepe.ca>
 <CAAk-MO-nMs-+RtK_QOxPzq7uCA9hpG30ho52v4CSRPZ6769=1Q@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO-nMs-+RtK_QOxPzq7uCA9hpG30ho52v4CSRPZ6769=1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On 16 Nov 2017, at 09:30, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> On Wed, Nov 15, 2017 at 5:39 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>> On Wed, Nov 15, 2017 at 09:01:07AM +0200, Erez Shitrit wrote:
>>>>>      if (!IS_ERR_OR_NULL(ah)) {
>>>>> +             /* check there is no mismatch from the request */
>>>>> +             if (memcmp(pathrec->dgid.raw, path->pathrec.dgid.raw,
>>>>> +                        sizeof(union ib_gid))) {
>>>>> +                     pr_warn("%s got PathRec for gid %pI6 while asked for %pI6\n",
>>>>> +                             dev->name, pathrec->dgid.raw, path->pathrec.dgid.raw);
>>>>> +                     /* overwrite the response from the sm  before copy to the db */
>>>>> +                     memcpy(pathrec->dgid.raw, path->pathrec.dgid.raw,
>>>>> +                            sizeof(union ib_gid));
>>>> 
>>>> This doesn't seem like it should be a warning, and replacing the
>>>> good DGID from the SA with local garbage seems really wrong.
>>> 
>>> IPoIB is L2 driver and should act as a pipe and cannot add its opinion
>>> about what is a good or a garbage GID.
>> 
>> Which is why ipoib should not override the result from the SA.
> 
> It override only the DGID in the record, and that for IPoIB uses only,
> not the ah which is the important.
> otherwise if the host will re-ask again for that DGID it will not be
> found in IPoIB database, and new record will be created and so on till
> the end of all the device memory.

Isn’t the correct solution to mask away the 16-bit subnet prefix when looking up a unicast DGID in the database?


Thxs, Håkon

> 
>> 
>> It needs to work in a way where it looks up a DGID from the LLADDR and
>> gets back a wire GRH and LRH which come from SA.
> 
> For that there is the ah object, this object is used as it came from the SA.
> 
>> 
>>> If the host is asking for specific mac address, IPoIB should return
>>> the response for the original request/mac and should not decide what
>>> is good for the host.
>> 
>> No, it is up to the SA to return the GRH to put in the packets, it
>> should never be changed in any way by a ULP.
> 
> The change is only for the ULP, the user/host has no idea of that, and
> it gets the same ah that came from the SA.
> 
>> 
>> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
