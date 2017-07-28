From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [PATCH V5 net-next 6/8] net: hns3: Add MDIO support to HNS3
 Ethernet driver for hip08 SoC
Date: Fri, 28 Jul 2017 23:52:07 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93B82AA5F@FRAEML521-MBX.china.huawei.com>
References: <20170728222652.118448-1-salil.mehta@huawei.com>
 <20170728222652.118448-7-salil.mehta@huawei.com>
 <20170728232859.GB16080@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170728232859.GB16080@lunn.ch>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Andrew Lunn <andrew@lunn.ch>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, huangdaode <huangdaode@hisilicon.com>, "lipeng (Y)" <lipeng321@huawei.com>, "mehta.salil.lnk@gmail.com" <mehta.salil.lnk@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Andrew Lunn
> Sent: Saturday, July 29, 2017 12:29 AM
> To: Salil Mehta
> Cc: davem@davemloft.net; Zhuangyuzeng (Yisen); huangdaode; lipeng (Y);
> mehta.salil.lnk@gmail.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Linuxarm
> Subject: Re: [PATCH V5 net-next 6/8] net: hns3: Add MDIO support to
> HNS3 Ethernet driver for hip08 SoC
> 
> > +int hclge_mac_mdio_config(struct hclge_dev *hdev)
> > +{
> ..
> 
> > +}
> > +
> > +int hclge_mac_start_phy(struct hclge_dev *hdev)
> > +{
> 
> > +}
> > +
> > +void hclge_mac_stop_phy(struct hclge_dev *hdev)
> > +{
> > +}
> > --
> 
> These are not static functions. So i would expect them to be in a
> header file somewhere....
Sure.

> 
>        Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
