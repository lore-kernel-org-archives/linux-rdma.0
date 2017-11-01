From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: How far back does rdma-core X supports the kernel Y?
Date: Wed, 1 Nov 2017 20:22:37 +0200
Message-ID: <3424c3a1-22cb-7330-81d6-0e1bf45ab755@dev.mellanox.co.il>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101163915.GB1030@ziepe.ca>
 <287a10c2-15a7-0748-c59e-3f084e7538f4@dev.mellanox.co.il>
 <20171101180001.GH1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101180001.GH1030-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/1/2017 8:00 PM, Jason Gunthorpe wrote:
>>>           if (attr_mask & ~((1ULL << (IBV_QP_DEST_QPN + 1)) - 1))
>>
>> The above rdma-core code is correct, look at verbs.h:
>> IBV_QP_DEST_QPN = 1 << 20,
> 
> Okay, then it should be
> 
>   if (attr_mask & ~(IB_QP_RATE_LIMIT - 1))
> 

Why the library should support values that were never exposed in verbs.h ?

In addition, running over latest few kernel with your suggestion will 
fail any way [1] as those bits are marked as RESERVED in IB core and 
aren't really supported.

[1]
http://elixir.free-electrons.com/linux/v4.14-rc7/source/drivers/infiniband/core/uverbs_cmd.c#L2041
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
