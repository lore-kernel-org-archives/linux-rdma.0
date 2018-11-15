From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH V2 net-next 0/5] net: hns3: Add support of hardware GRO
 to HNS3 Driver
Date: Thu, 15 Nov 2018 09:46:46 -0800 (PST)
Message-ID: <20181115.094646.1234839161454817822.davem@davemloft.net>
References: <20181115092925.11812-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181115092925.11812-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: salil.mehta@huawei.com
Cc: yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Salil Mehta <salil.mehta@huawei.com>
Date: Thu, 15 Nov 2018 09:29:20 +0000

> This patch-set adds support of hardware assisted GRO feature to
> HNS3 driver on Rev B(=0x21) platform. Current hardware only
> supports TCP/IPv{4|6} flows.
> 
> Change Log:
> V1->V2:
> 1. Remove redundant print reported by Leon Romanovsky.
>    Link: https://lkml.org/lkml/2018/11/13/715

Series applied, thanks.
