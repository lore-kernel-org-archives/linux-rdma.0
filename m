From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH V2 rdma-next 2/3] RDMA/hns: Fix the chip hanging caused
 by sending mailbox&CMQ during reset
Date: Wed, 23 Jan 2019 15:40:41 -0700
Message-ID: <20190123224041.GA11605@ziepe.ca>
References: <1547868967-115951-1-git-send-email-xavier.huwei@huawei.com>
 <1547868967-115951-3-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547868967-115951-3-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, liudongdong3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 19, 2019 at 11:36:06AM +0800, Wei Hu (Xavier) wrote:

> +static int hns_roce_v2_cmd_hw_resetting(struct hns_roce_dev *hr_dev,
> +					unsigned long instance_stage,
> +					unsigned long reset_stage)
> +{
> +	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv *)hr_dev->priv;
> +	struct hnae3_handle *handle = priv->handle;
> +	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
> +	unsigned long end;
> +
> +	/* When hardware reset is detected, we should stop sending mailbox&cmq
> +	 * to hardware, and wait until hardware reset finished. If now
> +	 * in .init_instance() function, we should exit with error. If now at
> +	 * HNAE3_INIT_CLIENT stage of soft reset process, we should exit with
> +	 * error, and then HNAE3_INIT_CLIENT related process can rollback the
> +	 * operation like notifing hardware to free resources, HNAE3_INIT_CLIENT
> +	 * related process will exit with error to notify NIC driver to
> +	 * reschedule soft reset process once again.
> +	 */
> +	end = msecs_to_jiffies(HNS_ROCE_V2_HW_RST_TIMEOUT) + jiffies;
> +	while (ops->get_hw_reset_stat(handle) && time_before(jiffies, end))
> +		udelay(1);

I thought you were getting rid of these loops?

Jason
