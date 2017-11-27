From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Mon, 27 Nov 2017 11:36:37 -0700
Message-ID: <20171127183637.GA13966@ziepe.ca>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511750484-102395-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, xavier_huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 27, 2017 at 10:41:21AM +0800, Wei Hu (Xavier) wrote:
> This patch-set introduces three patches to fix about the memory
> related issues.

If these patches are for-rc can you revise the commit message to more
clearly explain what the bug is, and supply Fixes lines?

Otherwise these will go to 4.16

It looks like the first one is for-rc material as it looks like DMA
will fail sometimes if the smmu is enabled?

The other two are less clear to me - is this just fixing the code to
conform to the DMA API, or is there an actual real user-impacting bug here?

Thanks
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
