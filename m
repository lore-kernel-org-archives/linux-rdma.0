From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH V2 net] net: hns3: Updates MSI/MSI-X alloc/free
 APIs(depricated) to new APIs
Date: Mon, 13 Nov 2017 10:19:10 +0900 (KST)
Message-ID: <20171113.101910.1171275534353628849.davem@davemloft.net>
References: <20171109163813.7704-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171109163813.7704-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: salil.mehta@huawei.com
Cc: hch@lst.de, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil.lnk@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Salil Mehta <salil.mehta@huawei.com>
Date: Thu, 9 Nov 2017 16:38:13 +0000

> This patch migrates the HNS3 driver code from use of depricated PCI
> MSI/MSI-X interrupt vector allocation/free APIs to new common APIs.
> 
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> Suggested-by: Christoph Hellwig <hch@lst.de>

This doesn't apply cleanly to the net-next tree.
