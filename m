From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/7] libhns: Add initial main frame
Date: Mon, 7 Nov 2016 16:15:32 -0700
Message-ID: <20161107231532.GB7002@obsidianresearch.com>
References: <1477487048-62256-1-git-send-email-oulijun@huawei.com>
 <1477487048-62256-2-git-send-email-oulijun@huawei.com>
 <20161026162053.GE24898@obsidianresearch.com>
 <5811776F.20908@huawei.com>
 <20161027145139.GD6818@obsidianresearch.com>
 <58130573.4010902@huawei.com>
 <20161028164030.GA17289@obsidianresearch.com>
 <5813F869.7010606@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5813F869.7010606-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 29, 2016 at 09:16:25AM +0800, oulijun wrote:

> We hope that the only one userspace library file named
> libhns-rdmav2.so will be used for the different hardware
> version(hip06, hip07, ...), because there are only little change
> between their userspace drivers. So we need to distinguish hardware
> version.

I guess that makes sense, but you still need to be able to parse dt
compatible strings that are lists.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
