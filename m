From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH V2] mlx4_core: allocate ICM memory in page size chunks
Date: Tue, 15 May 2018 11:53:29 -0700
Message-ID: <f4c5d8d3-1eea-8566-9921-a9dc48435f66@oracle.com>
References: <20180511192318.22342-1-qing.huang@oracle.com>
 <2797ac27-022c-0818-388c-e4a6131ad1ca@gmail.com>
 <ff9c44ca-eaae-cb3e-4c69-e9e3cbb72ca1@oracle.com>
 <1ded7d49-0ba2-3594-f840-74d7cf37a0eb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1ded7d49-0ba2-3594-f840-74d7cf37a0eb@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, davem@davemloft.net, haakon.bugge@oracle.com, yanjun.zhu@oracle.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 5/15/2018 2:19 AM, Tariq Toukan wrote:
>
>
> On 14/05/2018 7:41 PM, Qing Huang wrote:
>>
>>
>> On 5/13/2018 2:00 AM, Tariq Toukan wrote:
>>>
>>>
>>> On 11/05/2018 10:23 PM, Qing Huang wrote:
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
>>>> With 4KB ICM chunk size on x86_64 arch, the above issue is fixed.
>>>>
>>>> However in order to support smaller ICM chunk size, we need to fix
>>>> another issue in large size kcalloc allocations.
>>>>
>>>> E.g.
>>>> Setting log_num_mtt=30 requires 1G mtt entries. With the 4KB ICM chunk
>>>> size, each ICM chunk can only hold 512 mtt entries (8 bytes for 
>>>> each mtt
>>>> entry). So we need a 16MB allocation for a table->icm pointer array to
>>>> hold 2M pointers which can easily cause kcalloc to fail.
>>>>
>>>> The solution is to use vzalloc to replace kcalloc. There is no need
>>>> for contiguous memory pages for a driver meta data structure (no need
>>>> of DMA ops).
>>>>
>>>> Signed-off-by: Qing Huang <qing.huang@oracle.com>
>>>> Acked-by: Daniel Jurgens <danielj@mellanox.com>
>>>> Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>>>> ---
>>>> v2 -> v1: adjusted chunk size to reflect different architectures.
>>>>
>>>>   drivers/net/ethernet/mellanox/mlx4/icm.c | 14 +++++++-------
>>>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c 
>>>> b/drivers/net/ethernet/mellanox/mlx4/icm.c
>>>> index a822f7a..ccb62b8 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx4/icm.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
>>>> @@ -43,12 +43,12 @@
>>>>   #include "fw.h"
>>>>     /*
>>>> - * We allocate in as big chunks as we can, up to a maximum of 256 KB
>>>> - * per chunk.
>>>> + * We allocate in page size (default 4KB on many archs) chunks to 
>>>> avoid high
>>>> + * order memory allocations in fragmented/high usage memory 
>>>> situation.
>>>>    */
>>>>   enum {
>>>> -    MLX4_ICM_ALLOC_SIZE    = 1 << 18,
>>>> -    MLX4_TABLE_CHUNK_SIZE    = 1 << 18
>>>> +    MLX4_ICM_ALLOC_SIZE    = 1 << PAGE_SHIFT,
>>>> +    MLX4_TABLE_CHUNK_SIZE    = 1 << PAGE_SHIFT
>>>
>>> Which is actually PAGE_SIZE.
>>
>> Yes, we wanted to avoid high order memory allocations.
>>
>
> Then please use PAGE_SIZE instead.

PAGE_SIZE is usually defined as 1 << PAGE_SHIFT. So I think PAGE_SHIFT 
is actually more appropriate here.


>
>>> Also, please add a comma at the end of the last entry.
>>
>> Hmm..., followed the existing code style and checkpatch.pl didn't 
>> complain about the comma.
>>
>
> I am in favor of having a comma also after the last element, so that 
> when another enum element is added we do not modify this line again, 
> which would falsely affect git blame.
>
> I know it didn't exist before your patch, but once we're here, let's 
> do it.

I'm okay either way. If adding an extra comma is preferred by many 
people, someone should update checkpatch.pl to enforce it. :)

>
>>>
>>>>   };
>>>>     static void mlx4_free_icm_pages(struct mlx4_dev *dev, struct 
>>>> mlx4_icm_chunk *chunk)
>>>> @@ -400,7 +400,7 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, 
>>>> struct mlx4_icm_table *table,
>>>>       obj_per_chunk = MLX4_TABLE_CHUNK_SIZE / obj_size;
>>>>       num_icm = (nobj + obj_per_chunk - 1) / obj_per_chunk;
>>>>   -    table->icm      = kcalloc(num_icm, sizeof(*table->icm), 
>>>> GFP_KERNEL);
>>>> +    table->icm      = vzalloc(num_icm * sizeof(*table->icm));
>>>
>>> Why not kvzalloc ?
>>
>> I think table->icm pointer array doesn't really need physically 
>> contiguous memory. Sometimes high order
>> memory allocation by kmalloc variants may trigger slow path and cause 
>> tasks to be blocked.
>>
>
> This is control path so it is less latency-sensitive.
> Let's not produce unnecessary degradation here, please call kvzalloc 
> so we maintain a similar behavior when contiguous memory is available, 
> and a fallback for resiliency.

No sure what exactly degradation is caused by vzalloc here. I think it's 
better to keep physically contiguous pages
to other requests which really need them. Besides slow path/mem 
compacting can be really expensive.

>
>> Thanks,
>> Qing
>>
>>>
>>>>       if (!table->icm)
>>>>           return -ENOMEM;
>>>>       table->virt     = virt;
>>>> @@ -446,7 +446,7 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, 
>>>> struct mlx4_icm_table *table,
>>>>               mlx4_free_icm(dev, table->icm[i], use_coherent);
>>>>           }
>>>>   -    kfree(table->icm);
>>>> +    vfree(table->icm);
>>>>         return -ENOMEM;
>>>>   }
>>>> @@ -462,5 +462,5 @@ void mlx4_cleanup_icm_table(struct mlx4_dev 
>>>> *dev, struct mlx4_icm_table *table)
>>>>               mlx4_free_icm(dev, table->icm[i], table->coherent);
>>>>           }
>>>>   -    kfree(table->icm);
>>>> +    vfree(table->icm);
>>>>   }
>>>>
>>>
>>> Thanks for your patch.
>>>
>>> I need to verify there is no dramatic performance degradation here.
>>> You can prepare and send a v3 in the meanwhile.
>>>
>>> Thanks,
>>> Tariq
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-rdma" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
