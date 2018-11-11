From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [RFC PATCH 00/10] net: hns3: Adds support of debugfs to HNS3
 driver
Date: Sun, 11 Nov 2018 16:47:04 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93BFA0E3C@FRAEML521-MBS.china.huawei.com>
References: <20181109220743.10264-1-salil.mehta@huawei.com>
 <20181109224346.GD5259@lunn.ch>
 <F4CC6FACFEB3C54C9141D49AD221F7F93BF9FC72@FRAEML521-MBS.china.huawei.com>
 <20181111161822.GC15953@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181111161822.GC15953@lunn.ch>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Andrew Lunn <andrew@lunn.ch>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "yuvalm@mellanox.com" <yuvalm@mellanox.com>, "leon@kernel.org" <leon@kernel.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "lipeng (Y)" <lipeng321@huawei.com>, "mehta.salil@opnsrc.net" <mehta.salil@opnsrc.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn [mailto:andrew@lunn.ch]
> Sent: Sunday, November 11, 2018 4:18 PM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: davem@davemloft.net; yuvalm@mellanox.com; leon@kernel.org;
> Zhuangyuzeng (Yisen) <yisen.zhuang@huawei.com>; lipeng (Y)
> <lipeng321@huawei.com>; mehta.salil@opnsrc.net; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Linuxarm
> <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH 00/10] net: hns3: Adds support of debugfs to
> HNS3 driver
> 
> > Agreed. But what about if we want to expose anything related to
> > firmware to user-space using the debugfs, assuming we are presenting
> > information in structured way and not as a black-box to some user-
> space
> > application. Is it something which might be discouraged?
> 
> Hi Salil
> 
> Please take a look at devlink. Mellonex have been adding commands to
> it for dumping firmware states.

sure, thanks for the info. Ill check.

Salil.
