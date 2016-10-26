From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/7] libhns: Add verbs of qp support
Date: Wed, 26 Oct 2016 10:23:21 -0600
Message-ID: <20161026162321.GF24898@obsidianresearch.com>
References: <1477487048-62256-1-git-send-email-oulijun@huawei.com>
 <1477487048-62256-6-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477487048-62256-6-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2016 at 09:04:06PM +0800, Lijun Ou wrote:

> +#ifndef min
> +#define min(a, b) \
> +	({ typeof (a) _a = (a); \
> +	typeof (b) _b = (b); \
> +	_a < _b ? _a : _b; })
> +#endif

Nope, use the ccan header

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
