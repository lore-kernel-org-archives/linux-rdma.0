From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [RFC PATCH 07/10] net: hns3: Add checksum info query function
Date: Sun, 11 Nov 2018 16:23:22 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93BFA0DEA@FRAEML521-MBS.china.huawei.com>
References: <20181109220743.10264-1-salil.mehta@huawei.com>
 <20181109220743.10264-8-salil.mehta@huawei.com>
 <20181109225114.GF5259@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181109225114.GF5259@lunn.ch>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Lunn <andrew@lunn.ch>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "yuvalm@mellanox.com" <yuvalm@mellanox.com>, "leon@kernel.org" <leon@kernel.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "lipeng (Y)" <lipeng321@huawei.com>, "mehta.salil@opnsrc.net" <mehta.salil@opnsrc.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, Liuzhongzhu <liuzhongzhu@huawei.com>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Andrew Lunn
> Sent: Friday, November 9, 2018 10:51 PM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: davem@davemloft.net; yuvalm@mellanox.com; leon@kernel.org;
> Zhuangyuzeng (Yisen) <yisen.zhuang@huawei.com>; lipeng (Y)
> <lipeng321@huawei.com>; mehta.salil@opnsrc.net; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Linuxarm
> <linuxarm@huawei.com>; Liuzhongzhu <liuzhongzhu@huawei.com>
> Subject: Re: [RFC PATCH 07/10] net: hns3: Add checksum info query
> function
> 
> On Fri, Nov 09, 2018 at 10:07:40PM +0000, Salil Mehta wrote:
> > From: liuzhongzhu <liuzhongzhu@huawei.com>
> >
> > This patch prints checksum config information
> > related to various layers of headers.
> >
> > debugfs command:
> > echo dump checksum > cmd
> 
> How does the information here differ from ethtool -k

Sure, this should be enough. Will drop this patch.

Thanks
