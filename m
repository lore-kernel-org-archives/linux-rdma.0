From: Salil Mehta <salil.mehta@huawei.com>
Subject: RE: [RFC PATCH 04/10] net: hns3: Add "promisc mode" config info
 query function
Date: Sun, 11 Nov 2018 16:45:32 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F93BFA0E16@FRAEML521-MBS.china.huawei.com>
References: <20181109220743.10264-1-salil.mehta@huawei.com>
 <20181109220743.10264-5-salil.mehta@huawei.com>
 <20181109224903.GE5259@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181109224903.GE5259@lunn.ch>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Andrew Lunn <andrew@lunn.ch>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "yuvalm@mellanox.com" <yuvalm@mellanox.com>, "leon@kernel.org" <leon@kernel.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>, "lipeng (Y)" <lipeng321@huawei.com>, "mehta.salil@opnsrc.net" <mehta.salil@opnsrc.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, Liuzhongzhu <liuzhongzhu@huawei.com>
List-Id: linux-rdma@vger.kernel.org

> From: Andrew Lunn [mailto:andrew@lunn.ch]
> Sent: Friday, November 9, 2018 10:49 PM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: davem@davemloft.net; yuvalm@mellanox.com; leon@kernel.org;
> Zhuangyuzeng (Yisen) <yisen.zhuang@huawei.com>; lipeng (Y)
> <lipeng321@huawei.com>; mehta.salil@opnsrc.net; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Linuxarm
> <linuxarm@huawei.com>; Liuzhongzhu <liuzhongzhu@huawei.com>
> Subject: Re: [RFC PATCH 04/10] net: hns3: Add "promisc mode" config info
> query function
> 
> On Fri, Nov 09, 2018 at 10:07:37PM +0000, Salil Mehta wrote:
> > From: liuzhongzhu <liuzhongzhu@huawei.com>
> >
> > This patch prints promiscuous mode status.
> 
> netstat -i
> 
> Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-
> OVR Flg
> lo       65536   871698      0      0 0        871698      0      0
> 0 LRU
> tun0      1500  1052639      0      0 0       1013998      0      0
> 0 MOPRU
> 
> The flag P means promisc.

sure, got the point. Anything which is available in the tools should be
avoided in the debugfs?

Many thanks
