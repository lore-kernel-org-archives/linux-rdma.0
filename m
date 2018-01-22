From: "jianchao.wang" <jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Mon, 22 Jan 2018 10:40:53 +0800
Message-ID: <460fca68-f8a8-e3c4-2e60-e90dc0e2f843@oracle.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <339a7156-9ef1-1f3c-30b8-3cc3558d124e@mellanox.com>
 <1516552998.3478.5.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516552998.3478.5.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eric

On 01/22/2018 12:43 AM, Eric Dumazet wrote:
> On Sun, 2018-01-21 at 18:24 +0200, Tariq Toukan wrote:
>>
>> On 21/01/2018 11:31 AM, Tariq Toukan wrote:
>>>
>>>
>>> On 19/01/2018 5:49 PM, Eric Dumazet wrote:
>>>> On Fri, 2018-01-19 at 23:16 +0800, jianchao.wang wrote:
>>>>> Hi Tariq
>>>>>
>>>>> Very sad that the crash was reproduced again after applied the patch.
>>
>> Memory barriers vary for different Archs, can you please share more 
>> details regarding arch and repro steps?
> 
> Yeah, mlx4 NICs in Google fleet receive trillions of packets per
> second, and we never noticed an issue.
> 
> Although we are using a slightly different driver, using order-0 pages
> and fast pages recycling.
> 
> 
The driver we use will will set the page reference count to (size of pages)/stride, the
pages will be freed by networking stack when the reference become zero, and the order-3
pages maybe allocated soon, this give NIC device a chance to corrupt the pages which have
 been allocated by others, such as slab.
In the current version with order-0 and page recycling, maybe the corruption occurred on
the inbound packets sometimes and just cause some bad and invalid packets which will be
dropped.

Thanks
Jianchao
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
