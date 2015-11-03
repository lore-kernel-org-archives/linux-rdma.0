From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 7/7] IB/srp: Avoid that mapping failure triggers an
 infinite loop
Date: Tue, 3 Nov 2015 11:12:48 -0800
Message-ID: <56390730.703@sandisk.com>
References: <562FF404.7000504@sandisk.com> <562FF4D9.2060809@sandisk.com>
 <5638F25D.703@dev.mellanox.co.il> <5639034D.8000905@sandisk.com>
 <5639040F.1040503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5639040F.1040503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/03/2015 10:59 AM, Sagi Grimberg wrote:
> On 03/11/2015 20:56, Bart Van Assche wrote:
>> On 11/03/2015 09:44 AM, Sagi Grimberg wrote:
>>> Can you spare a few words on this change in the change log?
>>>
>>>
>>>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>>>> ---
>>>>     drivers/infiniband/ulp/srp/ib_srp.c | 2 ++
>>>>     1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
>>>> b/drivers/infiniband/ulp/srp/ib_srp.c
>>>> index 47c3a72..59d3ff9 100644
>>>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>>>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>>>> @@ -1666,6 +1666,8 @@ map_complete:
>>>>
>>>>     unmap:
>>>>         srp_unmap_data(scmnd, ch, req, true);
>>>> +    if (ret == -ENOMEM && req->nmdesc >= target->mr_pool_size)
>>>> +        ret = -E2BIG;
>>>>         return ret;
>>>>     }
>>>
>>> Why return E2BIG for ENOMEM as well?
>>
>> Hello Sagi,
>>
>> The srp_queuecommand() function translates ENOMEM into QUEUE_FULL which
>> causes the SCSI mid-layer to retry the command. All other error codes
>> are translated into DID_ERROR which causes the SCSI command to fail.
>
> That's what I meant, ENOMEM is transient by nature. Why would you
> not want the scsi layer to requeue? I do understand this for the nmdesc
> condition but for the ENOMEM?

Hello Sagi,

Since the ret == -ENOMEM test is redundant in the above code that test 
can be left out. Would that make this patch more clear to you ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
