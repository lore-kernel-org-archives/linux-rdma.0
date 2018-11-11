From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [RFC PATCH 00/10] net: hns3: Adds support of debugfs to HNS3
 driver
Date: Sun, 11 Nov 2018 15:12:34 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93BF9FC72@FRAEML521-MBS.china.huawei.com>
References: <20181109220743.10264-1-salil.mehta@huawei.com>
 <20181109224346.GD5259@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181109224346.GD5259@lunn.ch>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Lunn <andrew@lunn.ch>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "yuvalm@mellanox.com" <yuvalm@mellanox.com>, "leon@kernel.org" <leon@kernel.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "lipeng (Y)" <lipeng321@huawei.com>, "mehta.salil@opnsrc.net" <mehta.salil@opnsrc.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Hi Andrew,
Thanks for replying. Sorry, for not being prompt as I was
traveling.

Please find some further follow-up questions below

Salil.

> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Andrew Lunn
> Sent: Friday, November 9, 2018 10:44 PM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: davem@davemloft.net; yuvalm@mellanox.com; leon@kernel.org;
> Zhuangyuzeng (Yisen) <yisen.zhuang@huawei.com>; lipeng (Y)
> <lipeng321@huawei.com>; mehta.salil@opnsrc.net; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Linuxarm
> <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH 00/10] net: hns3: Adds support of debugfs to
> HNS3 driver
> 
> > 3. Debugfs looks more unstructured unlike sysfs. Is there any
> >    de-facto standard of the user-api or drivers are allowed to
> >    use it in any way to expose the information from kernel.
> 
> Hi Salil
> 
> You don't really have a user api using debugfs, because debugfs is
> unstable. Anything can change at any time. Any user tools which use
> debugfs can be expected to break at any time as the information in
> debugfs changes. debugfs is for debug, not to export an API. And in
> production systems, it is often not mounted.


Sure, I understand. 

> 
> As much as possible, you are recommended to use existing APIs,
> ethtool, devlink, etc.


Agreed. But what about if we want to expose anything related to
firmware to user-space using the debugfs, assuming we are presenting
information in structured way and not as a black-box to some user-space
application. Is it something which might be discouraged?

Many Thanks
