From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH v3] mlx4_core: allocate ICM memory in page size chunks
Date: Tue, 22 May 2018 18:41:39 -0700
Message-ID: <4b7a4f67-2c08-a60d-81cd-f12db42622ec@oracle.com>
References: <20180517205343.8401-1-qing.huang@oracle.com>
 <e6c470f0-f2ae-5efd-09ed-0c9562a4a764@gmail.com>
 <19b7818e-16f6-2349-dc34-245c2f215f6f@oracle.com>
 <35ba0f14-7b24-96ff-6b2d-610a4b2980c2@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <35ba0f14-7b24-96ff-6b2d-610a4b2980c2@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net, haakon.bugge@oracle.com, yanjun.zhu@oracle.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gi-oh.kim@profitbricks.com
List-Id: linux-rdma@vger.kernel.org



On 5/22/2018 8:33 AM, Tariq Toukan wrote:
>
>
> On 18/05/2018 12:45 AM, Qing Huang wrote:
>>
>>
>> On 5/17/2018 2:14 PM, Eric Dumazet wrote:
>>> On 05/17/2018 01:53 PM, Qing Huang wrote:
>>>> When a system is under memory presure (high usage with fragments),
>>>> the original 256KB ICM chunk allocations will likely trigger kernel
>>>> memory management to enter slow path doing memory compact/migration
>>>> ops in order to complete high order memory allocations.
>>>>
>>>> When that happens, user processes calling uverb APIs may get stuck
>>>> for more than 120s easily even though there are a lot of free pages
>>>> in smaller chunks available in the system.
>>>>
>>>> Syslog:
>>>> ...
>>>> Dec 10 09:04:51 slcc03db02 kernel: [397078.572732] INFO: task
>>>> oracle_205573_e:205573 blocked for more than 120 seconds.
>>>> ...
>>>>
>>> NACK on this patch.
>>>
>>> You have been asked repeatedly to use kvmalloc()
>>>
>>> This is not a minor suggestion.
>>>
>>> Take a look 
>>> athttps://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d8c13f2271ec5178c52fbde072ec7b562651ed9d 
>>>
>>
>> Would you please take a look at how table->icm is being used in the 
>> mlx4 driver? It's a meta data used for individual pointer variable 
>> referencing,
>> not as data frag or in/out buffer. It has no need for contiguous phy. 
>> memory.
>>
>> Thanks.
>>
>
> NACK.
>
> This would cause a degradation when iterating the entries of table->icm.
> For example, in mlx4_table_get_range.
E.g.
int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
                          u32 start, u32 end)
{
         int inc = MLX4_TABLE_CHUNK_SIZE / table->obj_size;
         int err;
         u32 i;

         for (i = start; i <= end; i += inc) {
                 err = mlx4_table_get(dev, table, i);
                 if (err)
                         goto fail;
         }

         return 0;
...
}

E.g. mtt obj is 8 bytes, so a 4KB ICM block would have 512 mtt objects. 
So you will have to allocate
more 512 mtt objects in order to have table->icm pointer to increment by 
1 to fetch next pointer
value.  So 256K mtt objects are needed in order to traverse table->icm 
pointer across a page boundary
in the call stacks.

Considering mlx4_table_get_range() is only used in control path, there 
is no significant gain by using kvzalloc
vs. vzalloc for table->icm.

Anyway, if a user makes sure mlx4 driver to be loaded very early and 
doesn't remove and reload it afterwards,
we should have enough (and not wasting) contiguous phy mem for 
table->icm allocation. I will use kvzalloc to
replace vzalloc and send a V4 patch.

Thanks,
Qing


>
> Thanks,
> Tariq
>
>>> And you'll understand some people care about this.
>>>
>>> Strongly.
>>>
>>> Thanks.
>>>
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
