From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v6 for-4.13 0/7] Automatic affinity settings for nvme over
 rdma
Date: Thu, 3 Aug 2017 18:22:29 +0300
Message-ID: <2eecc5bb-e356-73e5-a2fc-1f1867a779f3@grimberg.me>
References: <1497796677-15794-1-git-send-email-sagi@grimberg.me>
 <20170619122806.GA29061@lst.de> <20170626100113.GA14446@lst.de>
 <7a91bc31-9a4d-a07c-002d-af06143c4257@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7a91bc31-9a4d-a07c-002d-af06143c4257-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Doug,

>>> Thanks Sagi,
>>>
>>> the whole series looks great to me.
>>>
>>> It would be even nicer if the maintainers of the various HCA drivers
>>> could look into adding support..
>>
>> Did we make any progress on getting this included?
> 
> AFAICT, its waiting for Doug to pick it up...
> 
> Not sure if Saeed is planning to run any tests on this,
> but its clearly agreed that this is the direction all parties
> want to take, and we have 6-9 rc's to hash out any issues if
> exist...
> 
>> It would be sad to miss another merge window..
> 
> I hope we don't...

Are you picking this up for 4.14? This already missed two merge
windows..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
