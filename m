From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 4/5] RDMA/hns: Add reset process for RoCE in
 hip08
Date: Thu, 17 May 2018 09:14:59 -0600
Message-ID: <20180517151459.GD10842@ziepe.ca>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-5-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526544173-106587-5-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org

On Thu, May 17, 2018 at 04:02:52PM +0800, Wei Hu (Xavier) wrote:
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 86ef15f..e1c44a6 100644
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -774,6 +774,9 @@ static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
>  	int ret = 0;
>  	int ntc;
>  
> +	if (hr_dev->is_reset)
> +		return 0;
> +
>  	spin_lock_bh(&csq->lock);
>  
>  	if (num > hns_roce_cmq_space(csq)) {
> @@ -4790,6 +4793,7 @@ static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
>  	return 0;
>  
>  error_failed_get_cfg:
> +	handle->priv = NULL;
>  	kfree(hr_dev->priv);
>  
>  error_failed_kzalloc:
> @@ -4803,14 +4807,70 @@ static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
>  {
>  	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
>  
> +	if (!hr_dev)
> +		return;
> +
>  	hns_roce_exit(hr_dev);
> +	handle->priv = NULL;
>  	kfree(hr_dev->priv);
>  	ib_dealloc_device(&hr_dev->ib_dev);
>  }

Why are these hunks here? If init fails then uninit should not be
called, so why meddle with priv?

Jason
