Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795167607;
	b=LBai7raKsT8q0J22ffT2Q5QWu4CIxXgJBDg/p1X2JX+0jie+wiN8bf6J++EW+sA99spU
	 OgsuDGjZXjLRKw4tgNNONEE3NXXVf7PkKXFvTxAAISG2jTRmrdsQHAh/+aW/MqOFfk7MB
	 SLkqwRLHIPNWuYyvVp0eRfNT4RqJJVn35z0PZTyAZKgUUYYbDgNeBr2skuXz1ig8CNj7U
	 yTkCaSQybHdDplM/TmP6ntptfFfJI1nMOeM6Wv+WTYUl+Ud0q98B3ESP9wBKhQLBRpcvX
	 QMoE9z8DlXstt35GLlUjpWkTdLjxyOxoBd5Xc6uEqB0x33MSTqWx5NToavTzbNLw+ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167607;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=WcQJO05ZPyLddgDxQPffKZQCiNEZKjoGbV4decLTjFM=;
	b=4M67RIga4zIr2412ALKxQPPoXO6uFf2+8D6A4XrWyJVIhtoBEd2XzAtglBpCzxevTiEv
	 k0M7uJiiVl41eh5iD3pCTCmwMqhXukgvazdXJOQ87supd/9/uqdXrMOsXw4O2Gsrthm20
	 hbnMOB8DQedZsGpZwhjVb945RffsF/Qr7sVtBOPj8y2zTbwSYN9EXU3K3roNeQSfrIL/4
	 NSx13+qHp+7RmvRWjI0a5gSyfxnYX7Dyy2HkzCB+0rERfZQtnO1bYpoRBiYEOBBl4bHGb
	 l356ncy0gAz2is7ueZ9BfoRd8T6irNfKS27C3ab9irXAmICnWNZzbbgREGehYSz1qZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hisilicon.com;
	spf=pass smtp.mailfrom=hisilicon.com;
	arc=none smtp.remote-ip=113.46.200.216
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F62B606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 09:40:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F62B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jW9Jw0my5z1T4Fr
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 17:39:12 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id AF0E740561
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 17:39:54 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 20 Nov 2026 17:39:54 +0800
Message-ID: <74fa0c4c-f677-3b63-0e63-adb5a2a3df9a@hisilicon.com>
Date: Fri, 20 Nov 2026 17:39:53 +0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH for-next] RDMA/hns: Add reset fence before freeing DMA
 memory when destroy mbox fails
To: <linux-rdma@vger.kernel.org>
References: <20261110115609.1981900-1-huangjunxian6@hisilicon.com>
 <20261115133104.GB42525@unreal>
