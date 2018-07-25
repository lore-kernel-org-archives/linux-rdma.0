From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: [PATCH] rds: send: Fix dead code in rds_sendmsg
Date: Wed, 25 Jul 2018 11:27:25 -0400
Message-ID: <20180725152725.GD8870@oracle.com>
References: <20180725152227.GA26303@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180725152227.GA26303@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On (07/25/18 10:22), Gustavo A. R. Silva wrote:
> Currently, code at label *out* is unreachable. Fix this by updating
> variable *ret* with -EINVAL, so the jump to *out* can be properly
> executed instead of directly returning from function.
> 
> Addresses-Coverity-ID: 1472059 ("Structurally dead code")
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
