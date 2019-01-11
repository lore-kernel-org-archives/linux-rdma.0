From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-rc 1/3] RDMA/hns: Fix the Oops during rmmod or
 insmod ko when reset occurs
Date: Fri, 11 Jan 2019 14:34:11 -0700
Message-ID: <20190111213411.GA22310@ziepe.ca>
References: <1547128663-69220-1-git-send-email-xavier.huwei@huawei.com>
 <1547128663-69220-2-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547128663-69220-2-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, liudongdong3@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 10, 2019 at 09:57:41PM +0800, Wei Hu (Xavier) wrote:
> +	/* Check the status of the current software reset process, if in
> +	 * software reset process, wait until software reset process finished,
> +	 * in order to ensure that reset process and this function will not call
> +	 * __hns_roce_hw_v2_uninit_instance at the same time.
> +	 * If a timeout occurs, it indicates that the network subsystem has
> +	 * encountered a serious error and cannot be recovered from the reset
> +	 * processing.
> +	 */
> +	if (ops->ae_dev_resetting(handle)) {
> +		dev_warn(dev, "Device is busy in resetting state. waiting.\n");
> +		end = msecs_to_jiffies(HNS_ROCE_V2_RST_PRC_MAX_TIME) + jiffies;
> +		while (ops->ae_dev_resetting(handle) &&
> +		       time_before(jiffies, end))
> +			msleep(20);

Really? Does this have to be so ugly? Why isn't there just a simple
lock someplace that is held during reset?

I'm skeptical that all this strange looking stuff is properly locked
and concurrency safe.

Also, this series seems a bit big for -rc

Jason
