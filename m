From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH rdma-next 2/5] RDMA/hns: Modify uar allocation algorithm
 to avoid bitmap exhaust
Date: Wed, 23 May 2018 15:12:45 +0800
Message-ID: <5B05146D.901@huawei.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-3-git-send-email-xavier.huwei@huawei.com>
 <20180523060515.GD2933@mtr-leonro.mtl.com> <5B050EFF.4040908@huawei.com>
 <20180523070055.GD5729@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523070055.GD5729@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org



On 2018/5/23 15:00, Leon Romanovsky wrote:
> On Wed, May 23, 2018 at 02:49:35PM +0800, Wei Hu (Xavier) wrote:
>>
>> On 2018/5/23 14:05, Leon Romanovsky wrote:
>>> On Thu, May 17, 2018 at 04:02:50PM +0800, Wei Hu (Xavier) wrote:
>>>> This patch modified uar allocation algorithm in hns_roce_uar_alloc
>>>> function to avoid bitmap exhaust.
>>>>
>>>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
>>>> ---
>>>>  drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
>>>>  drivers/infiniband/hw/hns/hns_roce_pd.c     | 10 ++++++----
>>>>  2 files changed, 7 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
>>>> index 53c2f1b..412297d4 100644
>>>> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
>>>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>>>> @@ -214,6 +214,7 @@ enum {
>>>>  struct hns_roce_uar {
>>>>  	u64		pfn;
>>>>  	unsigned long	index;
>>>> +	unsigned long	logic_idx;
>>>>  };
>>>>
>>>>  struct hns_roce_ucontext {
>>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
>>>> index 4b41e04..b9f2c87 100644
>>>> --- a/drivers/infiniband/hw/hns/hns_roce_pd.c
>>>> +++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
>>>> @@ -107,13 +107,15 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
>>>>  	int ret = 0;
>>>>
>>>>  	/* Using bitmap to manager UAR index */
>>>> -	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->index);
>>>> +	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->logic_idx);
>>>>  	if (ret == -1)
>>>>  		return -ENOMEM;
>>>>
>>>> -	if (uar->index > 0)
>>>> -		uar->index = (uar->index - 1) %
>>>> +	if (uar->logic_idx > 0 && hr_dev->caps.phy_num_uars > 1)
>>>> +		uar->index = (uar->logic_idx - 1) %
>>>>  			     (hr_dev->caps.phy_num_uars - 1) + 1;
>>>> +	else
>>>> +		uar->index = 0;
>>>>
>>> Sorry, but maybe I didn't understand this change fully, but logic_idx is
>>> not initialized at all and one of two (needs to check your uar
>>> allocation): the logic_idx is always zero -> index will be zero too,
>>> or logic_idx is random variable -> index will be random too.
>>>
>>> What did you want to do?
>>>
>> Hi, Leon
>>
>>     The prototype of hns_roce_bitmap_alloc as belows:
>>         int hns_roce_bitmap_alloc(struct hns_roce_bitmap *bitmap,
>> unsigned long *obj);
>>     In this statement,  we evaluate uar->logic_idx.
>>         ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap,
>> &uar->logic_idx);
>>
>>     In hip06,  hr_dev->caps.phy_num_uars equals 8,
>>         if (uar->logic_idx > 0)
>>              uar-> index = 0;
>>        else
>>              uar-> index =(uar->logic_idx - 1) %
>> (hr_dev->caps.phy_num_uars - 1) + 1;
>>     In hip08,  hr_dev->caps.phy_num_uars equals 1,  uar-> index = 0;
>>
>>    Regards
> Where did you change/set logic_idx?
In hns_roce_uar_alloc,
    ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->logic_idx);
In hns_roce_uar_free,
    hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->logic_idx,
BITMAP_NO_RR);

Thanks
> Thanks
>
>
>> Wei Hu
>>>>  	if (!dev_is_pci(hr_dev->dev)) {
>>>>  		res = platform_get_resource(hr_dev->pdev, IORESOURCE_MEM, 0);
>>>> @@ -132,7 +134,7 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
>>>>
>>>>  void hns_roce_uar_free(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
>>>>  {
>>>> -	hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->index,
>>>> +	hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->logic_idx,
>>>>  			     BITMAP_NO_RR);
>>>>  }
>>>>
>>>> --
>>>> 1.9.1
>>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
