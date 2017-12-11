From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] Revise eq support for hip06 & hip08
Date: Mon, 11 Dec 2017 08:49:02 -0700
Message-ID: <20171211154902.GA27709@ziepe.ca>
References: <1510651577-20794-1-git-send-email-liuyixian@huawei.com>
 <4636858b-4ae8-e37e-d2d3-44441560f266@huawei.com>
 <6d0a2aee-54e0-90dd-5293-7f8a5dac7d36@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6d0a2aee-54e0-90dd-5293-7f8a5dac7d36-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 11, 2017 at 04:55:23PM +0800, Liuyixian (Eason) wrote:
> Hi Jason,
> 
> This patch-set was based on Doug's RDMA tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> 
> Should I resend this patch-set based on the new shared RDMA git tree?
> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git

At this point it needs to apply cleanly on rc2 which is what is on the
rdma tree right now.

If it doesn't then you need to retest/resend..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
