From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V2 net] net: hns3: Updates MSI/MSI-X alloc/free
 APIs(depricated) to new APIs
Date: Mon, 13 Nov 2017 08:32:16 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93B971955@FRAEML521-MBX.china.huawei.com>
References: <20171109163813.7704-1-salil.mehta@huawei.com>
 <20171113.101910.1171275534353628849.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113.101910.1171275534353628849.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "lipeng (Y)" <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi David,
> -----Original Message-----
> From: David Miller [mailto:davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org]
> Sent: Monday, November 13, 2017 1:19 AM
> To: Salil Mehta
> Cc: hch-jcswGhMUV9g@public.gmane.org; Zhuangyuzeng (Yisen); lipeng (Y);
> mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linuxarm
> Subject: Re: [PATCH V2 net] net: hns3: Updates MSI/MSI-X alloc/free
> APIs(depricated) to new APIs
> 
> From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Date: Thu, 9 Nov 2017 16:38:13 +0000
> 
> > This patch migrates the HNS3 driver code from use of depricated PCI
> > MSI/MSI-X interrupt vector allocation/free APIs to new common APIs.
> >
> > Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Suggested-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> 
> This doesn't apply cleanly to the net-next tree.
It was meant for net repo. I will again re-spin it against net-next and
re-submit it today.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
