From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [RFC PATCH 07/10] net: hns3: Add checksum info query function
Date: Fri, 9 Nov 2018 23:51:14 +0100
Message-ID: <20181109225114.GF5259@lunn.ch>
References: <20181109220743.10264-1-salil.mehta@huawei.com>
 <20181109220743.10264-8-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181109220743.10264-8-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Salil Mehta <salil.mehta@huawei.com>
Cc: davem@davemloft.net, yuvalm@mellanox.com, leon@kernel.org, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com, liuzhongzhu <liuzhongzhu@huawei.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 09, 2018 at 10:07:40PM +0000, Salil Mehta wrote:
> From: liuzhongzhu <liuzhongzhu@huawei.com>
> 
> This patch prints checksum config information
> related to various layers of headers.
> 
> debugfs command:
> echo dump checksum > cmd

How does the information here differ from ethtool -k

    Andrew
