From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] libhns: Support cq record doorbell
Date: Tue, 23 Jan 2018 20:38:34 +0800
Message-ID: <7abe5a89-78ab-d015-b4b9-592a5e68ed56@huawei.com>
References: <1516242961-154453-1-git-send-email-liuyixian@huawei.com>
 <1516242961-154453-3-git-send-email-liuyixian@huawei.com>
 <20180118043717.GC8414@ziepe.ca>
 <9e577314-4fcb-45de-6909-d5b3be570196@huawei.com>
 <20180118161949.GA18973@ziepe.ca>
 <a33a1337-665f-4cd4-5b39-b12d9f03af72@huawei.com>
 <20180119200029.GD3437@ziepe.ca>
 <68e02f2a-0474-bc73-a784-fd52dbbde552@huawei.com>
 <20180121065727.GF1393@mtr-leonro.local>
 <1d95b4da-1cb8-e1ef-9c0e-4ac70a848d38@huawei.com>
 <20180122151307.GK1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122151307.GK1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2018/1/22 23:13, Leon Romanovsky wrote:
> On Mon, Jan 22, 2018 at 10:01:32PM +0800, Liuyixian (Eason) wrote:
>>
>>
>> On 2018/1/21 14:57, Leon Romanovsky wrote:
>>> On Sat, Jan 20, 2018 at 07:41:03PM +0800, Liuyixian (Eason) wrote:
>>>>
>>>
>>> <...>
>>>>
>>>> With carefully release-management, there would be no compatibility problem
>>>> both for hip06 and hip08.
>>>
>>> Sorry, for interrupting your discussion, but what does it mean "carefully
>>> release-management"?
>>>
>>> Thanks
>>>
>>
>> Hi Leon,
>>
>> Here release-management mainly means that our driver (kernel and userspace)
>> for hisilicon SoC is released progressively with linux kernel versions. Take
>> hip08 for example, our first version Roce driver for hip08 appear in linux
>> kernel 4.14, as more and more features are added in, some features may be
>> supported only in 4.16. I call this process as a release-management for
>> hisilicon SoC.
> 
> Are you aware that rdma-core and kernel are independent and can be
> installed in any combinations of old/new kernel/library mix?
> 
> Thanks
> 
Hi Leon,

Yes, I have already consider the mix case in my previous email responded to Jason.

The following table illustrates our compatibility cases.

+-----------------------+-------------------------------+
|			|	rdma-core release	|
|			+-------------------------------+
|			|   release 12	|   release 16	|
|			|     (old)	|     (new)	|
+-------+---------------+---------------+---------------+
| 	|     v4.9	|   compatible	| NOT compatible|
|kernel	|     (old)	|    (hip06)	|    (hip06)	|
|version|---------------+---------------+---------------+
|	|     v4.14	|   compatible	|  compatible	|
|	|     (new)	|    (hip06)	| (hip06/hip08)	|
+-------+---------------+---------------+---------------+

The above table illustrates that old/new kernel supports old rdma-core,
while the new rdma-core needs to update the kernel (driver) to new version.

I think this release-management strategy is reasonable.	What's your opinion?

Eason



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
