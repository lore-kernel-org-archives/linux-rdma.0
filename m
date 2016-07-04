From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx4: Fix some indent inconsistancy
Date: Mon, 04 Jul 2016 15:22:59 -0700 (PDT)
Message-ID: <20160704.152259.97878670707820538.davem@davemloft.net>
References: <1467462665-10191-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1467462665-10191-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: netdev-owner@vger.kernel.org
To: christophe.jaillet@wanadoo.fr
Cc: yishaih@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat,  2 Jul 2016 14:31:05 +0200

> Silent a few smatch warnings about indentation.
> This include the removal of a 'return' statement in 'resource_tracker.c'.
> This 'return' will still be performed when breaking out of the
> corresponding 'switch' block.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied to net-next, thanks.
