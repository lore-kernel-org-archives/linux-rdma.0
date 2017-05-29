From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Mon, 29 May 2017 15:21:11 +0300
Message-ID: <89409b6d-466d-070a-7082-1f7bbb9ad7c7@mellanox.com>
References: <1495957991-19223-1-git-send-email-maxg@mellanox.com>
 <1495957991-19223-2-git-send-email-maxg@mellanox.com>
 <20170528090705.GM13083@lst.de>
 <19a1d347-91da-7e5f-8877-86772204a80a@mellanox.com>
 <20170529100504.GZ17751@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170529100504.GZ17751-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 5/29/2017 1:05 PM, Leon Romanovsky wrote:
> On Sun, May 28, 2017 at 12:53:00PM +0300, Max Gurtovoy wrote:
>>
>>
>> On 5/28/2017 12:07 PM, Christoph Hellwig wrote:
>>> On Sun, May 28, 2017 at 10:53:11AM +0300, Max Gurtovoy wrote:
>>>> Cache the needed umr_fence and set the wqe ctrl segmennt
>>>> accordingly.
>>>
>>> Looks good,
>>>
>>> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>>
>> Thanks.
>>
>>>
>>> But that whole fence logic looks awkward to me.  Does the following
>>> patch to reorder it make sense to you?
>>>
>>
>>
>> Yes it make sense to me.
>> Sagi/Leon, any comments ?
>
> Max,
>
> Do you see any performance impact for IB_WR_RDMA_READ, IB_WR_RDMA_WRITE
> and IB_WR_RDMA_WRITE_WITH_IMM flows? They don't need fences and such
> change can cause to performance losses.
>
> Thanks
>

We don't fence those WR's.
Christoph just re-write it to be more intuitive code. I don't see logic 
difference, am I wrong here ?

>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
