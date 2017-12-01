From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: hns3: Refactors "reset" handling code in
 HCLGE layer of HNS3 driver
Date: Fri, 1 Dec 2017 14:44:15 +0100
Message-ID: <20171201134415.GD22599@lunn.ch>
References: <20171201033744.19104-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171201033744.19104-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Salil Mehta <salil.mehta@huawei.com>
Cc: davem@davemloft.net, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil.lnk@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 01, 2017 at 03:37:44AM +0000, Salil Mehta wrote:
> This patch refactors the code of the reset feature in HCLGE layer
> of HNS3 PF driver. Prime motivation to do this change is:
> 1. To reduce the time for which common miscellaneous Vector 0
>    interrupt is disabled because of the reset.
> 2. Simplification of reset request submission and pending reset
>    logic.
> 3. Simplification of the common miscellaneous interrupt handler
>    routine(for Vector 0) used to handle reset and other sources
>    of Vector 0 interrupt.
> 
> To achieve above below few things have been done:
> 1. Interrupt is disabled while common miscellaneous interrupt
>    handler is entered and re-enabled before it is exit. This
>    reduces the interrupt handling latency as compared to older
>    interrupt handling scheme where interrupt was being disabled
>    in interrupt handler context and re-enabled in task context
>    some time later.
> 2. Introduces new reset service task for honoring software reset
>    requests like from network stack related to timeout and serving
>    the pending reset request(to reset the driver and associated
>    clients).
> 3. Made Miscellaneous interrupt handler more generic to handle
>    all sources including reset interrupt source.

Hi Salil

This is a rather large patch. Can you break it up? It seems like you
should be able to break it up into at least three parts, maybe more.

You are aiming to have small patches which are obviously correct. It
is much easier to review than one big patch which is not obvious at
all.

	Andrew
