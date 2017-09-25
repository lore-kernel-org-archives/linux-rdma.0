From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/20] RDMA/hns: Add hip08 RoCE driver support
Date: Mon, 25 Sep 2017 13:37:41 -0400
Message-ID: <1506361061.120853.83.camel@redhat.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
         <59C89FD0.9050606@huawei.com> <1506355051.120853.70.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506355051.120853.70.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier_huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-09-25 at 11:57 -0400, Doug Ledford wrote:
> On Mon, 2017-09-25 at 14:18 +0800, Wei Hu (Xavier) wrote:
> > 
> > On 2017/8/30 17:22, Wei Hu (Xavier) wrote:
> > > This patchset adds support for the HiSilicon RoCE engine in the
> > > hip08
> > > SoC.
> > > 
> > > The driver is refactored so it can support both platform and pci
> > > device.
> > > And hip08 RoCE engine is a pci device, hip06 RoCE engine is a
> > > platform
> > > device.
> > > 
> > > New hardware layer file hns_roce_hw_v2.c is added for hw v2
> > > support,
> > > which also includes pci device probing and initialization.
> > > 
> > > Common functionality is still in hns-roce driver, along with
> > > device
> > > initialization.
> > > 
> > > This patchset depends on hns3 NIC driver which had been accepted
> > > by
> > > David,
> > > and is based on for-next branch of the repo:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> > 
> > Hi, Doug
> >      The dependent hns3 NIC driver had been merged into Linus'
> > v4.14-
> > rc1.
> 
> Thanks, I'm processing this series now.

OK, I've gone through the entire series, and pending resolution to my
comments on patch 5, the rest looks OK to me.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
