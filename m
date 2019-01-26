From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH V2 rdma-next 2/3] RDMA/hns: Fix the chip hanging caused by
 sending mailbox&CMQ during reset
Date: Sat, 26 Jan 2019 11:27:57 +0800
Message-ID: <5C4BD3BD.2080601@huawei.com>
References: <1547868967-115951-1-git-send-email-xavier.huwei@huawei.com>
 <1547868967-115951-3-git-send-email-xavier.huwei@huawei.com>
 <20190123224041.GA11605@ziepe.ca> <5C492D59.8030707@huawei.com>
 <20190124183120.GD17167@ziepe.ca> <5C4A714C.2070109@huawei.com>
 <20190125215018.GF23001@ziepe.ca> <5C4BBC3E.2000004@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5C4BBC3E.2000004@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: lijun_nudt@163.com, linux-rdma@vger.kernel.org, xavier_huwei@163.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org



On 2019/1/26 9:47, Wei Hu (Xavier) wrote:
>
> On 2019/1/26 5:50, Jason Gunthorpe wrote:
>> On Fri, Jan 25, 2019 at 10:15:40AM +0800, Wei Hu (Xavier) wrote:
>>> On 2019/1/25 2:31, Jason Gunthorpe wrote:
>>>> On Thu, Jan 24, 2019 at 11:13:29AM +0800, Wei Hu (Xavier) wrote:
>>>>> On 2019/1/24 6:40, Jason Gunthorpe wrote:
>>>>>> On Sat, Jan 19, 2019 at 11:36:06AM +0800, Wei Hu (Xavier) wrote:
>>>>>>
>>>>>>> +static int hns_roce_v2_cmd_hw_resetting(struct hns_roce_dev *hr_dev,
>>>>>>> +					unsigned long instance_stage,
>>>>>>> +					unsigned long reset_stage)
>>>>>>> +{
>>>>>>> +	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv *)hr_dev->priv;
>>>>>>> +	struct hnae3_handle *handle = priv->handle;
>>>>>>> +	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
>>>>>>> +	unsigned long end;
>>>>>>> +
>>>>>>> +	/* When hardware reset is detected, we should stop sending mailbox&cmq
>>>>>>> +	 * to hardware, and wait until hardware reset finished. If now
>>>>>>> +	 * in .init_instance() function, we should exit with error. If now at
>>>>>>> +	 * HNAE3_INIT_CLIENT stage of soft reset process, we should exit with
>>>>>>> +	 * error, and then HNAE3_INIT_CLIENT related process can rollback the
>>>>>>> +	 * operation like notifing hardware to free resources, HNAE3_INIT_CLIENT
>>>>>>> +	 * related process will exit with error to notify NIC driver to
>>>>>>> +	 * reschedule soft reset process once again.
>>>>>>> +	 */
>>>>>>> +	end = msecs_to_jiffies(HNS_ROCE_V2_HW_RST_TIMEOUT) + jiffies;
>>>>>>> +	while (ops->get_hw_reset_stat(handle) && time_before(jiffies, end))
>>>>>>> +		udelay(1);
>>>>>> I thought you were getting rid of these loops?
>>>>> Hi, Jason
>>>>>
>>>>>     Upper applications maybe notify driver to issue mailbox or CMD
>>>>>     commands to hardware, some commands used to cancel resources,
>>>>>     destory bt/destory cq/unreg mr/destory qp etc. when such
>>>>>     commands are executed successfully, the hardware engine will
>>>>>     no longer access some memory registered by the driver.
>>>>>
>>>>>     When reset occurs, it is possible for upper applications notify driver
>>>>>     to issue mailbox or CMD commands, we need to wait until hardware
>>>>>     reset finished to ensure that hardware no longer accesses related
>>>>> memory.
>>>> You should not wait for things using loops like the above.
>>> Hi, Jason
>>>
>>>     Are your comments foucsing on udelay? If not, thanks for your detail
>>> information.
>>>     In hns3 RoCE driver, some CMQ/mailbox operation are called inside
>>> the lock,
>>>     we can't use msleep in the lock, otherwise it will cause deadlock.
>>>     When reset occurs, RDMA service cannot be provided normally, I think
>>> in this
>>>     case using udelay will not have a great impact.
>> You should not use any kind of sleep call in a loop like this.
> Hi, Jason
>
>     OK, I got your opinion and will modify it in v3 patch as below:   
>
>     end = msecs_to_jiffies(HNS_ROCE_V2_HW_RST_TIMEOUT) + jiffies;
>     while (time_before(jiffies, end))
>         if (!ops->get_hw_reset_stat(handle))
>             break;           
>    
Hi, Jason
    Thanks for your comments, I have modified them and send patch V3.
    Thanks.

    Regards
Xavier
>     Regards
> Xavier
>> Jason
>>
>> .
>>
>
> _______________________________________________
> Linuxarm mailing list
> Linuxarm@huawei.com
> http://hulk.huawei.com/mailman/listinfo/linuxarm
>
> .
>
