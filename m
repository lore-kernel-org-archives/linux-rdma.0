From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH V3 net-next] net: hns3: Updates MSI/MSI-X alloc/free
 APIs(depricated) to new APIs
Date: Tue, 14 Nov 2017 14:23:34 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93B97A60C@FRAEML521-MBX.china.huawei.com>
References: <20171113113938.8660-1-salil.mehta@huawei.com>
 <20171114.214612.632435634031888429.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171114.214612.632435634031888429.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "lipeng (Y)" <lipeng321@huawei.com>, "hch@lst.de" <hch@lst.de>, "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Tuesday, November 14, 2017 12:46 PM
> To: Salil Mehta
> Cc: Zhuangyuzeng (Yisen); lipeng (Y); hch@lst.de;
> mehta.salil.lnk@gmail.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Linuxarm
> Subject: Re: [PATCH V3 net-next] net: hns3: Updates MSI/MSI-X
> alloc/free APIs(depricated) to new APIs
> 
> From: Salil Mehta <salil.mehta@huawei.com>
> Date: Mon, 13 Nov 2017 11:39:38 +0000
> 
> > This patch migrates the HNS3 driver code from use of depricated PCI
> > MSI/MSI-X interrupt vector allocation/free APIs to new common APIs.
> >
> > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> > Suggested-by: Christoph Hellwig <hch@lst.de>
> 
> Applied.

Thanks David.
