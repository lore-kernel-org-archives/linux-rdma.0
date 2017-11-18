From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/3] nvmet-rdma: SRQ per completion vector
Date: Sat, 18 Nov 2017 15:57:15 +0200
Message-ID: <935af437-d69e-e258-c00a-8bf9a04f9988@mellanox.com>
References: <1510852885-25519-1-git-send-email-maxg@mellanox.com>
 <263c6c9d-0dd2-da4f-12a9-efefd361e592@grimberg.me>
 <a8e2be0b-deb7-8cc1-92ce-fc5dea3e241a@mellanox.com>
 <20171118125229.GT18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171118125229.GT18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 11/18/2017 2:52 PM, Leon Romanovsky wrote:
> On Fri, Nov 17, 2017 at 09:32:42PM +0200, Max Gurtovoy wrote:
>>
>>
>> On 11/16/2017 8:36 PM, Sagi Grimberg wrote:
>>>
>>>> Since there is an active discussion regarding the CQ pool
>>>> architecture, I decided to push
>>>> this feature (maybe it can be pushed before CQ pool).
>>>>
>>>> This is a new feature for NVMEoF RDMA target,
>>>
>>> Any chance having this for the rest? isert, srpt, svcrdma?
>>>
>>
>> We can implement it for isert, but I think it's better to see how the CQ
>> pool will be defined first.
>> It can bring a big benefit and improvement for ib_srpt (similar to NVMEoF
>> target) but I'm not sure if I can commit for that one soon..
> 
> Too bad, but I don't see inclusion of generic SRQ pool code in RDMA
> subsystem without actual conversion of existing ULP clients.
> 
> Thanks
> 

This patchset adds this feature to NVMEoF target so actually there are 
ULPs that use it. Same issue we have with mr_pool that only RDMA rw.c 
use it (Now we're adding it to NVMEoF initiators too - in review).
I can add srq_pool to iSER target code but I don't want to re-write it 
again in few weeks, when the CQ pool will be added.
Regarding other ULPs, we don't have a testing environment for them so I 
prefer not to commit on their implementation in the near future.

I don't know why we can't add this feature "as is".
Other ULPs maintainers might use it once it will be pushed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
