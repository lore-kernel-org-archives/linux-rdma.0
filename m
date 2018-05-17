From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH v3] mlx4_core: allocate ICM memory in page size chunks
Date: Thu, 17 May 2018 14:45:20 -0700
Message-ID: <19b7818e-16f6-2349-dc34-245c2f215f6f@oracle.com>
References: <20180517205343.8401-1-qing.huang@oracle.com>
 <e6c470f0-f2ae-5efd-09ed-0c9562a4a764@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e6c470f0-f2ae-5efd-09ed-0c9562a4a764@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>, tariqt@mellanox.com, davem@davemloft.net, haakon.bugge@oracle.com, yanjun.zhu@oracle.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gi-oh.kim@profitbricks.com
List-Id: linux-rdma@vger.kernel.org



On 5/17/2018 2:14 PM, Eric Dumazet wrote:
> On 05/17/2018 01:53 PM, Qing Huang wrote:
>> When a system is under memory presure (high usage with fragments),
>> the original 256KB ICM chunk allocations will likely trigger kernel
>> memory management to enter slow path doing memory compact/migration
>> ops in order to complete high order memory allocations.
>>
>> When that happens, user processes calling uverb APIs may get stuck
>> for more than 120s easily even though there are a lot of free pages
>> in smaller chunks available in the system.
>>
>> Syslog:
>> ...
>> Dec 10 09:04:51 slcc03db02 kernel: [397078.572732] INFO: task
>> oracle_205573_e:205573 blocked for more than 120 seconds.
>> ...
>>
> NACK on this patch.
>
> You have been asked repeatedly to use kvmalloc()
>
> This is not a minor suggestion.
>
> Take a look athttps://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d8c13f2271ec5178c52fbde072ec7b562651ed9d

Would you please take a look at how table->icm is being used in the mlx4 
driver? It's a meta data used for individual pointer variable referencing,
not as data frag or in/out buffer. It has no need for contiguous phy. 
memory.

Thanks.

> And you'll understand some people care about this.
>
> Strongly.
>
> Thanks.
>
