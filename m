From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH] mlx4_core: allocate 4KB ICM chunks
Date: Fri, 11 May 2018 12:16:19 -0700
Message-ID: <c94909ea-ffed-88e1-88a5-ad8b586b768e@oracle.com>
References: <20180510233143.7236-1-qing.huang@oracle.com>
 <5ABF1B88-882E-4575-8E8C-41F0452FECC1@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5ABF1B88-882E-4575-8E8C-41F0452FECC1@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>
Cc: tariqt@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 5/11/2018 3:27 AM, Håkon Bugge wrote:
>> On 11 May 2018, at 01:31, Qing Huang<qing.huang@oracle.com>  wrote:
>>
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
>> With 4KB ICM chunk size, the above issue is fixed.
>>
>> However in order to support 4KB ICM chunk size, we need to fix another
>> issue in large size kcalloc allocations.
>>
>> E.g.
>> Setting log_num_mtt=30 requires 1G mtt entries. With the 4KB ICM chunk
>> size, each ICM chunk can only hold 512 mtt entries (8 bytes for each mtt
>> entry). So we need a 16MB allocation for a table->icm pointer array to
>> hold 2M pointers which can easily cause kcalloc to fail.
>>
>> The solution is to use vzalloc to replace kcalloc. There is no need
>> for contiguous memory pages for a driver meta data structure (no need
>> of DMA ops).
>>
>> Signed-off-by: Qing Huang<qing.huang@oracle.com>
>> Acked-by: Daniel Jurgens<danielj@mellanox.com>
>> ---
>> drivers/net/ethernet/mellanox/mlx4/icm.c | 14 +++++++-------
>> 1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
>> index a822f7a..2b17a4b 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/icm.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
>> @@ -43,12 +43,12 @@
>> #include "fw.h"
>>
>> /*
>> - * We allocate in as big chunks as we can, up to a maximum of 256 KB
>> - * per chunk.
>> + * We allocate in 4KB page size chunks to avoid high order memory
>> + * allocations in fragmented/high usage memory situation.
>>   */
>> enum {
>> -	MLX4_ICM_ALLOC_SIZE	= 1 << 18,
>> -	MLX4_TABLE_CHUNK_SIZE	= 1 << 18
>> +	MLX4_ICM_ALLOC_SIZE	= 1 << 12,
>> +	MLX4_TABLE_CHUNK_SIZE	= 1 << 12
> Shouldn’t these be the arch’s page size order? E.g., if running on SPARC, the hw page size is 8KiB.

Good point on supporting wider range of architectures. I got tunnel 
vision when fixing this on our x64 lab machines.
Will send an v2 patch.

Thanks,
Qing

> Thxs, Håkon
>
>> };
>>
>> static void mlx4_free_icm_pages(struct mlx4_dev *dev, struct mlx4_icm_chunk *chunk)
>> @@ -400,7 +400,7 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
>> 	obj_per_chunk = MLX4_TABLE_CHUNK_SIZE / obj_size;
>> 	num_icm = (nobj + obj_per_chunk - 1) / obj_per_chunk;
>>
>> -	table->icm      = kcalloc(num_icm, sizeof(*table->icm), GFP_KERNEL);
>> +	table->icm      = vzalloc(num_icm * sizeof(*table->icm));
>> 	if (!table->icm)
>> 		return -ENOMEM;
>> 	table->virt     = virt;
>> @@ -446,7 +446,7 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table,
>> 			mlx4_free_icm(dev, table->icm[i], use_coherent);
>> 		}
>>
>> -	kfree(table->icm);
>> +	vfree(table->icm);
>>
>> 	return -ENOMEM;
>> }
>> @@ -462,5 +462,5 @@ void mlx4_cleanup_icm_table(struct mlx4_dev *dev, struct mlx4_icm_table *table)
>> 			mlx4_free_icm(dev, table->icm[i], table->coherent);
>> 		}
>>
>> -	kfree(table->icm);
>> +	vfree(table->icm);
>> }
>> -- 
>> 2.9.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
