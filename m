From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] rds: send: Fix dead code in rds_sendmsg
Date: Wed, 25 Jul 2018 22:38:21 -0700 (PDT)
Message-ID: <20180725.223821.2249486672657415594.davem@davemloft.net>
References: <20180725152227.GA26303@embeddedor.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180725152227.GA26303@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gustavo@embeddedor.com
Cc: ka-cheong.poon@oracle.com, santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Wed, 25 Jul 2018 10:22:27 -0500

> Currently, code at label *out* is unreachable. Fix this by updating
> variable *ret* with -EINVAL, so the jump to *out* can be properly
> executed instead of directly returning from function.
> 
> Addresses-Coverity-ID: 1472059 ("Structurally dead code")
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
