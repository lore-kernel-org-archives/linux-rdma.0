From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/hns: Fix the bug of polling cq failed for
 loopback Qps
Date: Tue, 25 Jul 2017 10:11:18 +0300
Message-ID: <20170725071118.3erfnxyiqi7ittl3@mwanda>
References: <20170719114829.sctq34wns6h6zvxz@mwanda>
 <59769D18.4020400@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <59769D18.4020400-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 09:21:28AM +0800, Wei Hu (Xavier) wrote:
> Hi Dan Carpenter
> 
>     Thanks for your comments.
>     What is the checker tool? Where can I get it?

This is a Smatch check.  https://lwn.net/Articles/629250/

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
