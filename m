From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH V2 rdma-next 3/4] RDMA/hns: Add reset process for RoCE in
 hip08
Date: Fri, 25 May 2018 13:54:31 +0800
Message-ID: <5B07A517.7030507@huawei.com>
References: <1527070590-94399-1-git-send-email-xavier.huwei@huawei.com>
 <1527070590-94399-4-git-send-email-xavier.huwei@huawei.com>
 <20180524213143.GE3948@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524213143.GE3948@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 2018/5/25 5:31, Jason Gunthorpe wrote:
> On Wed, May 23, 2018 at 06:16:29PM +0800, Wei Hu (Xavier) wrote:
>> This patch added reset process for RoCE in hip08.
>>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
>>
>> v1->v2: 1.Delete handle->priv = NULL in hns_roce_hw_v2_uninit_instance.
>> 	2.Add hns_roce_hw_v2_reset_notify_init callback function,
>> 	  When RoCE reinit failed in this function, inform NIC driver.
>> 	The related link of Jason's commets:
>> 	https://www.spinics.net/lists/linux-rdma/msg65009.html
>>  drivers/infiniband/hw/hns/hns_roce_cmd.c    |  3 ++
>>  drivers/infiniband/hw/hns/hns_roce_device.h |  2 +
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 76 +++++++++++++++++++++++++++++
>>  drivers/infiniband/hw/hns/hns_roce_main.c   |  7 +++
>>  4 files changed, 88 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
>> index 9ebe839..a0ba19d 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
>> @@ -176,6 +176,9 @@ int hns_roce_cmd_mbox(struct hns_roce_dev *hr_dev, u64 in_param, u64 out_param,
>>  		      unsigned long in_modifier, u8 op_modifier, u16 op,
>>  		      unsigned long timeout)
>>  {
>> +	if (hr_dev->is_reset)
>> +		return 0;
>> +
>>  	if (hr_dev->cmd.use_events)
>>  		return hns_roce_cmd_mbox_wait(hr_dev, in_param, out_param,
>>  					      in_modifier, op_modifier, op,
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
>> index 412297d4..da8512b 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>> @@ -774,6 +774,8 @@ struct hns_roce_dev {
>>  	const char		*irq_names[HNS_ROCE_MAX_IRQ_NUM];
>>  	spinlock_t		sm_lock;
>>  	spinlock_t		bt_cmd_lock;
>> +	bool			active;
>> +	bool			is_reset;
>>  	struct hns_roce_ib_iboe iboe;
>>  
>>  	struct list_head        pgdir_list;
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> index e0ab672..a70d07b 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> @@ -768,6 +768,9 @@ static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
>>  	int ret = 0;
>>  	int ntc;
>>  
>> +	if (hr_dev->is_reset)
>> +		return 0;
>> +
>>  	spin_lock_bh(&csq->lock);
>>  
>>  	if (num > hns_roce_cmq_space(csq)) {
>> @@ -4790,14 +4793,87 @@ static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
>>  {
>>  	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
>>  
>> +	if (!hr_dev)
>> +		return;
>> +
>>  	hns_roce_exit(hr_dev);
>>  	kfree(hr_dev->priv);
>>  	ib_dealloc_device(&hr_dev->ib_dev);
>>  }
>>  
>> +static int hns_roce_hw_v2_reset_notify_down(struct hnae3_handle *handle)
>> +{
>> +	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
>> +	struct ib_event event;
>> +
>> +	if (!hr_dev) {
>> +		dev_err(&handle->pdev->dev,
>> +			"Input parameter handle->priv is NULL!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	hr_dev->active = false;
>> +	hr_dev->is_reset = true;
>> +
>> +	event.event = IB_EVENT_DEVICE_FATAL;
>> +	event.device = &hr_dev->ib_dev;
>> +	event.element.port_num = 1;
>> +	ib_dispatch_event(&event);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hns_roce_hw_v2_reset_notify_init(struct hnae3_handle *handle)
>> +{
>> +	int ret;
>> +
>> +	ret = hns_roce_hw_v2_init_instance(handle);
>> +	if (ret) {
>> +		/* when reset notify type is HNAE3_INIT_CLIENT In reset notify
>> +		 * callback function, RoCE Engine reinitialize. If RoCE reinit
>> +		 * failed, we should inform NIC driver.
>> +		 */
>> +		handle->priv = NULL;
>> +		dev_err(&handle->pdev->dev,
>> +			"In reset process RoCE reinit failed %d.\n", ret);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int hns_roce_hw_v2_reset_notify_uninit(struct hnae3_handle *handle)
>> +{
>> +	msleep(100);
>> +	hns_roce_hw_v2_uninit_instance(handle, false);
>> +	return 0;
>> +}
>> +
>> +static int hns_roce_hw_v2_reset_notify(struct hnae3_handle *handle,
>> +				       enum hnae3_reset_notify_type type)
>> +{
>> +	int ret = 0;
>> +
>> +	switch (type) {
>> +	case HNAE3_DOWN_CLIENT:
>> +		ret = hns_roce_hw_v2_reset_notify_down(handle);
>> +		break;
>> +	case HNAE3_INIT_CLIENT:
>> +		ret = hns_roce_hw_v2_reset_notify_init(handle);
>> +		break;
>> +	case HNAE3_UNINIT_CLIENT:
>> +		ret = hns_roce_hw_v2_reset_notify_uninit(handle);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>  static const struct hnae3_client_ops hns_roce_hw_v2_ops = {
>>  	.init_instance = hns_roce_hw_v2_init_instance,
>>  	.uninit_instance = hns_roce_hw_v2_uninit_instance,
>> +	.reset_notify = hns_roce_hw_v2_reset_notify,
>>  };
>>  
>>  static struct hnae3_client hns_roce_hw_v2_client = {
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
>> index 1b79a38..ac51372 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
>> @@ -332,6 +332,9 @@ static struct ib_ucontext *hns_roce_alloc_ucontext(struct ib_device *ib_dev,
>>  	struct hns_roce_ib_alloc_ucontext_resp resp = {};
>>  	struct hns_roce_dev *hr_dev = to_hr_dev(ib_dev);
>>  
>> +	if (!hr_dev->active)
>> +		return ERR_PTR(-EAGAIN);
> This still doesn't make sense, ib_unregister_device already makes sure
> that hns_roce_alloc_ucontext isn't running and won't be called before
> returning, don't need another flag to do that.
>
> Since this is the only place the active flag is tested it can just be deleted
> entirely.
Hi, Jason
   
    roce reset process:
    1. hr_dev->active = false;  //make sure no any process call
ibv_open_device.   
    2. call ib_dispatch_event() function to report IB_EVENT_DEVICE_FATAL
event.
    3. msleep(100);   // for some app to free resources
    4. call ib_unregister_device().   
    5. ...
    6. ...

    There are 2 steps as above before calling ib_unregister_device(), we
evaluate
hr_dev->active with false to avoid no any process call ibv_open_device.
    Thanks     

    Regards
Wei Hu
>> @@ -425,6 +428,7 @@ static void hns_roce_unregister_device(struct hns_roce_dev *hr_dev)
>>  {
>>  	struct hns_roce_ib_iboe *iboe = &hr_dev->iboe;
>>  
>> +	hr_dev->active = false;
>>  	unregister_netdevice_notifier(&iboe->nb);
>>  	ib_unregister_device(&hr_dev->ib_dev);
> Jason
>
> .
>
