From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH V3 net-next] net: hns3: Updates MSI/MSI-X alloc/free
 APIs(depricated) to new APIs
Date: Tue, 14 Nov 2017 21:46:12 +0900 (KST)
Message-ID: <20171114.214612.632435634031888429.davem@davemloft.net>
References: <20171113113938.8660-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113113938.8660-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Mon, 13 Nov 2017 11:39:38 +0000

> This patch migrates the HNS3 driver code from use of depricated PCI
> MSI/MSI-X interrupt vector allocation/free APIs to new common APIs.
> 
> Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Suggested-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Applied.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
