From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH V2] mlx4_core: allocate ICM memory in page size chunks
Date: Tue, 15 May 2018 12:45:30 -0700
Message-ID: <094279df-93c2-b06e-9f48-11be5cd78b69@oracle.com>
References: <20180511192318.22342-1-qing.huang@oracle.com>
 <2797ac27-022c-0818-388c-e4a6131ad1ca@gmail.com>
 <ff9c44ca-eaae-cb3e-4c69-e9e3cbb72ca1@oracle.com>
 <1ded7d49-0ba2-3594-f840-74d7cf37a0eb@mellanox.com>
 <f4c5d8d3-1eea-8566-9921-a9dc48435f66@oracle.com>
 <f71278c2-a111-1bf6-2ff3-d9a8dd46bfbe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f71278c2-a111-1bf6-2ff3-d9a8dd46bfbe@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>, Tariq Toukan <tariqt@mellanox.com>, davem@davemloft.net, haakon.bugge@oracle.com, yanjun.zhu@oracle.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 5/15/2018 12:08 PM, Eric Dumazet wrote:
>
> On 05/15/2018 11:53 AM, Qing Huang wrote:
>>> This is control path so it is less latency-sensitive.
>>> Let's not produce unnecessary degradation here, please call kvzalloc so we maintain a similar behavior when contiguous memory is available, and a fallback for resiliency.
>> No sure what exactly degradation is caused by vzalloc here. I think it's better to keep physically contiguous pages
>> to other requests which really need them. Besides slow path/mem compacting can be really expensive.
>>
> Just use kvzalloc(), and you get the benefit of having contiguous memory if available,
> without expensive compact phase.
>
> This thing _automatically_ falls back to vmalloc(), thus your problem will be solved.
>
> If you are not sure, trust others.

Thanks for the review. There are many places in kernel and applications 
where physically contiguous pages are needed.
We saw quite a few issues when there were not enough contiguous phy mem 
available. My main concern here is that why
using physically contiguous pages when they are not really needed?
