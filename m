From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] RDMA/hns: Support rq record doorbell for
 kernel space
Date: Thu, 25 Jan 2018 20:57:36 +0800
Message-ID: <443225ea-5a6a-5d7f-8136-b061e087f271@huawei.com>
References: <1516242871-154089-1-git-send-email-liuyixian@huawei.com>
 <1516242871-154089-4-git-send-email-liuyixian@huawei.com>
 <20180123110740.GR1393@mtr-leonro.local>
 <c5cfd489-e589-1d01-ef7a-718d3dc6d4e5@huawei.com>
 <20180124132139.GK1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180124132139.GK1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2018/1/24 21:21, Leon Romanovsky wrote:
> On Wed, Jan 24, 2018 at 08:40:42PM +0800, Liuyixian (Eason) wrote:
>>
>>
>> On 2018/1/23 19:07, Leon Romanovsky wrote:
>>> On Thu, Jan 18, 2018 at 10:34:30AM +0800, Yixian Liu wrote:
>>>> This patch updates to support rq record doorbell for
>>>> the kernel space.
>>>>
>>>> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>  drivers/infiniband/hw/hns/hns_roce_db.c     | 112 ++++++++++++++++++++++++++++
>>>>  drivers/infiniband/hw/hns/hns_roce_device.h |   6 ++
>>>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  15 +---
>>>>  drivers/infiniband/hw/hns/hns_roce_main.c   |   5 ++
>>>>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  18 ++++-
>>>>  5 files changed, 143 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_db.c b/drivers/infiniband/hw/hns/hns_roce_db.c
>>>> index 0908208..de3fa94 100644
>>>> --- a/drivers/infiniband/hw/hns/hns_roce_db.c
>>>> +++ b/drivers/infiniband/hw/hns/hns_roce_db.c
>>>> @@ -92,3 +92,115 @@ void hns_roce_db_unmap_user(struct hns_roce_ucontext *context,
>>>>  	mutex_unlock(&context->db_page_mutex);
>>>>  }
>>>>  EXPORT_SYMBOL(hns_roce_db_unmap_user);
>>>> +
>>>> +static struct hns_roce_db_pgdir *hns_roce_alloc_db_pgdir(
>>>> +					struct device *dma_device, gfp_t gfp)
>>>> +{
>>>> +	struct hns_roce_db_pgdir *pgdir;
>>>> +
>>>> +	pgdir = kzalloc(sizeof(*pgdir), gfp);
>>>> +	if (!pgdir)
>>>> +		return NULL;
>>>> +
>>>> +	bitmap_fill(pgdir->order1, HNS_ROCE_DB_PER_PAGE / 2);
>>>> +	pgdir->bits[0] = pgdir->order0;
>>>
>>> order0? isn't it equal to zero?
>>>
>>
>> No. Here order0 is the name of a bitmap array and bits[0] points to it.
> 
> pgdir was allocated with kzalloc() -> all fields are zero ->
> pgdir->order0 == 0 or pgdir->order0 == NULL -> What is the point in such
> assignment?

The definition of hns_roce_db_pgdir is in patch [1/4] as following:

	struct hns_roce_db_pgdir {
		struct list_head	list;
		DECLARE_BITMAP(order0, HNS_ROCE_DB_PER_PAGE);
		DECLARE_BITMAP(order1, HNS_ROCE_DB_PER_PAGE / 2);
		unsigned long		*bits[2];
		u32			*db_page;
		dma_addr_t		db_dma;
	};

and,

	#define DECLARE_BITMAP(name,bits) \
		unsigned long name[BITS_TO_LONGS(bits)]

Therefore, pgdir->order0 is the base address of an array, not NULL.

Thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
