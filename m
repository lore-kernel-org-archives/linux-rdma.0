From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net: mlx5: fix a potential NULL pointer dereference
Date: Mon, 11 Mar 2019 13:38:38 -0700 (PDT)
Message-ID: <20190311.133838.74958847820887089.davem@davemloft.net>
References: <20190311063343.20188-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190311063343.20188-1-kjlu@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>
Date: Mon, 11 Mar 2019 01:33:43 -0500

> In case skb_header_pointer fails, the fix issues a warning.
> 
> A better fix requires modifying the signature of mlx5e_get_fcs to
> pass an error code upstream.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Saeed, I'll let you take this.

Thanks.
