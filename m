From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH V2 rdma-next 0/4] Misc update for hns driver
Date: Thu, 24 May 2018 15:43:42 -0600
Message-ID: <20180524214342.GA13272@ziepe.ca>
References: <1527070590-94399-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527070590-94399-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 23, 2018 at 06:16:26PM +0800, Wei Hu (Xavier) wrote:
> This patchset included fixing bug, some optimization, reset
> process for hns driver.
> 
> v1->v2: 1.pull the patch out of the series. The name of the patch is 
> 	  RDMA/hns: Implement the disassociate_ucontext API.
> 	2.Modify the fixes statement according to Leon's comment.
> 	3.Address the Jason's comment in reset relevant patch.
> 
> Wei Hu (Xavier) (4):
>   RDMA/hns: Modify uar allocation algorithm to avoid bitmap exhaust
>   RDMA/hns: Increase checking CMQ status timeout value

I took these two to for-next , the others have to respun.

>   RDMA/hns: Add reset process for RoCE in hip08
>   RDMA/hns: Fix the illegal memory operation when cross page

Thanks,
Jason
