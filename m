From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH rdma-next 4/5] RDMA/hns: Add reset process for RoCE in
 hip08
Date: Fri, 18 May 2018 15:23:00 +0800
Message-ID: <5AFE7F54.9030201@huawei.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-5-git-send-email-xavier.huwei@huawei.com>
 <20180517151459.GD10842@ziepe.ca> <5AFE484B.2080206@huawei.com>
 <20180518041502.GS10842@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518041502.GS10842@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org



On 2018/5/18 12:15, Jason Gunthorpe wrote:
> On Fri, May 18, 2018 at 11:28:11AM +0800, Wei Hu (Xavier) wrote:
>>
>> On 2018/5/17 23:14, Jason Gunthorpe wrote:
>>> On Thu, May 17, 2018 at 04:02:52PM +0800, Wei Hu (Xavier) wrote:
>>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>>>> index 86ef15f..e1c44a6 100644
>>>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>>>> @@ -774,6 +774,9 @@ static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
>>>>  	int ret = 0;
>>>>  	int ntc;
>>>>  
>>>> +	if (hr_dev->is_reset)
>>>> +		return 0;
>>>> +
>>>>  	spin_lock_bh(&csq->lock);
>>>>  
>>>>  	if (num > hns_roce_cmq_space(csq)) {
>>>> @@ -4790,6 +4793,7 @@ static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
>>>>  	return 0;
>>>>  
>>>>  error_failed_get_cfg:
>>>> +	handle->priv = NULL;
>>>>  	kfree(hr_dev->priv);
>>>>  
>>>>  error_failed_kzalloc:
>>>> @@ -4803,14 +4807,70 @@ static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
>>>>  {
>>>>  	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
>>>>  
>>>> +	if (!hr_dev)
>>>> +		return;
>>>> +
>>>>  	hns_roce_exit(hr_dev);
>>>> +	handle->priv = NULL;
>>>>  	kfree(hr_dev->priv);
>>>>  	ib_dealloc_device(&hr_dev->ib_dev);
>>>>  }
>>> Why are these hunks here? If init fails then uninit should not be
>>> called, so why meddle with priv?
>> In hns_roce_hw_v2_init_instance function, we evaluate handle->priv with 
>> hr_dev,
>> We want clear the value in hns_roce_hw_v2_uninit_instance function.
>> So we can ensure no problem in RoCE driver.
> What problem could happen?
>
> I keep removing unnecessary sets to null and checks of null, so please
> don't add them if they cannot happen.
>
> Eg uninit should never be called with a null priv, that is a serious
> logic mis-design someplace if it happens.
>
> Jason
NIC driver call the registered reset_notify() function to finish the
part of RoCE reset process.
In RoCE driver,  when hnae3_reset_notify_type is HNAE3_UNINIT_CLIENT,
we call hns_roce_hw_v2_uninit_instance(handle, false) to release the
resources.
when hnae3_reset_notify_type is HNAE3_INIT_CLIENT, we call
hns_roce_hw_v2_init_instance.
if hns_roce_hw_v2_init_instance failed, we should ensure no problem in
the other callback
function registered by RoCE driver.
 
The related RoCE driver:
static int hns_roce_hw_v2_reset_notify_uninit(struct hnae3_handle *handle)
{
    msleep(100);
    hns_roce_hw_v2_uninit_instance(handle, false);
    return 0;
}

static int hns_roce_hw_v2_reset_notify(struct hnae3_handle *handle,
                       enum hnae3_reset_notify_type type)
{
    int ret = 0;

    switch (type) {
    case HNAE3_DOWN_CLIENT:
        ret = hns_roce_hw_v2_reset_notify_down(handle);
        break;
    case HNAE3_INIT_CLIENT:
        ret = hns_roce_hw_v2_init_instance(handle);
        break;
    case HNAE3_UNINIT_CLIENT:
        ret = hns_roce_hw_v2_reset_notify_uninit(handle);
        break;
    default:
        break;
    }

    return ret;
}

The related NIC driver:

static int hclge_notify_roce_client(struct hclge_dev *hdev,
                    enum hnae3_reset_notify_type type)
{
    struct hnae3_client *client = hdev->roce_client;
    struct hnae3_handle *handle;
    int ret = 0;
    u16 i;

    if (!client)
        return 0;

    if (!client->ops->reset_notify)
        return -EOPNOTSUPP;

    for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
        handle = &hdev->vport[i].roce;
        ret = client->ops->reset_notify(handle, type);
        if (ret) {
            dev_err(&hdev->pdev->dev,
                "notify roce client failed %d", ret);
            return ret;
        }
    }

    return ret;
}

static void hclge_reset(struct hclge_dev *hdev)
{
    struct hnae3_handle *handle;

    /* perform reset of the stack & ae device for a client */
    handle = &hdev->vport[0].nic;

    hclge_notify_roce_client(hdev, HNAE3_DOWN_CLIENT);
    hclge_notify_roce_client(hdev, HNAE3_UNINIT_CLIENT);

    rtnl_lock();
    hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);

    if (!hclge_reset_wait(hdev)) {
        hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
        hclge_reset_ae_dev(hdev->ae_dev);
        hclge_notify_client(hdev, HNAE3_INIT_CLIENT);

        hclge_clear_reset_cause(hdev);
    } else {
        /* schedule again to check pending resets later */
        set_bit(hdev->reset_type, &hdev->reset_pending);
        hclge_reset_task_schedule(hdev);
    }

    hclge_notify_client(hdev, HNAE3_UP_CLIENT);
    handle->last_reset_time = jiffies;
    rtnl_unlock();

    hclge_notify_roce_client(hdev, HNAE3_INIT_CLIENT);
    hclge_notify_roce_client(hdev, HNAE3_UP_CLIENT);
}

Thanks, Jason

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
