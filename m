From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH V4 rdma-next 0/3] RDMA/hns: Some fixes for hns RoCE driver
Date: Mon, 4 Feb 2019 16:22:56 -0700
Message-ID: <20190204232256.GA3731@ziepe.ca>
References: <1549197795-23118-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1549197795-23118-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, liudongdong3@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 03, 2019 at 08:43:12PM +0800, Wei Hu (Xavier) wrote:
> Hi, Jason and Doug
> 
> This patch series includes three bugfixes for reset related operations
> and are maked based on wip/jgg-for-next branch.
> 
> Best Regards
> Xavier
> 
> Wei Hu (Xavier) (3):
>   RDMA/hns: Fix the Oops during rmmod or insmod ko when reset occurs
>   RDMA/hns: Fix the chip hanging caused by sending mailbox&CMQ during
>     reset
>   RDMA/hns: Fix the chip hanging caused by sending doorbell during reset

Applied to for-next

Thanks,
Jason
