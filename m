From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: build failure on linus' latest master branch
Date: Mon, 10 Oct 2016 10:41:09 -0500
Message-ID: <01ca01d2230c$b8ade6f0$2a09b4d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Leon, I hit this trying to compile Linus' latest master branch.
 
 CC [M]  drivers/net/ethernet/mellanox/mlx5/core/pagealloc.o
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c: In function
âreclaim_pages_cmd.clone.0â:
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:347: error: call to
â__compiletime_assert_347â declared with attribute error: BUILD_BUG_ON failed:
__mlx5_bit_off(manage_pages_out, pas[i]) % 64
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c: In function âgive_pagesâ:
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:290: error: call to
â__compiletime_assert_290â declared with attribute error: BUILD_BUG_ON failed:
__mlx5_bit_off(manage_pages_in, pas[i]) % 64
make[5]: *** [drivers/net/ethernet/mellanox/mlx5/core/pagealloc.o] Error 1

Is there a fix for this?

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
