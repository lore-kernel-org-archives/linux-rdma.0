From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH] ib/core: not to set page dirty bit if it's already set.
Date: Mon, 22 May 2017 16:43:57 -0700
Message-ID: <9f4a4f90-a7b1-b1dc-6e7a-042f26254681@oracle.com>
References: <20170518233353.14370-1-qing.huang@oracle.com>
 <20170519130541.GA8017@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170519130541.GA8017@infradead.org>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, dledford@redhat.com, sean.hefty@intel.com, artemyko@mellanox.com, linux-mm@kvack.org
List-Id: linux-rdma@vger.kernel.org


On 5/19/2017 6:05 AM, Christoph Hellwig wrote:
> On Thu, May 18, 2017 at 04:33:53PM -0700, Qing Huang wrote:
>> This change will optimize kernel memory deregistration operations.
>> __ib_umem_release() used to call set_page_dirty_lock() against every
>> writable page in its memory region. Its purpose is to keep data
>> synced between CPU and DMA device when swapping happens after mem
>> deregistration ops. Now we choose not to set page dirty bit if it's
>> already set by kernel prior to calling __ib_umem_release(). This
>> reduces memory deregistration time by half or even more when we ran
>> application simulation test program.
> As far as I can tell this code doesn't even need set_page_dirty_lock
> and could just use set_page_dirty

It seems that set_page_dirty_lock has been used here for more than 10 
years. Don't know the original purpose. Maybe it was used to prevent 
races between setting dirty bits and swapping out pages?

Perhaps we can call set_page_dirty before calling ib_dma_unmap_sg?

>> Signed-off-by: Qing Huang<qing.huang@oracle.com>
>> ---
>>   drivers/infiniband/core/umem.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
>> index 3dbf811..21e60b1 100644
>> --- a/drivers/infiniband/core/umem.c
>> +++ b/drivers/infiniband/core/umem.c
>> @@ -58,7 +58,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
>>   	for_each_sg(umem->sg_head.sgl, sg, umem->npages, i) {
>>   
>>   		page = sg_page(sg);
>> -		if (umem->writable && dirty)
>> +		if (!PageDirty(page) && umem->writable && dirty)
>>   			set_page_dirty_lock(page);
>>   		put_page(page);
>>   	}
>> -- 
>> 2.9.3
>>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
