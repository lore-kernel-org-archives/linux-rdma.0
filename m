From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net: hns: Fixes the missing put_device in positive
 leg for roce reset
Date: Mon, 18 Feb 2019 17:45:33 -0800 (PST)
Message-ID: <20190218.174533.1821639443595554040.davem@davemloft.net>
References: <20190218174032.22972-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190218174032.22972-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: salil.mehta@huawei.com
Cc: yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Salil Mehta <salil.mehta@huawei.com>
Date: Mon, 18 Feb 2019 17:40:32 +0000

> This patch fixes the missing device reference release-after-use in
> the positive leg of the roce reset API of the HNS DSAF.
> 
> Fixes: c969c6e7ab8c ("net: hns: Fix object reference leaks in hns_dsaf_roce_reset()")
> Reported-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>

Applied, thanks Salil.
