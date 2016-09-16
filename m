From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx4_en: fix off by one in error handling
Date: Fri, 16 Sep 2016 04:16:44 -0400 (EDT)
Message-ID: <20160916.041644.578196330402521836.davem@davemloft.net>
References: <alpine.LFD.2.20.1609141305360.1727@schleppi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1609141305360.1727@schleppi>
Sender: netdev-owner@vger.kernel.org
To: sebott@linux.vnet.ibm.com
Cc: yishaih@mellanox.com, tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Date: Wed, 14 Sep 2016 13:09:24 +0200 (CEST)

> If an error occurs in mlx4_init_eq_table the index used in the
> err_out_unmap label is one too big which results in a panic in
> mlx4_free_eq. This patch fixes the index in the error path.
> 
> Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>

Applied.
