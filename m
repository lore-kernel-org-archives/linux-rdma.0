From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH net-next] net: hns3: Refactors "reset" handling code in
 HCLGE layer of HNS3 driver
Date: Sat, 2 Dec 2017 18:06:48 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93BB5D6DC@FRAEML521-MBX.china.huawei.com>
References: <20171201033744.19104-1-salil.mehta@huawei.com>
 <20171201134415.GD22599@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171201134415.GD22599-g2DYL2Zd6BY@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Cc: "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "lipeng (Y)" <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn [mailto:andrew-g2DYL2Zd6BY@public.gmane.org]
> Sent: Friday, December 01, 2017 1:44 PM
> To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; Zhuangyuzeng (Yisen)
> <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>; lipeng (Y) <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>;
> mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linuxarm
> <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Subject: Re: [PATCH net-next] net: hns3: Refactors "reset" handling
> code in HCLGE layer of HNS3 driver
> 
> On Fri, Dec 01, 2017 at 03:37:44AM +0000, Salil Mehta wrote:
> > This patch refactors the code of the reset feature in HCLGE layer
> > of HNS3 PF driver. Prime motivation to do this change is:
> > 1. To reduce the time for which common miscellaneous Vector 0
> >    interrupt is disabled because of the reset.
> > 2. Simplification of reset request submission and pending reset
> >    logic.
> > 3. Simplification of the common miscellaneous interrupt handler
> >    routine(for Vector 0) used to handle reset and other sources
> >    of Vector 0 interrupt.
> >
> > To achieve above below few things have been done:
> > 1. Interrupt is disabled while common miscellaneous interrupt
> >    handler is entered and re-enabled before it is exit. This
> >    reduces the interrupt handling latency as compared to older
> >    interrupt handling scheme where interrupt was being disabled
> >    in interrupt handler context and re-enabled in task context
> >    some time later.
> > 2. Introduces new reset service task for honoring software reset
> >    requests like from network stack related to timeout and serving
> >    the pending reset request(to reset the driver and associated
> >    clients).
> > 3. Made Miscellaneous interrupt handler more generic to handle
> >    all sources including reset interrupt source.
> 
> Hi Salil
> 
> This is a rather large patch. Can you break it up? It seems like you
> should be able to break it up into at least three parts, maybe more.
> 
> You are aiming to have small patches which are obviously correct. It
> is much easier to review than one big patch which is not obvious at
> all.
Ok. No issues. I will try to fix this in V2 version.

> 
> 	Andrew
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
