From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH rdma-next 3/3] RDMA/hns: Modify hns RoCE device's name
Date: Sat, 24 Nov 2018 21:01:19 +0800
Message-ID: <5BF94B9F.5030409@huawei.com>
References: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
 <1542986065-44265-4-git-send-email-xavier.huwei@huawei.com>
 <20181123203958.GJ3395@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181123203958.GJ3395@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org



On 2018/11/24 4:39, Jason Gunthorpe wrote:
> On Fri, Nov 23, 2018 at 11:14:25PM +0800, Wei Hu (Xavier) wrote:
>> This patch modifies the name of hns RoCE device's name in order
>> to ensure that the name is consistent before and after reset.
>>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
>>  drivers/infiniband/hw/hns/hns_roce_device.h | 1 +
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 3 +++
>>  drivers/infiniband/hw/hns/hns_roce_main.c   | 4 +++-
>>  3 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
>> index 259977b..a8cfe76 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>> @@ -954,6 +954,7 @@ struct hns_roce_dev {
>>  	struct pci_dev		*pci_dev;
>>  	struct device		*dev;
>>  	struct hns_roce_uar     priv_uar;
>> +	char			name[IB_DEVICE_NAME_MAX];
>>  	const char		*irq_names[HNS_ROCE_MAX_IRQ_NUM];
>>  	spinlock_t		sm_lock;
>>  	spinlock_t		bt_cmd_lock;
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> index 1d639a0..678c7ec 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> @@ -6110,6 +6110,9 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
>>  		hr_dev->irq[i] = pci_irq_vector(handle->pdev,
>>  						i + handle->rinfo.base_vector);
>>  
>> +	snprintf(hr_dev->name, IB_DEVICE_NAME_MAX, "hns%s",
>> +		 handle->rinfo.netdev->name);
> Why is this making up its own driver name? How is this avoiding
> colliding with an existing name?
>
> This is very dangerous since we now have device renaming, the driver
> could fail to load with no recovery.
Hi, Jason
       
    The NIC driver notifies the RoCE driver to perform reset related
processing by calling the .reset_notify() interface registered by the
RoCE driver. If the RoCE reset processing fails, .reset_notify()
returns non-zero, and then hns NIC driver will reschedule the
reset task again.
   
    The current hardware version in hip08 SoC cannot support
after reset process the application still communicates with the
resources like QP requested before reset. In RoCE reset process,
we will release the resources through ib_unregister_device, after
the hardware reset is completed, driver will re-execute
ib_register_device.
   
    Currently, we find that the ib_device's name after reset
and the one before reset may be different. We can specify the
device name to solve this problem.

    Best Regards
Xavier
> Jason
>
> .
>
