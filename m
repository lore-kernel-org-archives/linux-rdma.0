From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Tue, 23 Jan 2018 11:25:55 +0800
Message-ID: <f577e24f-e718-9047-8ae3-6ce7fcb9ec18@oracle.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <339a7156-9ef1-1f3c-30b8-3cc3558d124e@mellanox.com>
 <1516552998.3478.5.camel@gmail.com>
 <460fca68-f8a8-e3c4-2e60-e90dc0e2f843@oracle.com>
 <20180122154734.GD14372@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180122154734.GD14372@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Tariq Toukan <tariqt@mellanox.com>, junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Jason

Thanks for your kindly response.

On 01/22/2018 11:47 PM, Jason Gunthorpe wrote:
>>> Yeah, mlx4 NICs in Google fleet receive trillions of packets per
>>> second, and we never noticed an issue.
>>>
>>> Although we are using a slightly different driver, using order-0 pages
>>> and fast pages recycling.
>>>
>>>
>> The driver we use will will set the page reference count to (size of pages)/stride, the
>> pages will be freed by networking stack when the reference become zero, and the order-3
>> pages maybe allocated soon, this give NIC device a chance to corrupt the pages which have
>>  been allocated by others, such as slab.
> But it looks like the wmb() is placed when stuffing new rx descriptors
> into the device - how can it prevent corruption of pages where
> ownership was transfered from device to the host? That sounds more like a
> rmb() is missing someplace to me...
> 
The device may see the prod_db updating before rx_desc updating.
Then it will get stale rx_descs.
These stale rx_descs may contain pages that has been freed to host.
 

> (Granted the missing wmb() is a bug, but it may not be fully solving this
>  issue??)the wmb() here fix one of the customer's test case.

Thanks
Jianchao
