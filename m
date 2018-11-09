From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [RFC PATCH 04/10] net: hns3: Add "promisc mode" config info
 query function
Date: Fri, 9 Nov 2018 23:49:03 +0100
Message-ID: <20181109224903.GE5259@lunn.ch>
References: <20181109220743.10264-1-salil.mehta@huawei.com>
 <20181109220743.10264-5-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181109220743.10264-5-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Salil Mehta <salil.mehta@huawei.com>
Cc: davem@davemloft.net, yuvalm@mellanox.com, leon@kernel.org, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com, liuzhongzhu <liuzhongzhu@huawei.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 09, 2018 at 10:07:37PM +0000, Salil Mehta wrote:
> From: liuzhongzhu <liuzhongzhu@huawei.com>
> 
> This patch prints promiscuous mode status.

netstat -i

Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
lo       65536   871698      0      0 0        871698      0      0      0 LRU
tun0      1500  1052639      0      0 0       1013998      0      0      0 MOPRU

The flag P means promisc.

    Andrew