Content-Language: en-US
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20261115133104.GB42525@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/11/15 21:31, Leon Romanovsky wrote:
> On Tue, Nov 10, 2026 at 07:56:09PM +0800, Junxian Huang wrote:
>> When a destroy mailbox (QPC/CQC/MPT/SRQC/EQC) fails or is skipped
>> in a reset, HW may still access the context while the driver frees
>> its DMA memory, causing a HW UAF.
>>
>> According to the suggestion in [1], add a reset fence before freeing
>> DMA memory when the destroy mailbox fails. Once ops->ae_dev_reset_cnt()
>> increases, the HW reset is guaranteed to have completed, so HW will
>> no longer access the DMA memory and it is safe for the driver
>> to free it.
>>
>> [1] https://lore.kernel.org/linux-rdma/20250401133956.GC186258@ziepe.ca/
>>
>> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_cmd.c    |  7 +++-
>>  drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 40 +++++++++++++++++++++
>>  3 files changed, 47 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
>> index 1943031b0dbe..885900e68779 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
>> @@ -287,5 +287,10 @@ int hns_roce_create_hw_ctx(struct hns_roce_dev *dev,
>>  
>>  int hns_roce_destroy_hw_ctx(struct hns_roce_dev *dev, u8 cmd, unsigned long idx)
>>  {
>> -	return hns_roce_cmd_mbox(dev, 0, 0, cmd, idx);
>> +	int ret;
>> +
>> +	ret = hns_roce_cmd_mbox(dev, 0, 0, cmd, idx);
>> +	dev->hw->mbox_rst_fence(dev, ret);
> 
> There is no need to pass ret to .mbox_rst_fence(), call it conditionally
> instead:
> if (ret)
> 	dev->hw->mbox_rst_fence(dev);
> 

if (ret) is not sufficient here because mbox has a fake success path.
When the device is in reset, v2_chk_mbox_is_avail() returns 0 directly
without posting the mbox. In this case we still have to wait for the
fence.

The current implementation checks both ret and device state in
hns_roce_v2_mbox_rst_fence(), but we can move this check to
the callers to avoid passing ret if you prefer.

>> +
>> +	return ret;
> 
> Is the returned error still relevant after calling `mbox_rst_fence()`?
> 

Indeed, will change to return 0.

>>  }
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
>> index 5890ee69247c..021a52bc49ab 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>> @@ -976,6 +976,7 @@ struct hns_roce_hw {
>>  				enum hns_roce_scc_algo algo);
>>  	int (*query_scc_param)(struct hns_roce_dev *hr_dev,
>>  			       enum hns_roce_scc_algo alog);
>> +	void (*mbox_rst_fence)(struct hns_roce_dev *hr_dev, int mbox_ret);
>>  };
>>  
>>  #define HNS_ROCE_SCC_PARAM_SIZE 4
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> index a8f319a57f25..e17569a532e4 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> @@ -1317,6 +1317,43 @@ static bool check_device_is_in_reset(struct hns_roce_dev *hr_dev)
>>  	return false;
>>  }
>>  
>> +static void hns_roce_v2_mbox_rst_fence(struct hns_roce_dev *hr_dev,
>> +				       int mbox_ret)
>> +{
>> +#define FENCE_POLL_INTERVAL_US 1000
>> +#define FENCE_TIMEOUT_US (60 * 1000 * 1000)
> 
> Please put these defines above hns_roce_v2_mbox_rst_fence().
> 

Will do.

>> +	struct hns_roce_v2_priv *priv = hr_dev->priv;
>> +	struct hnae3_handle *handle = priv->handle;
>> +	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
>> +	unsigned long cnt;
>> +	unsigned long val;
>> +	int ret;
>> +
>> +	might_sleep();
>> +
>> +	if (!mbox_ret && !check_device_is_in_reset(hr_dev))
>> +		return;
>> +
>> +	cnt = ops->ae_dev_reset_cnt(handle);
>> +	if (cnt != hr_dev->reset_cnt)
> 
> This is exactly what your check_device_is_in_reset() checks.
> 

Not exactly. check_device_is_in_reset() returns true in two different
situations: a reset has completed, or a reset is still in progress.
This cnt check means the former. This is the only situation where
it is safe to return immediately.

>> +		return;
>> +
>> +	if (!check_device_is_in_reset(hr_dev)) {
>> +		struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hr_dev->pci_dev);
>> +		enum hnae3_reset_type rst_type = hr_dev->is_vf ?
>> +			HNAE3_VF_FUNC_RESET : HNAE3_FUNC_RESET;
>> +
>> +		ops->set_default_reset_request(ae_dev, rst_type);
>> +		ops->reset_event(hr_dev->pci_dev, handle);
>> +	}
>> +
>> +	ret = read_poll_timeout(ops->ae_dev_reset_cnt, val, val > cnt,
>> +				FENCE_POLL_INTERVAL_US, FENCE_TIMEOUT_US,
>> +				false, handle);
>> +	if (ret)
>> +		dev_err(hr_dev->dev, "reset fence timeout.\n");
>> +}
>> +
>>  static bool v2_chk_mbox_is_avail(struct hns_roce_dev *hr_dev, bool *busy)
>>  {
>>  	struct hns_roce_v2_priv *priv = hr_dev->priv;
>> @@ -5943,6 +5980,8 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
>>  			ibdev_err_ratelimited(ibdev,
>>  					      "failed to modify QP to RST, ret = %d.\n",
>>  					      ret);
>> +
>> +		hr_dev->hw->mbox_rst_fence(hr_dev, ret);
>>  	}
>>  
>>  	send_cq = hr_qp->ibqp.send_cq ? to_hr_cq(hr_qp->ibqp.send_cq) : NULL;
>> @@ -7327,6 +7366,7 @@ static const struct hns_roce_hw hns_roce_hw_v2 = {
>>  	.hns_roce_dev_srq_ops = &hns_roce_v2_dev_srq_ops,
>>  	.config_scc_param = hns_roce_v2_config_scc_param,
>>  	.query_scc_param = hns_roce_v2_query_scc_param,
>> +	.mbox_rst_fence = hns_roce_v2_mbox_rst_fence,
> 
> I don't see much justification for implementing this as a callback when only one
> v2 HNS device is supported.
> 

Will drop this callback.

Thanks,
Junxian

> Thanks
> 
>>  };
>>  
>>  static const struct pci_device_id hns_roce_hw_v2_pci_tbl[] = {
>> -- 
>> 2.33.0
>>
>>
> 
> 
