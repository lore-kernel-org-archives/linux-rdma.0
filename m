From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx5e: reduce stack usage in
 mlx5_eswitch_termtbl_create
Date: Mon, 17 Jun 2019 14:02:30 -0700 (PDT)
Message-ID: <20190617.140230.537297372523260104.davem@davemloft.net>
References: <20190617110855.2085326-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617110855.2085326-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de
Cc: saeedm@mellanox.com, leon@kernel.org, ozsh@mellanox.com, paulb@mellanox.com, elibr@mellanox.com, markb@mellanox.com, ogerlitz@mellanox.com, maorg@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 17 Jun 2019 13:08:22 +0200

> Putting an empty 'mlx5_flow_spec' structure on the stack is a bit
> wasteful and causes a warning on 32-bit architectures when building
> with clang -fsanitize-coverage:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c: In function 'mlx5_eswitch_termtbl_create':
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c:90:1: error: the frame size of 1032 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> Since the structure is never written to, we can statically allocate
> it to avoid the stack usage. To be on the safe side, mark all
> subsequent function arguments that we pass it into as 'const'
> as well.
> 
> Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Saeed, once Arnd fixes the reverse christmas tree issue, I assume you will take
this in via your tree?

Thanks.
