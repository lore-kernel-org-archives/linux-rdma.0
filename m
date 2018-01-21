From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Sun, 21 Jan 2018 11:31:30 +0200
Message-ID: <dfc02a48-7d2a-56da-dc4e-d90a9fcc559c@mellanox.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180112163247.GB15974@ziepe.ca> <1515775567.131759.42.camel@gmail.com>
 <a40e44f4-106b-1075-8f92-f7741508372c@oracle.com>
 <af562737-4a3e-0429-1fd6-fc25c3e3f867@mellanox.com>
 <fea0aa1c-b68e-9485-3826-2dfad7824911@oracle.com>
 <53b1ac4d-a294-eb98-149e-65d7954243da@oracle.com>
 <1516376999.3606.39.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516376999.3606.39.camel@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>, "jianchao.wang" <jianchao.w.wang@oracle.com>, Tariq Toukan <tariqt@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 19/01/2018 5:49 PM, Eric Dumazet wrote:
> On Fri, 2018-01-19 at 23:16 +0800, jianchao.wang wrote:
>> Hi Tariq
>>
>> Very sad that the crash was reproduced again after applied the patch.
>>
>> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>> @@ -252,6 +252,7 @@ static inline bool mlx4_en_is_ring_empty(struct mlx4_en_rx_ring *ring)
>>   
>>   static inline void mlx4_en_update_rx_prod_db(struct mlx4_en_rx_ring *ring)
>>   {
>> +	dma_wmb();
> 
> So... is wmb() here fixing the issue ?
> 
>>   	*ring->wqres.db.db = cpu_to_be32(ring->prod & 0xffff);
>>   }
>>
>> I analyzed the kdump, it should be a memory corruption.
>>
>> Thanks
>> Jianchao

Hmm, this is actually consistent with the example below [1].

AIU from the example, it seems that the dma_wmb/dma_rmb barriers are 
good for synchronizing cpu/device accesses to the "Streaming DMA mapped" 
buffers (the descriptors, went through the dma_map_page() API), but not 
for the doorbell (a coherent memory, typically allocated via 
dma_alloc_coherent) that requires using the stronger wmb() barrier.


[1] Documentation/memory-barriers.txt

  (*) dma_wmb();
  (*) dma_rmb();

      These are for use with consistent memory to guarantee the ordering
      of writes or reads of shared memory accessible to both the CPU and a
      DMA capable device.

      For example, consider a device driver that shares memory with a device
      and uses a descriptor status value to indicate if the descriptor 
belongs
      to the device or the CPU, and a doorbell to notify it when new
      descriptors are available:

	if (desc->status != DEVICE_OWN) {
		/* do not read data until we own descriptor */
		dma_rmb();

		/* read/modify data */
		read_data = desc->data;
		desc->data = write_data;

		/* flush modifications before status update */
		dma_wmb();

		/* assign ownership */
		desc->status = DEVICE_OWN;

		/* force memory to sync before notifying device via MMIO */
		wmb();

		/* notify device of new descriptors */
		writel(DESC_NOTIFY, doorbell);
	}

      The dma_rmb() allows us guarantee the device has released ownership
      before we read the data from the descriptor, and the dma_wmb() allows
      us to guarantee the data is written to the descriptor before the 
device
      can see it now has ownership.  The wmb() is needed to guarantee 
that the
      cache coherent memory writes have completed before attempting a 
write to
      the cache incoherent MMIO region.

      See Documentation/DMA-API.txt for more information on consistent 
memory.


>> On 01/15/2018 01:50 PM, jianchao.wang wrote:
>>> Hi Tariq
>>>
>>> Thanks for your kindly response.
>>>
>>> On 01/14/2018 05:47 PM, Tariq Toukan wrote:
>>>> Thanks Jianchao for your patch.
>>>>
>>>> And Thank you guys for your reviews, much appreciated.
>>>> I was off-work on Friday and Saturday.
>>>>
>>>> On 14/01/2018 4:40 AM, jianchao.wang wrote:
>>>>> Dear all
>>>>>
>>>>> Thanks for the kindly response and reviewing. That's really appreciated.
>>>>>
>>>>> On 01/13/2018 12:46 AM, Eric Dumazet wrote:
>>>>>>> Does this need to be dma_wmb(), and should it be in
>>>>>>> mlx4_en_update_rx_prod_db ?
>>>>>>>
>>>>>>
>>>>>> +1 on dma_wmb()
>>>>>>
>>>>>> On what architecture bug was observed ?
>>>>>
>>>>> This issue was observed on x86-64.
>>>>> And I will send a new patch, in which replace wmb() with dma_wmb(), to customer
>>>>> to confirm.
>>>>
>>>> +1 on dma_wmb, let us know once customer confirms.
>>>> Please place it within mlx4_en_update_rx_prod_db as suggested.
>>>
>>> Yes, I have recommended it to customer.
>>> Once I get the result, I will share it here.
>>>> All other calls to mlx4_en_update_rx_prod_db are in control/slow path so I prefer being on the safe side, and care less about bulking the barrier.
>>>>
>>>> Thanks,
>>>> Tariq
>>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
