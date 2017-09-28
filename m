From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH for-next 3/9] RDMA/hns: Add return statement when kzalloc
 return NULL in hns_roce_v1_recreate_lp_qp
Date: Thu, 28 Sep 2017 19:56:59 +0800
Message-ID: <59CCE38B.4040408@huawei.com>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-4-git-send-email-xavier.huwei@huawei.com>
 <20170928091308.GT2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170928091308.GT2297@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, xavier.huwei@tom.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org



On 2017/9/28 17:13, Leon Romanovsky wrote:
> On Thu, Sep 28, 2017 at 12:57:28PM +0800, Wei Hu (Xavier) wrote:
>> From: Lijun Ou <oulijun@huawei.com>
>>
>> When lp_qp_work is NULL, it should be returned ENOMEM. This patch
>> mainly fixes it.
>>
>> Ihis patch fixes the smatch error as below:
>> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:918 hns_roce_v1_recreate_lp_qp()
>> error: potential null dereference 'lp_qp_work'.  (kzalloc returns null)
>>
>> Signed-off-by: Lijun Ou <oulijun@huawei.com>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
>> Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
>> ---
>>   drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> index 95f5c88..1071fa2 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> @@ -912,6 +912,8 @@ static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
>>
>>   	lp_qp_work = kzalloc(sizeof(struct hns_roce_recreate_lp_qp_work),
>>   			     GFP_KERNEL);
>> +	if (!lp_qp_work)
>> +		return -ENOMEM;
>>
> You will treat this error in the same was as you will treat timeout,
> which is wrong.
Thanks,  Leon
We will send v2 to fix the compatible warn info.
> 1656          */
> 1657         if (hr_dev->hw->dereg_mr && hns_roce_v1_recreate_lp_qp(hr_dev))
> 1658                 dev_warn(&hr_dev->pdev->dev, "recreate lp qp timeout!\n");
> 1659
> 1660         p = (u32 *)(&addr[0]);
>
>
>>   	INIT_WORK(&(lp_qp_work->work), hns_roce_v1_recreate_lp_qp_work_fn);
>>
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
