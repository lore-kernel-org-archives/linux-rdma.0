From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [RFC PATCH 00/10] net: hns3: Adds support of debugfs to HNS3
 driver
Date: Fri, 9 Nov 2018 23:43:46 +0100
Message-ID: <20181109224346.GD5259@lunn.ch>
References: <20181109220743.10264-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181109220743.10264-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Salil Mehta <salil.mehta@huawei.com>
Cc: davem@davemloft.net, yuvalm@mellanox.com, leon@kernel.org, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

> 3. Debugfs looks more unstructured unlike sysfs. Is there any
>    de-facto standard of the user-api or drivers are allowed to
>    use it in any way to expose the information from kernel.

Hi Salil

You don't really have a user api using debugfs, because debugfs is
unstable. Anything can change at any time. Any user tools which use
debugfs can be expected to break at any time as the information in
debugfs changes. debugfs is for debug, not to export an API. And in
production systems, it is often not mounted.

As much as possible, you are recommended to use existing APIs,
ethtool, devlink, etc.

	Andrew
